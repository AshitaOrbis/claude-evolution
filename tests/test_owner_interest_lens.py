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

import pytest

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
