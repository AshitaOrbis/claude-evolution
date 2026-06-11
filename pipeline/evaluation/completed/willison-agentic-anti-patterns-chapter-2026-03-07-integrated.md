# Discovery: Agentic Engineering Patterns — Anti-Patterns Chapter (New)

- **Source**: https://simonwillison.net/guides/agentic-engineering-patterns/
- **Date Found**: 2026-03-07
- **Category**: technique
- **Summary**: Simon Willison added a new "anti-patterns" chapter to his living Agentic Engineering Patterns guide. Currently documents at least one key anti-pattern: "Inflicting unreviewed code on collaborators" (dumping large PRs without testing/review). A new annotated prompts section was also added with worked examples.
- **Potential Value**: Medium
- **Integration Complexity**: Easy

## Redundancy Check

**Existing Capability**: Agentic Engineering Patterns (Simon Willison) — **IMPLEMENTED**
- Registry entry: `library/techniques/agentic-engineering-patterns.md`
- Integrated: 2026-02-24
- Existing redundancy triggers: "agentic engineering patterns", "writing code is cheap", "Simon Willison patterns guide", "prompt as architecture", "validate before trust", "Willison agentic guide", "linear walkthrough", "codebase walkthrough"

**Classification**: IMPROVEMENT — New chapter in an existing living document already integrated.

**Gap**: Current registry entry and library file do NOT include anti-patterns content. "anti-pattern", "unreviewed code", "annotated prompts" are not in existing redundancy triggers.

## New Content Details

### Anti-Patterns Chapter
- First documented anti-pattern: **"Inflicting unreviewed code on collaborators"**
  - Dumping a 1000-line PR without verifying it works first
  - Ties to existing principle: validate before trust (but from the review/submission angle)
  - Complements the 80/20 coding philosophy already in system

### Annotated Prompts Section
- First example: Prompt used for building a web UI for GIF compression using WebAssembly (Gifsicle)
- Shows exact prompt structure + Claude Code workflow for web builds

## Comparison to Existing Capability

| Aspect | Current (Integrated) | New Addition |
|--------|---------------------|--------------|
| Focus | What to DO in agentic work | What NOT to do |
| Content | 5 patterns (writing code is cheap, prompt as architecture, etc.) | Anti-patterns + annotated real prompts |
| Integration target | `library/techniques/agentic-engineering-patterns.md` | Same file (extend) |
| Integration effort | N/A (done) | Low — append new section |

## Integration Target

Update `library/techniques/agentic-engineering-patterns.md` with:
1. New "Anti-Patterns" section covering "Inflicting unreviewed code on collaborators"
2. New "Annotated Prompts" section with first example
3. Update redundancy triggers in registry: "anti-pattern", "unreviewed code", "inflicting code", "annotated prompt example", "reviewed before PR"

## Notes

This follows the **living-document-updates-pattern** playbook — the guide is continuously updated and we should track new chapters as IMPROVEMENT discoveries.
