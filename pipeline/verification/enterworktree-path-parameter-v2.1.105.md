# Discovery: EnterWorktree `path` Parameter

**Discovered**: 2026-04-14
**Source**: Claude Code v2.1.105 official changelog (github.com/anthropics/claude-code/releases)
**Category**: Tool Enhancement / Git Worktree Workflow
**Redundancy Check**: NOVEL — existing `EnterWorktree` only creates NEW worktrees; cannot switch into existing ones

---

## What It Is

v2.1.105 added a `path` parameter to the built-in `EnterWorktree` tool. Previously, `EnterWorktree` could only create a new worktree from the current repo — it had no way to enter an already-existing worktree at a given path. Now agents can specify `path` to switch INTO an existing worktree.

**Official changelog entry**:
> Added `path` parameter to the `EnterWorktree` tool to switch into an existing worktree of the current repository

---

## Why It Matters

### Current Limitation
Without `path`, agents that need to operate on a pre-existing worktree (e.g., one created by a human, a previous session, or a CI process) have no way to enter it via the tool API. They must use Bash (`cd <worktree-path>`) to navigate there, losing the clean tool-layer abstraction and the paired `ExitWorktree` cleanup.

### New Capability
- **Cross-session worktree access**: An agent can resume work in a worktree created in a prior session
- **Human-created worktree entry**: CI/human creates the worktree; agent enters it cleanly
- **EnterWorktree/ExitWorktree symmetry**: Both halves of the worktree tool pair now support explicit paths
- **Evolution pipeline use case**: `capability-discoverer` with `isolation: worktree` frontmatter auto-creates worktrees — but orchestrator agents that need to READ a discoverer's worktree now have a clean entry mechanism

---

## Redundancy Check

| Existing Capability | Overlap | Verdict |
|---------------------|---------|---------|
| `EnterWorktree` (existing) | Same tool, different parameter set | IMPROVEMENT to existing tool |
| `using-git-worktrees` skill | Manual Bash `cd` workaround | SUPERSEDES bash workaround for agent contexts |
| `isolation: worktree` frontmatter | Creates new worktree at agent spawn | COMPLEMENTARY — different use case |

Classification: **NOVEL capability** within existing tool (net new parameter → net new workflow unlocked).

---

## Integration Path

**Complexity**: Easy (tool already implemented; this is a parameter addition — zero config, zero install)  
**Action needed**:
1. Add `path` parameter example to `~/.claude/skills/using-git-worktrees/SKILL.md`
2. Add note to registry under "Agent Worktree Isolation" / "ExitWorktree Built-in Tool" entries
3. Update hook-lifecycle skill if worktree hooks reference EnterWorktree usage patterns

---

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 95 | Zero install — built-in tool enhancement, just document it |
| Token efficiency impact | 50 | Neutral (replaces bash `cd`, not adding context overhead) |
| Capability expansion | 75 | Unlocks previously impossible: enter existing worktree from tool API |
| Maintenance burden | 95 | Official Anthropic; no maintenance required |
| Community validation | 90 | Official release feature |

**Total**: (95×0.20) + (50×0.25) + (75×0.25) + (95×0.15) + (90×0.15) = 19 + 12.5 + 18.75 + 14.25 + 13.5 = **78.0**

**Decision**: APPROVED

**Reasoning**: Official Anthropic v2.1.105 feature, zero integration complexity (documentation update only). Unlocks cross-session and cross-agent worktree access via the tool API — previously required Bash `cd` workaround. No empirical safety test required (no env vars or settings.json changes). Integration: update `using-git-worktrees` SKILL.md and registry entry.

**Evaluated**: 2026-04-15
