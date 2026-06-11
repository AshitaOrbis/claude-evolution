# Discovery: Clean-Room Rewrite Technique (Willison, March 2026)

- **Source**: https://simonwillison.net/2026/Mar/5/chardet/
- **Date Found**: 2026-03-12
- **Category**: technique
- **Summary**: Simon Willison demonstrates a staged, testing-first workflow for rewriting open-source libraries via "clean-room" reimplementation using Claude Code. The approach avoids license contamination by writing tests against the original library first, then implementing from scratch against those tests — with Claude Code generating the full implementation. Produces planning artifacts showing phased discovery → test scaffolding → implementation approach.
- **Potential Value**: Medium
- **Integration Complexity**: Easy

## What Makes This Novel

The existing "Agentic Engineering Patterns" entry (IMPLEMENTED) covers Willison's general guide (Feb 2026). This March 2026 case study adds a *specific, replicable workflow*:

1. **Clean-room rationale**: Use reimplementation to shed restrictive licenses while preserving behavior
2. **Test-first scaffolding**: Generate comprehensive test suite against the *original* library before touching implementation
3. **Staged Claude Code workflow**: Planning doc → test generation → implementation pass → validation
4. **Artifact documentation**: Planning artifacts as living documents guiding the agent session

**Key distinction from existing registry entry**: The Feb 2026 guide covers general patterns (cheap code, validate before trust, etc.). This March 2026 post is a *worked example* with concrete multi-phase workflow — extractable as a reusable playbook.

## Redundancy Check

- **Agentic Engineering Patterns** (`library/techniques/agentic-engineering-patterns.md`): IMPROVEMENT — the clean-room rewrite is a specific workflow not covered by the general patterns guide
- **Spec-Driven Development** skill: COMPLEMENTARY — spec-driven dev covers feature implementation phases; clean-room covers full library reimplementation from behavioral tests
- **Manus-style planning**: COMPLEMENTARY — planning-with-files covers persistent plans; this adds test-first scaffolding and clean-room rationale

**Classification**: IMPROVEMENT over Willison patterns — adds specific reusable workflow
