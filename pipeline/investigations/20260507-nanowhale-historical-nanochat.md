---
date: 2026-05-11
topic: "Look into this, see if any of it might be useful for historical nanochat"
discord_message_id: "1502020092903297207"
url: "https://github.com/huggingface/nanowhale"
status: complete
---

# Nanowhale — Relevance to Historical Nanochat

## Topic
> Look into this, see if any of it might be useful for historical nanochat: https://github.com/huggingface/nanowhale

## Key Findings

- **What it is**: Nanowhale is a 110M-parameter transformer trained from scratch by HuggingFace, implementing the DeepSeek-V4 architecture at miniature scale. It is a learning/research reference implementation, not a production model.
- **Architecture features at nano scale**: Multi-Head Latent Attention (MLA), Mixture-of-Experts (4 routed + 1 shared, top-2 routing), Hyper-Connections with Sinkhorn routing, and Multi-Token Prediction — all implemented at 110M params. This is notable: these are frontier architecture techniques running efficiently at small scale.
- **Training scale**: 2-stage: 5k steps pretraining on FineWeb-Edu (2.6B tokens), then 3k steps SFT on SmolTalk. Final BPB not reported but loss curves are tracked.
- **Context window**: 2,048 tokens — comparable to nanochat's current training config.
- **Direct relevance**: Historical Nanochat (governed_v4_d22) is currently training at 615M params with a 2-stage approach (pretraining + eventual SFT). The architecture techniques in Nanowhale are potentially adoptable at that scale.
- **MoE angle**: The existing nanochat architecture is dense (d22 config). Nanowhale demonstrates MoE at ~100M params — at 615M, MoE could be worth evaluating for future runs but adds dataloader and routing complexity.

## Details

Nanowhale is most interesting not as a model to use, but as a reference implementation of advanced architecture features at a scale that's manageable to study and potentially adapt. The DeepSeek-V4-style MLA (Multi-Head Latent Attention) is the most potentially useful technique: it compresses the KV cache significantly compared to standard MHA, which matters for training efficiency on the RTX 3090 (currently at 17.13 GiB peak VRAM out of 24 GiB — headroom is limited).

The MoE implementation is harder to adopt mid-project. The current d22 615M architecture is committed, and switching to MoE would require a new training run from scratch plus a more complex dataloader. Worth noting for the next architecture decision (post-governed PoC), not the current run.

Multi-Token Prediction (MTP) is the most actionable short-term finding: this technique trains the model to predict multiple future tokens simultaneously rather than just the next one, improving training efficiency (more signal per forward pass) without changing inference behavior. HuggingFace's reference implementation could be adapted into the existing nanochat training loop before the governed re-run.

The Hyper-Connections with Sinkhorn routing is experimental and probably not worth adopting at this stage — it adds routing complexity with uncertain gains at the scale we're operating at.

## Relevance to Workspace

- **Open problem #1 (multi-family corpus training dynamics)**: None of Nanowhale's techniques directly address the shard-flip divergence problem. That's a dataloader/training dynamics issue, not an architecture issue.
- **Open problem #2 (OCRonos-Vintage)**: Not relevant to OCR preprocessing.
- **MLA for VRAM pressure**: If a future governed run hits VRAM OOM, MLA is worth evaluating. The current run is comfortable (17.13 GiB / 24 GiB).
- **Multi-Token Prediction**: Strongest near-term candidate for adoption — investigate adapting into the Phase-0 repacking + training pipeline.
- **Relation to existing evaluations**: OCRonos-Vintage (from Pleias, same family as REWIRE) is the open problem most likely to move the needle before the governed re-run. Nanowhale is architecture research, which matters more for post-baseline architecture decisions.

## Recommended Actions

1. **File as architecture reference** for the post-governed-baseline architecture decision: MLA for KV cache compression, MoE for parameter efficiency.
2. **Investigate Multi-Token Prediction** for the nanochat training loop — it's the one technique that could be adopted without changing the architecture or dataloader.
3. **No action needed on current run**: The d22 615M run is committed and near step ~10k. Don't interrupt it for architecture experiments.
4. **Link to historical-nanochat hub**: Add a note to `library/projects/historical-nanochat.md` under open problems or the architecture section.
