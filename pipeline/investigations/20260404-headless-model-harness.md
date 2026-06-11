# Headless Multi-Model Calling Harness

- **Date**: 2026-04-04
- **Source**: Conversation — investigating unified model invocation
- **Status**: To investigate
- **Compare**: Excalibur (viemccoy/excalibur) vs Hermes Agent (Nous Research)

## Problem

Three models, three invocation patterns, no unified cost tracking:

| Model | Interface | Pattern |
|-------|-----------|---------|
| Claude (Opus/Sonnet/Haiku) | `claude -p` | CLI subprocess |
| GPT-5.4 | Codex MCP / `codex` CLI | MCP tool or CLI |
| Gemini 3.1 Pro | Gemini CLI MCP | MCP tool |

No per-operation budget tracking. No unified error handling. No normalized output format.

## Frameworks to Compare

### Excalibur (viemccoy/excalibur)
- Markdown-only agent configuration (no code)
- **Novel**: Charge management — per-operation token budgets tracked as explicit resource
- Lightweight (zero dependency — it's guidelines)
- ~80% overlap with existing agent/skill patterns
- Score: 51.5/100 (charge management sub-concept likely 70+)

### Hermes Agent (Nous Research)
- Full runtime framework — actually spawns and orchestrates model instances
- Multi-framework orchestration: Claude Code + Codex + self-instances
- Self-improvement: Atropos RL + Tinker training backend
- Heavy dependency (full Nous ecosystem)
- Score: 53.5/100

## What We'd Actually Want

A thin unified harness that borrows:
- Excalibur's **charge management** pattern (budget per model call)
- Hermes's **multi-model dispatch** pattern (unified call to any model)
- Built on existing `claude -p` / Codex MCP / Gemini CLI plumbing

Target interface: `call(model, prompt) → {response, tokens, cost, duration}`

## Research Questions

1. What does Excalibur's charge management actually look like in practice? (Read the repo)
2. How does Hermes Agent's multi-model spawning work under the hood? CLI wrapping or API?
3. Is there value in a unified harness beyond what `model-router` subagent already provides?
4. Could this be a publishable open-source tool? (Lightweight multi-model harness)
5. What's the simplest implementation: TypeScript wrapper? Python? Bash dispatcher?

## Related

- `model-router` subagent (existing routing, no cost tracking)
- `~/.claude/skills/mcp-search-framework/SKILL.md` (search tool selection — analogous pattern for model selection)
- Excalibur evaluation: `pipeline/evaluation/completed/excalibur-agent-framework-2026-04-03.json`
- Hermes evaluations: `pipeline/evaluation/completed/discord-inbox-20260226-twitter-teknium-evaluation.md`
