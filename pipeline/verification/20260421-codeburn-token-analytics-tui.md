# Integration Report: CodeBurn Token Analytics TUI

**Date**: 2026-04-21
**Type**: technique (external CLI tool)
**Status**: INTEGRATED
**Score**: 71.0/100
**Source**: https://github.com/getagentseal/codeburn

## What Was Done

Documented CodeBurn in the registry as a complement to ccusage for task-level token cost analytics.

## Changes Made

1. **registry/existing-capabilities.md**
   - Updated header count: 53 → 56 integrations
   - Added CodeBurn row to "External Tools (Integrated)" table
   - Added CodeBurn Details block with install command, description, and use case
   - Added redundancy triggers

## Verification

- Registry entry present: ✅ `External Tools (Integrated)` section
- Redundancy triggers added: ✅ "codeburn", "task-level cost", "token analytics TUI", etc.
- No config changes required (npm install documented, not executed)
- No approval gate needed (external CLI tool, zero system-file impact)

## Notes

Install when needed: `npm install -g codeburn`
- Complements ccusage (date-level) with task-type granularity (13 categories)
- No equivalent in registry — fills genuine observability gap
- Validated: Show HN positive reception + awesome-claude-code issue #1550
