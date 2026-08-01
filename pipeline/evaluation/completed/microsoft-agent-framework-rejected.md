# Discovery: Microsoft Agent Framework (Semantic Kernel + AutoGen Unification)

**Source**: https://github.com/microsoft/agent-framework
**Category**: Agent Framework
**Stars**: 6,500+ (as of Jan 2026)
**Date Discovered**: 2026-02-06

## Summary

Microsoft Agent Framework is the unification of Semantic Kernel and AutoGen projects into a single framework for building, orchestrating, and deploying AI agents and multi-agent workflows. Supports both Python and .NET with first-class MCP integration, state management, and orchestration patterns. Now integrates with GitHub Copilot SDK and Claude Agent SDK.

**Key Innovation**: "Framework of frameworks" - provides consistent abstractions across multi-turn conversations, state management, and orchestration while supporting multiple LLM providers (OpenAI, Anthropic, Gemini, GitHub Models, Azure).

## Key Features

- **Dual-language support**: Python + .NET (unified API)
- **MCP first-class citizen**: Native Model Context Protocol support
- **Multi-provider**: OpenAI, Anthropic, Gemini, GitHub Models, Azure Foundry
- **Observability built-in**: OpenTelemetry integration, token/latency tracking
- **Workflow orchestration**: Advanced multi-agent patterns
- **State management**: Persistent agent state across sessions
- **SDK integrations**: GitHub Copilot SDK, Claude Agent SDK
- **Deployment ready**: Production patterns, enterprise-focused

## Potential Value

**Token Impact**: SAVES - Built-in observability reduces debugging overhead; orchestration patterns prevent redundant work

**Capability**: Comprehensive agent framework with .NET support (novel for our stack). Current system uses Python-centric approaches; MSF could enable .NET-based agents if needed.

**Integration Effort**: HARD
- Requires .NET runtime (we're Python/Bash-focused)
- Large framework (not a simple library)
- Designed for building agents from scratch, not integrating with Claude Code's native agent system
- Would require architectural shift (Claude Code → MSF agent runner)

## Comparison to Existing Architecture

| Feature | Claude Code Native | evolution-orchestrator | Microsoft Agent Framework |
|---------|-------------------|------------------------|---------------------------|
| **Language** | Python/Bash | Python (via Task) | Python + .NET |
| **Agent Model** | Task tool + subagents | Subagent delegation | Framework-managed agents |
| **MCP Support** | First-class (built-in) | Via Claude Code tools | First-class (library) |
| **Observability** | `/debug`, hooks | Manual logging | **OpenTelemetry built-in** |
| **State Management** | Agent Memory frontmatter | Project memory | **Framework-managed state** |
| **Orchestration** | evolution-orchestrator | Manual Task calls | **Workflow DSL** |

**Key Distinction**: MSF is a *framework for building agents* while Claude Code *is an agent* with built-in agent capabilities. MSF would be used to build agents that coordinate with Claude, not replace Claude.

## Use Cases for Claude Code Evolution System

### Not Applicable (Architectural Mismatch)
❌ **Replace Claude Code agents** - MSF can't "enhance" Claude's native agent system; it's a separate runtime

### Potentially Applicable (External Integration)
✅ **Wrap external .NET services** - If we had .NET-based tools/services, MSF could expose them as agents that Claude coordinates with

✅ **Observability layer** - MSF's OpenTelemetry patterns could inform our hook-based observability (not direct integration)

✅ **Workflow patterns** - Study MSF orchestration patterns for improving evolution-orchestrator

### Realistic Integration Path
```
Claude Code (primary agent)
  → calls MSF-based .NET agent via API/MCP
    → returns results to Claude
```

**Not**: Replace Claude with MSF-based agents.

## Complementarity Analysis

**Architectural mismatch, not redundant**:

- **Claude Code**: AI agent with built-in orchestration (Task tool, subagents)
- **MSF**: Framework for *building* AI agents (library, not agent itself)

**Analogy**:
- Claude Code = Anthropic's pre-built AI agent
- MSF = LangChain/LlamaIndex (library to build your own agent)

**Can they coexist?**
- Yes, if we had .NET services that MSF agents could wrap
- Yes, if we wanted to study MSF patterns for our orchestrator design
- No, if we're trying to "enhance Claude Code" with MSF (they're different layers)

**Verdict**: NOT REDUNDANT but NOT APPLICABLE to current architecture (Python/Bash-centric, Claude native agents)

## Quick Assessment Score

- **Integration complexity**: 20/100 (requires .NET, architectural shift, not designed for Claude Code enhancement)
- **Token efficiency impact**: 60/100 (observability helps, but indirect)
- **Capability expansion**: 40/100 (.NET support novel but not needed; patterns can be studied)
- **Maintenance burden**: 30/100 (large framework, .NET runtime, separate ecosystem)
- **Community validation**: 80/100 (6.5k stars, Microsoft-backed, production-ready)
- **TOTAL**: 46/100

