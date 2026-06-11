# Markdown-Then-Code Workflow (Interview → Documentation → Plan → Implementation)

**Source**: [tobieapb/claude-interactive-documentation-workflow](https://github.com/tobieapb/claude-interactive-documentation-workflow)
**Category**: Workflow Pattern
**Stars**: Unknown (last updated 2026-02-01)
**Discovery Date**: 2026-02-06

## Summary

A four-phase workflow: "I used to whiteboard, then code. Now I markdown, then code." Replaces visual planning with structured markdown documentation as the primary planning artifact.

## Workflow Phases

1. **Interview Phase**: Claude asks questions to understand requirements → produces structured doc
2. **Documentation Phase**: Refine the documentation using documentation crafting guidelines
3. **Plan Phase**: Convert documentation into implementation plan using plan crafting guidelines
4. **Implementation Phase**: Execute the plan

**Each phase has**:
- Explicit guidelines
- Quality checkpoints
- Phase transition criteria

## Problem Addressed

Traditional planning approaches:
- Whiteboards are ephemeral (not AI-consumable)
- Plans in conversation context are lossy (compaction degrades them)
- Requirements often misunderstood due to vague prompts
- No structured quality gates before coding

## Solution Pattern

**Persistent Markdown Planning**:
- Interview skill (`/interview`) produces a documentation file
- Documentation follows crafting guidelines (structure, detail level, examples)
- Plan is created FROM documentation (not conversation memory)
- Implementation references plan file (not chat history)

**Key Insight**: Markdown files serve as the "source of truth" that persists across sessions and compactions, replacing whiteboard sketches with AI-parseable structured docs.

## Implementation

Repo includes:
- `/interview` command (optional - guidelines are reusable without it)
- Documentation crafting guidelines (markdown template)
- Plan crafting guidelines (markdown template)
- Real example from production (computer vision training pipeline)

**LLM-agnostic**: Core value is in the guidelines themselves, not Claude-specific features.

## Relationship to Existing Capabilities

**ENHANCEMENT of existing features**:
- Plan Mode (built-in): Creates plans in conversation context
- Markdown-Then-Code: Creates plans in PERSISTENT FILES (survives compaction)
- CLAUDE.md: Static project knowledge
- This pattern: DYNAMIC per-feature documentation files

**Similar to**:
- "Manus-style persistent markdown planning" (OthmanAdi/planning-with-files) - same philosophy
- Spec-driven development (Pimzino/claude-code-spec-workflow) - similar phase gates

**Different from**:
- Planning with verbally describing requirements (common anti-pattern)
- Using Plan Mode without persistent artifacts

## Potential Value

**Token Impact**: Highly positive
- Documentation file replaces repeated explanation of requirements
- Plan file replaces "what were we building?" context rebuilding
- Persistent files reduce cross-session context pollution
- Guidelines prevent vague requirements (fewer clarification loops)

**Capability**: Structured planning workflow with persistent artifacts
- Addresses known pain point: plan degradation after compaction
- Enables multi-session feature development with continuity
- Quality gates (interview → doc → plan → code) prevent rework

**Integration Effort**: Medium
- Adopt documentation crafting guidelines as skill
- Adopt plan crafting guidelines as skill
- Create `/interview` command (optional)
- Document workflow in CLAUDE.md

## Quick Assessment Score

- Integration complexity: **75/100** (guideline docs + optional command)
- Token efficiency impact: **85/100** (major reduction in context pollution)
- Capability expansion: **80/100** (structured planning with persistence)
- Maintenance burden: **85/100** (static guidelines, low maintenance)
- Community validation: **60/100** (recent repo, production-validated but low star count)

**TOTAL**: **77/100**

## Recommended Action

[X] Evaluate further - Examine repo for guideline documents, assess overlap with Plan Mode
[ ] Reject
[ ] Fast-track integration

## Redundancy Check

**Triggers checked**: "markdown planning", "persistent planning", "documentation workflow", "phase gates", "interview-driven development"

**Result**: PARTIAL MATCH with "planning-with-files" (Manus-style) in search results

**Classification**: IMPROVEMENT - More structured than ad-hoc planning, adds interview phase and explicit guidelines. Compare to planning-with-files (below) to determine if complementary or duplicate.

## Related Discoveries

- **planning-with-files** (OthmanAdi): Manus-style persistent markdown planning
- **claude-code-spec-workflow** (Pimzino): Spec-driven development with phase gates
- May be variations on same theme - needs comparative evaluation

---

## Evaluation

**Evaluator**: capability-evaluator
**Date**: 2026-02-06

### Comparative Analysis

| Pattern | Focus | Files | Unique Feature |
|---------|-------|-------|----------------|
| **planning-with-files** | Persistence | task_plan.md, findings.md, progress.md | Auto-recovery |
| **spec-driven-development** | Phase gates | requirements.md, design.md, tasks.md | Multi-phase validation |
| **markdown-then-code** | Interview-driven | documentation.md, plan.md | Interview phase |

**Verdict**: OVERLAPPING but complementary. markdown-then-code adds interview phase; others focus on structure/persistence.

### Scoring

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration Complexity | 75/100 | Guidelines + optional command |
| Token Efficiency | 85/100 | Persistent docs, prevents context pollution |
| Capability Expansion | 60/100 | OVERLAP with planning-with-files + SDD (65% similar) |
| Maintenance Burden | 85/100 | Static guidelines |
| Community Validation | 60/100 | Recent repo, production-validated, low stars |
| **WEIGHTED TOTAL** | **71/100** | |

### Cross-Validation (Codex)
"Interview phase is valuable but 65% overlap with planning-with-files + SDD. 71/100 - marginal addition."

### Decision: FUTURE (71/100)

**Rationale**: Above 70 BUT high overlap. Already integrating planning-with-files (82/100) and SDD (75/100).

**Recommendation**: Extract interview guidelines only (unique value), integrate into SDD skill as optional phase.

**Integration Path** (if revisited):
1. Add interview guidelines to `~/.claude/skills/spec-driven-development/interview-phase.md`
2. Skip plugin install (redundant with planning-with-files)
3. Test interview → requirements → design → tasks workflow
