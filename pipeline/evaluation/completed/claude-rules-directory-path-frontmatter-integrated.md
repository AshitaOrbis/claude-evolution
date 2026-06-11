# Discovery: Claude Code Rules Directory with Path-Based Conditional Loading

- **Source**: https://claudefa.st/blog/guide/mechanics/rules-directory | https://www.reddit.com/r/ClaudeCode/comments/1rhe89z/i_split_my_claudemd_into_27_files_heres_the/
- **Date Found**: 2026-03-06
- **Category**: technique
- **Summary**: Claude Code supports a `.claude/rules/` directory where individual `.md` files can include YAML frontmatter `paths:` to conditionally load rules only when working with matching files. Rules without `paths:` frontmatter load every session. Fixed and confirmed working in print mode as of v2.1.69.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

The `.claude/rules/` system enables modular, scalable instruction organization beyond a single CLAUDE.md:

**How it works**:
```yaml
---
paths: src/api/**/*.ts
---
# API Development Rules
- All endpoints must validate input with Zod
- Return consistent error shapes: { error: string, code: number }
```

**Key behaviors**:
- Rules with `paths:` only load when Claude is editing matching files
- Rules without `paths:` load every session (like CLAUDE.md)
- Multiple rule files can be combined (additive loading)
- Reduces context token usage for irrelevant rules
- v2.1.69 fixed conditional loading in `claude -p` print mode

**Community adoption**:
- Reddit thread: "I split my CLAUDE.md into 27 files. Here's the architecture."
- Used by power users with 100+ configuration items
- Reduces per-session context while keeping full coverage

## Redundancy Check

**Status**: NOVEL

Checked registry for: "rules directory", "conditional loading", "paths frontmatter", "modular instructions", "CLAUDE.md splitting", "file-pattern rules". No matches.

Related but distinct:
- CLAUDE.md (global project instructions) — no path conditioning, always loaded
- Skill files (user-invocable, manual trigger) — different activation mechanism
- Memory files (auto-memory, persistent) — not instruction-based

This is a native Claude Code feature for conditional context loading. Directly relevant to our large CLAUDE.md and skill files.

## Evaluation Needs

1. When was `.claude/rules/` support first introduced? (pre- or post- v2.1.68?)
2. Does the `paths:` frontmatter use glob syntax (same as Glob tool)?
3. Can rules files use `@import` syntax like CLAUDE.md?
4. What's the token reduction in practice for a project like claude-evolution?
5. Would this replace or supplement our current CLAUDE.md/skills structure?
6. Is there a maximum number of rules files or total size limit?

## Potential Integration

- Split large CLAUDE.md sections into path-scoped rules (e.g., Python rules only when editing `.py` files)
- Create language-specific rules for the evolution system scripts
- Document as a technique in `library/techniques/`
- Reference in `advanced-tool-use/SKILL.md` under context management
