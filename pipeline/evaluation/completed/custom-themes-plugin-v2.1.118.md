---
name: Custom Themes via /theme + Plugin themes/ directory
description: Create and switch named custom themes from /theme or hand-edit JSON files in ~/.claude/themes/; plugins can ship themes via a themes/ directory.
type: novel
source: Official Claude Code v2.1.118 changelog (April 23, 2026)
date_discovered: 2026-04-23
classification: NOVEL
version: 2.1.118
---

# Custom Themes (`/theme` command + `~/.claude/themes/`)

## What It Is

Claude Code v2.1.118 adds a full theme system:
- **`/theme` command**: Create and switch between named custom themes interactively.
- **JSON theme files**: Hand-edit `~/.claude/themes/<name>.json` for precise color control.
- **Plugin-shipped themes**: Plugins can include a `themes/` directory to distribute themes.

## Why It Matters

Previously: Claude Code had limited built-in color options (system prompt-based). No way to create named custom themes or distribute them via plugins.

Now: Full JSON-based theming system. Relevant for:
1. **Workspace branding**: Consistent visual identity across tmux sessions.
2. **Context switching**: Different colors per project/role (e.g. red tones for production work).
3. **Plugin distribution**: Evolution-ops or other plugins could ship a named "requiem-dark" theme.

## Integration Points

- **`~/.claude/themes/`** — new directory (auto-created by `/theme`).
- Plugin `themes/` directory — ship themes alongside agents/skills.
- `/theme` — interactive picker/creator.

## Redundancy Check

NOVEL — no existing theme system in the registry. The `/config` command exposed some styling options, but not named JSON themes.

## Preliminary Scoring

| Criterion | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Integration complexity | 20% | 95 | 19.0 |
| Token efficiency impact | 25% | 50 | 12.5 |
| Capability expansion | 25% | 65 | 16.25 |
| Maintenance burden | 15% | 95 | 14.25 |
| Community validation | 15% | 100 | 15.0 |
| **Total** | | | **77.0** |

## Action

Score 77 — above threshold. Low urgency (cosmetic), but plugin theme distribution is genuinely useful for the evolution-ops plugin if it gets published. Create a base theme, document the `~/.claude/themes/` path in the registry.

**Recommendation**: APPROVE — low effort, document in registry, create a base `requiem` theme file for consistency across sessions.
