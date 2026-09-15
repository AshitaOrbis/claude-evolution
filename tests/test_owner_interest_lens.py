"""Tests for the owner-interest lens.

The regression suite at the bottom is the point of the whole module: the three
repos the owner shared in Discord and the pipeline closed as "irrelevant to Claude
Code" must now route to REVIEW instead. If those tests ever go red, the lens has
stopped doing the one job it was built for.
"""

from __future__ import annotations

import json
import os
import shutil
from pathlib import Path

import re
import pytest
import yaml

from lib.owner_interest_lens import (
    DEFAULT_COMPLETED_DIR,
    DEFAULT_REVIEW_DIR,
    REOPEN_MARKER,
    STAMP_HEADING,
    LensConfig,
    _term_pattern,
    gate,
    load_config,
    parse_record,
    render_review_record,
    route_to_review,
    screen,
    stamp_pending,
    sweep,
)

REGRESSION_CASES = [
    ("discord-inbox-20260220-qwen3-tts.md", "speech-voice"),
    ("discord-inbox-20260226-airi.md", "avatar-vtuber"),
    ("discord-inbox-20260408-open-llm-vtuber.md", "avatar-vtuber"),
]


@pytest.fixture(scope="module")
def config() -> LensConfig:
    return load_config()


def _config_from(tmp_path: Path, body: str) -> LensConfig:
    path = tmp_path / "owner-interests.yaml"
    path.write_text(body, encoding="utf-8")
    return load_config(path)


# --------------------------------------------------------------------------- config


def test_shipped_config_loads_and_is_well_formed(config: LensConfig) -> None:
    ids = [d.id for d in config.domains]
    assert len(ids) == len(set(ids)), "duplicate domain ids"
    for domain in config.domains:
        assert domain.strong or domain.weak, f"{domain.id} has no signals"
        assert domain.threshold >= 1, f"{domain.id} has a threshold below 1"
        assert domain.why, f"{domain.id} has no rationale — a reviewer needs the why"
        assert domain.serves, f"{domain.id} routes nowhere"


def test_shipped_config_covers_the_commissioned_domains(config: LensConfig) -> None:
    ids = {d.id for d in config.domains}
    assert {
        "avatar-vtuber",
        "speech-voice",
        "radio-audio-streaming",
        "uai-education",
        "agent-harness",
        "psychometrics",
        "inference-economics",
        "games",
    } <= ids


def _mirror_repo() -> Path:
    """Second checkout of this repo whose cron actually runs the pipeline, if there is one.

    Set CLAUDE_EVOLUTION_MIRROR to point at it; the default is a sibling `-ops` directory.
    Resolved at call time (not import time) so the path is never baked into the file.
    """
    env = os.environ.get("CLAUDE_EVOLUTION_MIRROR")
    if env:
        return Path(env).expanduser()
    here = Path(__file__).resolve().parent.parent
    return here.parent / f"{here.name}-ops"


@pytest.mark.parametrize("relpath", ["lib/owner_interest_lens.py", "config/owner-interests.yaml"])
def test_the_mirror_copy_has_not_drifted(relpath: str) -> None:
    """An operational mirror of this repo carries its own copy of the lens and its config.

    Two copies of a scoring config is the failure mode worth catching: someone adds a domain
    in one checkout, the checkout the cron actually runs never sees it. Drift is a test
    failure, not a surprise. Skipped when no mirror is present.
    """
    mirror = _mirror_repo()
    if not mirror.is_dir():
        pytest.skip("no operational mirror present (set CLAUDE_EVOLUTION_MIRROR to check one)")
    if not (mirror / relpath).is_file():
        pytest.skip(f"mirror does not carry {relpath}")

    ours = (Path(__file__).resolve().parent.parent / relpath).read_text(encoding="utf-8")
    theirs = (mirror / relpath).read_text(encoding="utf-8")
    assert ours == theirs, (
        f"{relpath} differs between this checkout and the operational mirror at {mirror}. "
        "Copy the intended version across both before shipping."
    )


def test_every_routing_target_actually_exists(config: LensConfig) -> None:
    """A `serves` path that does not exist is a dead end for whoever triages the queue.

    Skipped when the repo is checked out somewhere other than the workspace it routes
    into — the paths are workspace-relative by design.
    """
    from lib.owner_interest_lens import REPO_ROOT

    workspace = REPO_ROOT.parent
    if not (workspace / "orchestration").is_dir():
        pytest.skip("not running inside the workspace these paths route into")

    missing = [
        f"{d.id} → {s}" for d in config.domains for s in d.serves if not (workspace / s).exists()
    ]
    assert not missing, "routing targets that do not exist: " + ", ".join(missing)


@pytest.mark.parametrize(
    "bad, err",
    [
        ("version: 1\ndomains: []\n", "no domains"),
        ("version: 1\ndomains:\n  - label: x\n", "missing 'id'"),
        ("version: 1\ndomains:\n  - id: a\n    signals: []\n", "no signals"),
        (
            "version: 1\ndomains:\n  - id: a\n    signals: [x]\n  - id: a\n    signals: [y]\n",
            "duplicate domain id",
        ),
    ],
)
def test_malformed_config_fails_loudly(tmp_path: Path, bad: str, err: str) -> None:
    with pytest.raises(ValueError, match=err):
        _config_from(tmp_path, bad)


