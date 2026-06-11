# Integration Report: v2.1.116 Resume Speed, Thinking Spinner, Config Search, Sandbox Safety

**Date**: 2026-04-21
**Type**: technique (version registry update)
**Status**: INTEGRATED
**Score**: 77.5/100
**Source**: https://github.com/anthropics/claude-code/releases

## What Was Done

Added v2.1.116 features to the registry. Updated heartbeat commands helper with /resume speed note.

## Changes Made

1. **registry/existing-capabilities.md**
   - Updated header count
   - Added `## Claude Code v2.1.116 Features (2026-04-21)` section with table and details
   - Added redundancy triggers

2. **helpers/commands/heartbeat-commands.md**
   - Added `/resume Performance (v2.1.116+)` section with usage example and why it matters for heartbeat chains

## Verification

- Version confirmed: v2.1.116 ✅ (workspace running target version)
- No config changes required
- No approval gate needed (registry-only + helper documentation)

## Five Features Summary

1. `/resume` 67% faster on 40MB+ sessions (dead-fork entry fix) — HIGH relevance for heartbeat
2. Thinking spinner inline progress ("still thinking", "thinking more", "almost done thinking")
3. `/config` search now matches option values (not just keys)
4. `/reload-plugins` auto-installs missing plugin dependencies
5. Sandbox `auto-allow` no longer bypasses dangerous-path check for rm/rmdir — security fix
