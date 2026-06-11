# Evaluation: Agentic Engineering Patterns Guide (Simon Willison)

- **Date**: 2026-02-24
- **Source**: https://simonwillison.net/2026/Feb/23/agentic-engineering-patterns/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Doc-only integration — add reference to library/techniques/ and link from CLAUDE.md. Zero architecture changes required. |
| Token efficiency impact | 25% | 50 | Neutral baseline; patterns like "writing code is cheap" change developer intuitions indirectly but don't reduce token usage. |
| Capability expansion | 25% | 70 | Incremental — Design Patterns format provides structured reference for patterns we partially document elsewhere (80/20 ratio, TDD). New framing adds pedagogical value beyond what's scattered in CLAUDE.md. |
| Maintenance burden | 15% | 80 | External living guide maintained by Simon Willison; local maintenance only requires periodic check for new chapters. |
| Community validation | 15% | 90 | Simon Willison is extremely high-signal (Django co-creator, datasette author, 1M+ followers, consistent accurate early-mover AI coverage). |

- **Claude Score**: 73.5/100
- **Codex Score**: 81.5/100
- **Final Score**: 77.5/100

## Decision

APPROVED — Living guide from high-credibility author provides Design Patterns-style structure for agentic coding patterns; complements and organizes existing scattered directives.

## Integration Notes

- **Type**: Technique documentation (reference library entry)
- **Target**: `library/techniques/agentic-engineering-patterns.md` + link in CLAUDE.md under relevant section
- **Approach**: Reference the live guide (link only); extract key patterns as local summaries
- **Monitor**: Set 90-day re-check trigger — living guide will grow (new chapters published periodically)
- **No replacement**: Complements existing AI Coding Philosophy (80/20 ratio) and TDD skill; does not replace
- **Redundancy trigger to add**: "agentic engineering patterns", "writing code is cheap", "Simon Willison patterns guide"
