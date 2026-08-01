# Synthetic Pretraining & REWIRE Technique

- **Source**: https://vintagedata.org/blog/posts/synthetic-pretraining (Pierre-Carl Langlais, Pleias)
- **Date Archived**: 2026-03-01
- **Relevance**: historical-nanochat project, fine-tuning workflows

## Core Thesis

Organic web data is "capability blind" — it cannot reliably deliver structured learning signals. Synthetic pretraining (using artificially generated data as a primary training axis) is becoming the dominant paradigm among frontier labs.

## Three-Stage Taxonomy

### Stage 1: Memorization (REWIRE Rephrasing) — MOST RELEVANT
- Rephrase source documents into varied, coherent restatements for better fact retention
- Key technique: **REWIRE framework** (Meta) — rephrase web documents into more coherent, elaborated structures
- Model memorizes through varied repetition, not single exposure
- Generator models: 3-8B sufficient, diminishing returns past 3B (per BeyondWeb research)
- **Directly applicable to historical-nanochat**: Dense 19th-century prose, OCR'd archival records, formulaic bureaucratic text all benefit from rephrasing

### Stage 2: Logical Hardwiring
- Embed rule-based reasoning into weights via engineered exercises
- Examples: DeepSeek-Prover-V2, Seed-Prover (230M unique math problems)
- **Not relevant** to historical-nanochat

### Stage 3: System Simulations
- Synthetic agent trajectories modeling real-world environments
- IBM Toucan: 1.5M trajectories from ~500 real MCP servers
- **Not relevant** to historical-nanochat

## Key Findings

### Document-Level Curation > Token-Level Tricks
Improved filtering of synthetic documents beats inference-time tricks (temperature, sampling params). For historical-nanochat's 434GB corpus with quality variance (OCR errors, degraded scans, formulaic text vs. rich narrative), curate at document level first.

### Volume < Quality of Expansion
The SYNTH experiment (Pleias) built a self-sufficient pretraining environment from just 56,000 Wikipedia articles via aggressive rephrasing. The 434GB historical corpus is very large — the bottleneck is quality and structure, not volume. Reframe: "what subset has the highest-quality signal, and how do we expand that subset?"

### Small-to-Large Distillation
Small specialized models can produce training inputs for larger models. A fine-tuned Mistral-7B could rephrase historical documents at scale without frontier model access.

### Failure Modes
- **Model collapse**: Low language diversity causes surface-form learning
- **Narrow search spaces**: Over-constrained generation prevents generalization

## Practical Applicability to historical-nanochat

| Technique | Actionability | historical-nanochat Fit |
|-----------|---------------|------------------------|
| REWIRE rephrasing | High (need fine-tuned 3-8B generator) | High — dense historical prose is the exact use case |
| Document-level curation | High (standard pipeline work) | High — 434GB has quality variance |
| Small generator model | High (3B sufficient, no frontier API) | High — no expensive dependencies |
| Distillation | Medium (needs larger target model) | Medium — depends on training setup |

## What This Does NOT Address

- **Conversational style reproduction**: If historical-nanochat aims to reproduce historical conversational *register*, careful fine-tuning on authentic examples may matter more than synthetic expansion
- The article doesn't discuss dialogue/conversational data specifically

## Related Work

- Cosmopedia (HuggingFace) — large-scale synthetic pretraining
- BeyondWeb — generator model scaling laws
- Quanta Hypothesis (Eric Michaud) — capabilities unlock discretely, not continuously
