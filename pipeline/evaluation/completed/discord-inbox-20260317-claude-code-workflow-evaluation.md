# Claude Code Workflow (runesleo)

- **Date**: 2026-03-16
- **Source**: Discord #general inbox
- **URL**: https://github.com/runesleo/claude-code-workflow
- **Category**: Claude Code configuration / workflow pattern
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1483331116923617373
- **Evaluated**: 2026-03-17

## What It Is

Battle-tested Claude Code workflow template from 3 months of daily usage by an independent developer. ~382 GitHub stars.

**Three-layer architecture:**
- Always-loaded rules (behaviors, skill triggers, memory)
- On-demand documentation (agents, routing, safety)
- Working memory files (context preservation)

**Features**: Context preservation, model-tier routing, verification-first practices, session continuity patterns.

## Registry Check

Registry "Workflow Patterns" has: persistent planning, spec-driven dev, wrap-up ritual, 80/20 ratio. Redundancy triggers explicitly include: "structured development", "multi-session workflow", "session handoff", "persistent planning", "markdown files", "working memory".

The three-layer architecture mirrors our own tiered CLAUDE.md + skills + agents structure. The working memory and context preservation patterns overlap significantly with our existing session-handoff skill and planning-with-files skill.

**Classification**: MOSTLY REDUNDANT (~70-80% overlap) but may contain specific novel patterns worth extracting.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 70 | Reading and extracting patterns is low-friction; no code changes needed |
| Token efficiency impact | 60 | Skills and rules are context-efficient |
| Capability expansion | 30 | ~70-80% overlap with existing system; specific novel patterns (if any) are incremental |
| Maintenance burden | 70 | Read-once extraction; no ongoing dependency |
| Community validation | 65 | 382 stars (100-1k range) |

**Weighted Score**: (70×0.20) + (60×0.25) + (30×0.25) + (70×0.15) + (65×0.15) = 14 + 15 + 7.5 + 10.5 + 9.75 = **56.75/100**

## Decision

**NEEDS_RESEARCH** (56.75 — mid-range; low priority)

## Research Questions

1. **Novel patterns scan**: Read the full repo (CLAUDE.md, skills, agents). List any patterns NOT covered by: session-handoff, planning-with-files, spec-driven-dev, 80/20-ratio, dispatching-parallel-agents.
2. **Model-tier routing**: How does runesleo's routing differ from our existing model-selection playbook? Any different heuristics?
3. **Verification-first**: Is this the same as our validate-before-irreversible-operations rule, or a distinct pattern?
4. **Extractable delta**: If only 20-30% is novel, is that delta worth a helpers/ entry?

**Research effort estimate**: 1 hour (skim-and-diff against our existing system).

**Re-evaluate at**: 40 if no novel patterns found (downgrade to REJECTED); 70+ if several extractable patterns discovered.

**Priority**: LOW — likely duplicate with minor extractable value. GStack (69.0) and Honcho (50.5) should be researched first.
