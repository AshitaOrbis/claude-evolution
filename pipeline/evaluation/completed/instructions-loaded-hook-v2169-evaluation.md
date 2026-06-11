# Evaluation: `InstructionsLoaded` Hook Event + Agent Metadata Fields

- **Date**: 2026-03-05
- **Source**: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
- **Category**: Hook Lifecycle / Agent Metadata
- **Version**: Claude Code 2.1.69
- **Automated**: Yes (daily heartbeat)

## Redundancy Check

- Registry: "Hook Lifecycle Architecture" documents all 16 hooks — `InstructionsLoaded` is NOT listed.
- `agent_id`/`agent_type`/`worktree` payload fields: NOT in registry or hook-environment-variables.md.
- **Classification**: NOVEL — 17th hook event; IMPROVEMENT to all existing hook payloads

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 85 | Docs update + optional hook addition; no infrastructure changes |
| Token efficiency impact | 25% | 55 | Indirect (observability/logging benefits, not direct token savings) |
| Capability expansion | 25% | 75 | New hook event + richer payloads; enables agent-aware hook branching |
| Maintenance burden | 15% | 90 | Low — extends existing patterns; Codex notes richer hook logic adds some complexity |
| Community validation | 15% | 85 | Official Anthropic release (v2.1.69) |

- **Claude Score**: 76/100
- **Codex Score**: 80/100
- **Final Score**: 78/100

## Decision

APPROVED — Meaningful hook system expansion (16→17 events) plus richer payload metadata enables agent-aware automation. Integration is primarily documentation updates.

## Integration Notes

- Type: Hook lifecycle skill update + registry entry + navigation helper update
- Update `~/.claude/skills/hook-lifecycle/SKILL.md`:
  - Add `InstructionsLoaded` as hook event #17
  - Document new payload fields: `agent_id`, `agent_type`, `worktree`
- Update `helpers/navigation/hook-environment-variables.md` with new fields
- Update `registry/existing-capabilities.md`: hook count 16 → 17
- Optional: Add a starter `~/.claude/hooks/instructions-loaded.sh` for skill usage logging
- Use case: suppress Discord notifications when `agent_type == "subagent"`
