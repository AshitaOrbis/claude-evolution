# Discovery: `/recap` Session Context Recap

**Discovered**: 2026-04-15  
**Source**: Claude Code v2.1.108 GitHub release notes  
**Version**: v2.1.108 (April 14, 2026)  
**Type**: Native Claude Code Feature  
**Status**: APPROVED

---

## What It Is

A new away-recap feature that provides contextual summary when returning to a long-running session:

- Configurable in `/config` (can be enabled/disabled per preference)
- Manually invokable with `/recap` slash command at any time
- `CLAUDE_CODE_ENABLE_AWAY_SUMMARY` env var forces the feature for users with telemetry disabled (who can't access the /config toggle)

**Behavior**: When returning to a session after an absence, provides a summary of what was in progress — similar to a "what were we doing?" context refresh.

---

## Why It Matters

**Problem it solves**: Long sessions (iterative-improve loop, multi-hour development) where returning mid-task means mentally reconstructing state. Currently requires reading back through conversation history or relying on the user's memory.

**Complements existing tools**:
- `/compact` — compresses context to reduce size, but doesn't summarize for human consumption
- Session compaction — automatic memory management, not user-facing recap
- `/resume` picker — finds sessions, but doesn't give content summary

**Gaps**:
- `/recap` is user-facing recap on demand — distinct from `/compact` which is model-facing context compression
- `CLAUDE_CODE_ENABLE_AWAY_SUMMARY` makes it work with telemetry disabled (our preference for privacy)

---

## Redundancy Check

Existing capabilities:
- `/compact` — DIFFERENT (context compression for model, not human-readable recap)
- Session title (`hookSpecificOutput.sessionTitle`) — DIFFERENT (names the session, doesn't summarize it)

**NOVEL** — no existing capability provides on-demand session recap.

---

## Implementation

```bash
# ~/.bashrc — enable away summaries even with telemetry disabled
export CLAUDE_CODE_ENABLE_AWAY_SUMMARY=1

# Manual invocation during any session
/recap
```

---

## Evaluation

**Empirical Safety Test**: PASSED (`{"passed": true, "permission_forced": false, "sandbox_failed": false, "exit_code": 0, "warnings": []}`)

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 95 | One env var + optional /config toggle — trivial |
| Token efficiency impact | 60 | Uses tokens to generate recap; saves time re-reading; net positive for long sessions |
| Capability expansion | 75 | Genuinely novel UX for long session management |
| Maintenance burden | 95 | Zero maintenance — official Anthropic feature |
| Community validation | 75 | Official Anthropic (v2.1.108 release) |

**Total**: (95×0.20) + (60×0.25) + (75×0.25) + (95×0.15) + (75×0.15) = 19 + 15 + 18.75 + 14.25 + 11.25 = **78.25**

**Decision**: APPROVED

**Reasoning**: Passed empirical safety test. Official Anthropic v2.1.108 feature. The `/recap` command addresses a real UX gap for long-running sessions (iterative-improve loops, overnight heartbeat sessions). `CLAUDE_CODE_ENABLE_AWAY_SUMMARY` makes it work even with telemetry disabled. Integration path: add `CLAUDE_CODE_ENABLE_AWAY_SUMMARY=1` to `~/.bashrc` — requires approval gate (env var → shell profile). Write proposal to `pipeline/pending-approval/`.

**Evaluated**: 2026-04-15
