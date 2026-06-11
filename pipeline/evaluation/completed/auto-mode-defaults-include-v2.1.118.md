---
name: Auto Mode $defaults Include
description: Include "$defaults" in autoMode.allow, autoMode.soft_deny, or autoMode.environment to add custom rules alongside built-in defaults rather than replacing them.
type: improvement
source: Official Claude Code v2.1.118 changelog (April 23, 2026)
date_discovered: 2026-04-23
classification: IMPROVEMENT
version: 2.1.118
---

# Auto Mode `"$defaults"` Sentinel

## What It Is

When configuring auto mode rules in `settings.json`, including `"$defaults"` in any of the three lists (`autoMode.allow`, `autoMode.soft_deny`, `autoMode.environment`) now merges your custom entries *alongside* the built-in Anthropic default list rather than replacing it.

**Before**: Adding any custom rule to `autoMode.allow` replaced the entire default allow list.
**After**: Add `"$defaults"` as one entry to include the built-in list while still adding custom rules.

**Example:**
```json
{
  "autoMode": {
    "allow": [
      "$defaults",
      "mcp__event-bus__publish_event",
      "mcp__event-bus__agent_heartbeat"
    ]
  }
}
```

## Why It Matters

Currently, auto mode is configured with `permissions.defaultMode: "auto"` globally. If custom `autoMode.allow` overrides were ever added, they would silently wipe Anthropic's built-in safe-allow list (read-only operations, basic shell, etc.). The `$defaults` sentinel prevents this footgun.

Relevant because:
- The heartbeat/cron setup uses auto mode heavily.
- Any future customization of auto mode rules can now safely extend defaults rather than replacing them.
- Reduces risk of accidentally blocking safe operations that were previously auto-approved.

## Existing Capability Comparison

| Aspect | Before | After |
|--------|--------|-------|
| Custom rules + defaults | Impossible (custom replaces defaults) | `"$defaults"` merges both |
| Risk of losing built-in safe-allows | High (any customization wipes them) | None |
| Documentation needed | "Be careful not to override defaults" | Add `"$defaults"` and you're safe |

## Redundancy Check

IMPROVEMENT — existing Auto Mode capability is in registry. This extends it with additive composition semantics.

## Preliminary Scoring

| Criterion | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Integration complexity | 20% | 98 | 19.6 |
| Token efficiency impact | 25% | 50 | 12.5 |
| Capability expansion | 25% | 70 | 17.5 |
| Maintenance burden | 15% | 98 | 14.7 |
| Community validation | 15% | 100 | 15.0 |
| **Total** | | | **79.3** |

## Action

Score 79 — approve. Update the **Auto Mode** entry in the registry to document `"$defaults"` sentinel. Update `~/.claude/skills/advanced-tool-use/SKILL.md` if it references auto mode configuration. No settings.json changes needed immediately, but document for any future auto mode customization.

**Recommendation**: APPROVE — document in registry, add to hook-lifecycle skill's auto mode section.
