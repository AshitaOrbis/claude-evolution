# `${CLAUDE_PLUGIN_DATA}` Plugin Persistent State Variable

**Source**: Claude Code v2.1.78 official release (2026-03-17)
**Discovered**: 2026-03-18
**Type**: Built-in feature (env var / plugin system extension)
**Evaluated**: 2026-03-18

## What It Is

Claude Code v2.1.78 adds `${CLAUDE_PLUGIN_DATA}` — a persistent data directory for plugins that survives plugin updates. Companion behavior: `/plugin uninstall` now prompts before deleting this directory (data preservation).

## Why It Matters

Enables stateful plugins — plugins can store learned preferences, history, configuration, or cache that persists across updates. Previously, any data written by a plugin would be wiped on update.

## Redundancy Check

- Auto-memory system (`memory/MEMORY.md`): Different scope — Claude's own memory, not plugin-specific
- `${CLAUDE_SESSION_ID}` variable: Different — session ID only, not persistent store
- CLAUDE.md files: Different — instructions, not plugin data storage

**Result**: NOVEL — no existing capability covers plugin-scoped persistent state.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 90 | Built-in; zero config beyond awareness of the variable |
| Token efficiency | 50 | Neutral — no direct impact on token usage |
| Capability expansion | 70 | Novel persistence mechanism: plugins can now be stateful across updates |
| Maintenance burden | 90 | Built-in feature — zero ongoing maintenance |
| Community validation | 85 | Official Anthropic v2.1.78 release |

**Weighted Score**: (90×0.20) + (50×0.25) + (70×0.25) + (90×0.15) + (85×0.15) = 18 + 12.5 + 17.5 + 13.5 + 12.75 = **74.25/100**

## Decision

**APPROVED** (74.25)

## Integration Notes

- Document `${CLAUDE_PLUGIN_DATA}` in registry under "Plugin System" or "Hooks & Events" section
- Note the `/plugin uninstall` prompt behavior change
- Research needed: exact resolved path (per-plugin vs shared?) — verify empirically
- Update `helpers/navigation/hook-environment-variables.md` with this new variable
- No skill or agent needed — documentation update only
