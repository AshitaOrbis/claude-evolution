# Discovery: /loop Command & Cron Scheduling Tools

**Source**: Claude Code v2.1.71 (2026-03-07)
**Type**: Built-in Slash Command + Native Tools
**Classification**: NOVEL
**Pre-Score**: 82.5/100 → **APPROVED** (route directly to integration)

---

## What Was Discovered

Claude Code v2.1.71 introduces in-session recurring task scheduling:

1. **`/loop` slash command**: User-facing command to run a prompt or slash command on a
   recurring interval within the current session. Example: `/loop 5m check the deploy status`

2. **`CronCreate` / `CronDelete` / `CronList` tools**: Programmatic tools (available to
   agents and skills) for managing recurring scheduled prompts within the session context.

---

## Scoring Breakdown

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Built-in native tools, zero config |
| Token efficiency impact | 25% | 50 | Neutral — automation-focused, not token-saving |
| Capability expansion | 25% | 80 | NOVEL: in-session recurring automation without external infra |
| Maintenance burden | 15% | 100 | Built-in, Anthropic-maintained |
| Community validation | 15% | 100 | Official Anthropic release (v2.1.71 changelog) |
| **Total** | | **82.5** | |

---

## Capability Details

### `/loop` Slash Command

```
/loop <interval> <prompt-or-command>
```

- `<interval>`: Duration string (e.g., `5m`, `30s`, `1h`)
- `<prompt-or-command>`: Any text prompt or slash command (e.g., `/test`, `check deploy`)
- Runs in the foreground of the current session on the specified interval
- User-cancellable

**Examples**:
```
/loop 5m check if the deployment succeeded
/loop 30s run the test suite and summarize failures
/loop 1h summarize what tasks have been completed
```

### CronCreate / CronDelete / CronList Tools

Programmatic API for the same underlying mechanism:

```
CronCreate(interval: string, prompt: string) → cronId
CronDelete(cronId: string)
CronList() → [{cronId, interval, prompt, nextRun}]
```

Available as deferred tools (loaded on-demand by Tool Search Tool).

---

## Comparison to Existing Capabilities

| Existing | What It Does | Gap |
|----------|--------------|-----|
| External cron (`scripts/evolution-daily-heartbeat.sh`) | Session-launching automation | Requires starting new session each time |
| CronCreate tool (new) | In-session recurring scheduling | **This is the new capability** |
| TodoWrite | Task tracking | Not scheduling |

**Key distinction**: External cron creates new Claude sessions. `/loop` and `CronCreate`
run within the current session — useful for monitoring tasks during active development.

---

## Integration Target

**Registry entry** in `registry/existing-capabilities.md` under v2.1.71 section.
**Pattern**: Registry-only (like `/copy`, `claude agents`) — no skill file needed.
The tools are discoverable via Tool Search Tool and the slash command via `/help`.

### Suggested Registry Entry

```
| `/loop` command + Cron tools | **ACTIVE** | In-session recurring prompt scheduling (v2.1.71+). User: `/loop 5m prompt`. Programmatic: CronCreate/CronDelete/CronList tools. Session-scoped only (not for persistence). |
```

---

## Use Cases in Evolution System

1. **Active monitoring**: During long heartbeat runs, `/loop 5m check pipeline status`
2. **Agent-driven scheduling**: Agents can `CronCreate` follow-up verification tasks
3. **Interactive sessions**: User-initiated recurring checks during development

---

## Limitations

- **Session-scoped**: All scheduled tasks die when the session ends
- **Not a replacement** for external cron (heartbeats need persistence across sessions)
- Interval precision is approximate (Claude turn-based)

---

## Decision: APPROVED → Integration

Score 82.5 > 70 threshold. Route to `pipeline/integration/` for registry update.
No skill file or agent modification needed — registry entry only.

**Redundancy triggers to add**: "/loop command", "loop slash command", "CronCreate tool",
"in-session cron", "recurring prompt", "session scheduling", "interval command"
