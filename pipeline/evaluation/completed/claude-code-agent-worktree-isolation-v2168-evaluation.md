# Evaluation: Agent Worktree Isolation (`isolation: worktree`)

- **Date**: 2026-03-05
- **Source**: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
- **Category**: Agent Architecture
- **Version**: Claude Code 2.1.68
- **Automated**: Yes (daily heartbeat)

## Redundancy Check

- `WorktreeCreate`/`WorktreeRemove` hooks: Related lifecycle hooks — not the same. No conflict.
- `using-git-worktrees` skill: Manual worktree workflow. This automates what that skill describes.
- Registry entry "Hook Lifecycle Architecture" (all 16 hooks, incl. WorktreeCreate/Remove): Different mechanism.
- **Classification**: NOVEL — declarative per-agent worktree isolation is a new primitive

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 95 | Single frontmatter field (`isolation: worktree`) — trivial to add |
| Token efficiency impact | 25% | 60 | Workflow benefit (parallel safety), not direct token savings |
| Capability expansion | 25% | 90 | Enables true parallel agent safety; removes need for manual worktree management |
| Maintenance burden | 15% | 95 | Built-in behavior, zero maintenance |
| Community validation | 15% | 90 | Official Anthropic feature (v2.1.68), noted in Boris Cherny announcement |

- **Claude Score**: 84/100
- **Codex Score**: 89/100
- **Final Score**: 87/100

## Decision

APPROVED — High-impact addition to agent architecture that makes parallel multi-agent workflows dramatically safer with near-zero integration cost. Strongest score in this batch.

## Integration Notes

- Type: Agent definition updates + registry entry + skill update
- Add `isolation: worktree` to agents that benefit from isolation:
  - `capability-discoverer` — parallel discovery runs
  - `capability-evaluator` — independent evaluation contexts
  - Any fan-out agents in `~/.claude/agents/`
- Update `registry/existing-capabilities.md` with new entry under Agent Architecture
- Update `~/.claude/skills/using-git-worktrees/SKILL.md` to reference this as the automated equivalent
- Note: Codex flags git/worktree edge cases in CI — document caveat in integration notes
