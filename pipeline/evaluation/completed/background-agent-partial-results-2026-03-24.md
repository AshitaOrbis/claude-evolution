# Integration: Background Agent Partial Result Preservation

**Score**: 81.25/100
**Decision date**: 2026-03-24
**Source**: Claude Code v2.1.81+ (releasebot.io)

## Action Required

### 1. Registry Update

Add to `registry/existing-capabilities.md` under the **Agent Orchestration** table:

```
| Background Agent Partial Result Preservation | ACTIVE (v2.1.81+) | When a background agent is killed/interrupted, completed work is preserved in conversation context. Distinct from Autonomous Subagent Resume (which resumes stopped agents) — this salvages partial output from forcibly killed agents. No configuration required, automatic behavior. |
```

Add to redundancy triggers: "background agent killed", "partial agent results", "interrupted agent", "checkpoint recovery", "agent work preserved"

### 2. Playbook

Create `helpers/playbooks/background-agent-partial-results.md` documenting:
- When it triggers vs Autonomous Subagent Resume
- How to inspect recovered partial results after agent kill
- Pattern: kill agent at good checkpoint → inspect recovered context → continue manually

## No Installation Required

This is automatic Claude Code behavior. Registry documentation is the only action.
