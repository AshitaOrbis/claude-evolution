# Discovery: Agent-to-Agent (A2A) Protocol

**Source**: https://github.com/google/A2A (Google, Linux Foundation)
**Category**: Agent Communication Protocol
**Stars/Validation**: Announced Apr 2025, Linux Foundation governance, Microsoft integrated (Jan 2026), IBM BeeAI compatible

## Summary

Agent-to-Agent (A2A) Protocol is Google's open standard for enabling AI agents from different vendors and frameworks to discover, authenticate, and collaborate seamlessly. Similar to how MCP connects agents to tools, A2A connects agents to other agents. Uses JSON-RPC 2.0, HTTP/HTTPS, and SSE for standardized agent-to-agent communication.

## Potential Value

- **Token impact**: Neutral to Positive - Enables delegation without custom integration code
- **Capability**: Novel - Standardized inter-agent communication across vendors/frameworks
- **Integration effort**: Medium - Requires A2A client/server implementation

## Key Features

1. **Agent Discovery**: Agents can discover each other's capabilities via "agent cards"
2. **Task Delegation**: Standardized task lifecycle (submit, status, result)
3. **Vendor Agnostic**: Works across CrewAI, LangGraph, Microsoft Agent Framework, etc.
4. **Security**: Built-in authentication and authorization
5. **Streaming**: SSE support for real-time task updates
6. **Extensions Framework**: Protocol is extensible for custom needs

## How It Differs from MCP

| Feature | MCP | A2A |
|---------|-----|-----|
| Purpose | Connect agents to tools/data | Connect agents to other agents |
| Use Case | "Agent needs database access" | "Agent needs specialist agent's help" |
| Integration | Client-server (agent ↔ tool) | Peer-to-peer (agent ↔ agent) |
| Governance | Anthropic | Linux Foundation |

**Key Insight**: MCP and A2A are complementary - use MCP for tool access, A2A for agent coordination.

## Potential Claude Code Integration

### Option 1: A2A Server for Claude Code Subagents
Expose Claude Code subagents (code-reviewer, debugger, etc.) as A2A agents:
- External frameworks (CrewAI, LangGraph) could call Claude Code subagents
- Enables "best tool for the job" delegation across ecosystems

### Option 2: A2A Client in Claude Code
Enable Claude Code to call external A2A agents:
- Delegate specialized tasks to external agent networks
- Access domain-specific agents (legal, medical, finance) via A2A

### Option 3: Internal A2A for Subagent Coordination
Use A2A as internal protocol for Claude Code subagent communication:
- Standardized task delegation between subagents
- Better than current Task tool serialization

## Current Status (Jan 2026)

- **Linux Foundation governance**: Ensures long-term neutrality
- **Microsoft integrated**: Agent Framework supports A2A (Jan 2026)
- **CrewAI v1.9.0**: Added A2A task execution utilities and agent cards
- **Early adoption phase**: Limited production deployments, mostly experimentation

## Quick Assessment Score

- **Integration complexity**: 60/100 (requires A2A SDK, protocol implementation)
- **Token efficiency impact**: 70/100 (reduces custom integration code)
- **Capability expansion**: 85/100 (novel inter-agent communication standard)
- **Maintenance burden**: 75/100 (Linux Foundation maintained, stable spec)
- **Community validation**: 80/100 (Google-backed, Linux Foundation, Microsoft/CrewAI adopted)
- **TOTAL**: **74/100**

## Recommended Action

[X] Evaluate further - Strong potential but needs research:
  - How does A2A compare to current Task tool delegation?
  - What are token costs of A2A serialization vs. native Task calls?
  - Is there a compelling use case for exposing Claude Code subagents externally?
  - Early adoption risk: Protocol is <1 year old, still evolving

## Research Questions

1. **Token Efficiency**: Does A2A's JSON-RPC overhead exceed Task tool's native serialization?
2. **External Value**: Would external frameworks benefit from calling Claude Code subagents?
3. **Internal Value**: Does A2A improve internal subagent coordination over Task tool?
4. **Ecosystem Fit**: Should Claude Code prioritize internal optimization or external interoperability?

## Integration Blocker Classification

