---
date: 2026-04-29
topic: "https://github.com/lechmazur/position_bias - Likely important for our LLM as judge regimens"
discord_message_id: "1498849758461296791"
status: complete
---

# LLM Position Bias Benchmark: Critical Finding for Our Judge Pipelines

## Topic
Look into github.com/lechmazur/position_bias — likely important for our LLM as judge regimens.

## Key Findings

- **Position bias in LLM judges is severe and systematic**: the benchmark shows a model-average first-shown pick rate of 63.3% (vs a fair 50% baseline) — judges significantly prefer whichever candidate is shown first
- **GPT-5.4 (high reasoning) is among the worst performers**: 66.3% order-flip sensitivity — the model we use as our primary reviewer in the publication-review pipeline has above-average position bias
- **Median model flips its underlying choice in 44.8% of decisive pairs**: nearly half the time, a judge would pick a different winner if you just swapped the order of presentation
- **This directly threatens our DSPy evaluation pipeline**: our prompt optimization uses LLM judges to score "which output is better" — if position determines 44–66% of outcomes, we're partly measuring prompt order, not prompt quality
- **Best available models**: ByteDance Seed2.0 Pro (28.0% flip rate) and Xiaomi MiMo V2 Pro (19.8% flip rate) are the most position-robust judges tested, though neither is in our current stack
- **The benchmark methodology is sound**: tests each pair in both orders, measures order-flip rate as primary metric, uses 193 verified story pairs × 27 judge models × 386 prompts per model

## Details

lechmazur/position_bias operationalizes a well-known failure mode of LLM evaluation: when you ask a model "which is better, A or B?", it tends to pick A (or whichever comes first) at rates well above chance. The benchmark formalizes this with a story editing task: two editors apply identical bounded changes to a base story, a judge sees both variants, and then the same judge sees the variants in reverse order. An unbiased judge should pick the same underlying story both times; a biased judge flips.

The 63.3% first-shown pick rate means: on average, across all judge models tested, if you show Story A first, it wins 63% of the time. Only 36.7% of "A won" outcomes reflect genuine preference independent of order. For GPT-5.4 (high-reasoning), this jumps to ~66% — meaning roughly two-thirds of its comparisons are at least partially determined by presentation order, not content quality.

For our publication-review pipeline: we use GPT-5.4 as the primary factual reviewer, but we're not currently doing head-to-head comparisons in that pipeline — we're doing single-document critique, which is different. Position bias is most acute in *pairwise comparison* tasks (A vs B). Single-document critique is somewhat less affected, though anchor bias (being more critical of what appears first in a long document) is a related phenomenon.

For our DSPy prompt optimization pipeline: this is where position bias is most dangerous. The optimizer runs pairwise comparisons between prompt outputs to determine which prompt version is better. If we're using LLM judges for these comparisons (and we are, via our `plan_quality_match` metric and publication-review holdout evaluations), position effects could be systematically inflating or deflating scores based on which candidate appears first in the prompt. This would corrupt the optimization signal and produce prompts optimized for presentation order, not quality.

**Mitigation strategies** used in the research literature:
1. **Dual ordering**: run every comparison in both orders, only count pairs where the judge agrees across orderings (the "decisive pair" approach used by this benchmark)
2. **Random ordering + averaging**: run multiple trials with randomized order, report win rate across trials
3. **Chain-of-thought + structured criteria**: explicit rubrics and reasoning before conclusion reduce position effects
4. **Use more position-robust judges**: Seed2.0 Pro (28% flip rate) is the current best available; MiMo V2 Pro at 19.8% but with coverage caveats

For our setup, the practical fix for pairwise evaluation is dual ordering: run the comparison in both orders, only use the result if the judge agrees in both directions, and treat disagreement as a tie. This doubles API calls but eliminates ~44–66% of false signal. The DSPy optimizer could implement this as a `robust_compare()` wrapper.

## Relevance to Workspace

Three active systems are affected:

1. **Publication-review pipeline** (`~/.claude/skills/publication-review/SKILL.md`): uses GPT-5.4 as a reviewer. Single-document critique mode is less affected than pairwise comparison. However, the "which round's output is better" judgments that happen during iteration could be affected. Low-priority fix.

2. **DSPy prompt optimizer** (`applications/dspy-prompt-optimizer/`): uses pairwise LLM evaluation for prompt optimization scoring. **High priority** — this is where corrupt evaluation signal has the most downstream harm.

3. **Autoreason-style comparisons** (backlog item): the proposed "tournament mode" for publication-review late rounds explicitly runs pairwise comparison (original vs adversarial vs synthesis). Position bias would need to be controlled for these to be reliable.

The `plan_quality_match` metric in the prompt optimizer uses a hybrid matching approach (anchor entities + char n-grams + keyword Jaccard) rather than pure LLM pairwise, which makes it more robust. But any workflow where we ask an LLM "is output A or B better?" is vulnerable.

## Recommended Actions

1. **Add `robust_compare()` wrapper to DSPy optimizer**: implement dual-order comparison (run A-vs-B and B-vs-A, only count decisive pairs where judge agrees), log flip rates per evaluation run to detect when bias is dominating
2. **Add position bias note to BACKLOG.md**: tag "any pairwise LLM comparison" as requiring dual-order validation before conclusions
3. **Benchmark our current judges**: run a small sample (20 pairs) from the publication-review pipeline through both orderings with GPT-5.4; measure our actual flip rate to calibrate whether 44% or 66% is the operative figure
4. **Consider Seed2.0 Pro for optimizer evaluation**: ByteDance Seed2.0 Pro has 28% flip rate and is available via API — worth testing as an alternative judge for DSPy optimizer pairwise comparisons where position bias is most harmful
