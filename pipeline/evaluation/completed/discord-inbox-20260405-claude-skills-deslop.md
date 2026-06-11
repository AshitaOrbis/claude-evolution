# Claude Skills: The `/deslop` Utility

- **Date**: 2026-04-05
- **Source**: Discord #general inbox
- **URL**: https://github.com/thtskaran/claude-skills
- **Category**: tool
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1490209284158525674

## Description

A repository containing battle-tested skills for Claude Code, focused on making AI-generated code production-ready. The primary offering is the `/deslop` skill, which implements a two-phase workflow for auditing and hardening code:

1. **Audit Phase**: 5-pass structured analysis (reconnaissance, patterns, logic, security, synthesis) producing a machine-parseable `AUDIT.md`
2. **Remediation Phase**: Safety-tiered fix application (Tier 1: mechanical, Tier 2: tested one-at-a-time, Tier 3: explicit approval)

Language-agnostic. Guardrails: no business-logic changes, no API-contract changes, no test deletion, no new dependencies without approval.

## Redundancy Check

**Existing overlapping capabilities:**

| Existing | Overlap |
|----------|---------|
| `code-reviewer` subagent | Post-implementation code review (unstructured) |
| `security-auditor` subagent + Semgrep MCP | Security scanning (more specialized) |
| `simplify` skill (built-in) | Code cleanup command |
| `self-healing-pipeline` skill | Iterative test-fix hardening loop |
| `refactoring-advisor` subagent | Code improvement suggestions |

**Classification**: IMPROVEMENT (adds structured audit artifact + tiered remediation gating) over existing `code-reviewer`, but incremental not transformative.

## Research Findings (Codex GPT-5.4 Cross-Validation)

| Question | Answer |
|----------|--------|
| Star count | **11** (2 forks, 0 issues, 0 PRs) |
| Last push | 2026-02-12 (~52 days stale) |
| Author activity | Active elsewhere (`claude-researcher` pushed 2026-04-04) but not on this repo |
| Community feedback | **Zero** — no HN, Reddit, Discord, or issue discussion |
| Landscape comparison | `davila7/claude-code-templates` (24K stars), `levnikolaevich/claude-code-skills` (314 stars) — this repo is far behind |
| Integration effort | Very low: single SKILL.md + 3 bash helper scripts |
| Token efficiency | Likely expensive: 5-pass audit + characterization tests per fix |

## Evaluation (2026-04-05, Research Resolved)

```json
{
  "evaluation": {
    "scores": {
      "integration_complexity": 90,
      "token_efficiency": 45,
      "capability_expansion": 55,
      "maintenance_burden": 35,
      "community_validation": 20
    },
    "weights": {
      "integration_complexity": 0.20,
      "token_efficiency": 0.25,
      "capability_expansion": 0.25,
      "maintenance_burden": 0.15,
      "community_validation": 0.15
    },
    "total": 51.3,
    "decision": "ARCHIVE",
    "cross_validation": "codex-gpt-5.4 (score: 55, concordant direction)",
    "reasoning": "Research resolved both blockers negatively. Star count (11) is far below the 100+ threshold needed to raise community validation. The structured AUDIT.md artifact is a thoughtful workflow design, but does not add enough capability over existing code-reviewer + simplify + self-healing-pipeline combination to justify integration. Token cost is a concern (5-pass full-codebase scan). 52 days stale with author scattered across multiple repos. No community validation whatsoever. Pattern extraction (audit-then-remediate with tiers) is the only extractable value — documented below for reference."
  }
}
```

### Score Breakdown

| Criterion | Weight | Score | Reasoning |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Single SKILL.md + 3 scripts, copy-paste setup, no deps |
| Token efficiency | 25% | 45 | 5-pass audit + per-fix characterization tests = expensive; no optimization claims |
| Capability expansion | 25% | 55 | Structured audit artifact is novel workflow, but overlaps 4+ existing capabilities |
| Maintenance burden | 15% | 35 | 11 stars, 52 days stale, author active elsewhere, low priority signal |
| Community validation | 15% | 20 | 11 stars, zero feedback, zero public discussion, new author |
| **Weighted Total** | | **51.3** | **Below 70 threshold, research complete, no path to approval** |

## Extractable Pattern (for reference)

The **tiered remediation** concept is worth noting:
- Tier 1 (mechanical/safe): auto-apply
- Tier 2 (logic-touching): apply with pre/post characterization tests
- Tier 3 (architectural): require explicit approval

This maps loosely to the iterative-improve skill's P0/P1/P2 classification in Phase 4 (Codex Code Review). No new integration needed — existing pattern is equivalent.

## Decision

**ARCHIVE** — Score 51.3, below 70 threshold. Research questions resolved negatively. Incremental over existing capabilities with concerning maintenance signals.
