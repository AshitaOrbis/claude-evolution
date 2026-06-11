# Memory in the Age of AI Agents (Taxonomy & Survey)

**Source**: https://arxiv.org/abs/2512.13564
**Date**: December 2025 / January 2026 (ArXiv, v2)
**Category**: Agent Memory Architecture
**Stars**: ArXiv paper (survey)

## Description

Comprehensive survey establishing **memory as a first-class primitive** in agentic intelligence design. Introduces a unified taxonomic framework organizing agent memory research across three dimensions.

### Three-Dimensional Taxonomy

**1. Forms** - Memory implementation types:
- **Token-level memory**: Context windows, conversation history
- **Parametric memory**: Fine-tuned model weights, knowledge distillation
- **Latent memory**: Vector databases, embeddings, external stores

**2. Functions** - Memory purpose:
- **Factual memory**: Knowledge, facts, entities
- **Experiential memory**: Past interactions, task histories
- **Working memory**: Active context, current task state

**3. Dynamics** - Memory lifecycle:
- **Formation**: How memories are created and encoded
- **Evolution**: How memories change over time
- **Retrieval**: How memories are accessed and used

### Key Contribution: Conceptual Clarity

The survey **delineates scope** - clearly separating:
- Agent memory (persistent state for autonomous systems)
- LLM memory (model knowledge)
- RAG (retrieval augmentation)
- Context engineering (prompt optimization)

**Problem addressed**: "Existing works differ substantially in their motivations, implementations, and evaluation protocols" - field fragmentation

### Emerging Research Frontiers

- Memory automation (automatic formation/pruning)
- Reinforcement learning integration
- Multimodal memory systems
- Multi-agent memory coordination
- Trustworthiness (privacy, security, bias)

## Redundancy Check

**Checked against**: Memory & Persistence section

**Classification**: **CONCEPTUAL FRAMEWORK** (not implementation)

### Existing Capabilities

We have:
- **Official Memory System**: Claude Code 2.1.32+ (token-level, auto-records)
- **Agent Memory Frontmatter**: Project/user/local scopes (latent memory via files)
- **CLAUDE.md**: Static knowledge base (parametric-like, but external)
- **Library system**: Archived learnings (`claude-evolution/library/`)
- **Session persistence**: Native Claude Code sessions

### What This Survey Adds

**Not a tool, but a LENS for organizing existing capabilities**:

| Our Implementation | Taxonomy Classification |
|-------------------|------------------------|
| Official Memory System | Token-level (short-term) + Factual function |
| Agent Memory Frontmatter | Latent memory (file-based) + Experiential function |
| CLAUDE.md | Latent memory (static) + Factual function |
| Library system | Latent memory (structured) + Experiential function |
| ACE Framework (pending eval) | Experiential memory + Structured evolution |

**Value**: Helps us understand GAPS in our memory architecture.

### Memory Architecture Gaps (Using Taxonomy)

**Forms Coverage**:
- ✅ Token-level: Official Memory System, conversation context
- ❌ Parametric: No fine-tuning or knowledge distillation
- ✅ Latent: Agent Memory files, CLAUDE.md, library

**Functions Coverage**:
- ✅ Factual: Official Memory, CLAUDE.md
- ⚠️ Experiential: Agent Memory (state only), library (archived), ACE (pending)
- ✅ Working: Conversation context, session state

**Dynamics Coverage**:
- ⚠️ Formation: Mostly manual (CLAUDE.md, library), auto (Official Memory)
- ❌ Evolution: Static files, no systematic refinement (ACE addresses this)
- ✅ Retrieval: Auto (Official Memory), manual (@imports, library search)

**Key Gap**: **Memory evolution** - our files are static, no systematic refinement over time

## Potential Value

### Token Impact
- **Not applicable**: Survey/taxonomy, not implementation
- **Indirect**: Helps identify efficient memory architectures

### Capability Expansion
- **Conceptual framework**: Organizes thinking about memory, not a new tool
- **Gap identification**: Reveals missing dynamics (evolution)
- **Research direction**: Points to emerging frontiers (multimodal, multi-agent coordination)

### Integration Effort
- **Not applicable**: No implementation to integrate
- **Use**: Apply taxonomy to analyze our memory stack

### Maintenance Burden
- **Not applicable**: Survey paper, no code

### Community Validation
- **High**: ArXiv survey paper (comprehensive literature review)
- **Scope**: Unified framework across diverse research
- **Credibility**: Establishes conceptual foundations for field

## Preliminary Assessment Score

**Not scored** - This is a conceptual framework/survey, not a tool or technique

## Recommended Action

☑ **DOCUMENT** - Use taxonomy to analyze and improve memory architecture

### Actions

1. **Create memory architecture map** using taxonomy:
   - Document what we have in Forms/Functions/Dynamics framework
   - Identify gaps (parametric memory, evolution dynamics)
   - Prioritize gaps by impact

2. **Evolution dynamics gap**:
   - ACE Framework (pending evaluation) addresses this
   - Consider: automatic CLAUDE.md refinement over time
   - Consider: library pruning/consolidation automation

3. **Multi-agent memory coordination**:
   - Survey identifies this as frontier
   - We have Agent Memory Frontmatter (project scope)
   - Gap: no coordination mechanism across agents
   - Opportunity: shared memory pool for evolution pipeline agents

4. **Add to helpers/ documentation**:
   - `helpers/navigation/memory-architecture-taxonomy.md`
   - Map our implementations to taxonomy
   - Highlight strengths and gaps

5. **Integration with ACE evaluation**:
   - ACE directly addresses "evolution" dynamic (grow-and-refine)
   - ACE's reflective architecture fits "experiential memory evolution"
   - Survey supports ACE's value proposition

## References

- **ArXiv**: https://arxiv.org/abs/2512.13564
- **Key contribution**: "Memory as a first-class primitive in the design of future agentic intelligence"
- **Taxonomy**: Forms (token/parametric/latent) × Functions (factual/experiential/working) × Dynamics (formation/evolution/retrieval)

## Notes

- Survey, not implementation - provides conceptual lens
- Helps organize our scattered memory implementations
- Reveals gap: memory evolution (ACE addresses this)
- Multi-agent memory coordination is emerging frontier (relevant for evolution pipeline)
- Parametric memory (fine-tuning) unlikely for our use case (API-based)
- Reinforcement learning integration not applicable (we don't use RL)
- Multimodal memory less relevant (mostly text-based workflows)
- Should create helper doc mapping our stack to this taxonomy
- Strengthens ACE evaluation case (addresses identified gap)

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Classification

**NOT SCORED** - This is a conceptual framework/survey, not a tool or technique

### Decision

**DOCUMENT** - Use taxonomy to analyze and improve memory architecture

**Actions**:
1. Create `helpers/navigation/memory-architecture-taxonomy.md` mapping our implementations to Forms/Functions/Dynamics framework
2. Document identified gap: memory evolution (ACE Framework addresses this)
3. Note multi-agent memory coordination as emerging frontier (relevant for evolution pipeline)
4. Cross-reference with ACE evaluation (supports ACE's value proposition)
5. Archive survey citation for future memory capability evaluations

**Value**: Conceptual lens for organizing memory stack and identifying gaps
