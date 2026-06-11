# Evaluation: Claude Code Skills 2.0 — Built-in Evals and A/B Testing

- **Date**: 2026-03-06
- **Source**: https://www.geeky-gadgets.com/anthropic-skill-creator/ | https://tessl.io/blog/anthropic-brings-evals-to-skill-creator-heres-why-thats-a-big-deal/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 70 | Medium: eval framework is workflow-level (skill files + scripts), not a new core language feature. Need to author test cases and integrate comparator agent pattern into existing skills. |
| Token efficiency impact | 25% | 50 | Neutral: eval/A-B runs add tokens upfront but prevent regressions from obsolete skills. Net neutral. |
| Capability expansion | 25% | 85 | Significant-to-novel: adds regression testing + blind comparison workflow for skill development. We have 40+ skills with no validation infrastructure. |
| Maintenance burden | 15% | 70 | Occasional: benchmark sets need updates as skills and underlying models evolve. |
| Community validation | 15% | 100 | Official Anthropic — confirmed via Anthropic Engineering blog and official skills GitHub repo (anthropics/skills/skill-creator). Codex cross-validation surfaced official sources not visible in discovery. |

- **Claude Score**: 67.5/100
- **Codex Score**: 73.25/100
- **Final Score**: 70.4/100

## Decision

APPROVED — Codex confirmed official Anthropic provenance (Engineering blog + anthropics/skills repo). Score tips above threshold. Fills genuine gap: skill creation tooling exists but skill validation infrastructure does not.

## Integration Notes

- **Type**: Technique integration — update `skill-creator` skill and document eval workflow
- **Key files**: `~/.claude/skills/skill-creator/SKILL.md` (add eval-aware scaffolding notes); create `library/techniques/skill-evaluation.md`
- **Comparator agent**: Official pattern at `anthropics/skills/skill-creator/agents/comparator.md` — can be adapted for our existing skills
- **Open questions** (resolve during integration):
  1. Does the eval framework require specific SKILL.md frontmatter or is it out-of-band?
  2. Can existing skills (code-reviewer, mgrep-guide) be retrofitted?
  3. What's the token cost of running eval suites — viable in heartbeat automation?
  4. Does this supersede or complement the DSPy prompt-optimizer?
- **Note**: Codex correction — community validation upgraded from 70 to 100 after confirming official Anthropic Engineering posts and GitHub repo
