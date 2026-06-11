# Second Brain Skills Framework — Evaluation (REJECTED)

**Evaluated**: 2026-04-12
**Source**: https://github.com/coleam00/second-brain-skills (Discord inbox)
**Decision**: REJECTED -> archive/
**Cross-validated**: Codex (GPT-5.4) via repo clone and inspection

## Summary

Open-source framework for creating "skills" (conversational prompt templates + memory patterns) for personal knowledge management. Contains 8 skills: note-taking, summarization, brainstorming, context-linking, reflection, synthesis, knowledge graphs, memory retrieval.

## Scoring

| Criterion | Weight | Claude | Codex | Final |
|-----------|--------|--------|-------|-------|
| Integration complexity | 20% | 70 | 30 | 50 |
| Token efficiency impact | 25% | 50 | 40 | 45 |
| Capability expansion | 25% | 70 | 35 | 53 |
| Maintenance burden | 15% | 70 | 50 | 60 |
| Community validation | 15% | 70 | 25 | 48 |

**Claude total**: 65.0 | **Codex total**: 36.0 | **Final (avg)**: 50.5

## Key Research Findings (from Codex repo inspection)

1. **Repo exists**: Confirmed, but only **4 stars**, last updated **2024-10** (~18 months stale)
2. **Format mismatch**: Generic conversational prompt templates, NOT Claude Code SKILL.md compatible
3. **Duplicate patterns**: Our context-librarian + MEMORY.md + library/ already implements these approaches
4. **No novel architecture**: Knowledge synthesis, context linking, and reflection are already covered
5. **Solo contributor**: Minimal community adoption

## Rejection Rationale

- Framework mismatch (conversational scaffolding vs file-based SKILL.md)
- 18 months stale with minimal adoption (4 stars)
- All proposed patterns already exist in our knowledge management stack
- Would require significant refactoring for zero novel capability

**Score below 50 threshold**: REJECT
