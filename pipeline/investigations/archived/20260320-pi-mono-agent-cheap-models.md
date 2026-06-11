---
date: 2026-03-20
topic: "Pi-mono coding agent and cheap model delegation via OpenRouter"
discord_message_id: "1484452615105286255,1484453329848500365"
status: complete
---

# Pi-mono Coding Agent and Cheap Model Delegation

## Topic

Two consecutive messages about the pi-mono coding agent and using cheap/fast models via Claude Code:

1. "look into this coding agent, supposed to be an incredibly versatile scaffold?" — github.com/badlogic/pi-mono/tree/main/packages/coding-agent
2. "I was also thinking we might come up with a simple coding subagent that runs GPT54-mini or even possibly nano, though we'd have to come up with a good set of rules for how to use them. But they are really fast, cheap, and good at simple well scoped coding tasks"

## Key Findings

- **Pi** is a minimal terminal coding harness with high extensibility — TypeScript-based, supports 15+ LLM providers including OpenRouter, customizable via Extensions/Skills/Themes
- Pi's multi-provider support makes it a good reference architecture, but it's a **full alternative coding IDE**, not a subagent plugin for Claude Code
- The **cheap-model delegation idea** (GPT-5.4-mini/nano subagents) is directly implementable today using the existing `mcp__codex__codex` MCP or a new lightweight agent definition
- OpenRouter provides access to many free/cheap models (Llama, Gemini Flash, etc.) — `gpt-5.4-mini` and presumably `gpt-5.4-nano` are available via OpenAI API
- The workspace already has a working pattern for Codex subagents (`codex-coder`, `codex-researcher`) — a "fast-coder" variant using a cheaper model is a straightforward addition
- **Key constraint**: Claude Code subagents currently delegate to other Claude models (via Task tool) or to Codex via MCP. Delegating to an arbitrary OpenRouter model requires either a new MCP wrapper or using Pi as an intermediary

## Details

### Pi Coding Agent Assessment

Pi is philosophically similar to Claude Code — minimal core, extensible, provider-agnostic. Its key distinguishing features:
- **Session branching**: navigate any point in conversation history (Claude Code lacks this natively)
- **RPC mode**: can be controlled programmatically by another process — useful as an orchestration target
- **Multiple subscription providers**: access Anthropic Max, OpenAI Plus, GitHub Copilot, Google Gemini CLI without API keys

The versatility claim is accurate — Pi is more of a framework than a tool. For this workspace, Pi would be most useful as a **research reference** for architecture patterns (particularly the Extensions/Skills system) or as a secondary coding environment for tasks requiring non-Claude models.

**Integration verdict**: Not worth replacing Claude Code, but the Extensions/Skills architecture is worth studying for claude-evolution's own subagent design. Consider documenting Pi's patterns in `library/techniques/`.

### Cheap Model Delegation via Subagents

The core idea — delegate simple, well-scoped coding tasks to faster/cheaper models — is already partially implemented:
- `codex-coder` uses GPT-5.4 via Codex MCP (xhigh reasoning mode, not cheap)
- For truly cheap delegation, `gpt-5.4-mini` would be the target

**Proposed pattern** for a `fast-coder` subagent:
```yaml
name: fast-coder
description: Lightweight coding tasks (variable renaming, simple transformations, boilerplate) delegated to GPT-5.4-mini. Use when task is well-scoped, <50 lines, no architectural judgment needed.
tools: [mcp__codex__codex]
```

Rules for when to delegate to fast-coder vs codex-coder vs main context:
- **fast-coder**: rename variable across file, generate a boilerplate class, write a simple utility function
- **codex-coder**: code review, cross-validation, architectural analysis, anything requiring judgment
- **main context**: complex multi-file changes, anything with interdependencies

The "good set of rules" the user mentioned is the real design work. A simple decision matrix:
| Task Property | Delegate to | Reason |
|---------------|-------------|--------|
| Well-scoped, <50 lines | fast-coder | Speed/cost |
| Needs judgment / architecture | codex-coder | Quality |
| Multi-file, complex deps | Main session | Context needed |
| Security-sensitive | Main session | Trust required |

## Relevance to Workspace

- `~/.claude/agents/`: New `fast-coder` agent definition
- `claude-evolution/library/techniques/`: Pi architecture patterns worth documenting
- Cost optimization: fast-coder reduces per-task cost for trivial coding operations in automated pipelines (heartbeat, etc.)

## Recommended Actions

1. **Implement `fast-coder` subagent**: Create `~/.claude/agents/fast-coder.md` using `mcp__codex__codex` with `gpt-5.4-mini` model parameter; write decision rules in agent description
2. **Test with boilerplate tasks**: Run 5 simple coding tasks through fast-coder and validate quality before promoting to production use
3. **Document Pi's architecture**: Add Pi's Extensions/Skills pattern to `library/techniques/` as a reference architecture for Claude Code extensibility comparison
4. **Defer OpenRouter integration**: Until a clear use case for non-OpenAI cheap models emerges; `gpt-5.4-mini` via Codex MCP is sufficient for now