def test_shipped_config_carries_no_private_routing_targets() -> None:
    """The PUBLISHED config must not leak internal project names or roadmap detail.

    claude.public_private_project_names_06 / bq-1266: config/owner-interests.yaml is
    tracked (and published) directly -- it is not under reference-config/, so
    scripts/test-public-config.sh never scanned it. It used to name real internal
    directories in its `serves` and `why` fields. Those now live only in the
    gitignored config/owner-interests.local.yaml overlay, which is never git-tracked
    and therefore never published.

    THE FORBIDDEN TERMS ARE READ FROM THAT OVERLAY, NEVER WRITTEN DOWN HERE. This
    file is itself on the publish allow list, so a hardcoded list of the private
    names would move the leak out of the config and into the test that proves the
    config is clean -- which is the same leak wearing a different hat. Reading them
    from the untracked overlay also makes the check self-maintaining: add a private
    routing target on this host and it is covered without editing a published file.

    A clone with no overlay has nothing private to check, so it skips.
    """
    from lib.owner_interest_lens import REPO_ROOT, _local_overlay_path

    tracked_path = REPO_ROOT / "config" / "owner-interests.yaml"
    assert tracked_path.is_file()

    overlay_path = _local_overlay_path(tracked_path)
    if not overlay_path.is_file():
        pytest.skip("no local overlay on this host — nothing private to check for")

    overlay_raw = yaml.safe_load(overlay_path.read_text(encoding="utf-8")) or {}
    private_terms: set[str] = set()

    def _consider(target: str) -> None:
        target = target.strip().rstrip(".,;:)")
        # A bare single-word directory whose name is an ordinary English noun
        # (`orchestration`) identifies nothing and collides with prose — the `why`
        # fields legitimately discuss orchestration, research and games as concepts.
        # Only treat a target as private when it is a real path or a distinctive slug.
        if target and ("/" in target or "-" in target):
            private_terms.add(target)
            # `games/veilbreak` must also catch a bare `veilbreak` in prose — but only
            # the LEAF. The parent segments are generic directory names (`games`,
            # `tools`, `research`) that appear in ordinary prose and would make this
            # check fire on nothing private.
            leaf = target.rstrip("/").split("/")[-1]
            if len(leaf) > 3:
                private_terms.add(leaf)

    for entry in overlay_raw.get("domains") or []:
        for target in entry.get("serves") or []:
            _consider(str(target))
        # DELIBERATE LIMIT, stated rather than hidden: the overlay's `serves` list is
        # the authoritative set of private routing targets, and that is all this
        # derives from. Mining the overlay's `why` prose for more names was tried and
        # removed — ordinary hyphenated and dotted English collides with the tracked
        # config's own prose, so it produced false failures rather than coverage. A
        # private name that appears ONLY inside an overlay rationale and never as a
        # routing target is therefore not guarded here.
    assert private_terms, f"{overlay_path.name} carries no serves targets — the check would be vacuous"

    # Check the STRUCTURED fields, not the raw file text. The leak surface is a
    # private name sitting in a `serves` target or a `why` rationale; ordinary prose
    # elsewhere in the file legitimately uses generic words that are also single-
    # segment routing targets (`orchestration` is both a directory and an English
    # word), and matching raw text makes those read as leaks.
    tracked_raw = yaml.safe_load(tracked_path.read_text(encoding="utf-8")) or {}
    routed_text: list[str] = []
    for entry in tracked_raw.get("domains") or []:
        routed_text.extend(str(t) for t in (entry.get("serves") or []))
        if entry.get("why"):
            routed_text.append(str(entry["why"]))
    haystack = "\n".join(routed_text)
    # Deliberately a COUNT, not the list: pytest reprs the asserted expression on
    # failure, so asserting on the terms themselves would print the private names
    # into CI logs — the same leak this test exists to prevent.
    n_found = sum(1 for t in private_terms if t in haystack)
    assert n_found == 0, (
        f"{n_found} private routing target(s) from the local overlay are present in the "
        f"PUBLISHED config {tracked_path.name}. The terms are deliberately not printed here — "
        f"read {overlay_path.name} to see which."
    )

    # It must still be a well-formed, self-sufficient config on its own (a public
    # clone has no overlay file at all).
    config = load_config(tracked_path)
    for domain in config.domains:
        assert domain.serves, f"{domain.id} routes nowhere without the local overlay"
        assert domain.why, f"{domain.id} has no rationale without the local overlay"


def test_local_overlay_merges_serves_and_why_by_domain_id(tmp_path: Path) -> None:
    """The per-host overlay overrides `serves`/`why` per domain id; matching is untouched."""
    base = tmp_path / "owner-interests.yaml"
    base.write_text(
        "version: 1\n"
        "default_threshold: 2\n"
        "domains:\n"
        "  - id: demo\n"
        "    label: Demo\n"
        '    why: "generic placeholder"\n'
        "    serves: [\"(configure in config/owner-interests.local.yaml)\"]\n"
        "    strong_signals: [vtuber]\n"
        "  - id: other\n"
        "    why: \"other placeholder\"\n"
        "    serves: [\"(configure in config/owner-interests.local.yaml)\"]\n"
        "    strong_signals: [gizmo]\n",
        encoding="utf-8",
    )
    overlay = tmp_path / "owner-interests.local.yaml"
    overlay.write_text(
        "domains:\n"
        "  - id: demo\n"
        "    serves: [real/private/path]\n"
        '    why: "the real internal rationale"\n',
        encoding="utf-8",
    )

    config = load_config(base)
    demo = config.domain("demo")
    assert demo.serves == ("real/private/path",)
    assert demo.why == "the real internal rationale"
    # "other" has no overlay entry: falls back to the base file's generic values.
    other = config.domain("other")
    assert other.serves == ("(configure in config/owner-interests.local.yaml)",)
    assert other.why == "other placeholder"
    # Matching logic (signals) is defined only in the base file and is unaffected.
    assert screen("a VTuber toolkit", config)[0].domain.id == "demo"


