# Integration Report: EnterWorktree `path` Parameter (v2.1.105)

**Date**: 2026-04-14
**Status**: INTEGRATED (registry done; skill file deferred — outside workspace boundary)
**Type**: technique (registry update)
**Source**: `pipeline/integration/20260414-enterworktree-path-param.json`

## What Was Integrated

v2.1.105 adds `path` parameter to EnterWorktree built-in tool, enabling agents to enter an EXISTING worktree without creating a new one. Also fixes stale worktree cleanup for squash-merged PRs.

## Files Changed

| File | Change |
|------|--------|
| `registry/existing-capabilities.md` | Added `EnterWorktree path parameter` row to Context Management section (near ExitWorktree entry). Added full v2.1.105 section with details and redundancy triggers. |
| `~/.claude/skills/using-git-worktrees/SKILL.md` | **DEFERRED** — file is outside `~/claudeworkspace/`; permission denied. Requires manual edit. |

## Pending Manual Steps

Add to `~/.claude/skills/using-git-worktrees/SKILL.md` in the "Automated Alternative (v2.1.68+)" section:

```markdown
### Entering Existing Worktrees (v2.1.105+)

Use the `path` parameter to switch INTO an existing worktree without creating a new one:

This is useful in multi-agent workflows where Agent A creates a worktree and Agent B needs to work in the same isolated branch:

```
# Agent B enters the worktree Agent A created
EnterWorktree(path: "/path/to/existing/worktree")
```

**Squash-merge cleanup** (v2.1.105): Stale worktree cleanup now correctly detects squash-merged PRs. Workflows using GitHub squash-and-merge no longer accumulate stale worktrees.
```

## Verification

- [x] Registry row added for EnterWorktree path parameter
- [x] Full v2.1.105 EnterWorktree section added to registry with redundancy triggers
- [ ] using-git-worktrees skill updated — MANUAL STEP REQUIRED

## Score

71.25/100 (APPROVED). Trivial documentation update; skill file deferred by workspace boundary.
