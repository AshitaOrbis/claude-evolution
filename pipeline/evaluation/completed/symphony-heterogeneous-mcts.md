# SYMPHONY: Synergistic Multi-Agent Planning with Heterogeneous LLM Assembly

**Source**: https://arxiv.org/html/2601.22623v1
**Date**: January 2026 (ArXiv)
**Category**: Multi-Agent Coordination
**Stars**: ArXiv paper (research)

## Description

SYMPHONY is a multi-agent planning framework that integrates **heterogeneous language models** (different LLMs) into a unified system using **Monte Carlo Tree Search (MCTS)**. Unlike existing approaches that use a single model or role-based task division, SYMPHONY leverages model diversity to generate complementary reasoning paths.

### Core Architecture

1. **Heterogeneous Agent Pool**: Multiple LLMs with diverse reasoning patterns (local open-source + cloud API)

2. **UCB-Based Agent Scheduling**: Dynamic allocation using Upper Confidence Bound principles (multi-armed bandit)

3. **Pool-wise Memory Sharing**: Decentralized reflection where agents generate natural language summaries of failures, shared across the pool

4. **Entropy-Modulated Confidence Scoring (EMCS)**: Uncertainty-aware value estimation that down-weights unreliable node evaluations

## Key Innovation: Structural Diversity Through Model Heterogeneity

**Problem with single-model MCTS**: "Outputs tend to exhibit high similarity across calls" - limited exploration diversity

**SYMPHONY's solution**: Use fundamentally different models (e.g., Claude + GPT + Llama) to generate complementary reasoning paths

### Distinction from Existing Approaches

| Framework | Approach | Limitation |
|-----------|----------|------------|
| **AgentVerse** | Blackboard architecture, free communication | Single-model during planning, role-based only |
| **CAMEL** | Turn-based dialogue | Single-model, sequential coordination |
| **AutoGen** | Role negotiation, task delegation | Role-based, not model-based diversity |
| **SYMPHONY** | Heterogeneous LLM MCTS | Model diversity for complementary reasoning |

## Empirical Results

- **More efficient search**: Requires fewer MCTS expansions than single-model approaches
- **Competitive performance**: Maintains quality even with consumer-grade hardware (heterogeneous pool)
- **Exploration diversity**: Different models generate non-overlapping reasoning paths

## Redundancy Check

**Checked against**: Multi-Model Orchestration, Context Management sections

**Classification**: **IMPROVEMENT** over existing multi-model coordination

### Existing Capabilities

We have:
- **Multi-model delegation**: Codex for code review, Gemini for UI, model-router subagent
- **Agent orchestration**: Task tool + 15+ specialized subagents
- **Agent Teams**: Experimental feature (autonomous parallel coordination)

### What SYMPHONY Adds

1. **MCTS-based planning**: Structured search over reasoning paths (vs ad-hoc delegation)
2. **Model heterogeneity as feature**: Leverages different models' reasoning styles systematically
3. **Pool-wise memory**: Shared failure analysis across diverse models
4. **UCB scheduling**: Data-driven model selection (vs manual routing rules)

### Comparison with Existing

| Feature | model-router | Agent Teams | SYMPHONY |
|---------|--------------|-------------|----------|
| **Model selection** | Rule-based (task type → model) | Autonomous coordination | UCB-based (performance data) |
| **Diversity mechanism** | Different models for different tasks | Parallel agents (same model) | Heterogeneous models for same task |
| **Planning approach** | Sequential delegation | Autonomous self-organization | MCTS search tree |
| **Memory sharing** | None (isolated contexts) | Shared context | Pool-wise failure summaries |
| **Optimization goal** | Task-model fit | Parallel throughput | Reasoning path diversity |

## Potential Value

### Token Impact
- **Unclear**: MCTS involves multiple model calls for planning, but may reduce overall attempts
- **Trade-off**: More upfront planning cost vs fewer trial-and-error iterations
- **Context**: Relevant for complex planning tasks (capability integration, architecture decisions)

### Capability Expansion
- **Novel**: Yes - MCTS planning with heterogeneous models distinct from current approaches
- **Relevance**: HIGH for evolution pipeline (complex decisions benefit from diverse perspectives)
- **Use cases**:
  - Capability evaluation: Get Codex + Claude + Gemini perspectives, MCTS selects best path
  - Integration planning: Explore multiple approaches before committing
  - Architecture decisions: Diverse model reasoning for trade-off analysis

### Integration Effort
- **Blocker**: No public implementation (research paper only)
- **Complexity**: HIGH - requires MCTS implementation, UCB scheduling, EMCS
- **Alternative**: Use principles (heterogeneous consultation) without full MCTS

