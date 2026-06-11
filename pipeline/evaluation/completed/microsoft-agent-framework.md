# Discovery: Microsoft Agent Framework

**Source**: https://github.com/microsoft/agent-framework
**Category**: Agent Framework
**Stars/Validation**: 7k stars, official Microsoft project, latest release Feb 6 2026

## Summary

Microsoft's comprehensive multi-language framework for building, orchestrating, and deploying AI agents with support for both .NET and Python. Key features: (1) Graph-based workflows with streaming/checkpointing, (2) Interactive DevUI for testing, (3) Built-in observability via OpenTelemetry, (4) Middleware system for request/response processing, (5) Human-in-the-loop support, (6) A2A protocol integration (Jan 2026).

## Potential Value

- **Token impact**: N/A - This is an external framework, not an MCP/tool
- **Capability**: Novel - Enterprise-grade agent orchestration with .NET support
- **Integration effort**: N/A - Cannot integrate external frameworks into Claude Code

## Key Features

### 1. Graph-Based Workflows

**How it works**:
- Define agent workflows as directed acyclic graphs (DAGs)
- Nodes = agents or functions
- Edges = data flow between nodes
- Supports streaming, checkpointing, time-travel debugging

**Claude Code Equivalent**:
We already have:
- ✅ Task tool for agent delegation (sequential, not graph-based)
- ✅ evolution-orchestrator for multi-agent workflows
- ✅ TodoWrite for task dependencies (but no DAG visualization)

**What We're Missing**:
- ❌ No graph-based workflow definition (Task tool is imperative, not declarative)
- ❌ No checkpointing (sessions are ephemeral)
- ❌ No time-travel debugging

### 2. Dual-Language Support (.NET + Python)

**How it works**:
- Consistent API across C#/.NET and Python
- .NET: 43.8% of codebase
- Python: 51.4% of codebase
- Enterprise-focused (Microsoft shop adoption)

**Claude Code Equivalent**:
We already have:
- ✅ Language-agnostic (works with any codebase)
- ✅ Bash tool for any runtime (Python, Node, .NET, etc.)

**What We're Missing**:
- ❌ No first-class .NET agent SDK (but Bash tool works)

### 3. DevUI for Testing

**How it works**:
- Interactive web interface for testing agent workflows
- Visualize agent interactions, data flow
- Debug step-by-step

**Claude Code Equivalent**:
We already have:
- ✅ `/debug` command for troubleshooting
- ✅ Task tool returns metrics (tokens, duration, tools)
- ✅ Session history for replay

**What We're Missing**:
- ❌ No visual DevUI (CLI-only)
- ❌ No step-by-step debugging (all-or-nothing execution)

### 4. Built-in Observability

**How it works**:
- OpenTelemetry integration for distributed tracing
- Track agent calls, token usage, latency
- Export to monitoring systems (Prometheus, Jaeger, etc.)

**Claude Code Equivalent**:
We already have:
- ✅ Task tool metrics (tokens, duration, tools used)
- ✅ Session logs
- ✅ Hooks for custom telemetry

**What We're Missing**:
- ❌ No OpenTelemetry integration (would be useful for enterprise)
- ❌ No distributed tracing (single-process only)

### 5. Middleware System

**How it works**:
- Intercept requests/responses between agents
- Add logging, auth, rate limiting, caching
- Composable middleware pipeline

**Claude Code Equivalent**:
We already have:
- ✅ Hooks system (PreToolUse, PostToolUse, etc.)
- ✅ Agent frontmatter for tool restrictions

**What We're Missing**:
- ❌ No middleware concept (hooks are more limited)
- ❌ No composable pipelines (hooks are single-function)

### 6. A2A Protocol Integration

**How it works**:
- Microsoft Agent Framework supports A2A protocol (Jan 2026)
- Agents can communicate with external A2A agents
- Enables cross-vendor collaboration

**Claude Code Equivalent**:
We already have:
- ✅ Task tool for internal agent delegation
- ❌ No A2A support (yet - see separate A2A evaluation)

## Redundancy Check

### Existing Capabilities

From registry:
- ✅ **Task Tool**: Agent delegation (sequential, not graph-based)
- ✅ **evolution-orchestrator**: Multi-agent workflows
- ✅ **Hooks System**: PreToolUse, PostToolUse, etc.
- ✅ **Task Metrics**: Token count, duration, tools used
- ✅ **Session Persistence**: Resume work later

