---
date: 2026-05-13
topic: "Look into this for historical nanochat: https://arxiv.org/abs/2605.06546"
discord_message_id: "1504242807295049789"
status: complete
---

# Token Superposition Training (TST) for Historical Nanochat

## Topic
Paper: **"Efficient Pre-Training with Token Superposition"** (Peng, Gigant, Quesnelle, arXiv 2605.06546). User asks whether it's applicable to historical nanochat.

## Key Findings

- **What it is**: TST is a two-phase pre-training technique that collapses multiple consecutive tokens into single input units during an initial "superposition phase" (multi-hot cross-entropy objective), then reverts to standard training in a "recovery phase" — no architecture, tokenizer, optimizer, or data changes required
- **Claimed speedup**: Up to **2.5x reduction in total pre-training time at 10B (A1B) scale** at equivalent loss; validated across 270M to 10B parameters
- **NOT applicable to the current run** (governed_v4_d22 at step 10000+): TST must be applied from the beginning of pre-training; it cannot be retrofitted mid-run
- **Potentially applicable to the next scale-up** if the deliberation outcome is "build a bigger instrument" — at 615M the speedup is likely ~1.5-2x (smaller than the 10B headline; superposition gains scale with model size)
- **Nanochat implementation cost is moderate**: requires modifying `scripts/base_train.py` to support phase switching and a multi-hot cross-entropy loss head — no architectural changes to the model itself
- **The custom 32K BPE tokenizer is compatible**: TST operates at the input-combination layer, not the vocabulary layer; the tokenizer is unchanged
- **Key risk for historical nanochat**: the superposition phase might partially undo the historical token distribution learned from the custom corpus — the "recovery phase" is meant to restore this, but for domain-specific corpora this is less validated

## Details

TST works by treating several consecutive tokens as a single training unit during the early "superposition phase." Instead of predicting the next single token (standard cross-entropy), the model learns to predict a set of next tokens simultaneously (multi-hot cross-entropy). This allows each parameter update to incorporate information from more of the sequence, effectively increasing data throughput per FLOP without increasing model size, batch size, or sequence length.

The "recovery phase" then reverts to standard next-token prediction. The intuition is that superposition acts like a form of curriculum: learn coarse co-occurrence structure quickly, then refine to single-token precision. The paper validates this doesn't degrade final quality — the model reaches the same loss as standard training but in substantially fewer wall-clock hours.

**Scale-dependent gains**: The 2.5x headline is at 10B. At 270M (the smallest scale in the paper), gains are present but smaller. Historical nanochat's 615M is within the validated range; a realistic estimate is 1.5-2x speedup — call it ~35-50% time saved vs the d22 run duration. The current d22 run at 16,361 tok/sec × estimated total steps means TST could save weeks on a next-scale run.

**Historical corpus risk**: Standard pre-training datasets (FineWeb, DCLM) have high entropy and diverse token co-occurrence. Historical nanochat's pre-1914 corpus has lower entropy (older vocabulary, repetitive grammatical structures, limited register diversity). The multi-hot superposition phase might learn different co-occurrence patterns than expected — not a fatal risk, but worth an ablation: compare superposition vs standard on a short 100M-step smoke run before committing.

**Implementation in nanochat**: The modifications are isolated to `scripts/base_train.py`:
- Add a `--tst_phase_frac` flag (fraction of total steps to run superposition, e.g. 0.2 = 20%)
- Add a `--tst_superposition_k` flag (how many tokens to combine, e.g. 2-4)
- Swap the loss function during superposition phase: `multi_hot_ce()` vs `cross_entropy()`
- No changes to the model architecture, optimizer (Muon), tokenizer, or data loader

**Current run status**: governed_v4_d22 is confirmed healthy at step 10000 (val BPB 1.2406, stable throughput, no OOM). TST is irrelevant to this run.

## Relevance to Workspace

The 2026-05-12 deliberation panel (Round 2 synthesis) concluded that **615M is too small to test the original cutoff hypothesis** and that the next meaningful step is either "scale to 1-3B and test the thesis" or "publish the 615M run as instrument prototype + calibration log." If the next-scale path is chosen, TST becomes a concrete time-saver: a 1.5B run that would take ~4 weeks at current throughput might complete in ~2.5-3 weeks with TST. On a single 3090, that's meaningful.

The paper's claim that no tokenizer or architecture changes are required is especially important for nanochat: the custom 32K BPE tokenizer is load-bearing (trained specifically on pre-1914 text; replacing it would invalidate the corpus governance claim).

## Recommended Actions

1. **No action on current run** — TST cannot be applied mid-training
2. **Add to nanochat backlog** for the next training run decision: if scaling up to 1B+, implement TST with a smoke ablation first (100M step comparison: TST vs standard on the historical corpus)
3. **Flag the historical-corpus risk** — the low-entropy pre-1914 register may interact differently with the superposition phase than the paper's standard corpora; run ablation before a multi-week commitment
4. **Implementation is ~1 day of work** in `base_train.py` — small cost for a potential 35-50% wall-clock reduction on long runs
