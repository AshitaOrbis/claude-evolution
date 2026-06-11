# Evaluation: Agent Memory Frontmatter (v2.1.33)

- **Date**: 2026-02-05
- **Source**: Claude Code v2.1.33 release notes
- **Category**: Memory & Persistence
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 92 | Just frontmatter in existing agent files; version gating needed for older runtimes |
| Token efficiency impact | 25% | 75 | Reduces context re-explanation; gains depend on repeat workflows |
| Capability expansion | 25% | 86 | Novel agent state management; complements Official Memory System |
| Maintenance burden | 15% | 89 | Official feature; requires governance for memory lifecycle |
| Community validation | 15% | 94 | Official Anthropic feature in stable release |

- **Claude Score**: 88/100
- **Codex Score**: 86/100
- **Final Score**: 87/100

## Decision

**APPROVED** — High-value official feature enabling stateful agents with scoped memory.

## Integration Notes

**Type**: Frontmatter addition to agent definitions

**Location**: `~/.claude/agents/*.md`

**Integration steps**:
1. Add `memory: user` to capability-discoverer (avoid duplicate searches globally)
2. Add `memory: project` to code-reviewer (learn project patterns)
3. Add `memory: project` to debugger (recall previous issues)
4. Add `memory: project` to evolution-orchestrator (track integration state)
5. Document in `~/.claude/agents/INDEX.md`
6. Update skill-creator guidance for new agents

**Concerns**:
- Memory lifecycle management: need cleanup/reset policies
- Version gating: ensure graceful degradation on Claude Code <2.1.33
- Memory drift: monitor for stale state accumulation

**Novel capability**: This is agent-specific scoped memory, distinct from:
- Official Memory System (conversational, auto-recorded)
- CLAUDE.md files (static context)
- Auto-memory directory (manual notes)

Agents can now maintain state across invocations with explicit scope control (user/project/local).
