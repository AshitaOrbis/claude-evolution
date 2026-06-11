# AgencyBench: Autonomous Agent Evaluation Framework

**Source**: https://arxiv.org/abs/2601.11044
**Date**: January 2026 (ArXiv)
**Category**: Agent Evaluation & Benchmarking
**Stars**: ArXiv paper (new release)

## Description

AgencyBench is a comprehensive benchmark for evaluating autonomous LLM agents across **6 core agentic capabilities in 32 real-world scenarios (138 tasks)** with genuinely demanding requirements: average 90 tool calls, 1 million tokens, and hours of execution time per task.

### What It Benchmarks

**Core Capabilities**:
1. Long-horizon planning
2. Tool use proficiency
3. Feedback-driven self-correction
4. Resource efficiency at scale
5. Visual and functional assessment
6. Framework-model co-optimization

**Task Characteristics**:
- Real-world scenarios (not synthetic toy tasks)
- Specific deliverables and evaluation rubrics
- 1M+ token contexts (tests long-context reasoning)
- Multi-hour execution requirements

## Key Findings

### 1M-Token Context Performance

**Model Performance**:
- Closed-source: 48.4% success rate
- Open-source: 32.1% success rate
- **16.3 point gap** at scale

**Framework-Model Co-Optimization**:
"Proprietary models demonstrate superior performance within their native ecosystems (e.g., Claude-4.5-Opus via Claude-Agent-SDK), while open-source models exhibit distinct performance peaks"

**Implication**: Agent performance depends on BOTH model quality AND framework optimization, not just model alone.

### Automated Evaluation Innovation

AgencyBench addresses evaluation scalability through:
- **User simulation agent**: Provides iterative feedback during task execution
- **Docker sandbox**: Conducts visual and functional rubric-based assessment
- **Automated at scale**: Enables evaluation of complex, long-horizon tasks without human bottlenecks

## Redundancy Check

**Checked against**: Reasoning & Thinking, Context Management sections

**Classification**: **NOVEL** - No existing agent evaluation framework

### Existing Capabilities

Our evolution system has:
- Capability scoring (5-criterion framework for discoveries)
- Subagent patterns (Task tool + specialized agents)
- 1M token context (Opus 4.6 available)

### What AgencyBench Adds

1. **Standardized agent benchmarking** at 1M-token scale
2. **Framework-model interaction metrics** (beyond model-only evaluation)
3. **Automated evaluation pipeline** for complex tasks
4. **Real-world scenario library** (32 scenarios, 138 tasks)

## Potential Value

### Token Impact
- **Not applicable**: This is an evaluation framework, not a token optimization technique
- **Indirect benefit**: Helps identify which agent patterns are most efficient at scale

### Capability Expansion
- **Novel**: Yes - systematic agent evaluation at 1M-token scale
- **Relevance**: High for evolution pipeline validation
- **Use cases**:
  - Benchmark capability-discoverer against industry standards
  - Validate evolution-orchestrator performance at scale
  - Compare our agent patterns to research benchmarks
  - Identify optimization opportunities through systematic testing

### Integration Effort
- **Blocker**: Requires benchmark dataset access
- **Complexity**: HIGH - need to implement AgencyBench tasks, rubrics, and evaluation pipeline
- **Alternative**: Use methodology, not full benchmark (adapt principles to our workflows)

### Maintenance Burden
- **Research paper**: No codebase to maintain (methodology only)
- **Implementation**: Would require custom build
- **Sustainability**: Research-based, methodology is portable

### Community Validation
- **Source**: ArXiv research paper (January 2026)
- **Novelty**: Addresses gap in agent evaluation (most benchmarks are short, linear tasks)
- **Credibility**: Systematic methodology, automated evaluation, real-world scenarios
- **Adoption**: Unknown (very recent, <1 month old)

