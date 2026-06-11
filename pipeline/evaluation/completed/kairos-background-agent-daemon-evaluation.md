# KAIROS — Background Agent Daemon — Evaluation

**Evaluated**: 2026-04-12
**Source**: Ars Technica article about Claude Code source leak (MEDIUM -> LOW confidence)
**Decision**: FUTURE -> pipeline/future/ (tracking only)
**Cross-validated**: Codex (GPT-5.4)

## Summary

KAIROS is reportedly an unreleased always-on background agent daemon found in Claude Code v2.1.88 source. Key mechanisms: tick-based proactive prompts, PROACTIVE flag, 15-second blocking budget, append-only daily logs, additional tools. Feature-gated behind `feature('KAIROS')`.

## Scoring

| Criterion | Weight | Claude | Codex | Final |
|-----------|--------|--------|-------|-------|
| Integration complexity | 20% | 30 | N/A | 30 |
| Token efficiency impact | 25% | 50 | N/A | 50 |
| Capability expansion | 25% | 90 | N/A | 90 |
| Maintenance burden | 15% | 80 | N/A | 80 |
| Community validation | 15% | 40 | N/A | 40 |

**Claude total**: 59.0 | **Codex total**: N/A (unverifiable) | **Final**: 59.0

## Codex Cross-Validation

Codex **could not verify the foundational claims**:
- No Ars Technica article about Claude Code source leak found
- No public KAIROS documentation in Anthropic releases
- No feature gate evidence in public repositories

Codex recommendation: REJECT for integration pipeline; FUTURE tracking only if Anthropic officially announces.

## Decision Rationale

The feature is behind a server-side feature gate and cannot be activated regardless of version. Source confidence is LOW (secondary reporting of alleged source leak, unverifiable). However, the concepts are architecturally interesting:

**Independently extractable patterns**:
1. **Append-only daily logs** (`logs/YYYY/MM/YYYY-MM-DD.md`) — already a sound pattern for our heartbeat, can adopt without KAIROS
2. **15-second blocking budget** — useful concept for our cron-based automation

**Action**: Move to pipeline/future/. Track for official Anthropic announcement (expected May 2026 per claims). If announced, re-evaluate at that time. The append-only log pattern is worth considering independently.

## Revisit Trigger

Official Anthropic announcement of KAIROS or equivalent persistent daemon feature.
