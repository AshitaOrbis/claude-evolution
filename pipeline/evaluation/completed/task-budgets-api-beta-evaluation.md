# Task Budgets API Beta — Evaluation

- **Source**: https://platform.claude.com/docs/en/docs/build-with-claude/task-budgets
- **Type**: Technique / API feature
- **Beta header**: `anthropic-beta: task-budgets-2026-03-13`
- **Discovered**: 2026-04-18
- **Evaluated**: 2026-04-19

## Verified Facts (from official docs, fetched 2026-04-19)

| Fact | Value |
|------|-------|
| Models supported | Claude Opus 4.7 only |
| Opus 4.6, Sonnet 4.6, Haiku 4.5 | **Not supported** |
| Claude Code support | **Not supported at launch** ("not supported on Claude Code or Cowork surfaces at launch") |
| Auth | `x-api-key: $ANTHROPIC_API_KEY` (Messages API direct) |
| Minimum budget | 20,000 tokens (below returns 400) |
| Carries across compaction | Yes, via `remaining` field |
| Hard cap? | No — advisory; `max_tokens` remains the hard limit |

## Redundancy Check

NOVEL conceptually — no existing equivalent in registry (`CLAUDE_CODE_SCRIPT_CAPS` is bash invocation cap, `max_tokens` is per-request hard cap). Task Budgets are model-visible, agentic-loop-spanning, advisory.

## Scoring

| Criterion | Weight | Score | Reasoning |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 0 | **Impossible.** Not supported on Claude Code. Max plan has no `ANTHROPIC_API_KEY`. No surface to call this from in current setup. |
| Token efficiency | 25% | 70 | If accessible, would meaningfully reduce wasted late-loop tokens via graceful self-termination. |
| Capability expansion | 25% | 70 | Novel cross-loop budget concept with carry-across-compaction. |
| Maintenance burden | 15% | 100 | Official Anthropic feature. |
| Community validation | 15% | 100 | Official platform docs, public beta. |

**Total**: (0×0.20) + (70×0.25) + (70×0.25) + (100×0.15) + (100×0.15) = 0 + 17.5 + 17.5 + 15 + 15 = **65.0**

## Decision: REJECT (revisit when reachable)

Same auth-blocker pattern as the ant CLI rejection (2026-04-15). Workspace runs on Claude Max plan keychain auth; there is no ANTHROPIC_API_KEY. Documentation is explicit: **Task Budgets are not supported on Claude Code at launch**. The capability is real and would be useful for heartbeat agentic loops, but there is no path from our setup to use it today.

**Reconsider when ANY of**:
1. Anthropic adds Task Budget support to Claude Code (watch changelog).
2. Max plan adds ANTHROPIC_API_KEY issuance.
3. Claude Code Routines or similar exposes a way to pass the beta header on Max plan.

Add to a watch list rather than archive — this is a "blocked-by-platform" rejection, not a quality rejection.

## Cross-Validation Note

Codex MCP was unreachable during this evaluation. Cross-validation done via direct fetch of official Anthropic docs (the most authoritative source available). The "not supported on Claude Code" line is dispositive and removes need for cross-model scoring.
