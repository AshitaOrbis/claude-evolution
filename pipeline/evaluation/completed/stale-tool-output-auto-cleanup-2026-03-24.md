# Integration: Automatic Stale Tool Output Cleanup

**Score**: 73.0/100
**Decision date**: 2026-03-24
**Source**: dev.to + releasebot.io (Claude Code 2026)

## ⚠️ VERIFY BEFORE ACTING

Source is secondary (not official Anthropic changelog). Before updating registry:
1. Confirm against official Claude Code release notes
2. Identify the exact version that introduced this
3. Verify trigger conditions (what threshold? is it configurable?)

## Action Required (Post-Verification)

### Registry Update

Add to `registry/existing-capabilities.md` under **Context Management** section:

```
| Automatic Stale Tool Output Cleanup | ACTIVE (verify version) | Claude Code automatically clears stale tool call outputs from conversation history. Targets verbose tool results (file reads, bash output) that are no longer active context. Distinct from /compact (manual full-session summarization) — this is automatic and granular. |
```

## No Installation Required

Automatic behavior if feature exists as described. Registry annotation only.
