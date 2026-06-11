# Evaluation: `claude agents` CLI Subcommand

- **Date**: 2026-03-05
- **Source**: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
- **Category**: CLI / Built-In Command
- **Version**: Claude Code 2.1.68
- **Automated**: Yes (daily heartbeat)

## Redundancy Check

- Registry search: No existing `claude agents` CLI entry.
- Nearest match: manual `ls ~/.claude/agents/` filesystem pattern — this replaces it.
- **Classification**: NOVEL (the command itself) / IMPROVEMENT (over manual browsing)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Built-in command, zero integration effort |
| Token efficiency impact | 25% | 55 | Indirect benefit — reduces debugging friction, no direct token savings |
| Capability expansion | 25% | 65 | Incremental QoL — structured agent introspection vs raw filesystem browsing |
| Maintenance burden | 15% | 100 | Zero maintenance, built-in |
| Community validation | 15% | 85 | Official Anthropic release (v2.1.68) |

- **Claude Score**: 78/100
- **Codex Score**: 82/100
- **Final Score**: 80/100

## Decision

APPROVED — Official built-in command with zero integration cost; strong community validation and useful for automation scripting and agent inventory verification.

## Integration Notes

- Type: Registry entry + documentation update (built-in command pattern)
- Document in `registry/existing-capabilities.md` under CLI/Built-In Commands section
- Reference in heartbeat automation docs as a way to validate agent definitions
- Optionally add to `evolution-daily.sh` as an agent inventory validation step
- Pattern: same as `/copy`, `/batch`, `/simplify` — registry entry only, no skill file needed
