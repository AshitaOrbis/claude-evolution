# Discovery: Claude Code `rate_limits` Field for Statusline Scripts (v2.1.82)

**Discovered**: 2026-03-25
**Source**: Claude Code v2.1.82 release notes (github.com/anthropics/claude-code/releases)
**Type**: NOVEL — built-in Claude Code feature
**Classification**: Claude Code Feature > Monitoring / Statusline

---

## What It Is

Claude Code v2.1.82 adds a `rate_limits` field to the statusline script data context. Statusline scripts now receive live rate limit usage data for both the 5-hour and 7-day Claude.ai usage windows:

```json
{
  "rate_limits": {
    "5h_used_percentage": 34.2,
    "5h_resets_at": "2026-03-25T18:00:00Z",
    "7d_used_percentage": 12.8,
    "7d_resets_at": "2026-03-31T00:00:00Z"
  }
}
```

---

## Why It Matters

**Before**: No native way to surface rate limit status in the statusline. To know usage, you had to check the Claude.ai dashboard manually.

**After**: Statusline scripts can display real-time rate limit percentages and reset times in the terminal status bar — visible during every interaction.

**Use cases:**
- Display remaining rate limit % in status bar alongside git branch
- Warn visually when approaching rate limit (e.g., >80% used)
- Heartbeat automation can check usage before spawning expensive tasks
- Proactive throttling: skip expensive discovery runs when >90% used

---

## Integration Surface

The statusline script location: `~/.claude/scripts/statusline.sh` (or `.py`). The `rate_limits` JSON is injected into the script's environment/stdin during statusline evaluation.

**Example statusline script addition:**
```bash
# Add to existing statusline script
RATE_5H=$(echo "$STATUSLINE_DATA" | jq -r '.rate_limits["5h_used_percentage"] // 0 | floor')
if [ "$RATE_5H" -gt 80 ]; then
  echo "⚠️ Rate: ${RATE_5H}%"
elif [ "$RATE_5H" -gt 50 ]; then
  echo "⚡ Rate: ${RATE_5H}%"
fi
```

---

## Evaluation Notes

**Redundancy check**: No existing rate limit monitoring capability in registry. The `--bare` flag and `CLAUDE_CODE_SIMPLE` don't provide rate limit data. The event bus tracks agent heartbeats but not Claude.ai rate limits. This is **NOVEL**.

**Integration complexity**: Low — statusline scripts already exist. Adding rate limit display is a 5-10 line addition.

**Token efficiency impact**: Neutral — statusline runs outside conversation context.

**Capability expansion**: NOVEL monitoring primitive. Prevents surprise rate limit interruptions in long heartbeat runs.

**Maintenance burden**: Low — built-in feature, no external dependencies.

**Community validation**: Official Anthropic release.

**Preliminary score estimate**: 72-78 (novel, easy integration, narrow scope)

---

## Version

Claude Code v2.1.82, released ~2026-03-22
