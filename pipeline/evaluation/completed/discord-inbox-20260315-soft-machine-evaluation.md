# Soft Machine — Evaluation

- **Date Evaluated**: 2026-03-16
- **Original Discovery**: discord-inbox-20260315-soft-machine.md
- **Source**: https://soft-machine.io/
- **Decision**: REJECTED

## What It Is

Soft Machine presents as a cloud-based collaborative development environment where "you and AI collaborate as equal participants," with persistent workspaces, instant deployment, and cross-device state sharing. Despite being described as an "agent swarm coordinator" in Discord, **no evidence of multi-agent orchestration, swarm coordination APIs, or framework-level tooling was found**. It reads as a SaaS cloud IDE positioned between Replit/Codespaces and an AI-paired dev environment. No GitHub repo discoverable, no star count, no technical documentation.

## Redundancy Check

N/A — Cannot assess redundancy without technical substance to compare.

## Scoring

| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|---------|
| Integration complexity | 0 | 20% | 0.0 |
| Token efficiency impact | 50 | 25% | 12.5 |
| Capability expansion | 10 | 25% | 2.5 |
| Maintenance burden | 100 | 15% | 15.0 |
| Community validation | 30 | 15% | 4.5 |
| **Total** | | | **34.5** |

## Scoring Rationale

- **Integration complexity (0)**: Nothing to integrate — closed SaaS product, no open API, no GitHub repo.
- **Token efficiency (50)**: Neutral.
- **Capability expansion (10)**: No agentic, orchestration-focused, or composable functionality discovered. Marketing-first presentation without technical depth.
- **Maintenance burden (100)**: Zero maintenance since there's nothing to integrate.
- **Community validation (30)**: No community traction found. No GitHub repo, no stars, no technical community discussion.

## Decision

**REJECTED (34.5)** — SaaS product with no evidence of technical substance behind the "agent swarm coordinator" label. No integration path. If a GitHub repo or technical spec surfaces in the future, re-evaluate. Monitor for re-submission if the product ships open-source tooling.
