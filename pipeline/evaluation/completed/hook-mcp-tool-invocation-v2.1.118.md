---
name: Hook MCP Tool Invocation
description: Hooks can now invoke MCP tools directly via type:"mcp_tool", enabling hooks to call event-bus, brave-search, and other MCP tools without a shell script intermediary.
type: novel
source: Official Claude Code v2.1.118 changelog (April 23, 2026)
date_discovered: 2026-04-23
classification: NOVEL
version: 2.1.118
---

# Hook MCP Tool Invocation (`type: "mcp_tool"`)

## What It Is

Claude Code v2.1.118 adds a new hook invocation type: `type: "mcp_tool"`. Previously, hooks could only execute shell commands (`type: "command"`). Now hooks can call any configured MCP tool directly, passing tool arguments in the hook definition.

**Example (hypothetical config in settings.json):**
```json
{
  "hooks": {
    "Stop": [
      {
        "type": "mcp_tool",
        "server": "event-bus",
        "tool": "publish_event",
        "args": {
          "topic": "session.stopped",
          "payload": {}
        }
      }
    ]
  }
}
```

## Why This Matters

Current architecture: hooks → shell script → MCP tool via HTTP/stdio → result.

New architecture: hooks → MCP tool (direct, in-process).

This removes the shell script intermediary for MCP-backed operations. Concrete impacts:

- **Event bus publishing from hooks**: Instead of `scripts/publish.sh`, hooks call `mcp__event-bus__publish_event` directly. Eliminates shell scripting for every event bus hook.
- **Agent heartbeat registration**: Hooks can call `mcp__event-bus__register_agent` / `mcp__event-bus__agent_heartbeat` without bash scaffolding.
- **Web search from hooks**: A PreToolUse hook could call `mcp__brave-search__brave_web_search` to validate parameters.
- **Cross-agent coordination**: Stop hooks can publish via event bus to trigger dependent agents.

## Existing Capability Comparison

| Aspect | Existing (shell command) | New (mcp_tool) |
|--------|--------------------------|----------------|
| Call MCP tools | Via shell script (curl or subprocess) | Native in-process |
| Reliability | Script must handle MCP auth/connection | Reuses existing MCP session |
| Latency | Shell process spawn + HTTP round-trip | Single in-process call |
| Maintenance | Scripts per hook | Config entry in settings.json |
| Error handling | Parse shell output | Native hook error model |

## Redundancy Check

NOVEL — no existing capability covers this. The `hook-lifecycle` skill documents hooks but only `type: "command"` (shell). Agent hooks via `TeammateIdle`/`TaskCompleted` are command-only. No existing workaround achieves in-process MCP tool invocation from a hook.

## Preliminary Scoring

| Criterion | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Integration complexity | 20% | 85 | 17.0 |
| Token efficiency impact | 25% | 70 | 17.5 |
| Capability expansion | 25% | 95 | 23.75 |
| Maintenance burden | 15% | 90 | 13.5 |
| Community validation | 15% | 100 | 15.0 |
| **Total** | | | **86.75** |

## Action Items

1. **Verify syntax**: Fetch actual `settings.json` hook config format for `type: "mcp_tool"` — changelog didn't specify full schema.
2. **Prototype**: Replace `scripts/publish.sh` shell hook with direct event-bus MCP hook invocation.
3. **Update hook-lifecycle skill**: Add `type: "mcp_tool"` to hook invocation types table.
4. **Update settings.json**: Convert 1-2 existing command hooks to mcp_tool invocations as pilot.

## Recommendation

**APPROVE for integration** — score 87. This is directly applicable to the existing hook + event-bus architecture. The main unknown is the exact config syntax, which needs verification via the official docs before rewriting existing hooks.

## Final Decision (2026-04-30, user walkthrough)

**Phase A APPLIED**: New `Hook Invocation Types` section added to `~/.claude/skills/hook-lifecycle/SKILL.md` documenting `type: "command"` vs `type: "mcp_tool"` (v2.1.118+) with example config and migration guidance.

**Phase B (settings.json migration) skipped — no current target**: Searched the workspace for existing shell hooks calling event-bus or other MCP tools. None found. Existing hooks are TDD-guard, plan-tracker, mgrep auto-index, restart-processes — all do file I/O or process management, not MCP-tool invocation. Convert opportunistically when adding NEW MCP-backed hooks (publish heartbeat events, register agents on session start, etc.).

**Future trigger**: When adding any new hook whose body would just be calling an MCP tool, prefer `type: "mcp_tool"` from the start instead of writing a shell wrapper.
