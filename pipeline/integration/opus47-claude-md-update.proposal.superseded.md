# Pending Approval: CLAUDE.md Model Table — Claude Opus 4.7 Update

**Type**: claude-md-update (file outside ~/claudeworkspace/)
**Target**: `~/.claude/CLAUDE.md` — Contemporary AI Models table
**Status**: superseded_applied
**Created**: 2026-04-19
**Resolved**: 2026-06-10 — superseded by manual refresh of the Contemporary AI Models table (Opus 4.8 + Fable 5 had since released; table updated directly with Last verified 2026-06-10)
**Source item**: `pipeline/integration/20260418-claude-opus-4-7-xhigh-auto-mode-max.json`

---

## What to Change

In `~/.claude/CLAUDE.md`, find the `## Contemporary AI Models` table.

**Current row**:
```
| Anthropic | Claude Opus 4.6 | `claude-opus-4-6` / `opus` | Complex reasoning, planning |
```

**Replace with**:
```
| Anthropic | Claude Opus 4.7 | `claude-opus-4-7` / `opus` | Complex reasoning, planning (default effort: xhigh) |
```

**Also update the "Last verified" line**:
```
**Last verified**: 2026-04-19
```

---

## Why

Claude Opus 4.7 launched April 16, 2026 (v2.1.111). The model ID is `claude-opus-4-7`. The prior entry `claude-opus-4-6` is outdated — agents, skills, and subagent frontmatter referencing `opus` as a shorthand will automatically route to the current model, but the explicit ID in the table is stale and could cause confusion if anyone hardcodes it.

**Key new characteristics**:
- Default effort level is `xhigh` (new level between high and max)
- Auto Mode now available to Max subscribers (previously Teams/Enterprise only)

**Risk**: Zero — documentation update only. No behavior change. The `opus` shorthand still works regardless.

---

**Status**: superseded_applied (2026-06-10) — table now lists Opus 4.8 and Fable 5; no further action
