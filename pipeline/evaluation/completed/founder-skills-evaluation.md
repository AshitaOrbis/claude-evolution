# Evaluation: Founder Skills (ognjengt/founder-skills)

- **Date**: 2026-03-08
- **Source**: https://github.com/ognjengt/founder-skills
- **Category**: other
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Skills files are Claude Code compatible; could technically be reviewed and selectively adopted. But effort required to filter 20+ skills for relevance. |
| Token efficiency impact | 25% | 50 | Neutral — adds functionality, no efficiency impact. |
| Capability expansion | 25% | 0 | Business/founder-oriented skills (growth teams, marketing, startup workflows) — completely off-scope for this AI engineering evolution system. Zero relevant expansion for Claude Code capability development. |
| Maintenance burden | 15% | 80 | External repo, would just be a reference. Low maintenance if selectively adopted. |
| Community validation | 15% | 50 | GitHub repo, appears in `awesome-agent-skills` aggregator. Unknown star count, no official backing. |

- **Claude Score**: 42/100
- **Codex Score**: N/A (Codex unavailable — skipped for clear-reject case)
- **Final Score**: 42/100

## Decision

REJECTED — Business/founder skills (Fortune 500 growth teams, startup marketing workflows) are entirely out of scope for this AI engineering capability evolution system. The capability expansion score is 0 because none of the 20+ skills address Claude Code, AI engineering, token efficiency, multi-model coordination, or developer tooling.

## Integration Notes

This repo appears in the `awesome-agent-skills` collection and may be useful for users building founder/business-oriented Claude assistants. However, the claude-evolution system focuses exclusively on AI engineering capabilities (token efficiency, multi-model orchestration, developer workflows, MCP integrations).

**Reconsideration trigger**: If the repo expands to include AI engineering or developer tooling skills, re-evaluate.