### Maintenance Burden
- **Research paper**: No codebase to maintain
- **Custom implementation**: Would be significant work
- **Sustainability**: Core idea (heterogeneous models) is simple, MCTS complexity is optional

### Community Validation
- **Source**: ArXiv research (January 2026)
- **Novelty**: First framework to emphasize model heterogeneity in MCTS
- **Evidence**: Empirical results vs single-model baselines
- **Adoption**: Unknown (very recent, no public code)

## Preliminary Assessment Score

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration complexity | 35/100 | No codebase, requires MCTS+UCB+EMCS implementation |
| Token efficiency impact | 60/100 | May reduce iterations but adds planning overhead |
| Capability expansion | 85/100 | Novel planning approach, high value for complex decisions |
| Maintenance burden | 45/100 | Research-only, custom implementation required |
| Community validation | 65/100 | Recent research, empirical results, no adoption data |

**TOTAL**: **58.0/100**

## Recommended Action

☑ **FUTURE** - Use principles now, monitor for implementation

### Why Not Immediate Integration

1. **No public codebase**: Research paper only, no GitHub repo
2. **High implementation cost**: MCTS, UCB, EMCS, memory pooling
3. **Simpler alternatives exist**: Can consult multiple models without full MCTS
4. **Unclear token economics**: Planning overhead may exceed savings

### How to Use Now (Principles Adoption)

**Lightweight heterogeneous consultation**:

```markdown
# For complex capability evaluations
1. Get Claude's analysis (our primary)
2. Get Codex cross-validation (existing pattern)
3. **NEW**: Get Gemini's perspective (vision/UI expertise)
4. Synthesize insights (manual or simple voting)

# Without MCTS overhead
- Skip UCB scheduling (use all three models)
- Skip tree search (consult once, synthesize)
- Keep token cost bounded
```

**Evolution pipeline application**:
- **Capability evaluation**: Multi-model consensus (Claude + Codex + Gemini)
- **Integration planning**: Diverse perspectives on approach
- **Architecture decisions**: Trade-off analysis from different reasoning styles

**Value vs Full SYMPHONY**:
- **Retain**: Model heterogeneity principle
- **Drop**: MCTS complexity (overkill for our use cases)
- **Add**: Simple synthesis heuristics (consensus, voting, synthesis prompt)

### Adoption Trigger

**Monitor for**:
- Public GitHub implementation
- Integration with LangGraph/CrewAI
- Token cost analysis (planning overhead vs iteration savings)
- Community adoption in production systems

**Revisit if**:
- Evolution pipeline tackles extremely complex decisions (multi-step integration)
- Token efficiency of heterogeneous consultation proves valuable
- MCTS implementation becomes available as library

## References

- **ArXiv**: https://arxiv.org/html/2601.22623v1
- **Key insight**: "Existing approaches predominantly employ a single-agent framework during MCTS planning" - SYMPHONY addresses this with model heterogeneity

## Notes

- Core insight is valuable: different models produce different reasoning paths
- MCTS may be overkill for our use cases (lightweight consultation sufficient)
- UCB scheduling is interesting but adds complexity
- Pool-wise memory (failure sharing) could be adapted without full MCTS
- Research validates multi-model consultation value (we already do Claude + Codex)
- Adding Gemini perspective for UI/visual decisions is low-hanging fruit
- Score reflects research value + principles vs full implementation complexity

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Redundancy Classification

**Match**: YES - model-router subagent, Agent Teams
**Classification**: IMPROVEMENT (MCTS planning + heterogeneous models)

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 35/100 | 20% | 7.0 | No codebase, requires MCTS+UCB+EMCS implementation |
| Token efficiency | 60/100 | 25% | 15.0 | May reduce iterations but adds planning overhead |
| Capability expansion | 85/100 | 25% | 21.25 | Novel planning approach, high value for complex decisions |
| Maintenance burden | 45/100 | 15% | 6.75 | Research-only, custom implementation required |
| Community validation | 65/100 | 15% | 9.75 | Recent research, empirical results, no adoption data |

**TOTAL**: **59.75/100** ⏸️ FUTURE

### Decision

**FUTURE** - Use principles now (heterogeneous consultation), monitor for implementation. MCTS complexity not justified for current use cases.

**Actions Now**:
1. Add Gemini perspective to complex capability evaluations (Claude + Codex + Gemini)
2. Document lightweight heterogeneous consultation pattern in helpers/
3. Apply to evolution pipeline: multi-model consensus for architecture decisions

**Adoption Trigger**: Public implementation, token economics analysis, extremely complex decisions requiring MCTS

**Priority**: MONITOR - Principles valuable, full MCTS overkill
