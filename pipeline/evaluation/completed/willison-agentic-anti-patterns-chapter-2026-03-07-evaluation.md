# Evaluation: Agentic Engineering Patterns — Anti-Patterns Chapter (New)

- **Date**: 2026-03-07
- **Source**: https://simonwillison.net/guides/agentic-engineering-patterns/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Redundancy Check

**Existing capability**: Agentic Engineering Patterns (Simon Willison) — IMPLEMENTED (2026-02-24, updated 2026-03-03)
**Location**: `library/techniques/agentic-engineering-patterns.md`
**Classification**: IMPROVEMENT — new chapter in existing living document.

Current registry entry covers 5 patterns + Linear Walkthroughs chapter. Anti-patterns and Annotated Prompts sections are NOT present in existing integration.

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Append to existing library file + add registry triggers — zero new config |
| Token efficiency impact | 25% | 50 | Neutral: knowledge/technique document, not token-saving infrastructure |
| Capability expansion | 25% | 70 | Incremental: extends existing guide with anti-patterns (what NOT to do) + annotated prompt examples; same source, additive content |
| Maintenance burden | 15% | 100 | No new infrastructure; update existing file, same 90-day re-check schedule |
| Community validation | 15% | 100 | Same Willison guide (1M+ followers, Django co-creator); already scored 100 in original evaluation |

- **Claude Score**: 80/100
- **Codex Score**: N/A (skipped — improvement-to-existing-asset, score range unambiguous)
- **Final Score**: 80/100

## Decision

APPROVED — Clear incremental improvement to an already-integrated high-value resource. Low effort, zero maintenance cost.

## Integration Notes

**Type**: Technique library update (extend existing file, update registry triggers)

**Files to update**:
1. `library/techniques/agentic-engineering-patterns.md` — append:
   - "Anti-Patterns" section: "Inflicting unreviewed code on collaborators" (1000-line PRs without verifying they work first; ties to validate-before-trust principle from review/submission angle)
   - "Annotated Prompts" section: first example — web UI for GIF compression using WebAssembly (Gifsicle); shows exact prompt structure + Claude Code workflow
2. `registry/existing-capabilities.md` — add redundancy triggers: "anti-pattern", "unreviewed code", "inflicting code", "annotated prompt example", "reviewed before PR", "dump PR", "large PR without testing"

**Relationship to existing system**: Anti-pattern "inflicting unreviewed code" directly complements 80/20 coding philosophy (review phase) and spec-driven-dev skill. Reinforces validate-before-trust from a PR/collaboration angle.
