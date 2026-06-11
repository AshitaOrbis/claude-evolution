---
title: Add mcpServers frontmatter documentation to ~/.claude/agents/INDEX.md
type: documentation
status: applied
created: 2026-04-22
source_item: agent-frontmatter-mcpservers-v2.1.117.json
---

**Resolved 2026-06-10**: Applied as proposed to `~/.claude/agents/INDEX.md` (new "Agent Bundled MCP Servers (v2.1.117+)" section after Agent Teammate Hooks). Verified against changelog v2.1.117 ("Agent frontmatter `mcpServers` are now loaded for main-thread agent sessions via `--agent`"); current version 2.1.172; section did not previously exist.

# Proposal: Document Agent mcpServers Frontmatter in INDEX.md

## Why

v2.1.117 adds `mcpServers` as a new agent frontmatter field. When declared, these MCP servers now load in both `--agent` mode and subagent/Task mode. The integration evaluation requires documenting this in `~/.claude/agents/INDEX.md` under the Agent Design Patterns section.

The integration file is outside `~/claudeworkspace/` (blocked by pipeline guard), so this requires manual application.

## Exact Change

Add the following section to `~/.claude/agents/INDEX.md`, **after** the "Agent Teammate Hooks" section and **before** "## Best Practices Documentation":

```markdown
### Agent Bundled MCP Servers (v2.1.117+)

Agents can declare their own MCP servers in frontmatter via the `mcpServers` field. In v2.1.117, these servers now load correctly in both subagent (Task tool) mode AND `--agent` mode.

**Syntax:**
```yaml
---
name: my-agent
mcpServers:
  my-mcp-server:
    command: node
    args: ["/path/to/server.js"]
---
```

**When to use:**
- Agent needs a specific MCP server that shouldn't be in global config
- Creating portable agents that bundle their own dependencies
- Reducing global `~/.claude.json` surface area

**Candidates in this workspace**: `event-bus-publisher`, `event-bus-reader`, `pipeline-orchestrator` could declare `event-bus` MCP directly in frontmatter rather than relying on the global workspace `.mcp.json` config.

**Distinct from:**
- Global `~/.claude.json` mcpServers (applies to all sessions)
- Plugin `bin/` executables pattern (v2.1.91+)

**Status**: ACTIVE (v2.1.117+) — use for self-contained agent packaging
```

## No Sandbox Test Required

This is a documentation-only change. No env vars, settings.json, MCP config, or hooks involved.
