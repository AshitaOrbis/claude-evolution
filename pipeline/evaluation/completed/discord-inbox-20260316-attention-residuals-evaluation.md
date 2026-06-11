# Attention Residuals (Moonshot AI / Kimi) — Evaluation

- **Date Evaluated**: 2026-03-16
- **Original Discovery**: discord-inbox-20260316-attention-residuals.md
- **Source**: https://github.com/MoonshotAI/Attention-Residuals/blob/master/Attention_Residuals.pdf
- **Decision**: REJECTED
- **Historical-nanochat relevance**: No

## What It Is

AttnRes is a Transformer architecture modification from Moonshot AI (Kimi team) that replaces fixed residual connections with *attention over depth*. Instead of each layer adding its output to a single shared hidden state with uniform weight (`x + f(x)`), AttnRes lets each layer compute softmax attention weights over all preceding layer outputs — treating the layer stack like a short sequence. Demonstrated on a 48B model with meaningful improvements:

- GPQA-Diamond: +7.5 points (36.9 → 44.4)
- HumanEval: +3.1 points (59.1 → 62.2)
- MMLU: +1.1 points (73.5 → 74.6)
- ~1.25x compute cost vs baseline

## Redundancy Check

NOVEL — No match in registry. But architecture-level technique, not a Claude Code capability.

## Historical-Nanochat Relevance

**Not applicable.** AttnRes requires training from scratch with a modified architecture — it cannot be bolted onto existing pretrained models. Historical-nanochat uses fine-tuning (LoRA/SFT) of existing small models, not pretraining a new architecture. Scale mismatch also: gains demonstrated at 48B parameters, behavior at 1-7B is unknown and likely weaker.

## Scoring

| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|---------|
| Integration complexity | 0 | 20% | 0.0 |
| Token efficiency impact | 50 | 25% | 12.5 |
| Capability expansion | 20 | 25% | 5.0 |
| Maintenance burden | 100 | 15% | 15.0 |
| Community validation | 70 | 15% | 10.5 |
| **Total** | | | **43.0** |

## Scoring Rationale

- **Integration complexity (0)**: Requires building a new model from scratch with a modified architecture. No integration path into Claude Code or fine-tuning workflows.
- **Token efficiency (50)**: Neutral — inference efficiency is unclear; 1.25x compute for training doesn't translate directly.
- **Capability expansion (20)**: Interesting future architecture direction, but zero actionable capability for this system now.
- **Maintenance burden (100)**: Nothing to maintain since nothing is integrated.
- **Community validation (70)**: Moonshot AI is a credible lab; paper is not yet peer-reviewed but from a serious team.

## Decision

**REJECTED (43.0)** — Architecture-level pretraining modification. Not applicable to fine-tuning workflows (historical-nanochat) or Claude Code configuration/skill systems. Worth monitoring as a "future architecture trend" if the technique becomes standardized in small model training (e.g., adopted by LLaMA or Qwen base model training), at which point historical-nanochat could benefit from using an AttnRes-based base model.
