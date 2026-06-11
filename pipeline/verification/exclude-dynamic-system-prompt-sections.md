# Discovery: `--exclude-dynamic-system-prompt-sections` Print Mode Flag

**Source**: Official Claude Code v2.1.97 changelog  
**Discovered**: 2026-04-10  
**Category**: Token Efficiency / Prompt Caching  
**Type**: NOVEL

---

## What It Is

A new CLI flag for `claude -p` (print/headless mode) that excludes dynamic system prompt sections from the prompt hash used for caching. When set, Claude Code omits user-specific or session-specific sections (such as per-user CLAUDE.md content) from the cache key, enabling the static prefix to be cached and shared across users or runs that differ only in dynamic sections.

```bash
claude -p --exclude-dynamic-system-prompt-sections "your prompt here"
```

---

## Why It Matters

In headless pipeline runs (heartbeat, automation), the system prompt includes CLAUDE.md content that may vary per session but has a large static core. If the dynamic sections (e.g., date stamps, session-specific context) shift the cache key, every run burns a fresh cache fill rather than hitting the cached static prefix.

This flag explicitly tells Claude Code: "the dynamic parts shouldn't invalidate the shared cache."

**For this setup:**
- Heartbeat runs (`claude -p`) rebuild context from CLAUDE.md on every invocation
- The `currentDate` line in CLAUDE.md changes daily → cache miss every day
- This flag could allow the rest of the static CLAUDE.md context to cache across the daily boundary

---

## Redundancy Check

| Existing Capability | Conflict? |
|--------------------|-----------|
| Tool Search Tool | No — different layer (tools vs prompt) |
| CLAUDE_CODE_SIMPLE | No — SIMPLE disables CLAUDE.md loading entirely; this flag is more surgical |
| Compact with Instructions | No — compaction is runtime; this is startup caching |
| `--bare` flag | Partial — `--bare` skips CLAUDE.md loading entirely; this flag keeps it but excludes it from cache key |

**Classification: NOVEL** — no equivalent in registry.

---

## Evaluation Criteria

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 100 | Single flag addition to existing `-p` invocations — drop-in |
| Token efficiency impact | 70 | Eliminates daily cache misses in heartbeat; effect magnitude uncertain until tested |
| Capability expansion | 70 | Extends existing prompt caching with surgical precision |
| Maintenance burden | 100 | Zero maintenance — flag on existing command |
| Community validation | 100 | Official Anthropic changelog |

---

## Evaluation

```json
{
  "scores": {
    "integration_complexity": 100,
    "token_efficiency": 70,
    "capability_expansion": 70,
    "maintenance_burden": 100,
    "community_validation": 100
  },
  "total": 85.0,
  "decision": "APPROVED",
  "reasoning": "Single-flag addition to heartbeat invocations with high potential to eliminate daily prompt cache misses (caused by rotating currentDate in CLAUDE.md). Official v2.1.97, zero maintenance. Requires empirical validation — add flag to heartbeat run, compare cache hit rates before/after. Update helpers/commands/heartbeat-commands.md if confirmed effective."
}
```

---

## Action Items

1. Test: Add `--exclude-dynamic-system-prompt-sections` to a heartbeat run and verify cache behavior
2. If effective: Update `helpers/commands/heartbeat-commands.md` with the flag
3. Evaluate whether to add to `INVESTIGATE-UPDATE.md` invocation template
