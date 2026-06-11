# 80/20 AI Coding Ratio Pattern

**Source**: [rohitg00/pro-workflow](https://github.com/rohitg00/pro-workflow)
**Category**: Workflow Philosophy
**Stars**: Unknown (2026-02-06)
**Discovery Date**: 2026-02-06

## Summary

A workflow optimization philosophy: "80% of my code is written by AI, 20% is spent reviewing and correcting it." This represents a mental model shift from "AI as assistant" to "AI as primary developer with human oversight."

## Problem Addressed

Many developers use AI as a code suggestion tool, treating it like autocomplete. This leads to:
- Constantly interrupted flow (review every line)
- Low trust in AI output (over-verification)
- Underutilization of AI capabilities (micro-edits instead of macro-generation)
- Token waste from excessive back-and-forth

## Solution Pattern

**80/20 Philosophy**:
1. **80% Generation**: Let AI write large blocks of code autonomously
2. **20% Review**: Focus human effort on strategic review and correction
3. **Batch workflow**: Generate → Review → Correct (not line-by-line validation)
4. **Trust calibration**: Build confidence in AI output quality through repeated validation

**Key Insight**: Optimize for throughput (code generation speed) rather than perfection per line. Correction is cheaper than generation.

## Implementation

The `pro-workflow` skill is "optimized for that ratio" per the repo description. Likely includes:
- Prompting strategies for large-scale generation
- Review checklists focused on critical paths
- Confidence calibration (know when to trust, when to verify)
- Batch correction patterns

## Relationship to Existing Capabilities

**PHILOSOPHY vs PATTERN**:
- This is a mental model, not a tool
- Existing capabilities (Plan Mode, subagents, batch-orchestrator) enable the pattern
- But the 80/20 framing itself is novel guidance

**Different from**:
- Plan Mode: Focuses on approval of PLANS, not review of CODE
- Code-reviewer subagent: Focuses on quality, not throughput optimization
- Existing workflows assume more human involvement in generation phase

## Potential Value

**Token Impact**: Positive
- Reduces micro-management prompts ("change line 5", "now fix line 8")
- Encourages autonomous generation (fewer interruptions)
- Batch corrections more token-efficient than incremental edits

**Capability**: Workflow optimization philosophy
- Changes HOW you interact with Claude Code
- Not a feature to integrate, but a mindset to document
- Could inform prompting guidelines in CLAUDE.md

**Integration Effort**: Easy
- Document philosophy in CLAUDE.md or skill file
- Add prompting examples that embody 80/20 approach
- No code, no tools, just guidance

## Quick Assessment Score

- Integration complexity: **95/100** (documentation only)
- Token efficiency impact: **75/100** (indirect but significant)
- Capability expansion: **65/100** (philosophy not feature)
- Maintenance burden: **100/100** (static guidance)
- Community validation: **50/100** (part of larger repo, no standalone validation)

**TOTAL**: **77/100**

## Recommended Action

[X] Evaluate further - Document as workflow philosophy in CLAUDE.md or create dedicated skill
[ ] Reject
[ ] Fast-track integration

## Redundancy Check

**Triggers checked**: "code generation ratio", "AI coding philosophy", "autonomous generation", "batch review"

**Result**: NO MATCH in existing-capabilities.md

**Classification**: NOVEL - Philosophy/mindset guidance not explicitly documented in existing stack. Complements technical patterns with human workflow optimization.

## Notes

- Could be integrated as a skill: `~/.claude/skills/80-20-coding-philosophy/SKILL.md`
- Include prompting examples: "Write the entire feature implementation" vs "Help me write line 5"
- Confidence calibration guide: When to trust AI output vs when to verify deeply
- May want to cross-reference with Addy Osmani's workflow (source below)

---

## Evaluation

**Date**: 2026-02-06

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 95/100 | 20% | 19.0 | Documentation only, no code |
| Token Efficiency | 75/100 | 25% | 18.75 | Reduces micro-prompts, encourages batching |
| Capability Expansion | 65/100 | 25% | 16.25 | Philosophy not feature, but valuable mindset |
| Maintenance Burden | 100/100 | 15% | 15.0 | Static guidance, zero maintenance |
| Community Validation | 50/100 | 15% | 7.5 | Part of larger repo, no standalone validation |
| **TOTAL** | | | **76.5** | **APPROVE** |

### Decision: APPROVE

**Reason**: High-value workflow philosophy with low integration cost. Complements technical patterns with human workflow optimization.

**Integration path**: Create `~/.claude/skills/80-20-coding-ratio/SKILL.md` with prompting examples and confidence calibration guide.
