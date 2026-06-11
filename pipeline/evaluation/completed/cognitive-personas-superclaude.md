# Discovery: Cognitive Personas (SuperClaude Framework)

**Source**: https://github.com/SuperClaude-Org/SuperClaude_Framework
**Date**: 2026-02-06
**Category**: Agent / Prompting
**Stars**: Not yet tracked (recent project)

## Description

Meta-programming framework that transforms Claude Code through "behavioral instruction injection"—16 specialized cognitive personas that activate contextually based on task type.

### Cognitive Personas (16)
1. PM Agent - Continuous learning documentation
2. Deep Research Agent - Autonomous web research
3. Security Engineer - Vulnerability identification
4. Frontend Architect - UI/UX expertise
5. Business Panel - Multi-expert strategic analysis
6. Code Understanding Specialist - Context-aware analysis
7. Token Efficiency Expert - 30-50% context savings
8. Reasoning Coordinator - Multi-step logic
9-16. DevOps, Testing, Documentation, Performance, etc.

### Behavioral Modes
- **Brainstorming Mode**: Question-driven exploration
- **Orchestration Mode**: Efficient tool coordination
- **Introspection Mode**: Meta-cognitive quality analysis
- **Task Management**: Systematic organization
- **Token-Efficiency**: Context pruning

### Development Methodologies (7)
- Planning-Only: Direct execution
- Intent-Planning: Collaborative refinement
- Unified: Adaptive depth (default)
- Deep Research: Multi-hop reasoning (5 iterations)
- Business Analysis: Panel-based consensus
- Token-Efficient: Selective retention
- Introspective: Self-evaluation loops

## Redundancy Check

**Keywords searched**: "cognitive personas", "behavioral injection", "meta-prompting", "adaptive reasoning", "multi-expert", "persona switching"

**Match in registry**: YES - Significant overlap:
- Existing subagents (code-reviewer, debugger, test-writer, security-auditor, etc.)
- model-router subagent (routes to appropriate model/agent)
- evolution-orchestrator (master coordinator)
- Effort Controls (Opus 4.6 API - low/medium/high/max)
- Adaptive Thinking (Opus 4.6 - auto-calibrates depth)

**Classification**: **DUPLICATE with different packaging** - Repackages existing subagent + routing patterns

### Comparison

| Feature | Existing Stack | SuperClaude Framework |
|---------|----------------|------------------------|
| Specialized agents | 15+ subagents in `~/.claude/agents/` | 16 "personas" |
| Routing | model-router subagent | Implicit via slash commands |
| Adaptive depth | Opus 4.6 Adaptive Thinking | 7 methodology modes |
| Token optimization | advanced-tool-use skill | Token Efficiency Expert persona |
| Multi-step reasoning | Plan Mode + Task tool | Deep Research mode |
| Security | security-auditor subagent | Security Engineer persona |
| Business analysis | General-purpose prompting | Business Panel persona |

### Why This is Largely Redundant

1. **Agent specialization**: We already have 15+ specialized subagents with explicit tools/responsibilities
2. **Adaptive reasoning**: Opus 4.6 Adaptive Thinking adjusts depth automatically
3. **Routing**: model-router handles task→agent delegation
4. **Token efficiency**: advanced-tool-use skill covers optimization patterns
5. **Meta-prompting**: CLAUDE.md + skills inject behavioral instructions

**The framework repackages well-known patterns (specialized agents, adaptive prompting, routing) into a branded "persona" system.**

### Possible Novel Elements

1. **Confidence scoring** (0.6 min, 0.8 target) - This could be valuable
2. **PM Agent systematic documentation** - Overlaps with context-librarian but more structured
3. **Business Panel multi-expert synthesis** - Novel for strategic analysis
4. **30 slash commands** - High integration effort for marginal value

## Decision

**REJECT** - 80% overlap with existing stack (subagents + model-router + adaptive thinking)

**Rationale**:
- Subagents provide clearer separation of concerns than "personas"
- model-router already handles delegation
- Opus 4.6 Adaptive Thinking auto-calibrates depth
- 30 slash commands = high maintenance burden
- "Behavioral instruction injection" is standard CLAUDE.md/skill approach

### Cherry-Pick Opportunities

If confidence scoring proves valuable:
1. Extract confidence scoring pattern (min 0.6, target 0.8)
2. Add to capability-evaluator scoring framework
3. Document as evaluation pattern, not full framework adoption

## Notes

- Requires 8 MCP servers (Tavily, Context7, Sequential-Thinking, Serena, Playwright, etc.)
- High setup complexity
- Better to improve existing subagent stack than adopt alternative system
- Framework targets users without established agent architectures

---

## Evaluation

**Evaluated**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Scoring Breakdown

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 30/100 | 20% | 6.0 | Requires 8 MCP servers + 30 slash commands (high effort) |
| Token Efficiency | 40/100 | 25% | 10.0 | Persona injection overhead; 80% overlap with existing patterns |
| Capability Expansion | 35/100 | 25% | 8.75 | 80% duplicate of subagents + model-router + adaptive thinking |
| Maintenance Burden | 40/100 | 15% | 6.0 | 30 slash commands + 8 MCPs = high maintenance |
| Community Validation | 20/100 | 15% | 3.0 | Recent project, no established adoption (no stars tracked) |
| **TOTAL** | | | **33.75/100** | |

### Cross-Validation: Not Required
Score far below 50 threshold - clear rejection case.

### Redundancy Check

**Classification**: **DUPLICATE** - 80% overlap with existing stack

**Detailed Comparison**:

| SuperClaude Feature | Existing Equivalent | Notes |
|---------------------|---------------------|-------|
| 16 Cognitive Personas | 15+ specialized subagents | code-reviewer, debugger, test-writer, security-auditor, etc. |
| Routing/Orchestration | model-router subagent | Task→agent delegation |
| Adaptive depth | Opus 4.6 Adaptive Thinking | Auto-calibrates reasoning depth |
| Token efficiency | advanced-tool-use skill | Programmatic calling, deferred loading |
| Multi-step reasoning | Plan Mode + Task tool | Structured planning + delegation |
| Security analysis | security-auditor subagent | Explicit tools/responsibilities |
| Business analysis | General prompting | No need for "Business Panel" persona |

**Overlap**: 80%
**Novel elements**: Confidence scoring (0.6-0.8), PM Agent documentation (overlaps context-librarian)

### Decision

**STATUS**: REJECTED (Score: 33.75/100)

**Rejection Reasons**:
1. **80% functional overlap** - Subagents + model-router + adaptive thinking already provide this
2. **High integration burden** - 8 MCPs + 30 slash commands vs existing agent files
3. **Worse architecture** - "Personas" less clear than specialized subagents with explicit tools
4. **Unproven** - Recent project, no established community validation

**Kill Signal**: "Alternative framework repackaging existing patterns with higher complexity"

### Cherry-Pick Opportunity

**Confidence scoring** (min 0.6, target 0.8) could be valuable if proven:
- Extract as evaluation pattern
- Add to capability-evaluator scoring
- Document independently (NOT full framework adoption)

### Notes

- Framework targets users WITHOUT established agent architectures
- Subagent approach provides clearer separation of concerns
- "Behavioral instruction injection" is standard CLAUDE.md/skill pattern
- 30 slash commands = maintenance nightmare vs file-based agents
- Better to improve existing subagent stack than adopt alternative system
- Similar rejection pattern: Claude Flow (external orchestrator), Task Master (API-heavy alternative to TodoWrite)
