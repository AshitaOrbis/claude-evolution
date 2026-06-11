# Claude Code Token Usage Analyzer (Kieran Klaassen Gist)

- **Date**: 2026-04-06
- **Source**: Discord #general inbox
- **URL**: https://gist.github.com/kieranklaassen/7b2ebb39cbbb78cc2831497605d76cc6
- **Category**: tool, token-analysis
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1490863196867657800
- **Evaluated**: 2026-04-11 (gist content fetched)

## Description

Python utility (`token_analysis.py`) that parses Claude Code session JSONL files from `~/.claude/projects/` to analyze token consumption patterns. Key features:
- Tracks input, output, cache creation, and cache read tokens across sessions
- Identifies costliest sessions and subagent usage patterns
- Filters sessions by date range via `SINCE_DAYS` or `SINCE_DATE` env vars
- Generates markdown reports with per-project breakdowns
- Outputs reports to `~/tuin/analysis/tokens/` (Kieran-specific path, requires modification)

## Evaluation (NEEDS_RESEARCH — 57.75)

```json
{
  "scores": {
    "integration_complexity": 60,
    "token_efficiency": 40,
    "capability_expansion": 65,
    "maintenance_burden": 70,
    "community_validation": 60
  },
  "total": 57.75,
  "decision": "NEEDS_RESEARCH",
  "reasoning": "Content now confirmed via gist fetch. The script analyzes Claude Code session artifacts to track per-project and per-subagent token costs — a capability we don't have. Token efficiency score is 40 (analyzes waste, doesn't prevent it). Capability expansion is 65 (novel, useful for understanding heartbeat/subagent cost patterns). Integration complexity is 60 (requires path modification from ~/tuin/analysis/tokens/ to a workspace-appropriate location, verifying Python deps). Kieran Klaassen is a recognized Claude Code community contributor (community 60 — gist format, no star tracking). Research needed: (1) identify exact Python dependencies, (2) adapt output path, (3) assess whether per-session token breakdown adds value vs Claude Code's built-in /cost command.",
  "research_questions": [
    "What Python dependencies does the script use? (stdlib only? or pandas/tabulate/etc?)",
    "Does this add value over /cost command's per-session breakdown?",
    "Can the output path be made configurable via env var rather than hardcoded?",
    "How does it handle multi-project analysis — does it distinguish cwd contexts?"
  ]
}
```
