# Evaluation: Agent Teams (Claude Opus 4.6 / Claude Code 2.1.32)

- **Date**: 2026-02-06
- **Source**: https://www.anthropic.com/news/claude-opus-4-6
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Simple env var toggle (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), no code changes needed |
| Token efficiency impact | 25% | 40 | Anthropic explicitly warns "token-intensive", shared context increases cost vs isolated subagents |
| Capability expansion | 25% | 85 | Novel autonomous coordination, agents self-organize without manual orchestration |
| Maintenance burden | 15% | 95 | Official Anthropic feature, maintained by Anthropic, stable release path |
| Community validation | 15% | 100 | Official Anthropic feature, announced with Opus 4.6, research preview status |

- **Claude Score**: 78/100
- **Codex Score**: N/A (Codex MCP unavailable)
- **Final Score**: 78/100

## Decision

**APPROVED** — Official Anthropic feature with novel autonomous coordination capability. Despite token intensity warning, provides unique value for specific use cases (read-heavy codebase reviews, parallel analysis).

## Integration Notes

**Integration Type**: Technique documentation + optional usage pattern

**Where it goes**:
1. Document in `registry/existing-capabilities.md` under "Context Management"
2. Update `~/.claude/agents/INDEX.md` with guidance on when to use Agent Teams vs Task tool
3. Add to `CLAUDE.md` as optional workflow pattern

**Usage Guidance**:
- **Use Agent Teams when**: Read-heavy parallel work (codebase audits, multi-file analysis), autonomous coordination beneficial
- **Use Task tool when**: Need explicit control, cost-sensitive, isolated contexts preferred, sequential dependencies

**Trade-offs**:
- **Pros**: Autonomous coordination, parallel execution, shared context understanding
- **Cons**: Higher token cost, less control, research preview stability
- **Current status**: Research preview - monitor for GA release

**Concerns**:
- Token cost impact needs empirical testing
- Interaction with existing subagent patterns unclear
- Research preview may have breaking changes

**Next Steps** (if integrated):
1. Test Agent Teams on sample codebase review task
2. Compare token usage vs parallel Task tool calls
3. Document empirical findings
4. Update registry with usage recommendations
