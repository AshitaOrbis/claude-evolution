# Claude Evolution Backlog

Deferred improvements and ideas tracked from development sessions.

## Prompt Optimization for Review Subagents

**Source**: Model-Generation Audit (Post 037), March 2026
**Priority**: Medium
**Effort**: Medium

The publication-review pipeline uses three models (GPT-5.4, Gemini 3.1 Pro, Opus 4.6) with hand-written review prompts. Each model has a distinct orientation (fact-checking, structural analysis, argument rigor) but the prompts were designed by intuition, not optimized.

**Opportunity**: Use the DSPy-inspired prompt optimizer (`dspy-prompt-optimizer`) to systematically improve the review prompts. The audit produced a natural training signal: findings that were genuine errors vs false positives vs precision preferences. This labeled data could train better prompts that increase true positive rate and reduce false positives.

**Specific targets**:
- GPT-5.4 fact-checking prompt: reduce precision-preference false positives (a significant fraction of GPT-only flags were downgraded during triage)
- Gemini structural review prompt: Gemini caught 4 issues after two full GPT+Opus rounds, suggesting its structural orientation is undertapped
- Opus adversarial prompt: only caught 10 items vs GPT's 95; may be under-prompted for fact-checking specifically (its strength is argument analysis, but the gap is large)

**Training data available**:
- 33 posts x 3 models = ~99 review files with labeled findings
- 27 fix manifests with triage decisions (MUST/SHOULD/NICE/DISCARDED)
- 27 fix logs with applied vs skipped items
- Phase 1 → Phase 2 error trajectory (what was missed, what was introduced)

**Approach**: Bootstrap optimization on the review prompts using the fix manifests as ground truth. The manifest triage decisions (genuine error vs precision preference vs false positive) provide the supervision signal. Optimize for recall on genuine errors while minimizing false positive rate.

**Dependencies**: `dspy-prompt-optimizer` project, `publication-review` skill
