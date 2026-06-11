---
date: 2026-05-15
topic: "Also investigate this for historical nanochat: https://arxiv.org/abs/2605.06554"
discord_message_id: "1504902760946991176"
status: complete
---

# Lighthouse Attention: Long-Context Pre-Training Efficiency for Historical Nanochat

## Topic
ArXiv paper 2605.06554, "Long Context Pre-Training with Lighthouse Attention" by Bowen Peng, Subho Ghosh, and Jeffrey Quesnelle. The user wants to know if this is useful for historical nanochat.

## Key Findings

- **What it is**: Lighthouse Attention is a training-only, symmetrical selection-based hierarchical attention algorithm that wraps around standard SDPA. It is not a new inference architecture — after training, you run a brief recovery phase and end up with a plain standard-attention model.
- **Three components**: (1) subquadratic preprocessing via adaptive sequence compression/decompression; (2) symmetrical Q/K/V pooling strategy that maintains causal masking while improving parallelism; (3) two-stage training — pre-train with Lighthouse, then brief recovery phase to restore standard attention weights.
- **No gradient through selection**: The hierarchical selection mechanism is gradient-free, which avoids complex custom backward pass kernels and simplifies integration.
- **Reported gains**: Faster overall training time and lower final loss after the recovery phase, at "preliminary small-scale LLM experiments." Specific model sizes and benchmark numbers are not reported in the abstract.
- **Zero inference overhead**: Because you recover a standard attention model at the end, inference is identical to any normal transformer. No changes to serving infrastructure.
- **GitHub implementation available**: Paper states a public implementation exists, but the URL is not in the abstract.

## Details

The mechanism Lighthouse Attention is addressing is well-understood: for long sequences, standard SDPA scales quadratically in memory and compute with sequence length. This becomes expensive during pretraining when document chunks are large. Lighthouse's subquadratic preprocessing compresses the sequence before the full attention computation, then decompresses after — reducing the effective sequence length that SDPA sees while preserving the model's ability to attend over longer spans.

The two-stage approach is key to historical nanochat's use case. Stage 1 (Lighthouse pre-training) is the efficiency win. Stage 2 (brief recovery training) converts the model back to standard attention. The recovered model is then identical in architecture to what nanochat produces today — it can be quantized, served, evaluated, and compared to previous checkpoints with no architectural friction.

Jeffrey Quesnelle has previous work on RoPE scaling and long-context extension. The authorship is credible for a long-context training paper, though the preliminary results caveat means real-world gains at nanochat's scale (615M d22, 18.47B tokens) are unknown.

**Critical caveat — scale**: The paper describes "preliminary small-scale experiments." Historical nanochat is 615M params, which is small by modern standards but may be larger than what was tested. The training gains may not transfer, or may be stronger (small models may benefit more from efficient attention since they're memory-bound in other ways). This needs verification against the actual paper.

**Applicability to current vs. future run**: The d22 legacy baseline is ~step 10k of ~70k and targeting ETA ~2026-05-10. It's too late to integrate Lighthouse Attention into that run. The relevant target is the governed re-run (Path A/B/C decision pending), specifically if that run uses longer sequence lengths to leverage book-length documents.

**Sequence length relevance**: The current nanochat training chunked text to a fixed context window. If the governed re-run adopts longer context windows (e.g., 8k or 16k tokens to preserve book-chapter coherence), Lighthouse Attention becomes directly applicable. At standard 2k-4k chunk sizes, the quadratic cost isn't the bottleneck and the benefit is marginal. This is the key question before evaluating further.

**Karpathy nanochat codebase compatibility**: The nanochat codebase is minimal Python/PyTorch. "Wraps around SDPA" suggests the modification is at the attention function level — plausibly a drop-in replacement for the `F.scaled_dot_product_attention` call. Complexity depends entirely on the implementation, which requires reading the GitHub repo.

## Relevance to Workspace

- **Direct project**: historical-nanochat (`~/claudeworkspace/research/historical-nanochat/`)
- **Only applies to governed re-run**: Legacy d22 baseline is too far in to integrate
- **Gated on context-length decision**: If the governed re-run stays at 2k-4k token chunks, Lighthouse Attention is likely marginal. If it extends to 8k+ chunks to process whole book chapters or full newspaper issues, it becomes high-value.
- **Complements Open Problem #1** (multi-family corpus): Longer context windows during training could improve cross-shard coherence and reduce shard-flip divergence, since the model sees more of each document before a family switch.
- **Related prior work**: `library/techniques/synthetic-pretraining-rewire-2026-03-01.md` (REWIRE / Pleias) — same motivation of better utilizing domain corpus during pretraining.

## Recommended Actions

1. **Find and read the GitHub implementation** — search for "Lighthouse Attention" + the author names to confirm the codebase and check integration complexity with PyTorch/nanochat.
2. **Decide context-length strategy for governed re-run first** — if sticking with 2k-4k chunks, skip this. If extending to 8k+, prioritize evaluating Lighthouse Attention.
3. **Check experimental scale in the full paper** — confirm what model size and token count the "small-scale experiments" used, to calibrate whether 615M gains are likely to materialize.
4. **Add to hub**: Update `library/projects/historical-nanochat.md` → add this investigation to the reports table and add a pointer to Lighthouse Attention in Technique Library Cross-References.
