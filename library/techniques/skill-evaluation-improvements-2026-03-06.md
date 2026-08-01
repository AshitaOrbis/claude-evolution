# Skills 2.0 Evaluation Improvements

**Date**: 2026-03-06
**Source**: Anthropic Claude Code Skills 2.0 release
**Category**: Technique
**Tags**: prompt-optimization, assertion-testing, model-drift, failure-analysis

## What Was Adopted

Three improvements from Anthropic's Skills 2.0 eval/A/B testing framework, integrated into our existing DSPy-inspired prompt optimizer:

### 1. Assertion-Based Test Format

**What**: JSON assertions as a lightweight alternative to full Python metric functions.

**Why**: Writing a Python metric function for each new skill is expensive. For simple skills where you just need to check "output contains X" or "output doesn't mention Y", assertions are faster to author.

**Implementation**: `assertion_metric()` in `lib/prompt_optimizer/metrics.py`

Supported types: `contains`, `not_contains`, `matches_regex`, `min_length`, `max_length`

```json
{"input": "Should I use grep or mgrep for 'handleSubmit'?", "assertions": [{"type": "contains", "value": "grep"}, {"type": "not_contains", "value": "mgrep"}]}
```

### 2. Model Drift Detection

**What**: Track which model optimized each target; warn when verifying with a different model.

**Why**: Prompt optimizations are model-specific. An optimization tuned for Opus may score differently on Sonnet. Without tracking, you can't tell if a score drop is a real regression or just a model mismatch.

**Implementation**:
- `optimized_with_model` field on `OptimizedPrompt` dataclass
- `--check-model-drift` flag on `verify_optimizations.py`
- Backfilled `opus-4-6` on all 13 existing targets in `status.json`

### 3. Failure Analyzer Pass

**What**: Structured breakdown of why examples failed, with cross-failure pattern detection.

**Why**: Knowing a score is 0.35 doesn't help you fix the problem. Seeing "expected keywords missing from actual: authentication, middleware, jwt" tells you what to adjust.

**Implementation**: `--analyze-failures` flag on `verify_optimizations.py` — purely programmatic (zero token cost).

## What Was Skipped

| Feature | Reason |
|---------|--------|
| Tessl CI/CD integration | Paid service, not needed for local optimizer |
| Auto-regression triggers on model releases | Token budget constraint — manual verification runs only |
| Comparator agent pattern | Already have A/B testing via `run_ab_test.py` |

## How This Extends the Existing Optimizer

Our DSPy-inspired system already had: BootstrapFewShot, COPRO, Iterative algorithms, holdout/CV verification, 15+ domain-specific Python metrics. The Skills 2.0 improvements add:

- A cheaper authoring path (assertions) for new skill tests
- Provenance tracking (which model, when) for reproducibility
- Diagnostic tools (failure analysis) for debugging poor scores

The core optimization loop is unchanged. These are quality-of-life improvements, not architectural changes.
