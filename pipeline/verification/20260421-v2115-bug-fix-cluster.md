# Integration Report: v2.1.115 Four Production-Critical Bug Fixes

**Date**: 2026-04-21
**Type**: technique (version registry update)
**Status**: INTEGRATED
**Score**: 72.5/100
**Source**: https://code.claude.com/docs/en/changelog

## What Was Done

Added v2.1.115 bug fix cluster to the registry. Version verified as active (workspace is on v2.1.116).

## Changes Made

1. **registry/existing-capabilities.md**
   - Updated header count
   - Added `## Claude Code v2.1.115 Bug Fix Cluster (2026-04-20)` section with table and details
   - Added redundancy triggers for all four fixes

## Verification

- Version confirmed: v2.1.116 (>= v2.1.115) ✅
- Outside-root edit fix active: ✅ (directly affects ~/.claude/CLAUDE.md editing patterns)
- No config changes required
- No approval gate needed (registry-only documentation)

## Four Fixes Summary

1. `--resume` pre-v2.1.85 session backward compat — "tool_use ids" error resolved
2. Outside-root file edit (Write/Edit/Read on ~/.claude/**) with conditional skills/rules — HIGH relevance
3. Config write storm on skill invocation — performance regression fixed
4. `--bare` mode MCP tool drop + enqueued message discard — both fixed
