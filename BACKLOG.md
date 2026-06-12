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

## Confine Agent Writes Without Bash (Security)

**Source**: Security review follow-up, 2026-06-11
**Priority**: High
**Effort**: Medium

In review-gated mode the discovery/evaluation/helper agents run without Bash
but still hold unrestricted `Write` (integration additionally holds `Edit`).
The "only write to `pipeline/`/`registry/`" rules in the prompt files are soft
instructions, not a sandbox, so prompt-injected content fetched from the web
could direct a write to `~/.claude.json`, `.env`, `.git/hooks/`, etc. Path-
scoped `--allowed-tools` rules and `permissions.deny` settings were tested and
did **not** reliably constrain `claude -p` writes (see SECURITY.md).

**Robust fix options** (pick one, validate against a real run):
- Remove `Write` from the web-fetching phases; have each agent emit its
  results as JSON on stdout and let the wrapper script persist them to
  `pipeline/` via `jq` (deterministic, no agent filesystem authority).
- Run every phase inside a disposable container / low-privilege account with a
  bind-mounted repo and no access to the real `~/.claude` config.
- Re-evaluate Claude Code sandbox/permission features once the path-glob
  enforcement semantics for `Write`/`Edit` are confirmed working.

Until one of these lands, unattended runs should follow the container/account
guidance in SECURITY.md rather than trusting the prompt-level rules.
