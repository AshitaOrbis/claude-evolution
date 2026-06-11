# Evaluation: Linear Walkthroughs - New Chapter in Agentic Engineering Patterns

- **Date**: 2026-03-03
- **Source**: https://simonwillison.net/guides/agentic-engineering-patterns/linear-walkthroughs/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Redundancy Check

**Result**: IMPROVEMENT — extends existing integrated capability.
- Existing: `library/techniques/agentic-engineering-patterns.md` covers the original Feb 23, 2026 guide (5 patterns: writing code is cheap, prompt as architecture, iterative refinement, validate before trust, human in loop)
- This: Linear Walkthroughs added Feb 25, 2026 — a distinct 6th pattern for codebase comprehension, not in existing integration

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Drop-in update to existing library file; no new skill/MCP/agent needed |
| Token efficiency impact | 25% | 50 | Neutral — technique documentation doesn't directly affect token usage |
| Capability expansion | 25% | 70 | Distinct new technique (codebase comprehension prompt) not covered in original integration; incremental but adds real value for onboarding and post-vibe-code sessions |
| Maintenance burden | 15% | 100 | Pure doc update to existing file; zero ongoing maintenance |
| Community validation | 15% | 100 | Simon Willison (Django co-creator, 1M+ followers) — highly trusted, high-signal AI practitioner |

- **Claude Score**: 80/100
- **Codex Score**: N/A (unavailable — exit code 1)
- **Final Score**: 80/100

## Decision

**APPROVED** — Novel technique from trusted source, trivial integration effort, extends an already-high-value library entry.

## Integration Notes

**Type**: Technique extension (update existing library entry)
**Target**: `library/techniques/agentic-engineering-patterns.md`

Integration steps:
1. Add "Linear Walkthroughs" section to the existing library file
2. Include: prompt template ("Provide a linear walkthrough of the code that explains how it all works in detail"), use cases (post-vibe-code comprehension, onboarding, codebase audits), Willison's example (SwiftUI app)
3. Update registry `existing-capabilities.md` — add "linear walkthrough", "codebase walkthrough" to redundancy triggers for this entry; update re-check date

**No new skill file needed** — this is a prompt pattern, not a tool integration. Documenting in the library is sufficient. Could optionally add a one-liner to the helpers index for discoverability.
