# Discovery: Claude Code `--channels` MCP Push Messaging (v2.1.80)

**Discovered**: 2026-03-20
**Source**: Claude Code v2.1.80 release notes (claudeupdates.dev)
**Type**: NOVEL — built-in Claude Code feature (research preview)
**Classification**: Claude Code Feature > MCP Architecture

---

## What It Is

Claude Code v2.1.80 introduces `--channels` (research preview), enabling MCP servers to **push messages into active Claude Code sessions**. This is the first native bidirectional MCP communication mechanism — previously, MCP was strictly request/response (Claude calls tool → server responds).

With `--channels`, MCP servers can proactively inject messages, events, or data into an active session without Claude polling for them.

---

## Why It Matters

**Before**: Claude must poll for external state changes (e.g., "did the build finish?", "did the webhook fire?")
**After**: External systems can push events directly into the session as they happen

**Use cases this unlocks:**
- Real-time build/CI notifications → session continues when CI passes (no polling loop)
- Webhook events from external services (GitHub, Stripe, Discord) → session handles event
- Async agent coordination → one agent signals another via channel push
- Long-running background task completion → session notified when done
- Rate limit countdown → session gets notified when limit resets

---

## Technical Details

- **Flag**: `--channels` on Claude Code session startup
- **Status**: Research preview (not GA)
- **Direction**: MCP server → Claude Code session (push)
- **Complements**: Existing MCP request/response (pull)
- **Requires**: MCP servers that implement the channels push protocol

---

## Redundancy Check

| Existing Capability | Match? |
|--------------------|--------|
| MCP request/response (existing) | COMPLEMENTARY — existing is pull-only; channels adds push |
| SessionEnd/SessionStart hooks | COMPLEMENTARY — hooks are passive lifecycle events; channels are active pushes |
| Task tool subagents | COMPLEMENTARY — channels notify the session, not spawn agents |
| Event Bus MCP (agent-event-bus) | COMPLEMENTARY — event bus is a separate service; channels is native MCP protocol |

**Verdict**: NOVEL — no existing capability covers server-initiated push to active sessions.

---

## Scoring

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 55 | Built-in feature (easy), but need MCP servers with push support (medium) |
| Token efficiency impact | 25% | 65 | Eliminates polling loops = significant savings in async workflows |
| Capability expansion | 25% | 95 | First bidirectional MCP — fundamentally new architecture |
| Maintenance burden | 15% | 85 | Research preview caveat; Anthropic-maintained once stable |
| Community validation | 15% | 80 | Official Anthropic feature (research preview = high confidence it ships) |

**Weighted Score**: (55×0.20) + (65×0.25) + (95×0.25) + (85×0.15) + (80×0.15)
= 11 + 16.25 + 23.75 + 12.75 + 12 = **75.75/100** → APPROVED (monitor research preview)

---

## Integration Recommendation

**Status**: MONITOR — research preview. Do not build production workflows around it yet.

**When to promote to full integration:**
- Channels reaches GA (stable release)
- At least one high-quality MCP server ships channel push support
- Anthropic publishes protocol spec for implementing channel push in custom MCP servers

**Immediate action:**
- Add to registry under Hook Development Patterns or new "MCP Architecture" section
- Watch for MCP servers announcing channel push support in discovery pipeline
- Add redundancy trigger: "MCP push", "server-initiated messages", "MCP channels", "push messaging MCP", "bidirectional MCP"

---

## Example Workflow (Future)

```
1. Claude Code starts with --channels and a custom CI MCP
2. Claude triggers a long-running test suite via MCP tool call → normal request/response
3. MCP server starts build asynchronously
4. 10 minutes later: build finishes → MCP server pushes result into Claude's channel
5. Claude receives push notification and continues without polling
```

Compare to current approach:
```
1. Claude triggers build → gets "build started" response
2. Claude must /loop or have hook check CI status repeatedly
3. Eventually sees "build passing" → continues
```

Channels eliminates the polling loop entirely.

---

## Re-Evaluation Triggers

- `--channels` promoted from research preview to stable
- Any popular MCP server (GitHub, Semgrep, etc.) adds channel push support
- Anthropic publishes MCP channels protocol spec
- Discovery of MCP server that already implements push (check server announcements)
