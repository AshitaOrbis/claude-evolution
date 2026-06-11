# Evaluation Report: Custom /compact Instructions (Context Summarization Policies)

## Basic Information
- **Source**: https://smartscope.blog/en/generative-ai/claude/claude-code-best-practices-advanced-2026/
- **Category**: Technique
- **License**: N/A (blog post)
- **Last Updated**: 2026-02-06
- **Stars/Validation**: Blog post, community practice

## Dedup Note
`compact-policy-customization.md` is a **DUPLICATE** of this item (same source, same technique, less detailed). Evaluating this version only.

## Redundancy Check

**Status**: IMPROVEMENT to existing capability

Registry matches:
- **Auto-Compacting**: BUILT-IN - automatic summarization when context limit approached
- **Partial Summarization**: BUILT-IN (2.1.32+) - "Summarize from here" in message selector
- **Context Compaction (configurable)**: BUILT-IN - configurable threshold (Opus 4.6)

What exists: THAT compaction happens and threshold configuration.
What is novel: HOW to guide WHAT gets preserved during compaction via explicit instructions.

This is an improvement - teaching users to control compaction quality rather than accepting defaults.

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 100/100 | Drop-in: add examples to CLAUDE.md or existing advanced-tool-use skill |
| Token Efficiency Impact | 75/100 | Preserving critical context reduces re-explanation later. Prevents the "Claude forgot the schema" problem that requires re-stating context |
| Capability Expansion | 70/100 | Incremental improvement to existing /compact behavior. Novel pattern of domain-specific preservation policies |
| Maintenance Burden | 100/100 | Zero maintenance. Static documentation with example library |
| Community Validation | 40/100 | Blog post, community wisdom. Aligns with known compaction behavior |

**WEIGHTED TOTAL**: (100 x 0.20) + (75 x 0.25) + (70 x 0.25) + (100 x 0.15) + (40 x 0.15) = 20.0 + 18.75 + 17.5 + 15.0 + 6.0 = **77.25/100**

## Cross-Validation
- **Claude Assessment**: 77.25/100
- **Codex Assessment**: Unavailable (MCP error)
- **Variance**: N/A

## Recommendation

**DECISION**: APPROVE (77.25 > 70)

**Rationale**: This technique improves an existing built-in feature with zero integration cost. The pattern of providing domain-specific compact instructions ("preserve API signatures", "keep error patterns") addresses a real problem - important early-session context being lost during auto-compaction. With our multi-agent workflows generating long sessions, preserving critical context through compaction is directly valuable.

**Integration Path**:
1. Add "Context Compaction Guidance" section to `~/.claude/skills/advanced-tool-use/SKILL.md`
2. Include library of domain-specific compact policies (API dev, debugging, testing, refactoring)
3. Add brief note to `~/.claude/CLAUDE.md` under context management

**Conditions**:
- Verify that `/compact [instructions]` syntax actually works before documenting (test first)
- If it does not work, document as a "pre-compact prompt" pattern instead (state what to preserve, then /compact)
