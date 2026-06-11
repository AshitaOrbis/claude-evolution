# Discovery: `refreshInterval` Statusline Setting

**Source**: Official Claude Code v2.1.97 changelog  
**Discovered**: 2026-04-10  
**Category**: Developer Experience / Statusline  
**Type**: NOVEL (extension of existing statusline system)

---

## What It Is

A new `refreshInterval` field in the statusline configuration that causes Claude Code to re-execute the status line command every N seconds, enabling live/dynamic status indicators without requiring user interaction.

```json
{
  "statusline": {
    "command": "/path/to/status-script.sh",
    "refreshInterval": 30
  }
}
```

---

## Current Statusline Setup

The existing statusline (via `~/.claude/statusline.sh`) reports:
- `rate_limits` (5h/7d usage windows, `used_percentage`, `resets_at`) — added v2.1.82
- `workspace.git_worktree` — added v2.1.97 (current directory is inside linked worktree)

Currently the statusline only updates when a new interaction begins (not on a timer).

---

## What This Enables

With `refreshInterval`, the statusline could show:
- Live token usage tracking (how close to rate limit)
- Real-time git status (branch, uncommitted changes)
- System resource indicators (memory, CPU for long runs)
- Heartbeat/cron job activity (last run, next run)
- Active MCP server health

---

## Redundancy Check

| Existing Capability | Conflict? |
|--------------------|-----------|
| Existing statusline (`rate_limits`) | No — extends it with auto-refresh |
| Discord notifications | No — different channel (terminal vs chat) |
| Event bus | No — different layer |

**Classification: NOVEL** — no equivalent in registry.

---

## Evaluation

```json
{
  "scores": {
    "integration_complexity": 100,
    "token_efficiency": 50,
    "capability_expansion": 40,
    "maintenance_burden": 100,
    "community_validation": 100
  },
  "total": 72.5,
  "decision": "APPROVED",
  "reasoning": "One-field addition to settings.json with zero maintenance. Enables live rate-limit countdown and heartbeat activity monitoring in the statusline — genuine QoL improvement for long sessions. Implementation: verify statusline.sh is idempotent/fast (no side effects), then add refreshInterval: 30 to settings.json statusline config."
}
```

---

## Action Items

1. Check if current `~/.claude/statusline.sh` script is refresh-safe (idempotent, fast, no side effects)
2. Test: Add `refreshInterval: 30` and observe behavior during a long session
3. Consider: Expose rate_limit percentage as a live countdown during active sessions