def test_missing_local_overlay_falls_back_to_generic_values(tmp_path: Path) -> None:
    base = tmp_path / "owner-interests.yaml"
    base.write_text(
        "version: 1\n"
        "default_threshold: 2\n"
        "domains:\n"
        "  - id: demo\n"
        '    why: "generic placeholder"\n'
        "    serves: [generic]\n"
        "    strong_signals: [vtuber]\n",
        encoding="utf-8",
    )
    # No owner-interests.local.yaml written next to it.
    config = load_config(base)
    assert config.domain("demo").serves == ("generic",)
    assert config.domain("demo").why == "generic placeholder"


# --------------------------------------------------------------------------- matching


@pytest.mark.parametrize(
    "term, text, expected",
    [
        ("tts", "Qwen3-TTS is a model", True),
        ("tts", "the attstore module", False),
        ("tts", "TTS", True),
        ("text-to-speech", "text to speech", True),
        ("text-to-speech", "texttospeech api", True),
        ("text-to-speech", "text_to_speech", True),
        ("vrm", "loads a VRM avatar", True),
        ("vrm", "vrmodel", False),
        ("game", "gamete biology", False),
        ("game", "a game engine", True),
    ],
)
def test_term_patterns_are_elastic_but_boundary_safe(term: str, text: str, expected: bool) -> None:
    assert bool(_term_pattern(term).search(text)) is expected


SYNTHETIC = """
version: 1
default_threshold: 2
domains:
  - id: demo
    label: Demo
    why: because
    serves: [somewhere]
    strong_signals: [vtuber, "lip sync"]
    signals: [rigging, mocap]
    exclude: ["avatar upload"]
"""


def test_one_strong_signal_is_enough(tmp_path: Path) -> None:
    cfg = _config_from(tmp_path, SYNTHETIC)
    matches = screen("a VTuber toolkit", cfg)
    assert [m.domain.id for m in matches] == ["demo"]
    assert matches[0].score == 2


def test_a_lone_weak_signal_is_not_enough(tmp_path: Path) -> None:
    cfg = _config_from(tmp_path, SYNTHETIC)
    assert screen("some rigging work", cfg) == []


def test_two_weak_signals_corroborate(tmp_path: Path) -> None:
    cfg = _config_from(tmp_path, SYNTHETIC)
    matches = screen("rigging and mocap", cfg)
    assert matches and matches[0].score == 2


def test_exclusion_vetoes_the_domain(tmp_path: Path) -> None:
    cfg = _config_from(tmp_path, SYNTHETIC)
    assert screen("VTuber avatar upload feature", cfg) == []


def test_overlapping_terms_count_once(config: LensConfig) -> None:
    """'speech synthesis' must not also score as 'speech'."""
    once = screen("speech synthesis", config)
    assert once and once[0].domain.id == "speech-voice"
    assert once[0].score == 2, f"double-counted: {once[0].hits}"


def test_repeating_a_term_does_not_inflate_the_score(config: LensConfig) -> None:
    single = screen("a vtuber project", config)[0].score
    repeated = screen("vtuber vtuber vtuber vtuber", config)[0].score
    assert single == repeated


def test_empty_text_matches_nothing(config: LensConfig) -> None:
    assert screen("", config) == []


# --------------------------------------------------------------------------- records

MD_BULLET = """# Some Repo

- **URL**: https://example.com/x

## Description

URL shared in Discord #general without additional context.

## Evaluation

**Score**: 15/100
**Decision**: REJECTED
**Reason**: It is a VTuber framework, irrelevant to Claude Code.
"""

MD_JSON = """# Some Repo

## Evaluation

```json
{
  "scores": {"integration_complexity": 0},
  "total": 27.5,
  "decision": "REJECTED",
  "reasoning": "VTuber character animation is out-of-domain."
}
```
"""

JSON_HUMAN = {
    "title": "Some Proposal",
    "reason": "A VTuber avatar toolkit.",
    "evaluation": {"decision": "REJECTED_BY_HUMAN", "reasoning": "Rejected by human via Discord."},
}


def test_parses_the_bullet_markdown_format(tmp_path: Path) -> None:
    p = tmp_path / "a.md"
    p.write_text(MD_BULLET, encoding="utf-8")
    rec = parse_record(p)
    assert rec.title == "Some Repo"
    assert rec.decision == "REJECTED"
    assert rec.score == 15.0
    assert rec.is_reopenable_reject


def test_parses_the_embedded_json_markdown_format(tmp_path: Path) -> None:
    p = tmp_path / "b.md"
    p.write_text(MD_JSON, encoding="utf-8")
    rec = parse_record(p)
    assert rec.decision == "REJECTED"
    assert rec.score == 27.5


def test_parses_the_json_format_and_screens_all_string_fields(tmp_path: Path) -> None:
    p = tmp_path / "c.json"
    p.write_text(json.dumps(JSON_HUMAN), encoding="utf-8")
    rec = parse_record(p)
    assert rec.decision == "REJECTED_BY_HUMAN"
    assert "VTuber" in rec.text


