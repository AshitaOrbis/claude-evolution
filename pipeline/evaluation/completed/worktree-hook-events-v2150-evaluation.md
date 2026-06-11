# Evaluation: WorktreeCreate and WorktreeRemove Hook Events

- **Date**: 2026-02-21
- **Source**: Claude Code v2.1.50 official release (2026-02-20)
- **Category**: Hook Development Patterns (IMPROVEMENT)
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Drop-in — add 2 entries to existing hook-lifecycle skill doc + example configs; no new installs |
| Token efficiency impact | 25% | 50 | Neutral — hooks run outside conversation context (zero token overhead); documentation footprint negligible |
| Capability expansion | 25% | 70 | Incremental — extends existing 13-hook system with 2 new lifecycle events; enables worktree setup/teardown automation for agent isolation workflows |
| Maintenance burden | 15% | 100 | Zero/minimal — official Anthropic feature in stable v2.1.50 release; same maintenance as existing hook skill |
| Community validation | 15% | 100 | Official Anthropic release; part of versioned v2.1.50 changelog |

- **Claude Score**: 80/100
- **Codex Score**: N/A (Codex unavailable)
- **Final Score**: 80/100

## Decision

APPROVED — Low-effort, high-confidence documentation update to existing hook skill; extends worktree isolation capability with setup/teardown lifecycle hooks.

## Integration Notes

**Integration type**: Skill documentation update
**Target file**: `~/.claude/skills/hook-lifecycle/SKILL.md`

Steps:
1. Add `WorktreeCreate` and `WorktreeRemove` to the hooks reference table
2. Add example `worktree-setup.sh` and `worktree-cleanup.sh` configurations
3. Update hook count from "13 hooks" to "15 hooks"
4. Add redundancy triggers: "WorktreeCreate", "WorktreeRemove", "worktree hooks", "worktree lifecycle hooks", "worktree setup teardown"
5. Update `registry/existing-capabilities.md` Hook Lifecycle entry with new hooks

**Use cases to document**:
- Install dependencies in isolated agent worktree (`npm install` on create)
- Environment setup (copy `.env.example` on create)
- Cleanup artifacts and log results before removal
- Verify agent made no unintended changes before worktree removal (safety check)

**Environment variable available**: `$CLAUDE_WORKTREE_PATH` in hook scripts
