# Parallel Worktree Sessions Pattern

**Source**: [rohitg00/pro-workflow](https://github.com/rohitg00/pro-workflow), multiple community sources
**Category**: Workflow Pattern
**Stars**: Unknown (2026-02-06)
**Discovery Date**: 2026-02-06

## Summary

"Running many parallel sessions—with separate git checkouts for each local session rather than branches—helps avoid conflicts when working on multiple tasks simultaneously." Use git worktrees instead of branches to enable true parallel Claude Code sessions.

## Problem Addressed

**Traditional branch-based parallelism**:
- Switching branches requires committing or stashing current work
- Risk of merge conflicts when working on related files
- Claude Code sessions tied to single working directory
- Can't run multiple Claude sessions on same repo (file locks, git state conflicts)

**Example pain point**: Working on feature A in Claude session 1, need to switch to bug fix B, must stop session 1, commit/stash, switch branch, start new session.

## Solution Pattern

**Git Worktree Architecture**:
1. Create worktree for each parallel task: `git worktree add ../repo-feature-a feature-a`
2. Run separate Claude Code session in each worktree directory
3. Each session has isolated filesystem (no conflicts)
4. Changes are independent until merge time
5. Clean up when done: `git worktree remove ../repo-feature-a`

**Key Insight**: Worktrees provide true isolation at the filesystem level, enabling multiple Claude sessions to work in parallel without interference.

## Existing Documentation

**We already have this**:
- `~/.claude/skills/using-git-worktrees/SKILL.md` (integrated 2026-01-15)
- From obra/superpowers (24.1k stars)
- Status: IMPLEMENTED

## Relationship to Existing Capabilities

**DUPLICATE**:
- Exact same pattern already documented in `using-git-worktrees` skill
- No new information provided by this discovery
- Same use case (parallel development)
- Same technique (git worktree command)

## Why This Discovery Still Valuable

**Community validation**:
- Multiple independent sources recommend same pattern (pro-workflow, obra/superpowers, Anthropic team)
- Confirms worktrees are becoming standard practice in Claude Code workflows
- Suggests our existing skill is correctly prioritizing the pattern

**Potential enhancement**:
- Check if pro-workflow has additional worktree tips not in our skill
- Possible refinements to existing documentation

## Quick Assessment Score

- Integration complexity: **0/100** (already integrated)
- Token efficiency impact: **0/100** (no new impact)
- Capability expansion: **0/100** (no new capability)
- Maintenance burden: **0/100** (no maintenance needed)
- Community validation: **100/100** (multiple sources confirm it's best practice)

**TOTAL**: **20/100** (averaged with 100% weight on community validation)

## Recommended Action

[ ] Evaluate further
[X] Reject - Already integrated as `using-git-worktrees` skill
[ ] Fast-track integration

## Redundancy Check

**Triggers checked**: "parallel sessions", "git worktrees", "multiple claude sessions", "isolated working directories"

**Result**: EXACT MATCH in existing-capabilities.md

**Status**: IMPLEMENTED in `~/.claude/skills/using-git-worktrees/SKILL.md`

## Notes

- This discovery serves as validation that our existing skill library is correctly prioritizing community best practices
- Confirms worktrees are standardizing as the recommended approach for parallel Claude Code work
- No action needed beyond noting the validation

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: Skills & Workflows - `using-git-worktrees` IMPLEMENTED (obra/superpowers)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 0/100 | 20% | 0.0 | Already integrated |
| Token Efficiency Impact | 0/100 | 25% | 0.0 | No new impact |
| Capability Expansion | 0/100 | 25% | 0.0 | No new capability |
| Maintenance Burden | 0/100 | 15% | 0.0 | No maintenance needed |
| Community Validation | 100/100 | 15% | 15.0 | Multiple sources confirm best practice |
| **TOTAL** | | | **15.0/100** | REJECT |

### Redundancy Analysis

**Classification**: EXACT DUPLICATE

**Existing capability**: `~/.claude/skills/using-git-worktrees/SKILL.md`
- Source: obra/superpowers (24.1k stars)
- Status: IMPLEMENTED (integrated 2026-01-15)
- Content: Exact same pattern (git worktree for parallel sessions)

**Discovery content**: Same technique, no new information

### Decision

**REJECT** (Score: 15.0/100)

**Rejection Reasons**:
1. Falls well below 50-point threshold (15.0/100)
2. 100% functional overlap with existing skill
3. Zero new capabilities provided
4. Already integrated as `using-git-worktrees` skill
5. Exact duplicate of existing documentation

**Value of Discovery**:
- Community validation: Confirms worktrees are best practice (multiple independent sources)
- Pattern confirmation: Our skill library correctly prioritizes community standards
- No action needed: Existing skill is correctly implemented

**Action**: Move to `archive/rejected/parallel-worktree-sessions-duplicate.md` with validation note
