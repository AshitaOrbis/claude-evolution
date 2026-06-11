# everything-claude-code: mcp-server-patterns Skill — Evaluation

**Evaluated**: 2026-04-12
**Source**: https://github.com/affaan-m/everything-claude-code (GitHub, ~260 stars)
**Decision**: NEEDS_RESEARCH -> pipeline/future/
**Cross-validated**: Codex (GPT-5.4) via repo clone and inspection

## Summary

The affaan-m/everything-claude-code repo added mcp-server-patterns skill (April 2026 expansion). Contains patterns for building and configuring MCP servers. Also added: pytorch-patterns, documentation-lookup, bun-runtime, nextjs-turbopack, and 8 operational domain skills.

## Scoring

| Criterion | Weight | Claude | Codex | Final |
|-----------|--------|--------|-------|-------|
| Integration complexity | 20% | 70 | 65 | 68 |
| Token efficiency impact | 25% | 50 | 50 | 50 |
| Capability expansion | 25% | 70 | 60 | 65 |
| Maintenance burden | 15% | 70 | 55 | 63 |
| Community validation | 15% | 90 | 70 | 80 |

**Claude total**: 68.0 | **Codex total**: 60.5 | **Final (avg)**: 64.25

## Key Research Findings (from Codex repo inspection)

1. **Repo exists**: Confirmed, ~260 stars, 300+ commits, last pushed 2026-04-10
2. **Format**: Markdown guides in `claude/` directory — NOT SKILL.md format (requires conversion)
3. **Content quality**: High-level architectural guides and checklists, not executable patterns
4. **mcp-server-patterns**: ~1.5k words, conceptual rather than code-specific
5. **Cherry-picking**: Possible but requires adaptation to our SKILL.md format

## Decision Rationale

The skill is conceptually sound but **largely replicates documentation we already maintain** (helpers/navigation/mcp-inventory.md, advanced-tool-use SKILL.md). Cherry-picking from external repo introduces sync burden with no clear novel content.

**Action**: Move to pipeline/future/. Monitor repo quarterly for genuinely novel MCP patterns. The repo is a good reference but doesn't justify active integration at this score level.
