---
date: 2026-04-03
topic: "https://github.com/openai/codex-plugin-cc\n\nHow does this compare with our current GPT/Codex setup?"
discord_message_id: "1489680619377131740"
status: complete
---

# Codex Plugin for Claude Code vs. Our Custom MCP Setup

## Topic

User asked how `openai/codex-plugin-cc` compares to the current GPT/Codex integration in the workspace.

## Key Findings

- **codex-plugin-cc is a Claude Code plugin** (installed via `/plugin install`), not an MCP server — architecturally different from our custom MCP at `~/.claude-mcp-servers/codex-simple/`
- **Both share the same auth/config**: plugin reads from `~/.codex/config.toml`, same as our MCP — no new credentials or account required if Codex CLI is already authenticated
- **Background job execution is the differentiating feature**: `/codex:rescue --background`, `/codex:status`, `/codex:result`, `/codex:cancel` — our MCP is synchronous only
- **Three unique slash commands**: `/codex:review`, `/codex:adversarial-review`, `/codex:rescue` — ergonomic wrappers for interactive use that our tool-call-based approach lacks
- **We already replicate most functionality**: `codex-researcher` and `codex-coder` subagents handle research, code review cross-validation, and multi-turn sessions; the plugin's interactive commands add UX convenience but not net-new capability
- **Cost/loop risk**: review gate mode can drain Codex usage limits quickly (documented limitation)

## Details

### Our Current Setup

`~/.claude-mcp-servers/codex-simple/server.js` is a lightweight stdio MCP server wrapping `codex exec --json`. It exposes two tools:
- `mcp__codex__codex` — start a new session (with model override support)
- `mcp__codex__codex-reply` — continue an existing session via session ID

These are invoked programmatically by subagents (`codex-researcher`, `codex-coder`) or directly in conversation via MCP tool calls. Execution is synchronous — the call blocks until Codex returns. Multi-turn works via session IDs passed between calls. Default model is gpt-5.4 at xhigh reasoning from `~/.codex/config.toml`.

### What codex-plugin-cc Adds

**Background job execution** is the genuine net-new capability. Long tasks can be launched with `--background`, then monitored with `/codex:status [task-id]` and retrieved with `/codex:result [task-id]`. Our MCP has no equivalent — if Codex takes 5 minutes, the conversation blocks for 5 minutes.

**`/codex:adversarial-review`** is a "steerable challenge review" that questions design assumptions. We replicate this with the `code-reviewer` subagent (which has adversarial framing baked in), but having it as a slash command is more ergonomic in interactive sessions.

**`/codex:rescue`** delegates a stuck task or bug investigation to Codex as background work. Functionally similar to spawning a `codex-coder` subagent, but with async execution and built-in tracking.

**`/codex:review`** is a read-only code assessment on current changes or branch diff. Our `code-reviewer` subagent handles this, but again — slash command ergonomics vs. explicit subagent spawn.

### Architectural Comparison

| Dimension | Our Custom MCP | codex-plugin-cc |
|-----------|---------------|-----------------|
| Integration type | MCP server (tool calls) | Claude Code plugin (slash commands) |
| Execution | Synchronous (blocks) | Sync (`--wait`) or async (`--background`) |
| Multi-turn | Yes (session IDs) | Via session IDs in `/codex:result` |
| Auth | `~/.codex/config.toml` | Same config |
| Subagent composition | Yes (codex-researcher, codex-coder) | No — slash command only |
| Interactive UX | Requires explicit tool invocation | Natural slash command UX |
| Background job tracking | No | Yes (status/result/cancel) |
| Cost risk | Controlled (explicit invocation) | Review gate loops can drain limits |

### Installation

```
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

Requires Node.js 18.18+ and Codex CLI already authenticated.

## Relevance to Workspace

The plugin is directly relevant to `claude-evolution/` and any project using the `codex-researcher`/`codex-coder` subagents. It doesn't replace the MCP setup — both can coexist, and our MCP is more suited for programmatic/subagent use. The plugin adds interactive ergonomics and, critically, **background job execution** which the MCP cannot provide.

The background job pattern would be most valuable for long Codex tasks (full codebase reviews, deep research) that currently force a blocking wait. The rescue command could help in multi-session agentic pipelines where a Claude agent gets stuck and wants to handoff to Codex without waiting synchronously.

## Recommended Actions

1. **Install as a complement, not a replacement** — keep the MCP for subagent/programmatic use; install the plugin for interactive slash command access
2. **Evaluate background job UX** — try `/codex:rescue --background` on a real task to assess the async workflow before committing to it
3. **Defer `/codex:review` use** — the review gate loop risk + Codex usage limits means this should be triggered intentionally, not in CI-style loops
4. **Document in registry** — add `codex-plugin-cc` as a complementary integration in `registry/existing-capabilities.md` under the Codex section, noting it adds background job execution to the existing MCP tools