## Preliminary Assessment Score

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration complexity | 30/100 | No public codebase, requires full benchmark implementation |
| Token efficiency impact | N/A | Evaluation framework, not optimization technique |
| Capability expansion | 85/100 | Novel systematic evaluation at scale, high research value |
| Maintenance burden | 50/100 | Research methodology, would need custom implementation |
| Community validation | 70/100 | Recent ArXiv paper, systematic methodology, no adoption data yet |

**TOTAL**: **58.75/100** (excluding N/A)

## Recommended Action

☑ **FUTURE** - Monitor for implementation, use methodology now

### Why Not Immediate Integration

1. **No public codebase**: Paper describes methodology but no GitHub repo with tasks
2. **High implementation cost**: 138 tasks, Docker sandbox, user simulation agent
3. **Unclear ROI**: Our agents don't operate at 1M-token scale routinely
4. **Alternative exists**: We have capability scoring framework (lighter weight)

### How to Use Now (Methodology Adoption)

1. **Adopt evaluation principles**:
   - Test agents at realistic scale (not toy examples)
   - Include feedback-driven self-correction metrics
   - Measure resource efficiency (tokens, time, tool calls)
   - Use Docker sandboxes for automated assessment

2. **Framework-model co-optimization insight**:
   - When comparing agents, test in THEIR native frameworks
   - Codex vs Claude comparison should use respective SDKs
   - Performance gaps may be framework-related, not just model quality

3. **Create mini-benchmark for evolution pipeline**:
   - 3-5 realistic capability discovery scenarios
   - Automated evaluation (token usage, discoveries found, redundancy check accuracy)
   - Compare capability-discoverer iterations over time

### Adoption Trigger

**Monitor for**:
- Public GitHub release with benchmark tasks
- Community implementations/runners
- Integration with existing agent frameworks (LangGraph, CrewAI)
- Cost-effective evaluation services

**Revisit if**:
- Evolution pipeline needs systematic validation
- Competing with other agent systems (need benchmark comparison)
- Publishing research on our evolution system (need credible evaluation)

## References

- **ArXiv**: https://arxiv.org/abs/2601.11044
- **Key insight**: "AgencyBench serves as a critical testbed for next-generation agents, highlighting the necessity of co-optimizing model architecture with agentic frameworks"

## Notes

- First evaluation framework explicitly designed for 1M-token agent tasks
- Addresses gap: most benchmarks test short, linear tasks (not realistic agent work)
- Framework-model interaction finding is valuable: agent performance isn't just about model quality
- Automated evaluation through user simulation + Docker sandbox is innovative
- Methodology is portable even without full benchmark implementation
- Score reflects research value vs immediate practical integration

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Redundancy Classification

**Match**: NONE - No existing agent evaluation framework
**Classification**: NOVEL

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 30/100 | 20% | 6.0 | No public codebase, requires full benchmark implementation |
| Token efficiency | N/A | 25% | 0.0 | Evaluation framework, not optimization (skip criterion) |
| Capability expansion | 85/100 | 33% | 28.05 | Novel systematic evaluation at scale, high research value |
| Maintenance burden | 50/100 | 15% | 7.5 | Research methodology, would need custom implementation |
| Community validation | 70/100 | 15% | 10.5 | Recent ArXiv, systematic methodology, no adoption data |

**TOTAL (adjusted)**: **52.05/100** ⏸️ FUTURE

### Decision

**FUTURE** - Monitor for implementation. Use methodology principles now (realistic scale testing, feedback-driven metrics, framework-model co-optimization). High research value but no public codebase blocks immediate integration.

**Adoption Trigger**: Public GitHub release with benchmark tasks, community implementations, or need for systematic evolution pipeline validation

**Actions Now**:
1. Document methodology principles in helpers/
2. Apply framework-model co-optimization insight to Codex vs Claude comparisons
3. Create mini-benchmark for evolution pipeline (3-5 realistic scenarios)

**Priority**: MONITOR - Valuable when available
