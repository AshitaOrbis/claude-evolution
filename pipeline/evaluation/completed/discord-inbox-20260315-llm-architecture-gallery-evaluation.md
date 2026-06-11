# LLM Architecture Gallery — Evaluation

- **Date Evaluated**: 2026-03-16
- **Original Discovery**: discord-inbox-20260315-llm-architecture-gallery.md
- **Source**: https://github.com/rasbt/llm-architecture-gallery
- **Decision**: REJECTED

## What It Is

Sebastian Raschka's curated visual gallery of LLM architectures, hosted at sebastianraschka.com/llm-architecture-gallery. The GitHub repo is a lightweight data backend: YAML metadata for gallery cards and WebP architecture diagrams. **Not an implementation repo** — no training code, no APIs, no model weights. Raschka is a highly respected ML educator (36k+ GitHub followers, author of *Build a Large Language Model From Scratch*). 384 GitHub stars.

## Redundancy Check

NOVEL — No match in registry. But this is a pure reference resource, not an integrable capability.

## Scoring

| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|---------|
| Integration complexity | 0 | 20% | 0.0 |
| Token efficiency impact | 50 | 25% | 12.5 |
| Capability expansion | 10 | 25% | 2.5 |
| Maintenance burden | 100 | 15% | 15.0 |
| Community validation | 50 | 15% | 7.5 |
| **Total** | | | **37.5** |

## Scoring Rationale

- **Integration complexity (0)**: Nothing to integrate — visual diagrams with no API or code surface.
- **Token efficiency (50)**: Neutral.
- **Capability expansion (10)**: No capability expansion for the evolution system. Useful for humans learning about LLM architectures, not for Claude Code workflows.
- **Maintenance burden (100)**: Zero maintenance since there's nothing to integrate.
- **Community validation (50)**: 384 stars, high-quality author, but small star count for the niche.

## Decision

**REJECTED (37.5)** — Pure educational reference. No integrable components. Claude Code agents don't benefit from visual architecture diagrams. Useful as a human reference when researching specific architectures, but adds no capability to the evolution system.
