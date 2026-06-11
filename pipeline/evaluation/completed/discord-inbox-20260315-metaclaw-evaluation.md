# MetaClaw — Evaluation

- **Date Evaluated**: 2026-03-16
- **Original Discovery**: discord-inbox-20260315-metaclaw.md
- **Source**: https://github.com/aiming-lab/MetaClaw
- **Decision**: REJECTED

## What It Is

MetaClaw is a continuous-learning agent framework from aiming-lab that wraps OpenClaw with an OpenAI-compatible proxy. Every live conversation becomes a training signal: the proxy intercepts requests, injects relevant skills, scores response quality via a PRM judge, and when enough samples accumulate, offloads LoRA fine-tuning to Tinker Cloud, then hot-swaps updated weights without downtime. ~1.4k GitHub stars, active development (v0.3.1 released 2026-03-13).

## Redundancy Check

NOVEL — No match in registry. Closest is the evolution/pipeline system itself, but MetaClaw targets weight-level adaptation (LoRA fine-tuning), not config/skill adaptation.

## Scoring

| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|---------|
| Integration complexity | 0 | 20% | 0.0 |
| Token efficiency impact | 50 | 25% | 12.5 |
| Capability expansion | 20 | 25% | 5.0 |
| Maintenance burden | 0 | 15% | 0.0 |
| Community validation | 70 | 15% | 10.5 |
| **Total** | | | **28.0** |

## Scoring Rationale

- **Integration complexity (0)**: Architecturally incompatible. Requires OpenClaw, Tinker Cloud (proprietary training backend), HuggingFace base models (Kimi-2.5 or Qwen3-4B), and the ability to fine-tune model weights. None of these apply to Claude Max/Claude Code — no integration path exists.
- **Token efficiency (50)**: Neutral — can't be integrated, moot point.
- **Capability expansion (20)**: Concepts are genuinely interesting (skill injection from live knowledge base, async quality scoring, hot-swap training), but no capability we can actually use in a Claude Code workflow.
- **Maintenance burden (0)**: Would be extremely high if we could integrate — external training backend dependency, weight management, continuous evaluation pipeline.
- **Community validation (70)**: 1.4k stars, active v0.3.x development. Legitimate project.

## Decision

**REJECTED (28.0)** — Architecturally incompatible with Claude Max. Requires LoRA fine-tuning and proprietary training infrastructure that don't exist in our stack. The conceptual patterns (skill injection, quality scoring) are already present in our evolution pipeline at the config/prompt level. File as inspiration if building a custom fine-tuning system in the future.