### Is This DUPLICATE or IMPROVEMENT?

**DUPLICATE**: Core capabilities exist
- Agent delegation: Task tool
- Multi-agent workflows: evolution-orchestrator
- Observability: Task metrics + session logs
- Middleware: Hooks system

**IMPROVEMENT**: Enterprise features
- Graph-based workflows (vs imperative Task calls)
- DevUI (vs CLI-only)
- OpenTelemetry (vs basic metrics)
- .NET support (vs language-agnostic Bash)
- A2A integration (vs internal-only)

**Key Insight**: Microsoft Agent Framework targets enterprise .NET/Python shops with DevOps needs. Claude Code targets individual developers with simpler workflows.

## Why This Discovery Matters

### Learnings for Claude Code

Microsoft's framework shows enterprise needs:

1. **Graph-Based Workflows**
   - Declarative workflow definition
   - Visual DAG representation
   - Checkpointing for long-running tasks

2. **Observability**
   - OpenTelemetry integration
   - Distributed tracing
   - Performance monitoring

3. **Middleware**
   - Composable request/response pipelines
   - Auth, rate limiting, caching

4. **DevUI**
   - Visual workflow testing
   - Step-by-step debugging

### What to Learn

1. **Enhance Hooks System**
   - Make hooks composable (middleware-style)
   - Add hook chaining support
   - Document hook patterns

2. **Add OpenTelemetry Support**
   - Export Task metrics to OpenTelemetry
   - Enable distributed tracing for subagents
   - Integrate with enterprise monitoring

3. **Improve Task Metrics**
   - Add checkpointing for long-running tasks
   - Add step-by-step execution mode
   - Add workflow visualization (future IDE feature)

### What NOT to Copy

1. **Graph-Based Workflows**: Too complex for most users, imperative is clearer
2. **DevUI**: Requires separate web server, IDE integration is better path
3. **Dual-Language SDKs**: Claude Code's Bash tool already language-agnostic

## Competitive Analysis

### Microsoft Agent Framework vs Claude Code

| Feature | Microsoft | Claude Code |
|---------|-----------|-------------|
| Workflow Style | Graph-based (declarative) | Imperative (Task tool) |
| Language Support | .NET, Python (dual SDKs) | Language-agnostic (Bash) |
| UI | DevUI (web-based) | CLI-only |
| Observability | OpenTelemetry | Task metrics |
| Middleware | Composable pipelines | Hooks |
| A2A Support | Yes (Jan 2026) | No (evaluating) |
| Target Audience | Enterprise .NET/Python shops | Individual developers |

**Verdict**: Different target audiences. Microsoft targets enterprise, Claude Code targets individuals.

## Quick Assessment Score

**N/A - This is a competitive analysis, not an integration candidate**

However, if scoring the *inspirational value*:
- **Pattern quality**: 85/100 (enterprise-grade, battle-tested)
- **Relevance to Claude Code**: 60/100 (different target audience)
- **Implementation effort**: N/A (cannot integrate external framework)
- **Novelty**: 70/100 (graph workflows, OpenTelemetry are novel)
- **INSPIRATIONAL VALUE**: **71/100**

## Recommended Action

[X] Document patterns - No integration needed, but document learnings:
  - Add to `library/patterns/enterprise-agent-orchestration.md`
  - Update hooks documentation with middleware patterns
  - Research OpenTelemetry integration for Task tool
  - Consider A2A protocol (see separate evaluation)

## Research Questions

1. **Hooks → Middleware**: Should hooks become composable middleware?
2. **OpenTelemetry**: Is enterprise monitoring a common need for Claude Code users?
3. **Graph Workflows**: Would declarative DAGs improve multi-agent orchestration?
4. **DevUI**: Is visual workflow testing valuable enough to build separate UI?

## Integration Blocker Classification

**N/A - Competitive Analysis**

No integration needed. This is an external framework, not an MCP/tool. We document patterns to improve Claude Code's existing features.

## Pros (Pattern Quality)

✅ Enterprise-grade architecture
✅ Graph-based workflows enable complex orchestration
✅ OpenTelemetry integration for monitoring
✅ DevUI for visual testing
✅ A2A protocol for cross-vendor collaboration
✅ Official Microsoft backing

## Cons (Applicability to Claude Code)

