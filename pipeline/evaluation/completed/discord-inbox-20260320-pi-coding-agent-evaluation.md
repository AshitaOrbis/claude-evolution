# Pi: Minimal Terminal Coding Harness

- **Date**: 2026-03-20
- **Source**: Discord #general inbox
- **URL**: https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent
- **Category**: tool, coding-harness, agent-framework
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1484452615105286255

## Description

Pi is a minimal terminal-based coding harness for AI-assisted development. Works with various AI models (Claude, GPT, others) and prioritizes extensibility over predetermined workflows.

Core tools: read (access files), write (create/modify), edit (targeted changes), bash (shell execution). Features interactive mode with @-syntax file references and image paste support, session management as JSONL trees for branching conversations, and extensibility through TypeScript extensions. Available in multiple modes: interactive terminal UI, CLI, SDK, and RPC.

## Relevance

User inquiry: "look into this coding agent, supposed to be an incredibly versatile scaffold?" Potential application as an alternative or complementary harness to Claude Code, particularly relevant for understanding agent scaffolding patterns or inspiring improvements to internal tool execution frameworks.

## Classification

To be evaluated by the standard pipeline.

---

## Evaluation

**Evaluated**: 2026-03-20
**Decision**: REJECTED (49.0/100)

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Separate tool running alongside Claude Code; requires setup but not complex |
| Token efficiency impact | 25% | 40 | Adds another tool layer; no clear token savings over Claude Code's native workflow |
| Capability expansion | 25% | 50 | Branching conversations (JSONL trees) and RPC mode are novel vs Claude Code, but peripheral to primary workflows |
| Maintenance burden | 15% | 65 | TypeScript monorepo; appears actively maintained |
| Community validation | 15% | 45 | Single-developer GitHub project; star count unverified |

**Weighted Score**: (50×0.20) + (40×0.25) + (50×0.25) + (65×0.15) + (45×0.15) = 10 + 10 + 12.5 + 9.75 + 6.75 = **49.0/100**

**Reasoning**: Pi is a capable alternative coding harness but we're fully invested in Claude Code's ecosystem (agents, skills, MCPs, hooks). Pi would run alongside rather than enhancing Claude Code, adding maintenance overhead. The branching conversations (JSONL trees) are interesting but no current workflow requires conversation branching. The primary interesting idea — multi-model delegation to cheap models — doesn't require Pi at all and is tracked separately (see discord-inbox-20260320-twitter-2034666936383213600.md, NEEDS_RESEARCH 66.75).

**Extracted Pattern**: Multi-model delegation using GPT-5.4-nano for simple scoped coding tasks is worth building as a standalone `codex-coder-mini` subagent via existing Codex MCP. No Pi required.

**Re-evaluation trigger**: If Pi reaches 500+ stars and ships a Claude Code plugin/extension rather than running as a parallel tool.
