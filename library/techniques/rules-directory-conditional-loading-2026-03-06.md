# Rules Directory — Conditional Context Loading

**Source**: claudefa.st guide, Reddit r/ClaudeCode, Claude Code v2.1.69 changelog
**Date**: 2026-03-06
**Type**: Native Claude Code feature (technique)
**Score**: 87.25/100 (approved)

## What It Does

`.claude/rules/` is a modular instruction system for Claude Code. Individual `.md` files in this directory can include YAML frontmatter with a `paths:` field to conditionally load rules only when editing matching files. Rules without `paths:` frontmatter load every session (like CLAUDE.md).

## How It Works

```yaml
---
paths: src/api/**/*.ts
---
# API Development Rules
- All endpoints must validate input with Zod
- Return consistent error shapes: { error: string, code: number }
```

**Key behaviors**:
- Rules with `paths:` only load when Claude is editing files matching the glob pattern
- Rules without `paths:` always load (equivalent to putting content in CLAUDE.md)
- Multiple rule files combine additively
- Reduces per-session context token usage for irrelevant domain-specific rules
- v2.1.69 fixed conditional loading in `claude -p` print mode

## Comparison to Other Instruction Mechanisms

| Mechanism | Loading Behavior | Use Case |
|-----------|-----------------|----------|
| `CLAUDE.md` | Always loaded | Project-wide instructions |
| `.claude/rules/*.md` (no paths) | Always loaded | Modular project instructions |
| `.claude/rules/*.md` (with paths) | Conditional on file edits | Domain-specific rules |
| Skills (`SKILL.md`) | Manual trigger or slash command | User-invocable workflows |
| Memory files | Auto-persistent across sessions | Learned preferences |

## Token Efficiency Benefit

For projects with large instruction sets, conditional loading reduces per-session context:
- A monorepo with 27+ rules can load only relevant subsets per task
- Python rules don't load when editing TypeScript
- API rules don't load when editing frontend components
- Community report: "Split my CLAUDE.md into 27 files" with path-based scoping

## Community Adoption

- Reddit: "I split my CLAUDE.md into 27 files. Here's the architecture." — power user with 100+ config items
- claudefa.st guide documents the feature with examples
- Used by teams with diverse tech stacks in monorepos

## Open Questions (To Be Verified)

- Does `paths:` use the same glob syntax as the Glob tool?
- Can rules files use `@import` syntax like CLAUDE.md?
- Is there a maximum number of rules files or total size limit?
- What's the measured token reduction for a project like claude-evolution?

## Version Notes

- Feature available pre-v2.1.68 (exact introduction version unknown)
- v2.1.69: Fixed conditional `paths:` loading in `claude -p` (print) mode

**Tags**: `rules-directory`, `conditional-loading`, `context-management`, `token-efficiency`, `modular-instructions`, `paths-frontmatter`