❌ External framework, cannot integrate
❌ Different target audience (enterprise vs individual)
❌ Graph workflows too complex for most Claude Code use cases
❌ DevUI requires separate web server (IDE integration is better)
❌ Dual-language SDKs unnecessary (Bash tool is language-agnostic)

## Key Takeaway

Microsoft Agent Framework validates enterprise needs:
1. **Observability**: OpenTelemetry integration
2. **Middleware**: Composable pipelines
3. **Visual Tools**: DevUI for testing
4. **Interoperability**: A2A protocol

Claude Code should:
1. **Enhance hooks**: Make composable like middleware
2. **Add OpenTelemetry**: Export Task metrics
3. **Improve Task tool**: Add checkpointing, step debugging
4. **Evaluate A2A**: See separate A2A evaluation

**Action**: Document Microsoft's patterns, enhance Claude Code's hooks and observability, evaluate A2A protocol separately.

---

**Evaluation Date**: 2026-02-06
**Evaluator**: capability-discoverer
**Discovery Loop**: #15

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6 (capability-evaluator)

### Redundancy Analysis

**Registry check**: Task tool, evolution-orchestrator, hooks system provide core multi-agent orchestration. **Classification: COMPETITIVE ANALYSIS** (external framework, not integrable)

This is NOT an integration candidate - it's a competitive framework analysis for pattern learning.

### Scoring (Inspirational Value)

| Criterion | Assessment | Rationale |
|-----------|------------|-----------|
| Pattern Quality | 85/100 | Enterprise-grade, battle-tested by Microsoft, addresses real DevOps needs |
| Relevance to Claude Code | 60/100 | Different target audience (enterprise .NET/Python vs individual developers) |
| Implementation Feasibility | N/A | Cannot integrate external framework |
| Novelty of Patterns | 70/100 | Graph workflows, OpenTelemetry, middleware are novel; agent delegation exists |
| **INSPIRATIONAL VALUE** | **71/100** | **Document patterns** |

### Decision: **DOCUMENT PATTERNS** (Not for Integration)

**Rationale**: This is an external framework targeting enterprise .NET/Python shops, not an MCP or tool we can integrate. However, the patterns are valuable for improving Claude Code's existing capabilities:

1. **Composable Middleware**: Enhance hooks system to support chaining
2. **OpenTelemetry Integration**: Export Task metrics to enterprise monitoring
3. **Checkpointing**: Add pause/resume to long-running Task executions
4. **A2A Protocol**: Evaluate separately (cross-vendor agent communication)

### Action Items

1. **Create pattern documentation**: `library/patterns/enterprise-agent-orchestration.md`
   - Document Microsoft's graph workflow patterns
   - Explain OpenTelemetry integration approach
   - Describe middleware vs hooks comparison
   - Note A2A protocol integration (evaluate separately)

2. **Update hooks documentation**: `~/.claude/agents/INDEX.md`
   - Add section on composable hooks (middleware-style patterns)
   - Document hook chaining examples
   - Reference Microsoft's middleware patterns

3. **Research OpenTelemetry**: Create research task
   - Is enterprise monitoring a common need for Claude Code users?
   - Can Task tool metrics export to OpenTelemetry?
   - What's the integration complexity?

4. **A2A Protocol**: Separate evaluation
   - Microsoft Agent Framework supports A2A as of Jan 2026
   - Evaluate A2A protocol independently (cross-vendor agent communication)
   - See if there's an A2A MCP or integration path

### Key Learnings

**What Microsoft Agent Framework teaches us:**

1. **Enterprise needs differ from individual needs**
   - Graph workflows (too complex for most users)
   - DevUI (IDE integration is better for Claude Code)
   - OpenTelemetry (valuable for enterprise, but niche)

2. **Composable patterns are powerful**
   - Middleware > single-function hooks
   - Declarative workflows have advantages for complex orchestration
   - Visual debugging helps enterprise adoption

3. **Observability matters at scale**
   - Task metrics are good, but OpenTelemetry enables enterprise integration
   - Distributed tracing for multi-agent workflows
   - Performance monitoring for production deployments

**What NOT to copy:**
- Graph-based workflows (imperative Task tool is clearer for most)
- DevUI (requires separate web server, IDE integration is better)
- Dual-language SDKs (Bash tool already language-agnostic)

### Notes

This evaluation demonstrates the importance of distinguishing "integration candidates" from "competitive analysis." Microsoft Agent Framework is valuable for LEARNING, not INTEGRATING. The patterns inform Claude Code's roadmap without requiring direct integration.
