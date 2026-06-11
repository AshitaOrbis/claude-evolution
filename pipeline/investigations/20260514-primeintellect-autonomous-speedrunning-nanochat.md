---
date: 2026-05-14
topic: "more to look into for historical nanochat https://github.com/PrimeIntellect-ai/experiments-autonomous-speedrunning"
discord_message_id: "1504615519943266375"
status: complete
---

# PrimeIntellect Autonomous Speedrunning — Optimizer Insights for Historical Nanochat

## Topic
PrimeIntellect's `experiments-autonomous-speedrunning` repository documents an autonomous AI competition (Claude vs. Codex) to minimize training steps to reach validation loss 3.28 on the `track_3_optimization` benchmark from modded-nanogpt. The user wants to know if there are insights applicable to historical nanochat.

## Key Findings

- **Same benchmark family**: The speedrunning competition uses modded-nanogpt — the same Karpathy nanoGPT lineage that historical nanochat builds on. Optimizer and scheduler findings transfer with minimal adaptation.
- **~16% step reduction achieved**: Baseline 3500 steps → Claude 2930 / Codex 2950 in the final wave. Techniques included novel scheduler design, initialization improvements, and constrained optimizer variants.
- **10,428 documented training runs**: The repo contains agent reasoning logs, generated variants, and aggregated metrics across four experimental waves — a searchable empirical map of which config changes matter for nanoGPT-class training.
- **Constraints were optimizer/scheduler/init only**: The competition excluded architectural changes. That's precisely the parameter space available to historical nanochat without a full architecture redesign.
- **Novelty-constrained iteration**: Each wave required agents to propose ideas not reducible to known methods. The resulting techniques are less likely to be already captured in standard nanoGPT recommendations.
- **Relevance is moderate-not-direct**: The target benchmark is likely a vision/token classification task (modded-nanogpt `track_3`), not language modeling on a specific text domain. Scheduler insights transfer; domain-specific dynamics (shard-flip divergence, multi-family corpus) do not.

## Details

The competition architecture is straightforward: autonomous agents propose optimizer/scheduler configs, run them against the benchmark, then propose next variants conditioned on results. The four experimental waves progressively tightened constraints and required increasingly novel approaches.

For historical nanochat specifically, the most actionable output is the **scheduler design space**. The d22 615M-param run is currently using a Chinchilla r=30 cosine schedule. If Claude's winning configuration used a non-cosine scheduler or a warmup-decay variant that reduced loss faster, that could shave meaningful wall-clock time off the remaining ~60,000 steps. The 3090 is at 16.4k tok/s; a 16% step reduction would save roughly 10 hours of training time.

The **initialization improvements** are a second candidate. Historical nanochat's current run passes all verification checks at step 10,000, but there's no indication the initialization was tuned beyond nanoGPT defaults. If the speedrunning repo identifies a consistently better init scheme for nanoGPT-family models, it could improve early-phase convergence for the governed re-run (which has the most to gain, since the legacy baseline is already underway).

The **10,428-run empirical database** is the most durable asset. Even if the specific winning configs don't transfer, the failure modes documented across thousands of runs would help anticipate pitfalls in the multi-family corpus shard-flip problem — particularly any runs that showed instability from data distribution shifts.

A caveat: the speedrunning benchmark's loss target (3.28) is a single-domain reference point. Historical nanochat's val BPB of 1.24 at step 10k suggests a very different loss regime (pre-1913 English is more redundant/predictable than the nanoGPT benchmark domain). Scheduler designs optimized for reaching loss 3.28 quickly may behave differently at the lower-loss regime where historical nanochat will spend most of its remaining training.

## Relevance to Workspace

- **Direct project**: historical-nanochat (`~/claudeworkspace/research/historical-nanochat/`)
- **Same upstream**: modded-nanogpt → nanoGPT → Karpathy, same family as historical nanochat
- **Timing**: The governed re-run decision gate (Path A/B/C for multi-family corpus) is the right moment to evaluate scheduler/init changes — before committing to another long run
- **No overlap with existing evaluations**: The `library/projects/historical-nanochat.md` hub has no prior entry for this repo

## Recommended Actions

1. **Browse the top-5 winning configs** from Wave v3 in the repo (`aggregated_metrics/` or equivalent) — extract the scheduler and init params for direct comparison with the current cosine schedule.
2. **Flag for governed re-run prep**: Before starting Path A/B/C, pull any scheduler improvements that show consistent wins across multiple waves and test them in a 2k-step smoke run.
3. **Check failure modes log** for data-distribution-shift instability — may contain directly applicable evidence for the shard-flip divergence problem (Open Problem #1 in the hub).
4. **Low priority**: Do not integrate the full repo into the evolution pipeline — this is a benchmark-specific competition, not a general tool.