def test_a_low_score_with_no_decision_still_reads_as_a_reject(tmp_path: Path) -> None:
    p = tmp_path / "d.md"
    p.write_text("# X\n\n**Score**: 22/100\n", encoding="utf-8")
    assert parse_record(p).is_reopenable_reject


# --------------------------------------------------------------------------- gate


def test_a_matching_reject_is_routed_to_review(tmp_path: Path, config: LensConfig) -> None:
    p = tmp_path / "a.md"
    p.write_text(MD_BULLET, encoding="utf-8")
    result = gate(parse_record(p), config)
    assert result.state == "REVIEW"
    assert "avatar-vtuber" in result.reason


def test_a_reject_with_no_owner_domain_stays_rejected(tmp_path: Path, config: LensConfig) -> None:
    p = tmp_path / "a.md"
    p.write_text(
        "# Yet Another Linter\n\n**Score**: 30/100\n**Decision**: REJECTED\n"
        "**Reason**: Redundant with the existing lint setup.\n",
        encoding="utf-8",
    )
    result = gate(parse_record(p), config)
    assert result.state == "REJECTED"
    assert not result.routed


def test_the_lens_never_touches_an_approval(tmp_path: Path, config: LensConfig) -> None:
    p = tmp_path / "a.md"
    p.write_text(
        "# A VTuber MCP Server\n\n**Score**: 80/100\n**Decision**: APPROVED\n", encoding="utf-8"
    )
    assert gate(parse_record(p), config).state == "UNCHANGED"


def test_a_human_rejection_is_final(tmp_path: Path, config: LensConfig) -> None:
    """The owner already ruled in person; the lens does not relitigate it."""
    p = tmp_path / "c.json"
    p.write_text(json.dumps(JSON_HUMAN), encoding="utf-8")
    result = gate(parse_record(p), config)
    assert result.state == "UNCHANGED"
    assert "REJECTED_BY_HUMAN" in result.reason


def test_an_already_reopened_record_is_not_reopened_again(
    tmp_path: Path, config: LensConfig
) -> None:
    p = tmp_path / "a.md"
    p.write_text(MD_BULLET + f"\n{REOPEN_MARKER}: 2026-07-29 → `x.md`\n", encoding="utf-8")
    assert gate(parse_record(p), config).state == "ALREADY_REVIEW"


# --------------------------------------------------------------------------- routing


def test_routing_writes_a_review_record_and_stamps_the_original(
    tmp_path: Path, config: LensConfig
) -> None:
    src = tmp_path / "completed" / "a.md"
    src.parent.mkdir()
    src.write_text(MD_BULLET, encoding="utf-8")
    review_dir = tmp_path / "review"

    result = gate(parse_record(src), config)
    review_path = route_to_review(result, review_dir, today="2026-07-29", apply=True)

    review = review_path.read_text(encoding="utf-8")
    assert review.startswith("# REVIEW — Some Repo")
    assert "avatar-vtuber" in review
    assert "**State**: REVIEW" in review
    assert "It is a VTuber framework" in review, "the original record must travel with it"

    stamped = src.read_text(encoding="utf-8")
    assert REOPEN_MARKER in stamped, "the closed record must point at its review record"
    assert "**Decision**: REJECTED" in stamped, "the rubric's verdict is not rewritten"


def test_routing_is_idempotent(tmp_path: Path, config: LensConfig) -> None:
    src = tmp_path / "a.md"
    src.write_text(MD_BULLET, encoding="utf-8")
    review_dir = tmp_path / "review"

    route_to_review(gate(parse_record(src), config), review_dir, today="2026-07-29", apply=True)
    first = src.read_text(encoding="utf-8")
    # second pass sees the stamp and declines
    second_result = gate(parse_record(src), config)
    assert second_result.state == "ALREADY_REVIEW"
    route_to_review(second_result, review_dir, today="2026-07-30", apply=True)
    assert src.read_text(encoding="utf-8") == first
    assert len(list(review_dir.iterdir())) == 1


def test_a_dry_run_writes_nothing(tmp_path: Path, config: LensConfig) -> None:
    src = tmp_path / "a.md"
    src.write_text(MD_BULLET, encoding="utf-8")
    review_dir = tmp_path / "review"
    route_to_review(gate(parse_record(src), config), review_dir, apply=False)
    assert not review_dir.exists()
    assert src.read_text(encoding="utf-8") == MD_BULLET


def test_json_originals_are_stamped_as_json_and_stay_idempotent(
    tmp_path: Path, config: LensConfig
) -> None:
    """A JSON stamp is a field, not marker text — it must still be seen on re-read."""
    src = tmp_path / "c.json"
    src.write_text(
        json.dumps({"title": "T", "reason": "A VTuber avatar rig.", "evaluation": {"decision": "REJECTED"}}),
        encoding="utf-8",
    )
    route_to_review(gate(parse_record(src), config), tmp_path / "review", apply=True)
    data = json.loads(src.read_text(encoding="utf-8"))
    assert data["evaluation"]["owner_interest_reopen"]["date"]
    assert data["evaluation"]["decision"] == "REJECTED"

    assert gate(parse_record(src), config).state == "ALREADY_REVIEW"


