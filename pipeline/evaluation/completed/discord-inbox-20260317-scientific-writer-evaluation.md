# Claude Scientific Writer Tool

- **Date**: 2026-03-17
- **Source**: Discord #general inbox
- **URL**: https://github.com/K-Dense-AI/claude-scientific-writer
- **Category**: Claude Code plugin / scientific writing
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1483526662514675812
- **Evaluated**: 2026-03-18

## What It Is

A Claude Code plugin from K-Dense-AI for academic/scientific writing. Features real-time research lookup via Perplexity Sonar Pro, intelligent paper detection, document conversion, and AI-powered diagram generation. Part of a broader K-Dense scientific skills ecosystem (~70 scientific skills, ~1.6k stars across org).

## Relevance to Workspace

The evolution pipeline focuses on Claude Code capability improvement (code review, discovery, integration) — not scientific writing. The blog (Ashita Orbis) involves tech writing, but the existing write-post skill covers that use case. A Perplexity API dependency adds external cost overhead. No current project specifically requires academic/scientific writing workflows.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 70 | Claude Code plugin — installable, but requires Perplexity Sonar Pro API |
| Token efficiency | 40 | Perplexity API calls add cost; does not reduce Claude token usage |
| Capability expansion | 25 | Not relevant to primary use cases (evolution pipeline, blog writing already covered) |
| Maintenance burden | 60 | External K-Dense ecosystem dependency; moderate maintenance |
| Community validation | 70 | ~1.6k stars in K-Dense org (100-1k range) |

**Weighted Score**: (70×0.20) + (40×0.25) + (25×0.25) + (60×0.15) + (70×0.15) = 14 + 10 + 6.25 + 9 + 10.5 = **49.75/100**

## Decision

**REJECTED** (49.75)

## Reasoning

Low capability expansion for actual use cases. Scientific writing is not a current workflow need. External Perplexity API dependency adds cost without reducing Claude token usage. The existing write-post skill covers tech blog writing. Re-evaluate if a scientific paper or academic research project becomes active in the workspace.
