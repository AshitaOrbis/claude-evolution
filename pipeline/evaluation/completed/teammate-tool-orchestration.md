# Discovery: TeammateTool Multi-Agent Orchestration

**Source**: https://gist.github.com/kieranklaassen/d2b35569be2c7f1412c64861a219d51f
**Date**: 2026-02-06 (documented pattern from internal Claude Code)
**Category**: Multi-Agent / Orchestration
**Status**: Server-side feature flag (not yet public)

## Description

Advanced multi-agent coordination system built into Claude Code that enables file-based messaging, shared task management, and sophisticated approval workflows between agents.

### Core Operations (13 total)
- `spawnTeam()` - Initialize team context
- `spawn()` - Launch worker agents
- `write()` - Send targeted messages
- `broadcast()` - Send to all team members
- `approveShutdown()` / `rejectShutdown()` - Graceful termination
- `approvePlan()` / `rejectPlan()` - Decision gates
- `requestShutdown()` - Timeout-based termination (5-min default)

### Execution Patterns
1. **Swarm Pattern**: Self-organizing workers claim from task queues, heartbeat timeouts
2. **Pipeline Pattern**: Sequential with `blockedBy` dependencies
3. **Council Pattern**: Multiple agents propose, leader synthesizes

### Coordination Storage
```
~/.claude/teams/{team-name}/
├── config.json (metadata, members)
└── messages/ (inter-agent mailbox)
```

## Redundancy Check

**Keywords searched**: "multi-agent", "team coordination", "agent orchestration", "teammate", "swarm pattern", "pipeline pattern"

**Match in registry**: YES - Multiple matches:
- Agent Teams (v2.1.32+, experimental flag)
- Agent Teammate Hooks (TeammateIdle, TaskCompleted)
- evolution-orchestrator subagent
- Task tool + specialized subagents

**Classification**: **DUPLICATE** - TeammateTool is the INTERNAL implementation of Agent Teams feature

### Comparison

| Feature | Existing (Agent Teams) | TeammateTool |
|---------|------------------------|--------------|
| Status | Research preview, experimental flag | Internal implementation (same feature) |
| Multi-agent coordination | Yes | Yes (underlying mechanism) |
| Approval workflows | Not documented | approvePlan/rejectPlan gates |
| Execution patterns | Autonomous coordination | Swarm/Pipeline/Council patterns |
| Storage | Not documented | `~/.claude/teams/` |

### Why This is a Duplicate

TeammateTool appears to be the **internal API** that powers the Agent Teams experimental feature already documented in the registry. The gist reveals implementation details (13 operations, file storage, approval gates) but doesn't represent a new capability—it documents how Agent Teams works under the hood.

**Evidence**:
1. Both gated behind server-side flags (`I9() && qFB()`)
2. Same coordination mechanism (file-based messaging)
3. Agent Teams uses `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` env var
4. Timeline matches (both 2.1.32+ era)

## Decision

**SKIP** - This is internal implementation documentation for an already-tracked feature (Agent Teams).

**Action**: Update Agent Teams entry in registry with newly discovered details:
- 13 core TeammateTool operations
- 3 execution patterns (Swarm/Pipeline/Council)
- Approval workflow gates (approvePlan/rejectPlan)
- Storage location (`~/.claude/teams/`)

## Notes for Registry Update

Add to Agent Teams section:
```markdown
**Implementation Details (TeammateTool)**:
- 13 operations: spawn, write, broadcast, approve/reject shutdown/plan, etc.
- Storage: `~/.claude/teams/{team-name}/` (config + messages)
- Patterns: Swarm (queue-based), Pipeline (dependency-based), Council (consensus-based)
- Approval gates: approvePlan/rejectPlan for decision points
- Graceful shutdown: 5-minute timeout, heartbeat monitoring
```

---

## Evaluation

**Evaluated**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Scoring Breakdown

This is NOT a new capability - it's internal implementation documentation for the already-tracked Agent Teams feature.

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | N/A | 20% | 0 | Already integrated (experimental flag) |
| Token Efficiency | N/A | 25% | 0 | Implementation detail, not new capability |
| Capability Expansion | 0/100 | 25% | 0 | 100% duplicate - documents existing feature |
| Maintenance Burden | N/A | 15% | 0 | Already tracked in registry |
| Community Validation | N/A | 15% | 0 | Internal implementation (not community tool) |
| **TOTAL** | | | **0/100** | |

### Cross-Validation: Not Required
This is documentation of an existing feature, not a new discovery.

### Redundancy Check

**Classification**: **DOCUMENTATION** - Internal implementation details of Agent Teams

**Evidence**:
1. Agent Teams already in registry (v2.1.32+, experimental)
2. TeammateTool is the internal API powering Agent Teams
3. Both gated behind same server-side flags
4. Timeline matches (2.1.32+ era)
5. Same file-based messaging mechanism

**Registry entry**: Lines 109-123 of existing-capabilities.md

### Decision

**STATUS**: SKIP - Not a discovery, this is implementation documentation

**Action**: Update Agent Teams registry entry with newly discovered details

**What to add to registry**:
- 13 TeammateTool operations (spawn, write, broadcast, approve/reject)
- 3 execution patterns (Swarm, Pipeline, Council)
- Approval workflow gates (approvePlan/rejectPlan)
- Storage location (`~/.claude/teams/`)

### Notes

- Valuable implementation details, but not a new capability
- This reveals HOW Agent Teams works, not WHAT it does (already documented)
- Similar to discovering internal code for existing feature
- Update registry with technical details, don't evaluate as new discovery
- Confirms Agent Teams is production-ready (well-architected internals)