def test_sweep_apply_is_idempotent_for_every_record_format(
    tmp_path: Path, config: LensConfig
) -> None:
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "a.md").write_text(MD_BULLET, encoding="utf-8")
    (completed / "b.md").write_text(MD_JSON, encoding="utf-8")
    (completed / "c.json").write_text(
        json.dumps({"title": "T", "reason": "A VTuber rig.", "evaluation": {"decision": "REJECTED"}}),
        encoding="utf-8",
    )
    review = tmp_path / "review"

    first = sweep(completed, config, review, apply=True, today="2026-07-29")
    second = sweep(completed, config, review, apply=True, today="2026-07-30")
    assert first["routed_to_review"] == 3
    assert second["routed_to_review"] == 0, "a format is not detecting its own reopen stamp"
    assert second["already_reopened"] == 3


def test_a_json_and_md_source_with_the_same_stem_do_not_collide(
    tmp_path: Path, config: LensConfig
) -> None:
    """claude.owner_interest_review_collision_04 (bq-1264).

    route_to_review used to derive the review filename from `stem + ".md"` alone,
    so a `.json` and a `.md` source sharing a stem collided: whichever routed
    second saw the file already existed and returned immediately -- its own
    reject was never stamped and never got a review record of its own.
    """
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "dup.md").write_text(MD_BULLET, encoding="utf-8")
    (completed / "dup.json").write_text(
        json.dumps({"title": "Dup", "reason": "A VTuber avatar rig.", "evaluation": {"decision": "REJECTED"}}),
        encoding="utf-8",
    )
    review = tmp_path / "review"

    report = sweep(completed, config, review, apply=True, today="2026-07-29")
    assert report["routed_to_review"] == 2, "both rejects must be routed, not just the first"
    assert not report["errors"]
    assert len(list(review.iterdir())) == 2, "two distinct sources need two distinct review files"

    md_record = parse_record(completed / "dup.md")
    json_record = parse_record(completed / "dup.json")
    assert md_record.reopened_to, "the .md source must be stamped"
    assert json_record.reopened_to, "the .json source must be stamped -- this is the collision"

    # A second sweep must not re-route either (idempotent for both formats now).
    second = sweep(completed, config, review, apply=True, today="2026-07-30")
    assert second["routed_to_review"] == 0
    assert second["already_reopened"] == 2


def test_an_interrupted_apply_is_repaired_not_mistaken_for_done(
    tmp_path: Path, config: LensConfig
) -> None:
    """If a prior apply wrote the review record but crashed before stamping the
    original (interrupted between the two writes), a later apply must repair the
    stamp -- not treat the review file's mere existence as proof there is nothing
    left to do, which would leave the original looking un-triaged forever.
    """
    src = tmp_path / "a.md"
    src.write_text(MD_BULLET, encoding="utf-8")
    review_dir = tmp_path / "review"

    result = gate(parse_record(src), config)
    review_path = route_to_review(result, review_dir, today="2026-07-29", apply=True)
    # Simulate the crash: revert the source to its pre-stamp content, leaving the
    # review record that was already written in place.
    src.write_text(MD_BULLET, encoding="utf-8")
    assert REOPEN_MARKER not in src.read_text(encoding="utf-8")

    repaired_result = gate(parse_record(src), config)  # not ALREADY_REVIEW: never stamped
    assert repaired_result.state == "REVIEW"
    route_to_review(repaired_result, review_dir, today="2026-07-30", apply=True)
    assert REOPEN_MARKER in src.read_text(encoding="utf-8"), "the repair must stamp the original"
    assert len(list(review_dir.iterdir())) == 1, "the repair must not write a second review file"


def test_review_record_names_the_project_it_serves(tmp_path: Path, config: LensConfig) -> None:
    src = tmp_path / "a.md"
    src.write_text(MD_BULLET, encoding="utf-8")
    rendered = render_review_record(gate(parse_record(src), config), "2026-07-29")
    assert "tools/vtuber-radio" in rendered


# --------------------------------------------------------------------------- sweep


def test_sweep_dry_run_reports_without_writing(tmp_path: Path, config: LensConfig) -> None:
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")
    (completed / "miss.md").write_text(
        "# Linter\n\n**Score**: 10/100\n**Decision**: REJECTED\n**Reason**: redundant.\n",
        encoding="utf-8",
    )
    review = tmp_path / "review"

    report = sweep(completed, config, review, apply=False)
    assert report["scanned"] == 2
    assert report["routed_to_review"] == 1
    assert report["items"][0]["serves"] == ["tools/vtuber-radio"]
    assert not review.exists()


def test_sweep_apply_then_rerun_is_stable(tmp_path: Path, config: LensConfig) -> None:
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")
    review = tmp_path / "review"

    first = sweep(completed, config, review, apply=True, today="2026-07-29")
    second = sweep(completed, config, review, apply=True, today="2026-07-30")
    assert first["routed_to_review"] == 1
    assert second["routed_to_review"] == 0
    assert second["already_reopened"] == 1
    assert len(list(review.iterdir())) == 1


def test_sweep_survives_a_malformed_record(tmp_path: Path, config: LensConfig) -> None:
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "broken.json").write_text("{not json", encoding="utf-8")
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")

    report = sweep(completed, config, tmp_path / "review", apply=False)
    assert report["routed_to_review"] == 1
    assert len(report["errors"]) == 1


