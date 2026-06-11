# Discovery: `/tui` Command — In-Session Rendering Mode Switch

**Date Discovered**: 2026-04-16  
**Source**: Claude Code v2.1.110 official changelog  
**Type**: IMPROVEMENT (over `CLAUDE_CODE_NO_FLICKER=1`)  
**Priority**: High

---

## What It Is

Claude Code v2.1.110 adds a `/tui` command (and `tui` settings key) that switches the rendering mode within the current conversation — no session restart required.

```
/tui fullscreen    # switches to flicker-free alt-screen rendering
/tui normal        # switches back to normal rendering
```

Previously, enabling flicker-free rendering required:
1. Setting `export CLAUDE_CODE_NO_FLICKER=1` in `~/.bashrc`
2. Starting a new session

Now it can be toggled live within the current session.

---

## Comparison to Existing Capability

| Aspect | `CLAUDE_CODE_NO_FLICKER=1` | `/tui fullscreen` |
|--------|---------------------------|-------------------|
| Trigger | Environment variable (session-start) | In-session slash command |
| Restart required | Yes — must start a new session | No — applies immediately |
| Persistence | Permanent (env var in bashrc) | Session-level (via `tui` setting) or ad-hoc |
| Scope | All sessions | Per-session or per-command |
| Discovery | 2026-03-31 (v2.1.88) | 2026-04-15 (v2.1.110) |

**Verdict**: IMPROVEMENT. The env var sets a permanent default; `/tui` adds live switching capability. These are complementary, not redundant — keep both.

---

## Relevance

- **requiem/tmux setup**: We already have `CLAUDE_CODE_NO_FLICKER=1` in `~/.bashrc` as the default. The `/tui` command adds the ability to switch mid-session when a session was started without the env var (e.g., via Remote Control from mobile, or a cron `claude -p` job).
- **Remote Control sessions**: Sessions initiated from mobile or claude.ai won't inherit the env var. `/tui` lets those sessions also enable flicker-free rendering.
- **`tui` settings key**: The `tui` setting in `~/.claude/settings.json` can persist the preference without the env var — potentially a cleaner approach than env var for new setups.

---

## Integration Notes

Companion changes in v2.1.110:
- `Ctrl+O` now toggles normal/verbose transcript (NOT Focus View — that moved to `/focus`)
- `autoScrollEnabled` config disables auto-scroll in fullscreen mode

## Evaluation Criteria Estimate

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 90 | Zero config — command just works |
| Token efficiency impact | 25% | 60 | Neutral — rendering change, no token effect |
| Capability expansion | 25% | 70 | Adds live switching vs env-var-only; useful for Remote Control sessions |
| Maintenance burden | 15% | 95 | Zero — built-in command |
| Community validation | 15% | 85 | Official Anthropic, v2.1.110 release |

**Estimated score**: ~77 (above 70 threshold → integrate)

## Recommended Action

- Add `/tui` command to registry as companion to `CLAUDE_CODE_NO_FLICKER=1`
- Note the `tui` settings key as a potential alternative to the env var for persistent preference
- Document that Remote Control sessions can use `/tui fullscreen` since they won't inherit `~/.bashrc` env vars

---

## Final Evaluation

```json
{
  "evaluation": {
    "scores": {
      "integration_complexity": 90,
      "token_efficiency": 60,
      "capability_expansion": 70,
      "maintenance_burden": 95,
      "community_validation": 85
    },
    "total": 77.5,
    "decision": "APPROVED",
    "reasoning": "Registry-only update plus documentation note. /tui adds live in-session rendering mode switching — genuinely useful for Remote Control sessions that don't inherit ~/.bashrc. Zero maintenance (built-in command), official Anthropic v2.1.110. Complements existing CLAUDE_CODE_NO_FLICKER=1 (permanent default) without replacing it.",
    "evaluated_at": "2026-04-20"
  }
}
```
