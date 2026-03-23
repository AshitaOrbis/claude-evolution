# Anchor-Based Paraphrase Matching for Review Metrics

**Date**: 2026-03-23
**Context**: Publication-review prompt optimization (DSPy pipeline)
**Applicable when**: Matching findings/items between a gold-standard reference and model-generated output where both describe the same source material but use different vocabulary.

## Problem

When comparing human-triaged review findings against AI-generated review findings, standard text similarity (Jaccard, cosine on bag-of-words, even crude stemming) fails catastrophically. Scores of ~0.08 on pairs a human would rate as obvious matches.

**Why it fails**: The gold standard quotes the source document ("under a tenth of a second on raw, half a second on Astro") while the model uses analytical language ("load times cited lack testing conditions"). Almost no vocabulary overlap despite describing the same issue.

## Solution: 3-Signal Hybrid Matcher

### Signal 1: Anchor Entities (50% weight)

**Insight**: Both the reference and the model output discuss the same source document. Proper nouns, numbers, and technical terms are preserved across paraphrases because they're intrinsic to the topic, not the reviewer's phrasing.

**Extract from both texts**:
- Numbers with units: `40%`, `2025`, `0.34s`, `8KB`
- Proper nouns: `Next.js`, `Changshu`, `Astro`, `Facebook`
- Technical terms from a domain-specific gazetteer
- Significant words from quoted phrases (inside `"..."`)

**Comparison**: Szymkiewicz-Simpson coefficient (overlap / min set size), NOT Jaccard. This handles asymmetric lengths — a terse model finding matching against a verbose manifest description.

### Signal 2: Character N-Grams (30% weight)

**Insight**: Character 3-grams and 4-grams catch partial word overlaps that word-level matching misses. "methodology" and "methodological" share many n-grams. "performance" and "performing" share n-grams.

**Method**: Extract all 3-grams + 4-grams from lowercased, whitespace-normalized text. Compare using Szymkiewicz-Simpson.

### Signal 3: Keyword Jaccard (20% weight)

**Insight**: Standard content-word Jaccard still contributes as a broad fallback. Use crude stemming (first 5 chars of words >= 6 chars) to bridge some vocabulary gaps.

**Method**: Extract content words, remove stopwords, add 5-char stems, compute Jaccard.

### Combined Score

```
score = 0.50 * anchor_overlap + 0.30 * ngram_coverage + 0.20 * keyword_jaccard
```

### Threshold

Use **0.15** for matching. This catches entity-anchored matches (scores 0.35-0.63 on true positives) while cleanly rejecting false matches (scores <0.10 on true negatives).

## Results

| Pair | Jaccard Only | Hybrid | Improvement |
|------|-------------|--------|-------------|
| Performance numbers | 0.08 | 0.35 | 4.4x |
| 40% benchmark | 0.10 | 0.63 | 6.3x |
| Changshu copyright | 0.08 | 0.59 | 7.4x |
| Identical content | 0.11 | 0.55 | 5.0x |
| Negative: perf vs overclaim | 0.05 | 0.01 | Clean reject |
| Negative: Changshu vs EU | 0.08 | 0.10 | Clean reject |

Holdout scores improved from 0.318 → 0.492 (Opus) and 0.266 → 0.395 (Gemini) on unchanged model output, purely from the metric improvement.

## When to Use This Pattern

- **Review/audit matching**: Comparing findings between different reviewers or between a gold standard and model output
- **Fact-checking verification**: Matching claims flagged by one system against claims in another
- **Any "same source, different language" comparison**: Both texts reference the same underlying document/data but use different vocabulary to describe issues

## When NOT to Use

- **Open-domain paraphrase detection**: Without a shared source document, anchors don't help
- **Short texts without entities**: If neither text contains proper nouns, numbers, or technical terms, fall back to embedding-based similarity
- **When API calls are available**: Embedding models (e.g., text-embedding-3-large) or LLM-as-judge will outperform this on pure paraphrase detection

## Key Design Decisions

1. **Szymkiewicz-Simpson over Jaccard**: The reference description is often 3-5x longer than the model output. Jaccard penalizes this asymmetry; Simpson handles it by dividing by the smaller set.

2. **Domain-specific gazetteer**: The `_KNOWN_TECH_TERMS` frozenset dramatically improves anchor extraction for technical content. Extend it for your domain.

3. **Quoted phrase extraction**: The gold standard often quotes the source document in `"..."`. Extracting significant words from those quotes provides high-precision anchors.

4. **3-gram + 4-gram, not higher**: Longer n-grams (5+) become too specific and lose the partial-overlap benefit. Shorter (2-grams) are too noisy.

## Implementation

See `dspy-prompt-optimizer/lib/prompt_optimizer/extractors.py`:
- `_extract_anchors()` — anchor entity extraction
- `_char_ngrams()` — character n-gram extraction
- `hybrid_finding_similarity()` — combined scoring
- `match_review_findings()` — bipartite matching with threshold

Cross-validated with GPT-5.4 research (Codex) which independently recommended the same anchor-first approach.
