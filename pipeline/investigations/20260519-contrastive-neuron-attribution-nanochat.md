---
date: 2026-05-19
topic: "Could be useful when following up on historical nanochat — arxiv.org/abs/2605.12290"
discord_message_id: "1506350144151359598"
status: complete
---

# Targeted Neuron Modulation via Contrastive Pair Search — Historical Nanochat Relevance

## Topic

User flagged arxiv.org/abs/2605.12290 as potentially useful for following up on historical nanochat.

## Key Findings

- **Paper**: "Targeted Neuron Modulation via Contrastive Pair Search" (Herring, Naviasky, Malhotra)
- **Core technique**: Contrastive Neuron Attribution (CNA) — identifies the 0.1% of MLP neurons whose activations most distinguish harmful from benign prompts, using only forward passes (no gradients, no extra training)
- **Safety finding**: Disabling these identified neurons in instruction-tuned models drops refusal rates >50% while preserving output coherence at all intervention strengths
- **Architecture insight**: Base models have similar neuron discrimination patterns as instruction-tuned ones, but steering base-model neurons only shifts content (not behavior) — the behavioral change requires instruction-tuning to convert the existing structure into an active refusal mechanism
- **Scale tested**: Llama and Qwen families, 1B–72B parameters — scale-agnostic findings, though 615M (historical nanochat target) is below the tested range
- **Direct historical nanochat link**: CNA's contrastive-pair approach could be repurposed to identify neurons discriminating *pre-1914 vs. post-1914 content*, providing mechanistic verification of the time-lock

## Details

The CNA method works by presenting the model with matched pairs of prompts (harmful vs. benign) and recording activation differences across MLP neurons. The top-discriminating neurons (just 0.1% of total) are then targeted for modulation. This is computationally cheap — only forward passes required — and appears to work at inference time without any fine-tuning.

The most relevant architectural finding for historical nanochat is the base vs. instruction-tuned split: base models already encode the discriminating structure, but it takes instruction-tuning to operationalize that structure into behavioral outputs. This has a direct parallel in the historical nanochat pipeline. The model being trained from scratch on pre-1914 text will likely develop internal structures that represent "historical" vs. "anachronistic" content boundaries. CNA-style analysis during or after training could reveal whether those boundaries exist mechanistically — i.e., whether the time-lock is reflected in sparse, targetable neural circuits the way safety alignment is.

A second practical use: if historical nanochat eventually gets an instruction-tuning phase (to make it chat-capable), the paper's findings suggest that phase will create sparse, targetable circuits. Understanding this beforehand means the team could proactively apply CNA post-instruction-tuning to verify the model's historical persona hasn't been undermined by RLHF pulling it toward modern-sounding refusals or modern knowledge retrieval.

The paper's finding that neuron-level intervention preserves output quality at all intervention strengths is encouraging for any inference-time steering experiments — you can modulate without causing incoherence.

## Relevance to Workspace

- **Historical nanochat (primary)**: CNA's contrastive-pair approach is directly adaptable. Pairs like (pre-1914 text, post-1914 text) or (authentic Victorian prose, anachronistic modern phrase) could identify time-lock discriminating neurons. This is a mechanistic interpretability experiment feasible after the current baseline run completes (~2026-05-10 ETA).
- **Publication review**: Minimally relevant — the paper's neuron-level analysis is domain-specific to model internals, not review methodology.
- **Future instruction-tuning planning**: The base-model architecture findings inform what to expect when historical nanochat eventually gets an instruction-tuning phase — alignment will create new sparse circuits, not overwrite existing structure.

## Recommended Actions

1. **File for post-baseline interpretability experiment**: After the `governed_v4_d22` baseline run completes, run CNA-style forward-pass analysis using pre-1914 vs. post-1914 content pairs to test whether time-lock is mechanistically encoded. This is a cheap experiment — no retraining required.
2. **Add to open problems list in `library/projects/historical-nanochat.md`** under a new section: "Post-training interpretability experiments."
3. **Save paper reference** for the future instruction-tuning planning phase — specifically the base vs. instruction-tuned discrimination finding.
