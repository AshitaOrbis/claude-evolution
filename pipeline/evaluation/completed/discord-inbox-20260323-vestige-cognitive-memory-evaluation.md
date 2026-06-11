# Vestige: Cognitive Memory for AI Agents — Evaluation

**Item**: discord-inbox-20260323-vestige-cognitive-memory.md
**Evaluated**: 2026-03-24
**Decision**: NEEDS_RESEARCH

## Scores

| Criterion | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Integration complexity | 20% | 65 | 13.0 |
| Token efficiency impact | 25% | 65 | 16.25 |
| Capability expansion | 25% | 80 | 20.0 |
| Maintenance burden | 15% | 65 | 9.75 |
| Community validation | 15% | 55 | 8.25 |
| **TOTAL** | | | **67.25** |

## Reasoning

Vestige is technically impressive — single Rust binary (~22MB), local-only (no cloud dependency), 1,238 tests, 29 cognitive modules, 21 MCP tools. The **genuine differentiators** vs existing memory infrastructure are: prediction error gating (stores only surprising/novel info), FSRS-6 spaced repetition (manages memory decay), 7-stage cognitive search with graph-based spreading activation, and memory consolidation via "dreaming" (replay + synthesis). These are not replicated by the Official Memory System (BUILT-IN since v2.1.32) or the file-based auto-memory directory.

**Why not approved outright**: The Official Memory System explicitly supersedes community memory MCPs in the registry ("zero-token-overhead system that replaces the need for community memory MCPs"). Vestige's case for exception rests on its cognitive sophistication (prediction error gating, FSRS) rather than basic persistence. Community validation score is 55 because no star count was provided — a codebase with 79,600 lines and 1,238 tests suggests serious engineering, but adoption signals are unknown.

**The decisive research question**: Does Vestige's intelligent filtering (prediction error gating) reduce the noise in long-running agent contexts meaningfully vs the file-based auto-memory? If the official system stores "everything" and Vestige stores "only what's novel," Vestige adds unique value for high-volume cron/heartbeat automation.

## Research Questions

1. GitHub star count — proxy for community adoption
2. Does Vestige conflict with or complement the Official Memory System? (Can both run simultaneously, or must one replace the other?)
3. Is the Nomic Embed v1.5 model included in the binary, or does it require a separate download?
4. What's the latency of the 7-stage cognitive search on typical agent contexts?

## Promote to APPROVED if

Stars >= 200 AND cognitive search latency < 1s AND confirmed compatibility with Official Memory System running in parallel.

## Reject if

Requires replacing Official Memory System OR no active maintenance (last commit > 6 months old).
