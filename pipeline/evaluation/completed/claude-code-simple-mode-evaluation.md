# Evaluation: CLAUDE_CODE_SIMPLE - Minimalist Mode for Claude Code

- **Date**: 2026-02-25
- **Source**: https://www.gradually.ai/changelogs/claude-code/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Single env var, zero config. Pin version to ensure expected tool set. |
| Token efficiency impact | 25% | 70 | Reduces tool orchestration overhead; not maximal but meaningful for constrained sessions. |
| Capability expansion | 25% | 70 | Incremental — adds a new operational mode (sandboxed/cost-sensitive) with no existing equivalent. |
| Maintenance burden | 15% | 85 | Official Anthropic feature; scope changed across early patches (v2.1.48→v2.1.50) so occasional version-check needed. |
| Community validation | 15% | 100 | Official Anthropic release (v2.1.48+). |

- **Claude Score**: 83/100
- **Codex Score**: 77/100
- **Final Score**: 80/100

## Decision

APPROVED — Novel env-var-based global tool restriction mode with zero maintenance cost and clear use cases for cost-sensitive workflows.

## Integration Notes

**Integration type**: Technique documentation → update `~/.claude/skills/advanced-tool-use/SKILL.md`

**Important version correction** (from Codex cross-validation):
- **v2.1.48**: Bash-only
- **v2.1.49**: Bash + file edit
- **v2.1.50**: Expanded to Read/Edit/Glob/Grep + Bash (discovery file was stale on this point)

**Where it goes**:
- Add to `~/.claude/skills/advanced-tool-use/SKILL.md` under "MCP Server Deferred Loading" section as a complementary tool-restriction mechanism
- Document use cases: cost-sensitive heartbeat, sandboxed agent testing, CI pipelines
- Note it is complementary to (not redundant with) Agent Spawn Restrictions and disabledMcpjsonServers

**Use cases for evolution system**:
1. Heartbeat discovery runs (simple, low-cost)
2. Training data generation sessions (predictable tool set)
3. CI/CD pipeline steps (no MCP overhead)
