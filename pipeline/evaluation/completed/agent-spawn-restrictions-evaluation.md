# Evaluation: Agent Spawn Restrictions (v2.1.33)

- **Date**: 2026-02-06
- **Source**: https://github.com/anthropics/claude-code/releases/tag/v2.1.33
- **Category**: Security/Control
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Very easy - frontmatter syntax in agent definitions |
| Token efficiency impact | 25% | 100 | Zero token cost, improves security |
| Capability expansion | 25% | 85 | Novel security control - restrict which sub-agents can spawn |
| Maintenance burden | 15% | 95 | Native feature, minimal maintenance |
| Community validation | 15% | 100 | Official Anthropic release in v2.1.33 |

- **Claude Score**: 92.75/100
- **Codex Score**: N/A (Codex MCP connection failed)
- **Final Score**: 92.75/100

## Decision

**APPROVED** — High-value security feature with zero cost

## Integration Notes

**What it does**: Control which sub-agents a parent agent can spawn via `Task(agent_type)` syntax in the agent's "tools" frontmatter.

**Example usage**:
```yaml
---
name: restricted-agent
tools: [Read, Grep, Task(code-reviewer), Task(debugger)]
---
```

This agent can ONLY spawn code-reviewer and debugger subagents, not any others.

**Security benefits**:
- Prevent privilege escalation (e.g., read-only agent spawning write-capable agent)
- Limit blast radius of untrusted agent code
- Enforce least-privilege principle in agent hierarchies
- Prevent infinite recursion (agent spawning itself)

**Integration steps**:
1. Document in `~/.claude/agents/INDEX.md` under "Agent Design Patterns"
2. Add security-auditor pattern: audit agents for appropriate spawn restrictions
3. Update existing high-risk agents with explicit spawn lists
4. Create skill for designing secure agent hierarchies

**Use cases**:
- Evolution pipeline: discovery agents should NOT spawn integration agents
- Untrusted code: OpenClaw sandbox agents restricted to read-only operations
- Cost control: prevent expensive agents from spawning other expensive agents
- Security boundaries: separation between prod and dev agent capabilities

**Registry update**: Add to "Multi-Agent Orchestration" section under Agent Teams

**Status**: Ready for immediate integration - document and apply to existing agents
