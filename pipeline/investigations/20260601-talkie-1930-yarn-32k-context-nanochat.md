---
date: 2026-06-01
topic: "Look into this, extended context version of talkie, worth noting at least"
discord_message_id: "1511087846457475264"
status: complete
---

# talkie-1930-13b-yarn-32k: Extended Context via YaRN for Historical Models

## Topic
Community release of an extended-context variant of talkie-1930-13b-base. YaRN applied to push the model's native 2,048-token window to 32,768 tokens (16× extension), with continued pretraining on Project Gutenberg data at full 32k length.

HuggingFace: https://huggingface.co/xlr8harder/talkie-1930-13b-yarn-32k-tf

## Key Findings

- **This is a community derivative, not an official talkie-lm release**: authored by `xlr8harder`, not by the talkie-lm team (Alec Radford / Nick Levine). Adds long-context capability that the official org hasn't shipped.
- **YaRN is a well-validated context extension technique**: "Yet Another RoPE extensioN" — extends positional encodings in RoPE-based transformers without full retraining, using continued pretraining on long sequences to stabilize the extended window.
- **16× extension was achieved in 500 continued pretraining steps** on 265M Talkie tokens (Project Gutenberg, English public-domain, 1500–1930), using 8×A100 80GB FSDP, 262,144 tokens/optimizer step.
- **RULER benchmark accuracy degrades gracefully**: 80.78% at 2k → 79.50% at 4k → 73.15% at 8k → 70.05% at 16k → 61.83% at 32k. Strongest on needle-in-haystack retrieval; weakest on variable tracking and QA at extreme lengths.
- **License is Apache-2.0**, same as the upstream talkie-lm models. No restrictions on research or derivative use.
- **Direct applicability to historical nanochat post-training**: if/when the governed model needs to process long historical documents (archival transcripts, book-length texts), YaRN is now a demonstrated path on this exact data distribution.

## Details

The previous investigation (2026-04-28) covered the official talkie-lm org releases (base, instruction-tuned, and OCRonos-Vintage). This model is a community extension built on top of `talkie-lm/talkie-1930-13b-base`, the same base covered there.

The YaRN technique (Peng et al., 2023) works by modifying the RoPE scaling factor during inference and adding a small amount of continued pretraining on long sequences to let the model "learn" the extended positional range. The 500-step continued pretraining used 265M tokens of Project Gutenberg text formatted as 32,768-token chunks — the same data distribution as the base model, so no historical contamination risk. This is a methodologically clean approach: the domain distribution is preserved, only the context window changes.

The RULER scores are respectable for a community effort. 61.83% accuracy at 32k is not state-of-the-art for long-context retrieval but is functional — the model can localize information within a 32k document more reliably than random chance. The stronger performance on retrieval (needle-in-haystack) vs. multi-hop reasoning is typical of YaRN extensions: positional generalization transfers better to retrieval than to tasks requiring integration across distant context.

For **historical nanochat specifically**, the practical question is whether a YaRN pass after the governed training run would be worth doing. The current model is 615M (d22 architecture), much smaller than talkie's 13B — YaRN cost scales with continued pretraining FLOP, so a 615M extension would be comparably cheap. The base window isn't known yet (depends on historical-nanochat's tokenizer config and attention implementation), but if it matches nanochat-style defaults (~2k), a 32k extension would follow similar mechanics.

## Relevance to Workspace

This is directly relevant to historical nanochat as a **post-training option**, not a current training concern:

- Talkie's 13B YaRN variant now establishes a reference: 500 steps of continued pretraining at 32k produces measurable long-context capability on exactly this data distribution.
- Historical nanochat's eventual use cases include processing full-length books and long newspaper archives — 2,048-token windows will be a bottleneck for these tasks.
- The technique is model-agnostic (any RoPE transformer) and cheap relative to full pretraining. At 615M params, a YaRN pass would cost a small fraction of the base training run.

**No overlap** with the April 28 investigation (which covered the base and instruction-tuned models + OCRonos). This is additive.

## Recommended Actions

1. **File as a post-training technique option** in `library/projects/historical-nanochat.md` under a new "Post-Training Options" section. YaRN at 32k is a viable step after the governed baseline completes.
2. **Note the 500-step recipe**: 16× YaRN extension at 500 steps using domain-matched data appears sufficient for base capability. When historical nanochat reaches a stable governed checkpoint, this is the reference to consult.
3. **No immediate action needed**: the current run is still working through multi-family corpus dynamics (Path A/B/C decision). YaRN is a Phase 3+ concern (post governed-PoC, pre-deployment).
