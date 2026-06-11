# Evaluation: SkillNet (zjunlp)

- **Date**: 2026-03-12
- **Source**: https://github.com/zjunlp/SkillNet
- **Category**: agent-capabilities
- **Automated**: Yes (daily heartbeat)
- **Status**: NEEDS_RESEARCH

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | MCP wrapper exists (CycleChain/skillnet-mcp, created 2026-03-09) but very new — requires Python package `skillnet-ai` + Node MCP wrapper. Moderate friction. |
| Token efficiency impact | 25% | 50 | `get_skill_rules` path is token-aware; `import_best_skill` dumps full skill docs into context. Net neutral without usage discipline. |
| Capability expansion | 25% | 65 | Codex raised this: search/download/create/evaluate/analyze over a skill corpus is beyond Claude Code's native skill management. But practical benefit depends on corpus quality. |
| Maintenance burden | 15% | 55 | Main SkillNet repo is active (has technical report on arXiv). MCP wrapper is brand new (2026-03-09) and unvalidated. |
| Community validation | 15% | 55 | ZJUNLP is a reputable academic group with published technical report (arXiv 2603.04448). Stars count unknown; MCP wrapper has near-zero adoption. |

- **Claude Score**: 54.5/100
- **Codex Score**: 66/100
- **Final Score**: 60.25/100

## Decision

NEEDS_RESEARCH — Codex surfaced a material update: SkillNet now has an official MCP integration path (`skillnet-mcp` by CycleChain, PyPI `skillnet-ai`). Score may rise to 70+ if the MCP wrapper proves stable. Core capability (skill search/compose/evaluate over corpus) is genuinely novel for Claude Code.

## Integration Notes

Key research questions:
1. How many stars does the main SkillNet repo have? (Codex noted "decent early traction" without specifics)
2. Is the `CycleChain/skillnet-mcp` wrapper stable? Stars, issues, last commit?
3. What does the skill corpus contain — Claude-specific skills or general LLM skills?
4. Does `get_skill_rules` provide the "safe" token-efficient path for routine use?
5. Technical report: arXiv 2603.04448 — what integration architecture does it describe?

If MCP wrapper has <50 stars → treat as pilot mode (optional enrichment only)
If MCP wrapper has 100+ stars + maintained → re-score IC to 70+ → likely crosses 70 threshold