def test_cmd_sweep_returns_nonzero_when_a_record_could_not_be_screened(
    tmp_path: Path, capsys
) -> None:
    """claude.owner_lens_error_success_04 / _03 / claude.owner_lens_sweep_failopen_03.

    A malformed record makes `sweep()` record an error and keep going -- correct,
    a malformed sibling must not stop the rest of the batch. But the CLI's exit
    code is what scripts/evolution-daily.sh actually branches on
    (`python3 "$OWNER_LENS" sweep --apply ...`), and it used to be an
    unconditional 0. A reject the gate never actually screened must not report
    the same exit code as a clean scan.
    """
    import argparse

    from lib.owner_interest_lens import _cmd_sweep

    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "broken.json").write_text("{not json", encoding="utf-8")

    args = argparse.Namespace(
        dir=str(completed),
        review_dir=str(tmp_path / "review"),
        apply=True,
        since_days=None,
        json=False,
    )
    rc = _cmd_sweep(args, load_config())
    assert rc != 0, "a record the sweep could not parse must not report success"
    capsys.readouterr()


def test_cmd_sweep_is_still_zero_on_a_clean_run(tmp_path: Path, capsys) -> None:
    import argparse

    from lib.owner_interest_lens import _cmd_sweep

    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")

    args = argparse.Namespace(
        dir=str(completed),
        review_dir=str(tmp_path / "review"),
        apply=True,
        since_days=None,
        json=False,
    )
    rc = _cmd_sweep(args, load_config())
    assert rc == 0
    capsys.readouterr()


def test_sweep_reports_a_missing_directory_as_an_error_not_a_clean_scan(
    tmp_path: Path, config: LensConfig
) -> None:
    """claude.owner_interest_sweep_error_success_03: an absent completed/ dir used to
    scan zero files and report success, indistinguishable from a genuinely empty queue.
    """
    missing = tmp_path / "does-not-exist"
    report = sweep(missing, config, tmp_path / "review", apply=True)
    assert report["scanned"] == 0
    assert report["errors"], "a missing directory must be reported as an error"


def test_since_days_filters_by_mtime(tmp_path: Path, config: LensConfig) -> None:
    import os
    import time

    completed = tmp_path / "completed"
    completed.mkdir()
    old = completed / "old.md"
    old.write_text(MD_BULLET, encoding="utf-8")
    os.utime(old, (time.time() - 86400 * 30, time.time() - 86400 * 30))

    assert sweep(completed, config, tmp_path / "review", since_days=7)["scanned"] == 0
    assert sweep(completed, config, tmp_path / "review", since_days=60)["scanned"] == 1


# --------------------------------------------------------------------------- stamping


def test_stamping_a_pending_record_is_idempotent_and_not_self_feeding(
    tmp_path: Path, config: LensConfig
) -> None:
    pending = tmp_path / "p.md"
    pending.write_text("# Open LLM VTuber\n\nA VTuber framework.\n", encoding="utf-8")

    before = screen(parse_record(pending).text, config)[0].score
    stamp_pending(pending, config, apply=True)
    body = pending.read_text(encoding="utf-8")
    assert STAMP_HEADING in body
    assert "pipeline/evaluation/review/" in body

    stamp_pending(pending, config, apply=True)
    assert pending.read_text(encoding="utf-8") == body, "stamped twice"
    after = screen(parse_record(pending).text, config)[0].score
    assert after == before, "the stamp fed its own domain names back into the lens"


def test_stamping_a_json_pending_record_stays_valid_json(
    tmp_path: Path, config: LensConfig
) -> None:
    """claude.owner_lens_json_corruption_02 / claude.owner_gate_json_failopen_03 (bq-1397/1210).

    stamp_pending used to append the Markdown block unconditionally regardless of
    suffix, turning a valid `.json` pending record into invalid JSON before the
    evaluator or the post-evaluation sweep ever parsed it.
    """
    pending = tmp_path / "p.json"
    pending.write_text(
        json.dumps({"title": "Open LLM VTuber", "description": "A VTuber framework."}),
        encoding="utf-8",
    )
    matches = stamp_pending(pending, config, apply=True)
    assert matches, "fixture drifted: this record no longer matches a domain"

    raw = pending.read_text(encoding="utf-8")
    data = json.loads(raw)  # must not raise -- this is the whole point
    assert "owner_interest_pre_screen" in data
    assert data["owner_interest_pre_screen"]["domains"][0]["id"] == "avatar-vtuber"
    assert data["title"] == "Open LLM VTuber", "original fields must survive the stamp"

    # Idempotent and not self-feeding, same guarantee as the Markdown path.
    stamp_pending(pending, config, apply=True)
    assert pending.read_text(encoding="utf-8") == raw, "stamped twice"


def test_stamping_a_malformed_json_pending_record_does_not_write(tmp_path: Path, config: LensConfig) -> None:
    """A JSON record this module cannot safely round-trip must be left untouched,
    not "fixed" into something that happens to parse.
    """
    pending = tmp_path / "p.json"
    pending.write_text('{"title": "Open LLM VTuber", "description": "A VTuber framework."',
                        encoding="utf-8")
    before = pending.read_text(encoding="utf-8")
    # An apply pass must also SAY it did not stamp the record, rather than hand back
    # matches the CLI then reports as "stamped" (review 2026-09-14).
    with pytest.raises(ValueError, match="malformed JSON; not stamped"):
        stamp_pending(pending, config, apply=True)
    assert pending.read_text(encoding="utf-8") == before
    # The read-only pass still reports what the lens would flag, and writes nothing.
    assert stamp_pending(pending, config, apply=False)
    assert pending.read_text(encoding="utf-8") == before


