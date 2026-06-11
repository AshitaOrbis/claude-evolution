# Feynman Tutoring Agent

- **Date**: 2026-03-27
- **Source**: Discord #general inbox
- **URL**: https://github.com/getcompanion-ai/feynman
- **Category**: agent
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1486942628997107886

## Description

Feynman is a tutoring/learning agent framework from getcompanion-ai. Named after Richard Feynman's famous learning technique of explaining concepts in simple terms, this appears to be a tool for building intelligent tutoring systems or educational agents.

## Relevance

Could be useful for educational applications or as a reference implementation for specialized agent frameworks. Potentially relevant to teaching/knowledge transfer use cases in Claude Code applications.

---

## Evaluation

**Evaluated**: 2026-03-30
**Decision**: REJECTED (44.5/100)

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Unknown codebase — no ready-made Claude Code integration; unclear if Python/JS/other stack |
| Token efficiency impact | 25% | 50 | Neutral — educational tutoring agent has no direct token efficiency implication for this workflow |
| Capability expansion | 25% | 40 | Marginal — Claude Code evolution system has no educational/tutoring use case; this is a domain-specific agent for a domain we don't operate in |
| Maintenance burden | 15% | 50 | Unknown — getcompanion-ai is an unfamiliar org with no star count provided |
| Community validation | 15% | 30 | No community data — no stars, no HN score, no Anthropic affiliation; single Discord mention |

**Weighted Score**: (50×0.20) + (50×0.25) + (40×0.25) + (50×0.15) + (30×0.15) = 10 + 12.5 + 10 + 7.5 + 4.5 = **44.5/100**

**Reasoning**: Feynman is an educational tutoring framework with no relevance to Claude Code capability evolution. The discovery note provides minimal information — no star count, no description of what the agent actually does beyond the Feynman technique name. The Claude Code evolution system does not build tutoring applications. Even if the framework were excellent, there is no integration path: we don't maintain educational agents, don't have tutoring use cases, and the agent taxonomy (capability discovery, evaluation, integration, orchestration) has no tutoring layer. The very low community validation score reflects the absence of any signal beyond a single Discord mention.

**Re-evaluation trigger**: None — domain mismatch is fundamental, not addressable by more information.
