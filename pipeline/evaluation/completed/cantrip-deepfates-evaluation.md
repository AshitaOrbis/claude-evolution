# Evaluation: Cantrip (deepfates)

- **Date**: 2026-03-11
- **Source**: https://github.com/deepfates/cantrip
- **Category**: Agent Framework / TypeScript Template
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Template is forkable but is a ghost library — abandoned, no active development |
| Token efficiency impact | 25% | 50 | Neutral — spec/template pattern with no measurable impact |
| Capability expansion | 25% | 30 | "Agent grimoire starter pack" overlaps with existing agent frameworks; abandoned state means no evolving value |
| Maintenance burden | 15% | 0 | Creator explicitly labels it "Status: ghost library" — zero maintenance expected, zero updates |
| Community validation | 15% | 20 | 1 GitHub star; abandoned per creator's own documentation |

- **Claude Score**: 33/100
- **Codex Score**: N/A (skipped — clearly below threshold)
- **Final Score**: 33/100

## Decision

REJECTED — Ghost library with 1 star. Creator marks status as "ghost library" on the project site. No active development, no community traction, capability overlaps with existing agent frameworks.

## Integration Notes

No reconsideration triggers. If the creator revives the project and it gains meaningful traction (100+ stars, active commits), re-evaluate. The spec-based approach to tool_choice enforcement could be interesting if the project were active.