def test_stamping_skips_records_with_no_match(tmp_path: Path, config: LensConfig) -> None:
    pending = tmp_path / "p.md"
    pending.write_text("# A Linter\n\nLints things.\n", encoding="utf-8")
    assert stamp_pending(pending, config, apply=True) == []
    assert STAMP_HEADING not in pending.read_text(encoding="utf-8")


# ------------------------------------------------------------------- REGRESSION (row 145)


def _as_closed(tmp_path: Path, filename: str) -> Path:
    """The record as the pipeline left it in March/April, before the backfill stamp."""
    original = (DEFAULT_COMPLETED_DIR / filename).read_text(encoding="utf-8")
    pre_fix = "\n".join(l for l in original.splitlines() if REOPEN_MARKER not in l)
    dest = tmp_path / filename
    dest.write_text(pre_fix, encoding="utf-8")
    return dest


@pytest.mark.parametrize("filename, expected_domain", REGRESSION_CASES)
def test_the_three_buried_repos_now_route_to_review(
    tmp_path: Path, config: LensConfig, filename: str, expected_domain: str
) -> None:
    """The commissioned regression.

    Qwen3-TTS, AIRI and Open-LLM-VTuber were shared by the owner in Discord #general,
    filed by the pipeline, and then closed 10–27/100 as "irrelevant to Claude Code" —
    months before the workspace built a radio station whose product is synthesized
    voice and animated hosts. Replayed exactly as they were closed, all three must now
    land in REVIEW instead.
    """
    src = _as_closed(tmp_path, filename)

    record = parse_record(src)
    assert record.decision == "REJECTED", "fixture drifted: this record is no longer a reject"

    result = gate(record, config)
    assert result.state == "REVIEW", f"{filename} would still be closed: {result.reason}"
    assert expected_domain in {m.domain.id for m in result.matches}
    assert "tools/vtuber-radio" in result.matches[0].domain.serves

    review = render_review_record(result, "2026-07-29")
    assert "**State**: REVIEW" in review
    assert "REJECTED" in review, "the review record must carry the original verdict"


@pytest.mark.parametrize("filename, expected_domain", REGRESSION_CASES)
def test_the_three_buried_repos_are_open_in_the_live_pipeline(
    filename: str, expected_domain: str
) -> None:
    """Not just "the lens would route them" — they are actually out of the closed pile."""
    review_record = DEFAULT_REVIEW_DIR / filename
    assert review_record.exists(), f"{filename} is still closed; run: sweep --apply"

    body = review_record.read_text(encoding="utf-8")
    assert "**State**: REVIEW" in body
    assert expected_domain in body
    assert "tools/vtuber-radio" in body

    closed = DEFAULT_COMPLETED_DIR / filename
    closed_body = closed.read_text(encoding="utf-8")
    assert REOPEN_MARKER in closed_body, "the closed record does not point at its review record"
    # Either record format is fine; what matters is that the verdict was not rewritten.
    assert parse_record(closed).decision == "REJECTED", "the rubric's verdict was rewritten"


def test_the_rubric_score_is_never_rewritten(config: LensConfig) -> None:
    """The lens changes routing, not scoring. AIRI stays a 15/100 for Claude Code."""
    record = parse_record(DEFAULT_COMPLETED_DIR / "discord-inbox-20260226-airi.md")
    assert record.score == 15.0
    assert gate(record, config).record.score == 15.0


def test_the_live_completed_dir_holds_no_unreviewed_owner_interest_rejects(
    config: LensConfig,
) -> None:
    """Backstop: once the backfill has run, the closed pile stays clean.

    A failure here means new rejects landed in an owner domain and were closed —
    exactly the row-145 defect — so run:
        python3 lib/owner_interest_lens.py sweep --apply
    """
    report = sweep(DEFAULT_COMPLETED_DIR, config, apply=False)
    unrouted = [i["path"] for i in report["items"]]
    assert not unrouted, "closed records matching an owner domain: " + ", ".join(unrouted)


def test_stamping_a_non_object_json_pending_record_refuses_on_apply(
    tmp_path: Path, config: LensConfig
) -> None:
    pending = tmp_path / "p.json"
    pending.write_text('["Open LLM VTuber", "A VTuber framework."]', encoding="utf-8")
    before = pending.read_text(encoding="utf-8")
    with pytest.raises(ValueError, match="not an object"):
        stamp_pending(pending, config, apply=True)
    assert pending.read_text(encoding="utf-8") == before
    assert stamp_pending(pending, config, apply=False) == []


def test_stamp_cli_exits_nonzero_when_a_record_could_not_be_stamped(
    tmp_path: Path, capsys: pytest.CaptureFixture
) -> None:
    from lib.owner_interest_lens import main as lens_main

    bad = tmp_path / "bad.json"
    bad.write_text('{"title": "Open LLM VTuber", "description": "A VTuber framework."', encoding="utf-8")
    assert lens_main(["stamp", "--apply", str(bad)]) == 1
    assert "NOT stamped" in capsys.readouterr().err


