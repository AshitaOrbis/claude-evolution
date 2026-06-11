# GStack - Garry Tan (YC)

- **Date**: 2026-03-16
- **Source**: Discord #general inbox
- **URL**: https://github.com/garrytan/gstack
- **Category**: Claude Code skills / workflow patterns
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1483289191923187772
- **Evaluated**: 2026-03-17

## What It Is

GStack is a set of 13 specialized Claude Code workflow skills from Garry Tan (YC President & CEO). Includes:

**Planning modes (multi-persona):**
- `/plan-ceo-review` — product/business lens
- `/plan-eng-review` — technical/architecture lens
- `/plan-design-review` — UX/design lens

**Execution modes:**
- `/review` — code review
- `/ship` — shipping workflow
- `/qa` — QA workflow

**Utility tools:**
- `/browse`, `/design-consultation`, `/retro`, `/document-release`

**Conductor pattern**: Manages simultaneous parallel planning sessions across multiple cognitive modes.

**~18,900 GitHub stars** — extremely high signal; one of the highest-star Claude Code workflow repos.

## Registry Check

Registry "Skills & Workflows" section has: spec-driven development, wrap-up ritual, 80/20 ratio, planning-with-files. Redundancy triggers: "persistent planning", "phase gates", "structured development", "multi-session workflow".

**Classification**: Partially redundant (planning workflows overlap), but multi-persona cognitive mode switching (CEO/eng/design review simultaneously) is a genuinely novel architectural pattern not in our registry.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 70 | Skills are Claude Code slash commands — moderate effort to review, adapt, and integrate; our skill format differs from GStack's format |
| Token efficiency impact | 60 | Skills add structured context; neutral vs unstructured planning |
| Capability expansion | 70 | Multi-persona parallel planning (CEO/eng/design simultaneously) is novel; Conductor pattern for parallel sessions not in our system |
| Maintenance burden | 50 | External repo dependency; need to monitor for updates and adapt when GStack changes |
| Community validation | 100 | 18,900 stars — extremely high; Garry Tan (YC president) = maximum practitioner credibility |

**Weighted Score**: (70×0.20) + (60×0.25) + (70×0.25) + (50×0.15) + (100×0.15) = 14 + 15 + 17.5 + 7.5 + 15 = **69.0/100**

## Decision

**NEEDS_RESEARCH** (69.0 — one point below approval threshold; high-priority research)

## Research Questions

1. **Multi-persona gap**: Does our evolution-orchestrator or capability-evaluator benefit from simultaneous CEO/eng/design perspectives? Is there a concrete workflow where this matters?
2. **Conductor pattern**: How does GStack manage simultaneous parallel planning sessions? Is this distinct from our existing dispatching-parallel-agents skill?
3. **Skill format compatibility**: Are GStack's 13 skills directly importable as Claude Code skills, or do they require significant reformatting?
4. **Novel patterns only**: Which of the 13 GStack skills are genuinely novel vs overlapping with our existing spec-driven-dev, session-handoff, 80/20-ratio, and planning-with-files skills?

**Research effort estimate**: 2-3 hours. Read GStack README, review each of 13 skills against our existing skills, identify extractable patterns.

**Re-evaluate at**: Likely 75-80 once we confirm multi-persona planning and Conductor pattern novelty. The 18,900 stars signal this has high production value.

**Priority**: HIGH — the star count and source (YC president's personal toolset) make this a high-signal discovery worth deeper investigation.
