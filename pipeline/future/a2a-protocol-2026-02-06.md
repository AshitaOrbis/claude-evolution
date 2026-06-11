# Discovery: A2A Protocol - Agent-to-Agent Interoperability

**Source**: https://a2aprotocol.ai/
**Category**: Protocol | Multi-Agent Communication
**Stars**: Not GitHub-based (industry standard protocol)
**Date Discovered**: 2026-02-06

## Summary

The Agent-to-Agent (A2A) Protocol is a foundational standard for enabling AI agents to communicate fluidly, comparable to how microservices communicate via HTTP/REST. Backed by Google Cloud (Amit Maraj, Developer Advocate), with support from LangGraph, AutoGen, and emerging as a 2026 industry standard alongside MCP.

**Key Innovation**: Standardized handshake protocol allowing agents from different frameworks (LangGraph, AutoGen, CrewAI, etc.) to communicate and orchestrate complex workflows across system boundaries.

## Key Features

- **Framework-agnostic**: Works with LangGraph, AutoGen, CrewAI, custom agents
- **Extension system**: A2UI for agent UIs, UCP for commerce transactions
- **Microservices-inspired**: Standardized message format like REST for agents
- **Workflow decomposition**: Break complex tasks into specialist agent handoffs
- **State management**: Each agent maintains state while coordinating through A2A
- **Security layer**: AP2 Protocol provides trust/verification for transactions

## Potential Value

**Token Impact**: NEUTRAL - Protocol overhead is minimal; efficiency depends on implementation

**Capability**: Novel interoperability layer enabling cross-framework agent orchestration. Current system uses Task tool for internal agents; A2A would enable external agent coordination (e.g., Claude agent → AutoGen agent → LangGraph agent).

**Integration Effort**: HARD
- Requires A2A server/gateway implementation
- Need to design message format mappings
- Claude Code Task tool doesn't natively speak A2A
- Would require custom adapter/middleware

## Comparison to Existing Orchestration

| Feature | Task Tool (Internal) | evolution-orchestrator | Agent Teams (experimental) | A2A Protocol |
|---------|---------------------|------------------------|---------------------------|--------------|
| **Scope** | Same Claude instance | Same Claude instance | Same Claude instance | **Cross-framework/cross-instance** |
| **Framework** | Claude Code native | Claude Code subagent | Claude Code experimental | Universal standard |
| **Communication** | Direct tool calls | Task delegation | Autonomous shared context | Standardized messages |
| **Use Case** | Internal specialization | Complex orchestration | Parallel read-heavy work | **External agent integration** |

**Key Distinction**: A2A enables *external* agent communication, not just internal Claude agent coordination. This is fundamentally different from Task tool / evolution-orchestrator / Agent Teams.

## Use Cases for Claude Code Evolution System

### Current (Internal Only)
```
capability-discoverer (Claude Sonnet)
  → capability-evaluator (Claude Opus)
    → capability-integrator (Claude Sonnet)
```
All same Claude Code instance, Task tool delegation.

### With A2A (Cross-Framework)
```
capability-discoverer (Claude Sonnet)
  → A2A Gateway
    → external-researcher (AutoGen multi-agent swarm)
      → A2A Gateway
        → capability-evaluator (Claude Opus)
```

**Example**: Use AutoGen's multi-agent conversation for research, then hand results to Claude evaluator.

### Specific Value-Adds

1. **Multi-model orchestration**: Send research to GPT-5 swarm via A2A, integrate results in Claude workflow
2. **Specialized frameworks**: Use CrewAI role-based agents for specific tasks, coordinate via A2A
3. **External services**: Integrate with n8n workflows, BrowserBase agents, etc. via A2A
4. **Agent marketplace**: Future-proof for ecosystem where agents from different vendors collaborate

## Complementarity Analysis

**NOT REDUNDANT** - A2A addresses *external* agent communication:

- **Task tool**: Internal Claude agents (same instance)
- **evolution-orchestrator**: Internal orchestration (same instance)
- **Agent Teams**: Parallel internal agents (same instance, experimental)
- **A2A Protocol**: **External agents** (different frameworks, instances, vendors)

**Analogy**:
- Task tool = function calls within a program
- A2A Protocol = HTTP/REST APIs between services

**Verdict**: NOVEL - Addresses cross-framework interoperability gap. Current system is monolithic (Claude-only); A2A enables polyglot agent ecosystems.

## Quick Assessment Score

