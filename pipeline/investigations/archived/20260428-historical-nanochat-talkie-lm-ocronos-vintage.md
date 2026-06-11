---
date: 2026-04-28
topic: "Look into these for historical nanochat influences - talkie-lm, OCRonos-Vintage"
discord_message_id: "1498688997902516397"
status: complete
---

# Historical Language Models: talkie-lm and OCRonos-Vintage

## Topic
Look into talkie-lm (https://huggingface.co/talkie-lm) and OCRonos-Vintage (https://huggingface.co/PleIAs/OCRonos-Vintage) for historical nanochat influences.

## Key Findings

- **talkie-lm is conceptually the closest external parallel to historical nanochat**: 13B-parameter models trained exclusively on pre-1931 English text; the instruction-tuned variant (`talkie-1930-13b-it`) is the most usable; non-profit by Alec Radford (OpenAI co-founder) and Nick Levine
- **OCRonos-Vintage is a different but complementary tool**: a tiny 124M GPT-2-based model purpose-built for OCR correction of pre-1956 cultural heritage text — not a chat model, but potentially useful at a corpus preprocessing step
- **Historical nanochat is at a more ambitious scale and scope**: talkie-lm uses a 13B base (vs our growing governed corpus approach with a custom tokenizer); OCRonos is 124M specialized; neither is building toward an interactive product with a corpus governance model
- **OCRonos preprocessing is directly actionable**: our governed corpus contains scraped archive material that almost certainly has OCR noise; running OCRonos as a preprocessing pass is low-cost and could measurably improve training quality
- **talkie-lm's instruction-tuned variant is worth running a side-by-side**: it represents what a well-executed version of the same vision looks like at 13B — comparing outputs against our model at equivalent loss points would reveal what we're gaining or losing relative to scale
- **Both projects are open-source with permissive licenses**: direct study of training recipes and data composition strategies is viable

## Details

**talkie-lm** was trained by a non-profit team including Alec Radford (GPT-1/2 co-author) using pre-1931 public domain English text. The instruction-tuned version (`talkie-1930-13b-it`) produces period-appropriate English when prompted. Key architectural difference: they started from a 13B base rather than training from scratch, which means their "historical character" is a fine-tuning artifact on top of a modern language model — the model will likely revert to modern patterns under distribution pressure. Historical nanochat is training a model where historical text is the *pretraining* distribution, a fundamentally stronger approach for producing authentic historical language generation. Their download counts (49–137) suggest the project has limited adoption.

**OCRonos-Vintage** (PleIAs/OCRonos-Vintage) is a 124M parameter GPT-2 model trained on 18B tokens of cultural heritage archive material from Library of Congress, Internet Archive, and Hathi Trust — all pre-December 1955, with ~65% from 1880–1920. Its primary task is OCR error correction: given a noisy digitized string, produce a clean version. Performance benchmark: >10k tokens/second on GPU, CPU-compatible, comparable to GPT-4 for English cultural archives OCR tasks. This is highly relevant as a preprocessing pass because our governed corpus pulls from the same source institutions (Gutenberg, Hathi Trust equivalents) and likely contains systematic OCR noise patterns that OCRonos was specifically trained to fix. A clean corpus should produce a model with lower perplexity on valid historical vocabulary and fewer garbage-token memorization artifacts.

The X post (https://x.com/i/status/2048878066273861646) was inaccessible via WebFetch (X authentication wall), but contextually was likely discussing one or both of these projects.

The historical nanochat governed v4 run has just reached step 10,000 with excellent trajectory (val BPB 1.2406 at step 10k, down from 3.89 at init; train loss 2.330 from 9.255). This timing is good: OCRonos-based corpus preprocessing is a Phase-0 concern, not an active training concern, so it would apply to the next governed run rather than the current one.

## Relevance to Workspace

Historical nanochat is actively training (`governed_v4_d22_r30_parallel_family`, step 10k+ as of 2026-04-28). The project uses a custom 32k vocabulary tokenizer trained on historical text, plus a Phase-0-lite governed corpus pipeline with rights/date audits and repacking. talkie-lm and OCRonos-Vintage both fit this research track:

- **OCRonos**: applicable immediately as a Phase-0-lite preprocessing step before repacking. Could be integrated into `repacker_v3.py` or as a separate `ocr_correct.py` preprocessing pass on raw JSONL before it enters the token cache.
- **talkie-lm 13b-it**: useful as a benchmark comparison point — not a replacement, but a reference output to compare against at equivalent loss points. Their architecture (13B fine-tune) vs ours (scratch-trained) also serves as a design contrast worth documenting.

## Recommended Actions

1. **Evaluate OCRonos-Vintage for Phase-0-lite preprocessing**: Run it against a sample from the governed corpus (e.g., 10k documents from Library of Congress or Hathi Trust JSONL) and compute a before/after character error rate. If it reduces noise without introducing anachronisms, integrate as a preprocessing step in the repacking pipeline.
2. **Run talkie-lm 13b-it side-by-side**: Generate historical prompt responses from our model (at current checkpoint) and from talkie-lm 13b-it using the same prompts. Document comparative outputs in `docs/model-comparisons/`.
3. **File an issue for OCRonos integration in historical-nanochat backlog**: Tag as Phase-0-lite concern, not current-run concern.
