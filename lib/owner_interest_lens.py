"""Owner-interest lens for the claude-evolution intake pipeline.

The evaluation rubric scores one question: does this improve the Claude Code
evolution system? Items that fail it are closed. That closure is terminal and
single-domain, and it has already buried three repos the owner personally shared
(Qwen3-TTS, AIRI, Open-LLM-VTuber) in domains the workspace later built projects in.

This module is the second question, asked only of items the rubric is about to
reject: does this land in a domain the owner works in anyway? A match does not
approve the item and does not touch its score. It routes the item to
``pipeline/evaluation/review/`` — an open state — instead of closing it.

Domains live in ``config/owner-interests.yaml``. Adding one is a config edit.

CLI::

    python3 lib/owner_interest_lens.py screen <path>...        # what matches, and why
    python3 lib/owner_interest_lens.py gate <path>...          # REVIEW or REJECTED
    python3 lib/owner_interest_lens.py stamp <path>...         # pre-screen a pending record
    python3 lib/owner_interest_lens.py sweep [--apply] [--since-days N] [--dir D]

``sweep`` is the enforcement path and is idempotent: an item already reopened is
never reopened twice.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from datetime import date, datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Iterable, Sequence

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_CONFIG_PATH = REPO_ROOT / "config" / "owner-interests.yaml"
DEFAULT_COMPLETED_DIR = REPO_ROOT / "pipeline" / "evaluation" / "completed"
DEFAULT_REVIEW_DIR = REPO_ROOT / "pipeline" / "evaluation" / "review"

STRONG_WEIGHT = 2
WEAK_WEIGHT = 1

#: Decisions the lens may reopen. Everything else passes through untouched —
#: notably REJECTED_BY_HUMAN, where the owner has already ruled in person.
REOPENABLE_DECISIONS = {"REJECTED", "REJECT"}
#: Below this score an item is treated as a reject even if it carries no decision.
REJECT_SCORE_CEILING = 50.0

REOPEN_MARKER = "**Owner-Interest Reopen**"
STAMP_HEADING = "## Owner Interest (pre-screen)"


# --------------------------------------------------------------------------- config


@dataclass(frozen=True)
class Domain:
    id: str
    label: str
    why: str
    serves: tuple[str, ...]
    threshold: int
    strong: tuple[tuple[str, re.Pattern[str]], ...]
    weak: tuple[tuple[str, re.Pattern[str]], ...]
    exclude: tuple[tuple[str, re.Pattern[str]], ...]


@dataclass(frozen=True)
class LensConfig:
    version: int
    default_threshold: int
    domains: tuple[Domain, ...]
    source_path: Path | None = None

    def domain(self, domain_id: str) -> Domain:
        for d in self.domains:
            if d.id == domain_id:
                return d
        raise KeyError(domain_id)


def _term_pattern(term: str) -> re.Pattern[str]:
    """Compile a term into an elastic, boundary-aware pattern.

    ``text-to-speech`` also matches ``text to speech`` and ``texttospeech``; ``tts``
    matches ``Qwen3-TTS`` but not ``attstore``.
    """
    parts = [re.escape(p) for p in re.split(r"[^a-z0-9.]+", term.lower().strip()) if p]
    if not parts:
        raise ValueError(f"term compiles to nothing: {term!r}")
    body = r"[\s\-_/]*".join(parts)
    return re.compile(rf"(?<![a-z0-9]){body}(?![a-z0-9])", re.IGNORECASE)


def _compile_terms(terms: Iterable[str]) -> tuple[tuple[str, re.Pattern[str]], ...]:
    return tuple((str(t), _term_pattern(str(t))) for t in (terms or []))


def load_config(path: str | Path | None = None) -> LensConfig:
    cfg_path = Path(path) if path else DEFAULT_CONFIG_PATH
    raw = yaml.safe_load(cfg_path.read_text(encoding="utf-8")) or {}

    default_threshold = int(raw.get("default_threshold", 2))
    domains: list[Domain] = []
    seen: set[str] = set()

    for entry in raw.get("domains") or []:
        domain_id = str(entry.get("id", "")).strip()
        if not domain_id:
            raise ValueError(f"{cfg_path}: a domain is missing 'id'")
        if domain_id in seen:
            raise ValueError(f"{cfg_path}: duplicate domain id {domain_id!r}")
        seen.add(domain_id)

        strong = _compile_terms(entry.get("strong_signals"))
        weak = _compile_terms(entry.get("signals"))
        if not strong and not weak:
            raise ValueError(f"{cfg_path}: domain {domain_id!r} has no signals")

        domains.append(
            Domain(
                id=domain_id,
                label=str(entry.get("label", domain_id)),
                why=" ".join(str(entry.get("why", "")).split()),
                serves=tuple(str(s) for s in entry.get("serves") or ()),
                threshold=int(entry.get("threshold", default_threshold)),
                strong=strong,
                weak=weak,
                exclude=_compile_terms(entry.get("exclude")),
            )
        )

    if not domains:
        raise ValueError(f"{cfg_path}: no domains defined")

    return LensConfig(
        version=int(raw.get("version", 1)),
        default_threshold=default_threshold,
        domains=tuple(domains),
        source_path=cfg_path,
    )


# --------------------------------------------------------------------------- screening


@dataclass(frozen=True)
class DomainMatch:
    domain: Domain
    score: int
    strong_hits: tuple[str, ...]
    weak_hits: tuple[str, ...]

    @property
    def hits(self) -> tuple[str, ...]:
        return self.strong_hits + self.weak_hits

    def describe(self) -> str:
        return f"{self.domain.id} (score {self.score}: {', '.join(self.hits)})"


def _count_once(
    text: str, terms: Sequence[tuple[tuple[str, re.Pattern[str]], int]]
) -> tuple[list[str], list[str], list[tuple[int, int]]]:
    """Count each term at most once, and never count the same evidence twice.

    Two rules, because there are two ways terms collide. ``speech synthesis`` swallows
    ``speech``, so a claimed *span* blocks anything overlapping it. ``vtuber`` and
    ``v-tuber`` are spellings of one word, so a claimed *string* blocks a synonym that
    matches the same text somewhere else in the document. Heavier terms claim first.
    """
    strong_hits: list[str] = []
    weak_hits: list[str] = []
    claimed_spans: list[tuple[int, int]] = []
    claimed_text: set[str] = set()

    for (term, pattern), weight in sorted(terms, key=lambda t: -t[1]):
        for m in pattern.finditer(text):
            span = m.span()
            if any(span[0] < c[1] and c[0] < span[1] for c in claimed_spans):
                continue
            normalized = re.sub(r"[\s\-_/]+", "", m.group(0).lower())
            if normalized in claimed_text:
                continue
            claimed_spans.append(span)
            claimed_text.add(normalized)
            (strong_hits if weight == STRONG_WEIGHT else weak_hits).append(term)
            break

    return strong_hits, weak_hits, claimed_spans


def screen(text: str, config: LensConfig) -> list[DomainMatch]:
    """Return every owner-interest domain the text lands in, best score first."""
    matches: list[DomainMatch] = []
    if not text:
        return matches

    for domain in config.domains:
        if any(pat.search(text) for _, pat in domain.exclude):
            continue
        terms = [(t, STRONG_WEIGHT) for t in domain.strong]
        terms += [(t, WEAK_WEIGHT) for t in domain.weak]
        strong_hits, weak_hits, _ = _count_once(text, terms)
        score = STRONG_WEIGHT * len(strong_hits) + WEAK_WEIGHT * len(weak_hits)
        if score >= domain.threshold:
            matches.append(DomainMatch(domain, score, tuple(strong_hits), tuple(weak_hits)))

    matches.sort(key=lambda m: (-m.score, m.domain.id))
    return matches


# --------------------------------------------------------------------------- records


@dataclass
class Record:
    path: Path
    title: str
    decision: str | None
    score: float | None
    text: str
    raw: str
    fmt: str  # "json" | "md"
    reopened_to: str | None = None

    @property
    def is_reopenable_reject(self) -> bool:
        """True when the rubric closed this item and no human has ruled on it."""
        if self.decision:
            return self.decision.upper() in REOPENABLE_DECISIONS
        return self.score is not None and self.score < REJECT_SCORE_CEILING


def _strings(node: Any) -> Iterable[str]:
    if isinstance(node, str):
        yield node
    elif isinstance(node, dict):
        for key, value in node.items():
            yield str(key)
            yield from _strings(value)
    elif isinstance(node, (list, tuple)):
        for value in node:
            yield from _strings(value)


def _strip_lens_annotations(text: str) -> str:
    """Remove the lens's own output so re-screening can't feed on itself."""
    lines: list[str] = []
    in_stamp = False
    for line in text.splitlines():
        if line.strip().startswith(STAMP_HEADING):
            in_stamp = True
            continue
        if in_stamp:
            if line.startswith("#") and not line.strip().startswith(STAMP_HEADING):
                in_stamp = False
            else:
                continue
        if REOPEN_MARKER in line:
            continue
        lines.append(line)
    return "\n".join(lines)


def parse_record(path: str | Path) -> Record:
    """Read an evaluation record in any of the three formats the pipeline emits."""
    path = Path(path)
    raw = path.read_text(encoding="utf-8")
    reopened = None
    for line in raw.splitlines():
        if REOPEN_MARKER in line:
            reopened = line.split("→")[-1].strip() if "→" in line else line.strip()
            break

    if path.suffix == ".json":
        data = json.loads(raw)
        evaluation = data.get("evaluation") if isinstance(data, dict) else None
        evaluation = evaluation if isinstance(evaluation, dict) else {}
        decision = evaluation.get("decision") or data.get("decision")
        score = evaluation.get("total", data.get("evaluation_score"))
        # JSON records carry the reopen stamp as a field, not as marker text.
        prior = evaluation.get("owner_interest_reopen")
        if isinstance(prior, dict) and prior.get("review_record"):
            reopened = str(prior["review_record"])
        return Record(
            path=path,
            title=str(data.get("title") or path.stem),
            decision=str(decision) if decision else None,
            score=float(score) if isinstance(score, (int, float)) else None,
            text=" ".join(_strings(data)),
            raw=raw,
            fmt="json",
            reopened_to=reopened,
        )

    title = path.stem
    for line in raw.splitlines():
        if line.startswith("# "):
            title = line[2:].strip()
            break

    decision = None
    m = re.search(r'"decision"\s*:\s*"([A-Za-z_]+)"', raw)
    if m:
        decision = m.group(1)
    else:
        m = re.search(r"\*\*Decision\*\*\s*:\s*([A-Za-z_]+)", raw)
        if m:
            decision = m.group(1)

    score = None
    m = re.search(r'"total"\s*:\s*([0-9.]+)', raw) or re.search(
        r"\*\*Score\*\*\s*:\s*([0-9.]+)", raw
    )
    if m:
        score = float(m.group(1))

    return Record(
        path=path,
        title=title,
        decision=decision,
        score=score,
        text=_strip_lens_annotations(raw),
        raw=raw,
        fmt="md",
        reopened_to=reopened,
    )


# --------------------------------------------------------------------------- gate


@dataclass
class GateResult:
    record: Record
    matches: list[DomainMatch]
    state: str  # REVIEW | REJECTED | UNCHANGED | ALREADY_REVIEW
    reason: str

    @property
    def routed(self) -> bool:
        return self.state == "REVIEW"


def gate(record: Record, config: LensConfig) -> GateResult:
    """Decide what happens to a record once the rubric has spoken.

    Only would-be rejects are screened. Approvals, research flags and human
    rejections pass through untouched — the lens widens closure, not approval.
    """
    if record.reopened_to:
        return GateResult(record, [], "ALREADY_REVIEW", f"already reopened → {record.reopened_to}")
    if not record.is_reopenable_reject:
        return GateResult(
            record, [], "UNCHANGED", f"decision {record.decision or 'n/a'} is not lens-eligible"
        )

    matches = screen(record.text, config)
    if not matches:
        return GateResult(record, [], "REJECTED", "no owner-interest domain matched")
    return GateResult(
        record,
        matches,
        "REVIEW",
        "owner-interest match: " + "; ".join(m.describe() for m in matches),
    )


# --------------------------------------------------------------------------- routing


def _serves(matches: Sequence[DomainMatch]) -> list[str]:
    out: list[str] = []
    for m in matches:
        for s in m.domain.serves:
            if s not in out:
                out.append(s)
    return out


def render_review_record(result: GateResult, today: str) -> str:
    r = result.record
    rel = _rel(r.path)
    original_decision = r.decision or "REJECTED (implied by score)"
    score_txt = f" (score {r.score:g}/100)" if r.score is not None else ""

    lines = [
        f"# REVIEW — {r.title}",
        "",
        "- **State**: REVIEW — open, not closed. Awaiting owner/orchestrator triage.",
        f"- **Reopened**: {today} by the owner-interest lens",
        f"- **Source record**: `{rel}`",
        f"- **Rubric decision**: {original_decision}{score_txt} — unchanged, and still correct "
        "for the Claude Code question it answers.",
        "- **Owner-interest domains**: "
        + ", ".join(f"{m.domain.id} ({m.score})" for m in result.matches),
        "- **Serves**: " + (", ".join(_serves(result.matches)) or "—"),
        "",
        "## Why this is open",
        "",
    ]
    for m in result.matches:
        lines.append(f"**{m.domain.label}** — {m.domain.why}")
        lines.append("")

    lines += ["## Matched signals", "", "| Domain | Score | Signals |", "|---|---|---|"]
    for m in result.matches:
        strong = ", ".join(f"**{h}**" for h in m.strong_hits)
        weak = ", ".join(m.weak_hits)
        signals = ", ".join(x for x in (strong, weak) if x)
        lines.append(f"| {m.domain.id} | {m.score} | {signals} |")

    lines += [
        "",
        "Bold signals are decisive on their own; plain signals need corroboration.",
        "",
        "## Triage",
        "",
        "One of three outcomes, recorded here:",
        "",
        "- **Route** — hand it to the project named under *Serves* and close this record.",
        "- **Close** — the rubric was right and the domain match is noise. Say why.",
        "- **Hold** — relevant but nothing consumes it yet; leave open with a trigger.",
        "",
        "## Original record",
        "",
        "```",
        r.raw.rstrip("\n"),
        "```",
        "",
    ]
    return "\n".join(lines)


def _rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def _stamp_original(record: Record, review_path: Path, today: str) -> None:
    """Mark the closed record so it cannot silently disagree with the review queue."""
    note = f"\n{REOPEN_MARKER}: {today} → `{_rel(review_path)}` (owner-interest lens)\n"
    if record.fmt == "json":
        data = json.loads(record.raw)
        data.setdefault("evaluation", {})
        data["evaluation"]["owner_interest_reopen"] = {
            "date": today,
            "review_record": _rel(review_path),
        }
        record.path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    else:
        record.path.write_text(record.raw.rstrip("\n") + "\n" + note, encoding="utf-8")


def route_to_review(
    result: GateResult,
    review_dir: Path = DEFAULT_REVIEW_DIR,
    today: str | None = None,
    apply: bool = False,
) -> Path:
    """Write the REVIEW record and stamp the original. Idempotent."""
    today = today or date.today().isoformat()
    review_path = review_dir / (result.record.path.stem + ".md")
    if not apply:
        return review_path
    review_dir.mkdir(parents=True, exist_ok=True)
    if review_path.exists():
        return review_path
    review_path.write_text(render_review_record(result, today), encoding="utf-8")
    _stamp_original(result.record, review_path, today)
    return review_path


def stamp_pending(path: str | Path, config: LensConfig, apply: bool = False) -> list[DomainMatch]:
    """Annotate a pending discovery so the evaluator sees the lens before scoring."""
    path = Path(path)
    raw = path.read_text(encoding="utf-8")
    matches = screen(_strip_lens_annotations(raw), config)
    if not apply or not matches or STAMP_HEADING in raw:
        return matches
    block = [
        "",
        STAMP_HEADING,
        "",
        "This item matches owner-interest domains. If the Claude Code rubric scores it below",
        "the reject threshold, it must **not** be closed: set `decision: REVIEW` and move it to",
        "`pipeline/evaluation/review/`. See `config/owner-interests.yaml`.",
        "",
        "| Domain | Score | Serves |",
        "|---|---|---|",
    ]
    for m in matches:
        block.append(f"| {m.domain.id} | {m.score} | {', '.join(m.domain.serves) or '—'} |")
    block.append("")
    path.write_text(raw.rstrip("\n") + "\n" + "\n".join(block), encoding="utf-8")
    return matches


# --------------------------------------------------------------------------- sweep


def sweep(
    directory: Path = DEFAULT_COMPLETED_DIR,
    config: LensConfig | None = None,
    review_dir: Path = DEFAULT_REVIEW_DIR,
    apply: bool = False,
    since_days: int | None = None,
    today: str | None = None,
) -> dict[str, Any]:
    """Screen closed records and reopen the ones that land in an owner domain."""
    config = config or load_config()
    cutoff = None
    if since_days is not None:
        cutoff = (datetime.now(timezone.utc) - timedelta(days=since_days)).timestamp()

    scanned = 0
    routed: list[dict[str, Any]] = []
    already = 0
    skipped_ineligible = 0
    errors: list[dict[str, str]] = []

    for path in sorted(directory.glob("*")):
        if path.suffix not in {".md", ".json"} or not path.is_file():
            continue
        if cutoff is not None and path.stat().st_mtime < cutoff:
            continue
        scanned += 1
        try:
            record = parse_record(path)
        except Exception as exc:  # a malformed record must not stop the sweep
            errors.append({"path": _rel(path), "error": f"{type(exc).__name__}: {exc}"})
            continue

        result = gate(record, config)
        if result.state == "ALREADY_REVIEW":
            already += 1
        elif result.state == "REVIEW":
            review_path = route_to_review(result, review_dir, today=today, apply=apply)
            routed.append(
                {
                    "path": _rel(path),
                    "title": record.title,
                    "score": record.score,
                    "domains": [
                        {"id": m.domain.id, "score": m.score, "hits": list(m.hits)}
                        for m in result.matches
                    ],
                    "serves": _serves(result.matches),
                    "review_record": _rel(review_path),
                }
            )
        elif result.state == "UNCHANGED":
            skipped_ineligible += 1

    return {
        "dir": _rel(directory),
        "applied": apply,
        "since_days": since_days,
        "scanned": scanned,
        "routed_to_review": len(routed),
        "already_reopened": already,
        "not_a_reject": skipped_ineligible,
        "errors": errors,
        "items": routed,
    }


# --------------------------------------------------------------------------- cli


def _cmd_screen(args: argparse.Namespace, config: LensConfig) -> int:
    for p in args.paths:
        record = parse_record(p)
        matches = screen(record.text, config)
        print(f"{_rel(Path(p))}  [{record.decision or 'no decision'}]")
        if not matches:
            print("  no owner-interest match")
        for m in matches:
            print(f"  {m.describe()}  → serves: {', '.join(m.domain.serves) or '—'}")
    return 0


def _cmd_gate(args: argparse.Namespace, config: LensConfig) -> int:
    exit_code = 0
    for p in args.paths:
        result = gate(parse_record(p), config)
        print(f"{_rel(Path(p))}: {result.state} — {result.reason}")
        if result.routed:
            exit_code = 10  # callers can branch on "something needs review"
    return exit_code


def _cmd_stamp(args: argparse.Namespace, config: LensConfig) -> int:
    for p in args.paths:
        matches = stamp_pending(p, config, apply=args.apply)
        state = "stamped" if (matches and args.apply) else ("would stamp" if matches else "no match")
        print(f"{_rel(Path(p))}: {state} — {', '.join(m.domain.id for m in matches) or '—'}")
    return 0


def _cmd_sweep(args: argparse.Namespace, config: LensConfig) -> int:
    report = sweep(
        directory=Path(args.dir),
        config=config,
        review_dir=Path(args.review_dir),
        apply=args.apply,
        since_days=args.since_days,
    )
    if args.json:
        print(json.dumps(report, indent=2))
    else:
        verb = "reopened" if args.apply else "would reopen"
        print(
            f"scanned {report['scanned']} · {verb} {report['routed_to_review']} · "
            f"already open {report['already_reopened']} · not a reject {report['not_a_reject']}"
        )
        for item in report["items"]:
            domains = ", ".join(f"{d['id']}({d['score']})" for d in item["domains"])
            print(f"  {item['path']}  →  {domains}")
        for err in report["errors"]:
            print(f"  ! {err['path']}: {err['error']}", file=sys.stderr)
    return 0


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--config", default=None, help="path to owner-interests.yaml")
    sub = parser.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("screen", help="show owner-interest matches for records")
    p.add_argument("paths", nargs="+")
    p.set_defaults(func=_cmd_screen)

    p = sub.add_parser("gate", help="show the post-lens decision for records")
    p.add_argument("paths", nargs="+")
    p.set_defaults(func=_cmd_gate)

    p = sub.add_parser("stamp", help="pre-screen pending discoveries for the evaluator")
    p.add_argument("paths", nargs="+")
    p.add_argument("--apply", action="store_true")
    p.set_defaults(func=_cmd_stamp)

    p = sub.add_parser("sweep", help="reopen closed rejects that match an owner domain")
    p.add_argument("--dir", default=str(DEFAULT_COMPLETED_DIR))
    p.add_argument("--review-dir", default=str(DEFAULT_REVIEW_DIR))
    p.add_argument("--apply", action="store_true", help="write review records (default: dry run)")
    p.add_argument("--since-days", type=int, default=None)
    p.add_argument("--json", action="store_true")
    p.set_defaults(func=_cmd_sweep)

    args = parser.parse_args(argv)
    return args.func(args, load_config(args.config))


if __name__ == "__main__":
    raise SystemExit(main())