- **Integration complexity**: 35/100 (requires gateway/adapter, no native Claude Code support)
- **Token efficiency impact**: 50/100 (neutral - depends on external agents)
- **Capability expansion**: 85/100 (novel interoperability layer)
- **Maintenance burden**: 60/100 (additional infrastructure, protocol evolution)
- **Community validation**: 75/100 (Google-backed, LangGraph/AutoGen support, emerging standard)
- **TOTAL**: 61/100

## Redundancy Check

**Checked against registry**: Task tool, evolution-orchestrator, Agent Teams, multi-agent orchestration, model-router

**Result**: NOVEL

**Reasoning**:
- All existing capabilities are *internal* agent coordination
- A2A is *external* agent interoperability (different layer)
- No overlap with current stack

## Integration Blocker Analysis

**Type**: D - Architecture (requires fundamental shift to distributed agents)

**Blockers**:
1. **No native Claude Code support**: Task tool doesn't emit/receive A2A messages
2. **Gateway required**: Need middleware to translate Claude tool calls ↔ A2A messages
3. **Uncertain ROI**: Do we actually need external agents? Current monolithic stack works well.
4. **Protocol maturity**: A2A is 2026-emerging; not yet battle-tested like MCP

**Questions**:
1. What external agents would we integrate? (AutoGen swarm? CrewAI researchers?)
2. Is polyglot agent orchestration worth the complexity?
3. Could we achieve same goals with MCP servers wrapping external agents?

## Recommended Action

- [ ] Needs research
- [ ] Reject (reason: ...)
- [x] **DOCUMENT FOR FUTURE** - Novel but not actionable today

**Reasoning**:
- Score: 61/100 (above research threshold of 50, below approval threshold of 70)
- High architectural complexity (no native support)
- Unclear immediate value (current stack works well)
- Emerging standard (wait for maturity + ecosystem adoption)

**Future Reconsideration Triggers**:
1. Anthropic adds native A2A support to Claude Code
2. We identify specific external agents worth integrating (AutoGen, CrewAI, BrowserBase)
3. A2A becomes industry standard (widespread adoption like MCP)
4. Cross-framework orchestration becomes critical need

**Action**:
- Move to `pipeline/future/a2a-protocol-2026-02-06.md`
- Add to registry as "DOCUMENTED (FUTURE)" with triggers
- Monitor A2A ecosystem development in 2026

---

**Filed by**: capability-discoverer
**Next step**: Move to future/ directory with trigger documentation

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: Context Management - Task tool, evolution-orchestrator, Agent Teams (all internal)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 35/100 | 20% | 7.0 | Requires gateway/adapter, no native support |
| Token Efficiency Impact | 50/100 | 25% | 12.5 | Neutral - depends on external agents |
| Capability Expansion | 85/100 | 25% | 21.25 | Novel external agent interoperability |
| Maintenance Burden | 60/100 | 15% | 9.0 | Additional infrastructure, protocol evolution |
| Community Validation | 75/100 | 15% | 11.25 | Google-backed, LangGraph/AutoGen support |
| **TOTAL** | | | **61.0/100** | FUTURE |

### Redundancy Analysis

**Classification**: NOVEL (addresses different layer)

**Existing capabilities** (all internal):
- Task tool: Same Claude instance agent delegation
- evolution-orchestrator: Same Claude instance orchestration
- Agent Teams: Same Claude instance parallel agents

**A2A Protocol**: Cross-framework external agent communication
- Different layer: Internal coordination vs external interoperability
- Analogy: Function calls (Task tool) vs HTTP APIs (A2A)

**Verdict**: NOT REDUNDANT - Enables polyglot agent ecosystems

### Decision

**FUTURE** (Score: 61.0/100)

**Reasoning**:
1. Score in FUTURE range (50-69)
2. Novel capability (external agent interoperability)
3. High architectural complexity (requires gateway, no native support)
4. Unclear immediate ROI (current monolithic stack works well)
5. Emerging standard (2026, not battle-tested like MCP)

**Why FUTURE instead of REJECT**:
- Novel capability (not redundant with internal orchestration)
- Google Cloud backing (strong validation)
- LangGraph/AutoGen support (ecosystem momentum)
- Polyglot agent coordination could be valuable long-term

**Adoption Triggers**:
1. Anthropic adds native A2A support to Claude Code
2. We identify specific external agents worth integrating (AutoGen swarm, CrewAI researchers)
3. A2A becomes industry standard (widespread adoption like MCP)
4. Cross-framework orchestration becomes critical need

**Integration Blockers** (Type D - Architecture):
- No native Claude Code support (Task tool doesn't emit/receive A2A)
- Gateway/adapter required (middleware overhead)
- Uncertain ROI vs current stack

**Action**: Move to `pipeline/future/a2a-protocol-2026-02-06.md` with triggers documented
