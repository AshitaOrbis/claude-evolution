# Evaluation: Mastra - Observational Memory

- **Date**: 2026-03-08
- **Source**: https://mastra.ai/docs/memory/observational-memory
- **Category**: reasoning-patterns
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Hard to port — Mastra-specific (TypeScript framework, PostgreSQL/LibSQL/MongoDB backend); adapting the technique to Claude Code requires custom hook design + persistent storage; not a drop-in |
| Token efficiency impact | 25% | 80 | Core value: 5–40x compression ratio at defined token thresholds via background observer/reflector agents; could significantly reduce context waste in long automation sessions |
| Capability expansion | 25% | 65 | NOVEL vs our current approach — automatic threshold-based compression (30K/40K tokens) with persistent observation objects is materially different from manual `/compact`; Claude Code's native auto-compaction is system-triggered and less controllable |
| Maintenance burden | 15% | 70 | If treated as technique (doc entry): zero; if implemented in our stack: moderate (hook + storage layer) |
| Community validation | 15% | 55 | Mastra is a real framework with enterprise users and GitHub presence; this specific OM feature not independently starred |

- **Claude Score**: 65/100
- **Codex Score**: N/A (skipped — NEEDS_RESEARCH case, Codex unlikely to resolve open questions)
- **Final Score**: 65/100

## Decision

**NEEDS_RESEARCH** — Compelling compression technique with proven 5–40x ratios, but direct integration requires custom implementation outside Mastra's framework. Research needed to determine if a Claude Code-native port is feasible and whether it's meaningfully distinct from native auto-compaction.

## Integration Notes

**Research questions:**

1. **Portability**: Can the two-agent pattern (Observer at 30K tokens → Reflector at 40K tokens) be implemented using Claude Code hooks (e.g., `PreToolUse` checking context size, triggering a summarization subagent)?
2. **Differentiation from native**: Claude Code's auto-compaction is system-triggered at session limits. Mastra OM triggers at configurable thresholds and produces *persistent, named observation objects*. Is this distinction valuable enough to implement?
3. **Storage layer**: Mastra uses PostgreSQL/LibSQL. What's the lightest-weight persistent storage for a Claude Code-native version? (SQLite, JSONL file, or auto-memory?)
4. **Cost**: Observer/Reflector agents = additional Claude calls. At what session length does the compression ROI exceed the per-call cost?

**If research answers are positive**: Integration target is a new skill or hook pattern in `~/.claude/skills/` — not a package install. Document as technique in `library/techniques/`.

**Redundancy triggers to add on approval**: "mastra observational memory", "threshold-based context compression", "observer reflector agent memory", "automatic conversation summarization threshold"
