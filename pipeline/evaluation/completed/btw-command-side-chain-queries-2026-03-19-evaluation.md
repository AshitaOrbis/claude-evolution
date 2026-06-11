# /btw — Side-Chain Query Command (No Context Pollution) — Evaluation

- **Source**: https://www.howdoiuseai.com/blog/2026-03-12-the-simple-btw-command-that-cuts-claude-code-costs
- **Type**: Built-in skill (slash command)
- **Evaluated**: 2026-03-19

## What It Is

New built-in `/btw` command in Claude Code that allows asking quick questions mid-task without polluting the main conversation history. Reuses the prompt cache, so overhead is minimal. Main thread continues uninterrupted — answers appear as an overlay, dismissed with Space/Enter/Escape.

**Key claims**:
- ~50% cost reduction for workflows with frequent side questions
- No history written (context stays clean)
- Cache reuse (minimal token overhead)
- Announced March 11-12, 2026 by Claude Code lead Thariq Shihipar (2.2M views); built by Erik Schluntz as internal side project

## Redundancy Check

**NOVEL.** No existing mechanism for mid-task side questions without context pollution. Closest: `/compact` (compresses history — different) and `batch-orchestrator` (offloads work — different). `/btw` uniquely targets the "quick clarifying question without committing it to context" use case.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 100 | Built-in command — zero integration. Just start using it. |
| Token efficiency impact | 90 | Cache reuse + no history = genuine token savings for workflows with mid-task questions. 50% claimed; likely 20-50% for relevant sessions. High plausibility. |
| Capability expansion | 85 | Genuinely novel UX pattern. No existing tool covers "ephemeral mid-task question." High value for heartbeat runs, iterative-improve sessions, any long agentic task. |
| Maintenance burden | 100 | Built-in command. Zero maintenance burden. |
| Community validation | 85 | Internal Anthropic (Erik Schluntz + Thariq Shihipar = first-party). 2.2M view tweet is strong signal. Third-party blog coverage confirms community awareness. Not an official release announcement but first-party authorship. |

**Weighted Score**: (100×0.20) + (90×0.25) + (85×0.25) + (100×0.15) + (85×0.15)
= 20 + 22.5 + 21.25 + 15 + 12.75 = **91.5/100**

## Decision

**APPROVED** (91.5 ≥ 70 threshold)

**Rationale**: This is a built-in command with zero integration cost, genuine token efficiency value, and a novel capability gap it fills. The authorship (Claude Code lead + internal engineer) is as close to official as it gets without a formal Anthropic release announcement. The overlay/cache-reuse design is architecturally sound. 91.5 is the highest score for a non-MCP item in the pipeline.

## Integration Actions

1. **CLAUDE.md**: Add `/btw` to the "Common Commands" or "Session Tips" section. Document the use case: "ask a quick question mid-task without polluting context."

2. **advanced-tool-use skill**: Add to the built-in command reference. Note cache reuse and no-history semantics.

3. **iterative-improve skill**: Add note in heartbeat/iterative sessions — `/btw` for quick checks without interrupting the main loop.

4. **Registry**: Add entry under "Context Management" with redundancy triggers: "side chain query", "btw command", "mid-task question", "context-free question", "ephemeral query"

## Open Questions

- **Version availability**: Verify minimum Claude Code version for `/btw`. The March 11-12 announcement suggests v2.1.70+ range. Check `claude --version` and test before documenting.
- **Caching behavior**: Does cache reuse apply to all context or just the system prompt? Relevant for understanding actual token savings.
- **Overlay scope**: Is the overlay session-scoped (lost on session end) or does it persist anywhere for reference?
