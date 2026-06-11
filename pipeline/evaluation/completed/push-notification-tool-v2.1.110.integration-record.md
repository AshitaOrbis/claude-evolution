**Triage 2026-06-10**: needs user decision because this is the companion discovery/evaluation record for `push-notifications-v2110.proposal.md` (a settings.json change) — it should travel with that proposal's decision, not be resolved independently.

# Discovery: Push Notification Tool (Native Claude Tool)

**Date Discovered**: 2026-04-16  
**Source**: Claude Code v2.1.110 official changelog  
**Type**: NOVEL  
**Priority**: Low-Medium

---

## What It Is

Claude Code v2.1.110 adds a native `PushNotification` tool that allows Claude to proactively send mobile push notifications to the user. Triggered when:

1. **Remote Control** is enabled (connects claude.ai to the local CLI session)
2. **"Push when Claude decides"** configuration is enabled in `/config`

Claude decides autonomously when a notification is warranted — e.g., when a long-running task completes, a blocking error occurs, or user input is needed.

---

## Relevance

| Scenario | Value |
|----------|-------|
| Heartbeat/cron completes | Claude notifies phone when 30-60 min run finishes |
| Iterative-improve loop blocked | Claude alerts when human input needed mid-loop |
| Error in unattended session | Proactive alert vs silent failure |
| Long agent run completes | Know when to come back without polling |

This directly addresses a real pain point: long-running sessions on requiem are unmonitored, requiring periodic manual checks.

---

## Prerequisites & Setup

1. **Remote Control setup required**: Connect claude.ai to local CLI session (requires claude.ai account and claude.ai mobile app)
2. **Mobile app**: claude.ai iOS/Android app to receive notifications
3. **Config**: Enable "Push when Claude decides" in `/config` (or `claudeCodePushNotifications: true` in settings)
4. **Sessions**: Must be initiated or connected via Remote Control

**Current blocker**: Remote Control requires a persistent connection from claude.ai. Headless `claude -p` cron jobs may not have Remote Control active. Verify whether push notifications work in non-interactive sessions.

---

## Comparison to Existing Approaches

| Approach | Setup | Reliability | Cost |
|----------|-------|------------|------|
| **Push notification tool** | Remote Control + mobile app | Automatic, Claude-decided | Free (built-in) |
| Manual monitoring (poll tmux) | None | Manual — requires attention | User attention |
| Discord webhook on completion | Custom hook + webhook URL | On session end only | Free |
| System notification via hook | OS notify-send in Stop hook | On session end only | Free |

**Verdict**: Complementary to existing Stop hook notifications. Push notification tool is more flexible (Claude can trigger mid-session) but requires Remote Control setup overhead.

---

## Evaluation Criteria Estimate

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 55 | Requires Remote Control setup; unclear if works in `-p` mode |
| Token efficiency impact | 25% | 60 | Neutral — notification tool itself minimal tokens |
| Capability expansion | 25% | 75 | Novel: proactive mid-session alerts vs end-of-session only |
| Maintenance burden | 15% | 80 | Built-in; no scripts to maintain |
| Community validation | 15% | 85 | Official Anthropic v2.1.110 |

**Estimated score**: ~69 (borderline — NEEDS_RESEARCH before integrating)

## Open Questions

1. Does Remote Control work with `claude -p` headless sessions? If not, this is interactive-only.
2. Can push notifications be triggered from agent runs (subagents), not just top-level sessions?
3. Is there a way to configure notification types (all decisions vs. specific thresholds)?
4. Does this duplicate what a Discord webhook Stop hook already provides for our workflow?

## Recommended Action

NEEDS_RESEARCH — answer the Remote Control + headless compatibility question before evaluating further. If headless sessions can receive push notifications, score jumps to ~80.

---

## Final Evaluation

```json
{
  "evaluation": {
    "scores": {
      "integration_complexity": 55,
      "token_efficiency": 60,
      "capability_expansion": 75,
      "maintenance_burden": 80,
      "community_validation": 85
    },
    "total": 69.5,
    "decision": "NEEDS_RESEARCH",
    "reasoning": "Borderline score. Novel proactive mid-session alerting vs end-of-session only, and official Anthropic. Blocked by unanswered question: does Remote Control work with headless claude -p sessions (cron/heartbeat)? If yes, score jumps to ~80 APPROVED. If interactive-only, marginal value vs existing Discord webhook Stop hook. Research: test Remote Control + headless compatibility.",
    "evaluated_at": "2026-04-20"
  }
}
```