## Redundancy Check

**Checked against registry**: Task tool, evolution-orchestrator, Agent Teams, AutoGen, multi-agent orchestration

**Result**: NOT REDUNDANT but NOT APPLICABLE

**Reasoning**:
- MSF unifies AutoGen (which we don't use) + Semantic Kernel (which we don't use)
- Our architecture is Claude Code native (Task tool, subagents, MCP)
- MSF is for *building agents*, not enhancing Claude Code
- .NET support is novel but not needed (Python/Bash ecosystem works)

## Integration Blocker Analysis

**Type**: D - Architecture (fundamental mismatch)

**Blockers**:
1. **Language mismatch**: Requires .NET; we're Python/Bash
2. **Architectural mismatch**: MSF builds agents; Claude Code *is* the agent
3. **No clear integration point**: Can't "plug in" MSF to Claude Code
4. **Redundant with native capabilities**: Task tool + evolution-orchestrator cover orchestration

**Non-Starter Question**:
"How would we integrate MSF with Claude Code?" → No good answer. MSF is a peer, not a plugin.

## Recommended Action

- [ ] Needs research
- [x] **REJECT** (reason: Architectural mismatch, language barrier, redundant with native capabilities)
- [ ] Fast-track integration

**Rejection Reasoning**:
1. **Score**: 46/100 (below approval threshold of 70, below research threshold of 50)
2. **Architectural mismatch**: MSF is for building agents; we use Claude Code (pre-built agent)
3. **Language barrier**: .NET not in our stack; integration cost too high
4. **Redundancy**: Orchestration covered by Task tool + evolution-orchestrator
5. **No clear value-add**: Observability patterns can be studied without integration

**What We Can Learn (Without Integrating)**:
- Study MSF workflow orchestration patterns → improve evolution-orchestrator
- Study OpenTelemetry integration → enhance our hook-based observability
- Monitor MCP best practices from MSF docs

**Action**:
- Add to registry as "EVALUATED AND REJECTED (architectural mismatch)"
- Document observability patterns worth studying
- Move to `archive/rejected/microsoft-agent-framework-rejected.md`

---

**Filed by**: capability-discoverer
**Next step**: Move to archive/rejected/ with lessons-learned section

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: Task tool, evolution-orchestrator (internal orchestration)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 20/100 | 20% | 4.0 | Requires .NET, architectural shift, not designed for enhancement |
| Token Efficiency Impact | 60/100 | 25% | 15.0 | Observability helps but indirect |
| Capability Expansion | 40/100 | 25% | 10.0 | .NET support novel but not needed |
| Maintenance Burden | 30/100 | 15% | 4.5 | Large framework, .NET runtime, separate ecosystem |
| Community Validation | 80/100 | 15% | 12.0 | 6.5k stars, Microsoft-backed, production-ready |
| **TOTAL** | | | **45.5/100** | REJECT |

### Redundancy Analysis

**Classification**: NOT REDUNDANT but NOT APPLICABLE (architectural mismatch)

**Architectural Layers**:
- MSF: Framework for *building* AI agents (library)
- Claude Code: *Is* the AI agent (application)

**Analogy**:
- MSF = LangChain/LlamaIndex (build your own agent)
- Claude Code = Anthropic's pre-built agent with orchestration

**Can't integrate**: MSF is a peer framework, not a plugin for Claude Code

### Decision

**REJECT** (Score: 45.5/100)

**Rejection Reasons**:
1. Falls below 50-point threshold (45.5/100)
2. Architectural mismatch: MSF builds agents, Claude Code *is* the agent
3. Language barrier: Requires .NET, we're Python/Bash-focused
4. Redundancy with native capabilities: Task tool + evolution-orchestrator cover orchestration
5. No clear integration point: Can't "plug in" MSF to Claude Code

**What MSF Offers** (not applicable to us):
- .NET agent development (we don't build .NET agents)
- AutoGen + Semantic Kernel unification (we don't use either)
- Framework abstractions (Claude Code provides abstractions natively)

**Lessons Learned** (without integrating):
- Study MSF workflow orchestration patterns → inform evolution-orchestrator improvements
- Study OpenTelemetry integration → enhance hook-based observability
- Monitor MSF MCP best practices for ecosystem trends

**Action**: Move to `archive/rejected/microsoft-agent-framework-rejected.md` with lessons-learned section

**Owner-Interest Reopen**: 2026-07-29 → `pipeline/evaluation/review/microsoft-agent-framework-rejected.md` (owner-interest lens)
