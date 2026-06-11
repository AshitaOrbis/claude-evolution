# Discovery: Linear Walkthroughs - New Chapter in Agentic Engineering Patterns

- **Source**: https://simonwillison.net/guides/agentic-engineering-patterns/linear-walkthroughs/
- **Date Found**: 2026-03-03
- **Category**: technique
- **Summary**: Simon Willison added a "Linear Walkthroughs" chapter to his Agentic Engineering Patterns guide (published ~Feb 25, 2026). The technique: prompt coding agents to produce "a linear walkthrough of the code that explains how it all works in detail", generating a structured document that explains how a codebase functions sequentially. Particularly valuable after vibe-coded sessions where the developer may not fully understand what was built.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Key Technique

Ask a coding agent:
> "Provide a linear walkthrough of the code that explains how it all works in detail"

The agent produces a document covering: entry points, data flow, module interactions, and how all components fit together. Willison used this against a vibe-coded SwiftUI app and found the resulting walkthrough "genuinely useful."

## Redundancy Check

**Existing capability**: "Agentic Engineering Patterns (Simon Willison)" is **IMPLEMENTED** in `library/techniques/agentic-engineering-patterns.md`

**Classification**: IMPROVEMENT

**Reason**: The existing integration covers the original guide (Feb 23, 2026). Linear Walkthroughs is a new chapter published Feb 25, after the integration. The 90-day re-check window is 2026-05-24, but this is a substantive new technique worth documenting now rather than waiting.

**Differentiation**: The existing integration covers: "writing code is cheap", "prompt as architecture", "iterative refinement", "validate before trust", "human in the loop". Linear Walkthroughs is a distinct technique for codebase comprehension/onboarding, not covered in the original integration.

## Integration Recommendation

Update `library/techniques/agentic-engineering-patterns.md` with the Linear Walkthroughs pattern:
- Add to the patterns section: prompt template, use cases, example output
- Update the "last updated" / re-check date in the registry

Low effort — no new skill file needed, just extend existing library entry.
