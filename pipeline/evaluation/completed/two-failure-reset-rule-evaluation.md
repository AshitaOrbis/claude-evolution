# Evaluation Report: Two-Failure Reset Rule

## Basic Information
- **Source**: https://smartscope.blog/en/generative-ai/claude/claude-code-best-practices-advanced-2026/
- **Category**: Technique
- **License**: N/A (blog post / community pattern)
- **Last Updated**: 2026-02-06
- **Stars/Validation**: Blog post, community best practice

## Redundancy Check

**Status**: NOVEL

Registry matches checked:
- "context management" - Context Isolation via subagents exists, but no failure-recovery pattern
- "session-end verification" - Post-implementation testing, not mid-session failure recovery
- "self-healing pipeline" - For Bash scripts only, automated test-fix loop
- "auto-compacting" - Context overflow management, not failure recovery

No existing capability addresses the specific pattern of detecting repeated failures and resetting context to break reasoning loops. This fills a gap between "auto-compacting" (context size) and "session-end verification" (post-implementation).

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 100/100 | Drop-in: add 3-5 lines to CLAUDE.md as behavioral guidance |
| Token Efficiency Impact | 85/100 | Directly prevents token waste from poisoned reasoning chains. Two failed iterations wasting 10-20k tokens each = 20-40k saved per occurrence |
| Capability Expansion | 80/100 | Significant - addresses a real failure mode (context poisoning) not covered by any existing pattern |
| Maintenance Burden | 100/100 | Zero maintenance. Static behavioral guideline. |
| Community Validation | 40/100 | Blog post, community wisdom. No empirical data, but aligns with known LLM behavior patterns |

**WEIGHTED TOTAL**: (100 x 0.20) + (85 x 0.25) + (80 x 0.25) + (100 x 0.15) + (40 x 0.15) = 20.0 + 21.25 + 20.0 + 15.0 + 6.0 = **82.25/100**

## Cross-Validation
- **Claude Assessment**: 82.25/100
- **Codex Assessment**: Unavailable (MCP error)
- **Variance**: N/A

## Recommendation

**DECISION**: APPROVE (82.25 > 70)

**Rationale**: This technique addresses a real, observed failure mode in LLM sessions - context poisoning from repeated failed attempts. It is zero-cost to integrate (CLAUDE.md addition), saves significant tokens when triggered, and fills a genuine gap in our failure recovery patterns. The "two-failure" threshold is a reasonable heuristic that avoids premature resets while catching genuine context poisoning.

**Integration Path**:
1. Add to `~/.claude/CLAUDE.md` under a "## Failure Recovery" section
2. Document in `~/.claude/skills/advanced-tool-use/SKILL.md` as a context management pattern
3. Optionally: create a Stop hook that tracks consecutive failure count (future enhancement)

**Conditions**:
- Start with documentation-only integration (CLAUDE.md guidance)
- Hook automation is optional and should be evaluated separately if needed