def test_three_sources_sharing_a_stem_each_keep_their_own_review_record(
    tmp_path: Path, config: LensConfig
) -> None:
    """Review 2026-09-14: routing dup.md.json, then dup.json, then dup.md found the one
    fallback name already taken by another source and stamped dup.md as reopened to a
    record that was never its own. Every candidate name is now checked for identity.
    """
    completed = tmp_path / "completed"
    completed.mkdir()
    reject = json.dumps({"title": "Dup", "reason": "A VTuber avatar rig.", "evaluation": {"decision": "REJECTED"}})
    (completed / "dup.md.json").write_text(reject, encoding="utf-8")
    (completed / "dup.json").write_text(reject, encoding="utf-8")
    (completed / "dup.md").write_text(MD_BULLET, encoding="utf-8")
    review = tmp_path / "review"
    order = ("dup.md.json", "dup.json", "dup.md")

    for name in order:
        result = gate(parse_record(completed / name), config)
        assert result.state == "REVIEW", name
        route_to_review(result, review, today="2026-09-14", apply=True)

    records = sorted(review.iterdir())
    assert len(records) == 3, "three sources need three review records"
    source_of = {
        p.name: re.search(r"\*\*Source record\*\*: `([^`]+)`", p.read_text(encoding="utf-8")).group(1)
        for p in records
    }
    assert len(set(source_of.values())) == 3, "each review record must name a different source"
    for name in order:
        stamped = parse_record(completed / name).reopened_to
        assert stamped, f"{name} must be stamped"
        # A Markdown stamp's value carries backticks and the note's trailing text.
        stamped_name = Path(stamped.replace("`", " ").split()[0]).name
        assert source_of[stamped_name].endswith("/" + name), (
            f"{name} is stamped to a review record that belongs to another source"
        )



# ----------------------------------------------- unreadable corpora (bq-2485)
#
# claude.owner_sweep_unreadable_dir_green_03 (GPT Pro 2026-09-15): the preflight
# checked is_dir(), which answers "is this a directory" and not "can its contents
# be listed". A populated directory whose listing permission is gone passed it,
# Path.glob("*") swallowed the PermissionError and yielded nothing, and the sweep
# returned scanned=0 with errors=[] and exit 0 -- so scripts/evolution-daily.sh
# read a permissions regression as a healthy, empty mandatory review while the
# rejects inside sat uninspected. The missing-directory control already worked;
# these cases pin the unreadable one, and pin that an actually-empty readable
# directory is still a clean zero.

_needs_unprivileged = pytest.mark.skipif(
    os.geteuid() == 0,
    reason="running as root: mode 000 does not block enumeration, so the case cannot be simulated",
)


@_needs_unprivileged
def test_sweep_reports_an_unreadable_completed_dir_as_an_error(
    tmp_path: Path, config: LensConfig
) -> None:
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")
    os.chmod(completed, 0o000)
    try:
        report = sweep(completed, config, tmp_path / "review", apply=False)
    finally:
        os.chmod(completed, 0o700)

    assert report["errors"], "an unreadable corpus must not report a clean, empty sweep"
    assert report["scanned"] == 0
    assert report["routed_to_review"] == 0
    joined = " ".join(e["error"] for e in report["errors"])
    assert "could not be enumerated" in joined, joined
    assert "PermissionError" in joined, joined


@_needs_unprivileged
def test_cmd_sweep_returns_nonzero_for_an_unreadable_completed_dir(
    tmp_path: Path, capsys
) -> None:
    """The exit code is what scripts/evolution-daily.sh branches on."""
    import argparse

    from lib.owner_interest_lens import _cmd_sweep

    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")
    os.chmod(completed, 0o000)
    args = argparse.Namespace(
        dir=str(completed),
        review_dir=str(tmp_path / "review"),
        apply=True,
        since_days=None,
        json=False,
    )
    try:
        rc = _cmd_sweep(args, load_config())
    finally:
        os.chmod(completed, 0o700)
    capsys.readouterr()
    assert rc != 0, "a corpus the sweep could not inspect must not report success"


@_needs_unprivileged
def test_sweep_reports_an_unreadable_record_as_an_error(
    tmp_path: Path, config: LensConfig
) -> None:
    """A listable directory holding one unreadable record: the rest still screens."""
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")
    locked = completed / "locked.md"
    locked.write_text(MD_BULLET, encoding="utf-8")
    os.chmod(locked, 0o000)
    try:
        report = sweep(completed, config, tmp_path / "review", apply=False)
    finally:
        os.chmod(locked, 0o600)

    assert report["scanned"] == 2, "both records were seen; one of them could not be read"
    assert report["routed_to_review"] == 1, "the readable reject must still be routed"
    assert any("locked.md" in e["path"] for e in report["errors"]), report["errors"]


def test_sweep_on_an_empty_readable_dir_is_still_a_clean_zero(
    tmp_path: Path, config: LensConfig
) -> None:
    """The fix must not turn a genuinely empty corpus into a failure."""
    completed = tmp_path / "completed"
    completed.mkdir()

    report = sweep(completed, config, tmp_path / "review", apply=False)
    assert report["errors"] == []
    assert report["scanned"] == 0
    assert report["routed_to_review"] == 0


def test_sweep_skips_a_broken_symlink_without_claiming_it_was_screened(
    tmp_path: Path, config: LensConfig
) -> None:
    """A dangling entry is an entry that could not be inspected, not an absent one."""
    completed = tmp_path / "completed"
    completed.mkdir()
    (completed / "hit.md").write_text(MD_BULLET, encoding="utf-8")
    (completed / "gone.md").symlink_to(tmp_path / "nowhere.md")

    report = sweep(completed, config, tmp_path / "review", apply=False)
    assert report["scanned"] == 1, "a dangling link is not a screened record"
    assert report["routed_to_review"] == 1
