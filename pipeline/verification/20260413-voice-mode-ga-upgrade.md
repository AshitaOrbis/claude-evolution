# Verification: Voice Mode GA Upgrade

**Date**: 2026-04-13
**Status**: COMPLETE
**Type**: Registry status upgrade (EARLY_PREVIEW → IMPLEMENTED)

## What Changed

Registry entry "Voice Input — Early Preview" updated to "Voice Input":
- Status: PREVIEW → IMPLEMENTED
- Source updated to official Anthropic docs (code.claude.com/docs/en/voice-dictation)
- Added stable config details: `voiceEnabled` setting, `voice:pushToTalk` keybinding
- Added 20-language STT list (Russian, Polish, Turkish, Dutch, Ukrainian, Greek, Czech, Danish, Swedish, Norwegian added in v2.1.69)
- Removed "What NOT to add yet" warning (no longer applicable)
- Updated redundancy triggers with: "voice dictation", "push-to-talk Claude"

## Verification

- [x] Registry entry updated
- [x] Re-evaluation trigger met: official Anthropic docs now document `/voice` with stable semantics
- [x] No CLAUDE.md or settings.json changes required (voice input is a built-in; opt-in config is optional)

## No Further Action Required

This was a registry status upgrade, not a new capability integration. The feature itself requires no installation — it's built into Claude Code. Users can optionally add a keybinding via `~/.claude/keybindings.json`.
