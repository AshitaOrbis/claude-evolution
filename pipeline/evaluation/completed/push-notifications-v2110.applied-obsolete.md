**Triage 2026-06-10**: needs user decision because it modifies `~/.claude/settings.json` (off-limits to automated triage) and the settings field name is still unverified — requires the interactive `/config` toggle check described below before applying.

# Push Notifications (Native v2.1.110+) — Approval Required

**Source discovery**: `pipeline/evaluation/completed/push-notification-tool-v2.1.110.md`
**Score**: 69.5 (NEEDS_RESEARCH at evaluation, APPROVED via 2026-04-30 user walkthrough)
**Approval mode**: Phase A (interactive sessions only). Phase B (headless `claude -p`) deferred until empirical compatibility test.

---

## What Changes

Enable Claude Code's native v2.1.110+ push-notification tool so the mobile claude.ai app gets a push when Claude *decides* a notification is warranted (long task complete, blocking error, input needed mid-session).

## Where

`~/.claude/settings.json` — global Claude Code settings.

## Why

Heartbeat/iterative-improve sessions on requiem run unattended for 30–60 min. Currently you have to poll dashi (phone) periodically. Native push fires when Claude decides a moment is worth interrupting — strictly better than polling.

Prerequisite **already satisfied**: `remoteControlAtStartup: true` is set, and the `remote-session` skill confirms Remote Control + claude.ai mobile is operational.

## Sandbox Test Results

```bash
bash scripts/sandbox-test-integration.sh --env "CLAUDE_CODE_PUSH_NOTIFICATIONS=1"
```

```json
{
  "passed": true,
  "env_tested": "CLAUDE_CODE_PUSH_NOTIFICATIONS=1",
  "stdout_contains_pass": true,
  "permission_forced": false,
  "sandbox_failed": false,
  "exit_code": 0,
  "warnings": []
}
```

(The sandbox test was run against the env-var form for safety verification. The actual integration uses the settings.json field below — same underlying feature, no permission/sandbox impact.)

## Exact Change

Add this single key to `~/.claude/settings.json` at the top level:

```json
{
  "claudeCodePushNotifications": true
}
```

Full minimal context (insert anywhere in the existing top-level object):

```diff
 {
   "remoteControlAtStartup": true,
+  "claudeCodePushNotifications": true,
   "skipAutoPermissionPrompt": true,
   ...
 }
```

## Verification Plan (post-apply)

1. Start a fresh interactive session in tmux on requiem.
2. Run a long Task subagent (e.g., `Task(web-researcher)` with a deep research query that takes >5 min).
3. Confirm phone receives push notification when the task completes.
4. If no push arrives within 1 min of completion: roll back, file a ticket noting the field name may differ from what the v2.1.110 changelog suggested.

## Rollback

Single edit: remove `"claudeCodePushNotifications": true` from `~/.claude/settings.json`.

## Known Unknowns (Phase B — deferred)

- **Headless `claude -p` mode**: Whether push notifications fire from cron-driven heartbeat sessions is untested. The Remote Control prerequisite may not be active for `-p` invocations. Test separately *after* Phase A confirms the field name and behavior in interactive mode.
- **Subagent push**: Whether push fires when a Task-spawned subagent completes (vs only top-level session completion) needs verification.
- **Field name accuracy**: `claudeCodePushNotifications` is the field name from the discovery brief. The v2.1.110 changelog phrased it as a `/config` toggle ("Push when Claude decides"); the underlying settings key may be slightly different. If the field name is wrong, the setting silently no-ops — verify by checking whether `/config` shows push-when-decide enabled after applying.

## Field Name Verification (do this before applying)

Run `/config` in any interactive Claude Code session, look for the "Push when Claude decides" toggle, and toggle it on/off. Then `jq 'keys' ~/.claude/settings.json` to see what key just appeared/disappeared. Use that exact key in the proposal above.

If `/config` toggle confirms the key as `claudeCodePushNotifications`, this proposal is ready to apply. If it's a different key (e.g., `pushNotifications`, `notifications.push`, etc.), update the proposal first.

## Approval Decision

- [ ] **APPLY** — verified field name via `/config`, applied to settings.json, verified Phase A.
- [ ] **REJECT** — push notifications not desired, or field name verification failed.
- [ ] **DEFER** — apply later, no current need for proactive mobile alerts.


**Approved by human via Discord reaction** (2026-06-11) — ready to apply.


**Resolved 2026-06-11 (applied as obsolete)**: PushNotification is now a NATIVE always-available Claude Code tool (verified empirically in a live v2.1.17x session — tool present with full schema, pushes to phone when Remote Control connected, no settings.json toggle required). The proposed `claudeCodePushNotifications` settings change is unnecessary; prerequisite remoteControlAtStartup already set. No action taken; capability already live.
