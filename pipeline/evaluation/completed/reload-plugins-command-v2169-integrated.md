# Discovery: `/reload-plugins` Built-In Command

**Date**: 2026-03-05
**Source**: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
**Version**: Claude Code 2.1.69
**Category**: Built-In Command / Developer Workflow

---

## What It Is

Claude Code 2.1.69 adds `/reload-plugins` as a built-in slash command that activates
pending plugin/skill changes without restarting the Claude Code process.

```
/reload-plugins
```

## Why It Matters

Previously, any change to plugin definitions (skills, agent frontmatter, MCP configs)
required restarting Claude Code to take effect. With `/reload-plugins`:
- Edit a skill, immediately reload without losing session context
- Iterate on plugin configurations without restart overhead
- Faster development loop for skill/agent authoring

## Integration Path

- Built-in command — zero integration cost
- Available in Claude Code 2.1.69+
- Relevant to document in skill-creator guide and hook-lifecycle patterns
- Reference in `~/.claude/CLAUDE.md` under development workflow section

## Preliminary Scoring

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 100 | Built-in, zero effort |
| Token efficiency impact | 55 | Indirect (saves restart overhead in dev) |
| Capability expansion | 65 | Incremental — workflow improvement |
| Maintenance burden | 100 | Zero maintenance — built-in |
| Community validation | 85 | Official Anthropic release |

**Estimated score**: ~73/100 → APPROVE (above threshold)

## Redundancy Check

- Registry: No existing `/reload-plugins` entry. NOVEL.
- Complements existing built-in commands (/compact, /copy, /batch, /simplify, etc.)

## Comparison to Existing Built-Ins

| Command | Version | Purpose |
|---------|---------|---------|
| `/compact` | 2.0+ | Summarize conversation context |
| `/batch` | 2.1.63 | Batch operations |
| `/simplify` | 2.1.63 | Code simplification |
| `/copy` | 2.1.58 | Copy code block |
| `/reload-plugins` | 2.1.69 | Reload skill/plugin changes |

---

**Status**: PENDING EVALUATION
