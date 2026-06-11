# Discovery: Claude Code v2.1.72 — CLAUDE_CODE_DISABLE_CRON + /plan Description

- **Source**: https://github.com/anthropics/claude-code/releases (v2.1.72, 2026-03-10)
- **Date Found**: 2026-03-11
- **Category**: technique
- **Summary**: v2.1.72 adds `CLAUDE_CODE_DISABLE_CRON` env var to suppress scheduled cron jobs (useful for controlled automation environments), and an optional description argument to the `/plan` command to direct planning focus. Both improve workflow control without adding overhead.
- **Potential Value**: Medium
- **Integration Complexity**: Easy

## Details

### CLAUDE_CODE_DISABLE_CRON (New Env Var)

Setting `CLAUDE_CODE_DISABLE_CRON=1` suppresses all cron-scheduled loop jobs for that session. Complements the loop/cron scheduling feature from v2.1.71.

**Relevance to our system**: We run heartbeat cron jobs via the `loop-command-cron-scheduling` feature. In some contexts (interactive sessions, CI runs, testing) we may want to disable cron without disabling the whole session. This env var provides that control.

**Integration**: Document in `state/versions.json` notes and potentially in the loop skill. Zero overhead.

### /plan Optional Description

`/plan [description]` now accepts a human-readable description to guide what Claude should focus on during planning. E.g. `/plan "auth refactor"` vs just `/plan`.

**Relevance**: Minor but useful UX improvement for plan mode workflows.

## Redundancy Check

- `CLAUDE_CODE_DISABLE_CRON`: No registry entry. **NOVEL** env var — complements `loop-command-cron-scheduling-v2171` (integrated).
- `/plan description`: No registry entry for this specific parameter. **IMPROVEMENT** to built-in /plan command.
- Note: `ExitWorktree` (also in v2.1.72) is already in the system's tool set — skip.

## Pre-Assessment Score (CLAUDE_CODE_DISABLE_CRON)

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Document env var — zero friction |
| Token efficiency impact | 25% | 50 | Neutral to token costs |
| Capability expansion | 25% | 60 | Incremental control over existing cron feature |
| Maintenance burden | 15% | 100 | No maintenance — built-in env var |
| Community validation | 15% | 100 | Official Anthropic release |
| **TOTAL** | | **77.5** | **APPROVE** |

## Recommended Action

- Document `CLAUDE_CODE_DISABLE_CRON` in registry under loop/cron section
- Note `/plan [description]` improvement
- Update `state/versions.json` notes
