# Evaluation: Agent Tool Restriction via Frontmatter (v2.1.33)

- **Date**: 2026-02-06
- **Source**: Claude Code v2.1.33 release notes
- **Category**: Agent Security & Control
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Extends existing frontmatter syntax, simple YAML addition to agent definitions |
| Token efficiency impact | 25% | 50 | Neutral - security feature doesn't reduce/increase tokens, just enforces boundaries |
| Capability expansion | 25% | 75 | Novel security control for agent hierarchies, enables principle of least privilege |
| Maintenance burden | 15% | 95 | Official Anthropic feature, zero maintenance overhead |
| Community validation | 15% | 95 | Official Anthropic feature in stable release (2.1.33) |

- **Claude Score**: 81/100
- **Codex Score**: N/A (Codex MCP unavailable)
- **Final Score**: 81/100

## Decision

**APPROVED** — Security and workflow control feature that adds granular agent delegation boundaries. Simple integration via existing frontmatter mechanism.

## Integration Notes

**Integration Type**: Security hardening + documentation

**Where it goes**:
1. Audit all agents in `~/.claude/agents/` for appropriate restrictions
2. Document in `~/.claude/agents/INDEX.md`
3. Update `skill-creator` skill to include tool restriction guidance
4. Add security review checklist item

**Agent Restriction Plan**:

| Agent | Restriction Level | Rationale |
|-------|------------------|-----------|
| `capability-discoverer` | `Task(capability-evaluator)` only | Should hand off to evaluator, not integrate directly |
| `capability-evaluator` | No Task tool | Pure evaluation, no sub-delegation needed |
| `capability-integrator` | No Task tool | Final integration step, no sub-delegation |
| `evolution-orchestrator` | `Task(*)` (all) | Coordinator role needs full delegation |
| `code-reviewer` | No Task tool | Focused review, no sub-delegation |
| `test-writer` | No Task tool | Focused testing, no sub-delegation |
| `debugger` | `Task(code-reviewer)` | May need review after fixes |

**Security Benefits**:
- Prevents unauthorized agent spawning
- Clear delegation boundaries
- Reduces attack surface
- Enforces workflow patterns

**Example Implementation**:
```yaml
# ~/.claude/agents/capability-discoverer.md
---
name: capability-discoverer
tools:
  - WebSearch
  - Exa
  - Brave
  - Read
  - Write
  - Task(capability-evaluator)  # Can only spawn evaluator
---
```

**Next Steps**:
1. Add restrictions to all existing agents
2. Test that restrictions work as expected
3. Document override mechanism (if any)
4. Update agent creation workflow
