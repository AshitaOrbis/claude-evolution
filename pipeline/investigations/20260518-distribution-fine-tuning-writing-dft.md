---
date: 2026-05-18
topic: "Investigate distribution fine-tuning for LLM writing — useful for autonovel, ashitaorbis, historical nanochat?"
discord_message_id: "1506012340011794493"
url: "https://rosmine.ai/2026/05/18/fixing-llm-writing-with-distribution-fine-tuning/"
status: complete
---

# Distribution Fine-Tuning (DFT) for LLM Writing — Workspace Applicability

## Topic
> Investigate this: https://rosmine.ai/2026/05/18/fixing-llm-writing-with-distribution-fine-tuning/
> Could it be useful for fine tuning a writing model? For the autonovel experiment and/or ashitaorbis posts or even the historical nanochat once we get there?

## Key Findings

- **What DFT is**: A post-training algorithm that optimizes model outputs to match the *statistical distribution* of training data, not just individual examples. Uses L2 token distribution distance (n-gram frequency), Maximum Mean Discrepancy (MMD in embedding space), and a judge model quality score.
- **What it solves**: Standard SFT produces AI-slop — overused tokens, formulaic patterns ("delve", em-dashes, "it's not X, it's Y"). SFT optimizes per-example; DFT optimizes the whole output *distribution* to match human writing.
- **Results are significant**: A 4B DFT model outperforms 14B SFT baselines. 49% MMD improvement, 63% judge-model quality improvement, +164% creativity scores. 100/100 outputs scored as human-written by a classifier.
- **Historical nanochat is the strongest fit**: DFT is exactly the right technique when target style is a *corpus* (e.g., historical documents) rather than a specific task. It would make nanochat outputs match the token frequency + semantic distribution of historical writing, not just learn individual example patterns.
- **Ashitaorbis angle is underexplored but exciting**: The 1.47M-word personal writing corpus could serve as a DFT target distribution, producing a writing model that statistically matches the user's actual voice at the corpus level — not just mimics samples.
- **Amnesiac-story has limited immediate applicability** but would benefit if the project ever moves to fine-tuning a smaller dedicated model (DFT would be the post-training step to use).
- **The technique is low computational overhead** vs standard fine-tuning — no new training from scratch required.

## Details

### The Core Problem DFT Solves

Standard SFT treats each training example as an independent optimization target. This means the model learns to produce outputs that locally match each example, but the overall *statistical character* of its outputs diverges from training data. The result is systematic AI-slop: the model overuses certain tokens (em-dashes, specific transition phrases, formulaic sentence openers) at rates that don't match human writing distributions, even when its per-example outputs look plausible.

DFT addresses this at the distribution level. The three metrics it uses are complementary: token-level n-gram distance captures word frequency divergence, MMD in embedding space captures semantic distribution mismatch, and the judge model quality score captures human preference alignment. Together they give a comprehensive signal for how much the model's *output distribution* has drifted from the target corpus distribution.

### Historical Nanochat — Highest Relevance

This is the clearest application. The project has a large corpus of historical documents as training data. The core challenge is making a fine-tuned model sound authentically historical rather than producing modern-sounding LLM text with period vocabulary sprinkled in. SFT would train the model to match individual historical examples; DFT would ensure the *statistical fingerprint* of outputs — word frequencies, phrase patterns, semantic distributions — matches the corpus as a whole.

Concretely: historical writing has characteristic token distributions (archaic vocabulary at specific frequencies, different sentence structure rhythms, different punctuation patterns). SFT doesn't capture this at the distributional level. DFT does. The result would be model outputs that "feel" historical not because they use "thee" and "thou" correctly in individual examples, but because their entire distributional character matches historical text.

The technique would apply as a post-training step after the base supervised fine-tuning that's already underway. It doesn't require retraining from scratch.

### Ashitaorbis Blog Posts — Interesting but Requires Corpus as Target

The current pipeline (Claude + publication-review + multi-model critique) addresses quality at the content level but doesn't address the distributional character of the writing. The user has a 1.47M-word personal writing corpus. If DFT were applied with that corpus as the target distribution, the result would be a fine-tuned model whose output token frequencies and semantic patterns statistically match the user's actual voice — not "write like this example" but "have the same distributional DNA as this corpus."

This would require: (1) choosing a base model to fine-tune, (2) using the personal corpus as the target distribution, (3) applying DFT as the post-training step. The challenge is that the current pipeline uses Claude directly via API — DFT isn't something you apply to a model you can't train. It would require a trainable open-source model and a fine-tuning setup.

Feasibility: medium. It requires running fine-tuning (4B parameter scale is accessible on a 3090), but is architecturally separate from the current Claude-based pipeline. Worth tracking as a future experiment once historical nanochat infrastructure is proven out.

### Amnesiac-Story / Autonovel — Limited Immediate Applicability

The story pipeline currently uses Claude directly for generation (story-writer agent). DFT isn't applicable to a model accessed via API — it's a post-training technique for trainable models. However: (1) if the project ever shifts to fine-tuning a smaller open model for story generation, DFT is the right post-training technique; (2) the insights from DFT about what makes writing "feel" human (distributional character vs individual sample quality) are useful for evaluating the current Claude-generated output — specifically, checking whether the writing has distributional slop patterns even if individual paragraphs look good.

## Relevance to Workspace

- **Historical nanochat** (active project): Direct high-value application as a post-training step after current SFT runs. The governed v4 corpus is exactly the kind of target distribution DFT is designed for.
- **Ashitaorbis** (future experiment): Personal 1.47M-word corpus is an unusual and compelling DFT target — could produce a genuinely voice-matched writing model.
- **Amnesiac-story** (indirect): Useful as evaluation framework to check if story outputs have distributional AI-slop signatures; actionable if project scales to fine-tuning.
- **Rosmine.ai** author is planning open-source releases — worth monitoring for code release that could be applied directly to nanochat.

## Recommended Actions

1. **Track the DFT codebase release from rosmine.ai** — author explicitly mentions open-source plans. When released, evaluate applicability to historical nanochat post-training.
2. **Document DFT as a planned post-training technique for historical nanochat** in the project's CLAUDE.md — specifically as a step after current SFT convergence.
3. **Flag the personal corpus angle** as a future writing model experiment: fine-tune a 4B model on the 1.47M-word corpus using DFT. Not urgent, but architecturally interesting.
4. **No immediate action needed** on amnesiac-story — DFT isn't applicable to the current Claude API pipeline.
