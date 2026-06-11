# Integration Report: Nested CLAUDE.md Re-injection Deduplication Fix (v2.1.89)

**Date**: 2026-04-05
**Type**: technique (registry-only)
**Status**: SUCCESS
**Integration time**: ~2 min

## What Was Done

Registry-only update as specified in integration instructions. Fix is automatic in v2.1.89+ — no config or code changes needed.

### Changes Made

1. **`registry/existing-capabilities.md`**: Added entry under Context Management:
   - Table row: `Nested CLAUDE.md Re-injection Deduplication | ACTIVE (v2.1.89+) | Automatic — nested CLAUDE.md files no longer re-injected repeatedly in long sessions`
   - Detail block with fix description, workspace impact, adjacent v2.1.90 fix note
   - Redundancy triggers: 8 triggers covering all likely search patterns

### Registry Header
- Updated: `Last Updated: 2026-04-05 (23 integrations: +nested-CLAUDE.md-dedup-v2.1.89)`

## Verification

- **Already active**: Running v2.1.92, fix shipped in v2.1.89 — confirmed passive
- **Workspace impact**: This workspace has 3 nested CLAUDE.md files; long file-intensive sessions were previously affected by this bug. Now fixed.
- **No regression risk**: Registry-only change, no runnable code modified

## Source File

Moved from: `pipeline/integration/claude-md-dedup-fix-v2189-20260405.md`

## Notes

Fix is explanatory + preventative: explains past unexplained context exhaustion on long sessions, documents that this behavior is no longer a concern on v2.1.89+.