**Type B: Validation Required**
- Need comparative benchmarking: A2A vs Task tool
- Need use case validation: Internal vs external integration
- Need adoption timeline assessment: Wait for production maturity?

## Notes

- A2A addresses vendor lock-in for multi-agent systems
- Complements MCP rather than competing with it
- CrewAI's integration shows framework adoption is happening
- Microsoft's adoption signals enterprise readiness
- Linux Foundation governance suggests long-term stability

---

## Evaluation

**Evaluator**: capability-evaluator
**Evaluation Date**: 2026-02-06

### Registry Redundancy Check

**Keywords**: agent-to-agent, inter-agent communication, agent coordination, task delegation

**Registry Check**: No existing A2A protocol implementation found. Searched for "agent coordination", "inter-agent", "task delegation" - only found:
- Agent Teams (experimental) - parallel agents with shared context, not peer-to-peer protocol
- Task tool - internal Claude Code subagent delegation, not cross-vendor standard
- evolution-orchestrator - internal multi-agent coordination, not external protocol

**Classification**: **NOVEL** - No existing capability for standardized agent-to-agent communication across vendors/frameworks.

### Scoring

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 50/100 | Requires A2A SDK implementation (client OR server), protocol handling, agent card generation. NOT drop-in. |
| Token Efficiency Impact | 65/100 | Neutral to positive - JSON-RPC overhead exists but replaces custom integration serialization. Net neutral for internal use, positive for external delegation. |
| Capability Expansion | 80/100 | Novel for external interop - enables Claude Code subagents to be called by CrewAI/LangGraph/etc OR call external specialist agents. Internal use case weaker (Task tool already works). |
| Maintenance Burden | 70/100 | Linux Foundation governance = stable spec, but early adoption phase means protocol evolution risk. Need to track breaking changes. |
| Community Validation | 75/100 | Google-backed, Linux Foundation governance, Microsoft integrated (Jan 2026), CrewAI v1.9.0 support. Still <1 year old (Apr 2025), limited production use. |
| **WEIGHTED TOTAL** | **68.5/100** | |

**Calculation**: (50×0.20) + (65×0.25) + (80×0.25) + (70×0.15) + (75×0.15) = 68.5

### Cross-Validation (Codex)

**Codex Assessment**: 62/100
- Agreement: Novel capability for external interop
- Concern: "Internal use case is speculative - Task tool already efficient"
- Concern: "Protocol maturity risk - <1 year old, still evolving"
- Variance: 6.5 points (within acceptable range)

### Decision: FUTURE (50-69 range)

**Rationale**: Strong protocol with Linux Foundation backing and growing adoption (Microsoft, CrewAI), BUT:
1. **Use case unclear**: Would external frameworks actually call Claude Code subagents? No demand signal yet.
2. **Internal value low**: Task tool provides agent-in-agent delegation with zero protocol overhead.
3. **Early adoption risk**: Protocol <1 year old, still in adoption phase, breaking changes possible.
4. **Integration effort moderate**: Requires SDK implementation, not trivial.

### Research Gate Assessment

**Completeness**: 7/10 - Clear spec, growing implementations, but limited production examples
**Viability**: 6/10 - Technical viability high, but business viability unclear (who calls our agents?)
**Effort-to-Value**: 5/10 - Moderate effort, speculative value

**Total**: 18/30 - DEFER

### Recommended Action

**MOVE TO FUTURE** - Revisit when:
1. External demand signal emerges (someone requests Claude Code subagent access via A2A)
2. Protocol reaches 1-year production maturity (Apr 2026+)
3. Clear internal use case identified (better than Task tool)
4. A2A SDK for Python/Node.js becomes production-ready

### Notes

- Complements MCP (tools) with A2A (agents) - architecture is sound
- Linux Foundation governance suggests longevity
- Microsoft + CrewAI adoption validates direction
- "Option 3: Internal A2A" is interesting but needs benchmarking vs Task tool serialization
- Strongest case is "Option 1: Expose subagents externally" but needs demand validation

---

**Evaluation Date**: 2026-02-06
**Evaluator**: capability-discoverer
**Discovery Loop**: #15
