# Evaluation: /loop Command & Cron Scheduling Tools (v2.1.71)

- **Date**: 2026-03-07
- **Source**: Claude Code v2.1.71 (official Anthropic release)
- **Category**: version-control (built-in Claude Code feature)
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Built-in native tools and slash command — zero config, zero install |
| Token efficiency impact | 25% | 50 | Neutral: automation-focused, not inherently token-saving |
| Capability expansion | 25% | 80 | NOVEL: in-session recurring prompt scheduling without external infra; distinct from external cron (which creates new sessions) |
| Maintenance burden | 15% | 100 | Anthropic-maintained, ships with Claude Code |
| Community validation | 15% | 100 | Official Anthropic release (v2.1.71 changelog confirmed) |

- **Claude Score**: 82.5/100
- **Codex Score**: N/A (skipped — score is unambiguous, Codex not needed)
- **Final Score**: 82.5/100

## Decision

APPROVED — Official built-in capability, NOVEL in-session scheduling, zero integration cost.

## Integration Notes

**Type**: Registry-only (no skill file needed — discoverable via Tool Search Tool and `/help`)

**Integration target**: `registry/existing-capabilities.md` — add entry under v2.1.71 section.

**Suggested registry entry**:
```
| `/loop` command + Cron tools | **ACTIVE** | In-session recurring prompt scheduling (v2.1.71+). User: `/loop 5m prompt`. Programmatic: CronCreate/CronDelete/CronList tools. Session-scoped only (not a replacement for external cron heartbeats). |
```

**Redundancy triggers to add**: "/loop command", "loop slash command", "CronCreate tool", "in-session cron", "recurring prompt", "session scheduling", "interval command", "CronDelete", "CronList"

**Key constraint**: Session-scoped — all scheduled tasks die when session ends. External cron (evolution-daily-heartbeat.sh) remains the correct mechanism for persistent automation.
