# Evaluation: Claude Code Rules Directory with Path-Based Conditional Loading

- **Date**: 2026-03-06
- **Source**: https://claudefa.st/blog/guide/mechanics/rules-directory | https://www.reddit.com/r/ClaudeCode/comments/1rhe89z/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 95 | Near-zero: create `.claude/rules/*.md` files with optional `paths:` frontmatter. No config changes, no dependencies. |
| Token efficiency impact | 25% | 92 | Major savings: rules load only when matching files are touched. For large CLAUDE.md and 40+ skills, per-session context reduction is substantial. Codex gave 100. |
| Capability expansion | 25% | 80 | Significant: modular path-targeted behavior control doesn't exist in current system. Enables instruction scoping that CLAUDE.md cannot provide. |
| Maintenance burden | 15% | 77 | Low-to-occasional: rule files and glob patterns need periodic cleanup as project structure evolves. |
| Community validation | 15% | 83 | Official Anthropic changelog reference (v2.1.69 fix confirmed). Claudefa.st guide + Reddit community adoption. Not a formal Anthropic Engineering post, but native feature with official fix entry. |

- **Claude Score**: 84/100
- **Codex Score**: 90.5/100
- **Final Score**: 87.25/100

## Decision

APPROVED — High-confidence approval. Native Claude Code feature with direct token efficiency benefits. Directly relevant to our large CLAUDE.md and growing skill library. Clear integration path.

## Integration Notes

- **Type**: Technique — document in `library/techniques/` and reference in `advanced-tool-use/SKILL.md`
- **Immediate opportunity**: Split language/tool-specific sections of CLAUDE.md into path-scoped rules (e.g., Python rules only when editing `.py` files, bash conventions only for shell scripts)
- **Evolution system**: Script-specific rules for `scripts/*.py`, `scripts/*.sh` paths
- **Questions to resolve during integration**:
  1. When was `.claude/rules/` first introduced? (pre- or post-v2.1.68?)
  2. Does `paths:` use Glob tool syntax (double-star globs)?
  3. Can rules files use `@import` like CLAUDE.md?
  4. Maximum rules files or total size limit?
- **Suggested rule candidates**: Python conventions, bash conventions, TypeScript/pnpm rules, evaluation-specific rules for `pipeline/` paths
