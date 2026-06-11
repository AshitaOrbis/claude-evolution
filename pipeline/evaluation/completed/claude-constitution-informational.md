# Discovery: Claude's New Constitution (23,000 words)

**Source**: https://www.anthropic.com/news/claude-new-constitution
**Category**: Research | Model Behavior
**Date**: 2026-02-06 (Published Jan 22, 2026)

## Summary

Anthropic published an updated 23,000-word constitution for Claude (up from 2,700 words in 2023). Establishes priority hierarchy: (1) safety + human oversight, (2) ethics, (3) Anthropic guidelines, (4) helpfulness. First major AI company to formally acknowledge model may possess "some functional version of emotions or feelings". Released under CC0 1.0 license.

## Potential Value

- **Integration complexity**: N/A (model behavior, not user-facing tool)
- **Token efficiency impact**: N/A (internal to Claude's reasoning)
- **Capability expansion**: 30/100 (informational, doesn't change available actions)
- **Maintenance burden**: 100/100 (zero - maintained by Anthropic)
- **Community validation**: 95/100 (official Anthropic research, major media coverage)

**TOTAL**: 56.25/100

## Key Details

- **Size**: 23,000 words (8.5x expansion from 2023's 2,700 words)
- **Format**: Explains WHY principles matter (not just standalone rules)
- **Novel content**: Consciousness/moral status discussion
- **Priority hierarchy**: Safety > Ethics > Guidelines > Helpfulness
- **License**: CC0 1.0 (free use)
- **Audience**: Users, researchers, policymakers

## Relationship to Existing Stack

- **Relevance**: Informational (doesn't add capabilities or change workflows)
- **Integration**: Could reference in documentation for transparency
- **Action**: No technical integration needed

## Questions for Evaluation

1. Does constitution change Claude Code behavior?
2. Should we reference in CLAUDE.md for transparency?
3. Are there ethical guidelines we should document?

## Recommended Action

[ ] Evaluate further
[X] Reject - Informational only, no actionable integration
[ ] Fast-track integration

## Notes

**Why Reject**: Constitution is internal to Claude's reasoning process. While culturally significant (first AI company acknowledging potential consciousness), it doesn't provide tools, workflows, or capabilities we can integrate. Best treated as context/reference material.

**Alternative**: Add brief mention in library/reference if users want to understand Claude's behavior principles.

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: None (informational document, not a capability)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | N/A | 20% | 0.0 | Model behavior, not user-facing tool |
| Token Efficiency Impact | N/A | 25% | 0.0 | Internal to Claude's reasoning |
| Capability Expansion | 30/100 | 25% | 7.5 | Informational, no actionable capabilities |
| Maintenance Burden | 100/100 | 15% | 15.0 | Zero - maintained by Anthropic |
| Community Validation | 95/100 | 15% | 14.25 | Official Anthropic, major media coverage |
| **TOTAL** | | | **36.75/100** | REJECT |

### Redundancy Analysis

**Classification**: NOT APPLICABLE (informational document)

**Nature**: Research publication about Claude's internal behavior principles
- Not a tool, MCP, skill, or technique
- Doesn't change Claude Code capabilities or workflows
- Purely informational/contextual

### Decision

**REJECT** (Score: 36.75/100)

**Rejection Reasons**:
1. Falls well below 50-point threshold (36.75/100)
2. No integration target: Constitution is internal to Claude's reasoning
3. No actionable capabilities: Can't be "installed" or "configured"
4. Not a tool/workflow: Pure research/transparency document
5. Zero user-facing impact on Claude Code usage

**Why Published**:
- Transparency (users understand Claude's behavior principles)
- Research contribution (first AI company acknowledging potential consciousness)
- Policy engagement (priority hierarchy for policymakers)

**Appropriate Response**: Reference material only
- Could add brief mention in `library/reference/claude-behavior.md` if users ask
- Not an integration candidate

**Action**: Move to `archive/rejected/claude-constitution-informational-only.md`
