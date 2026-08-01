# Flow-Next — Repo-Owned Specs, Re-Anchored Workers, Evidence Receipts

**Source**: https://github.com/gmickel/flow-next
**Date**: 2026-06-26 (integrated 2026-07-19)
**Type**: technique (workflow pattern, extracted — plugin not installed)
**Score**: 76.8/100 (approved 2026-06-28)

## What It Is

Flow-Next is a mature workflow framework for agent-driven development. Four of its
mechanisms are worth adopting as patterns without installing the tool:

1. **Repo-owned specs.** The spec for a piece of work lives in the repository as a
   durable artifact — not in a chat transcript. Workers derive their instructions from
   the spec file; the spec survives session death, model swaps, and handoffs.
2. **Re-anchored workers.** Long-running work is executed by workers that are
   periodically *re-anchored*: restarted from the durable spec + current repo state
   rather than continuing on an ever-growing conversational context. Fresh context,
   same ground truth — drift dies at each re-anchor point.
3. **Adversarial review.** A separate reviewer role attacks the produced change against
   the spec (not against the worker's own narrative of what it did). The reviewer reads
   spec + diff, never the worker's self-report.
4. **Evidence receipts.** Every completed step emits a receipt: what was claimed, the
   command/observation proving it, timestamp. Receipts accumulate into an auditable
   trail that a later session (or human) can verify without re-running everything.

## Why This Fits Here

This workspace already runs pieces of the pattern under other names: plan files in
`orchestration/plans/`, subagent provenance requirements, verification reports in
`pipeline/verification/`, and the night-shift "green harnesses over-claim" lesson —
which is exactly the case for receipts over narratives. Flow-Next's contribution is
composing them: **spec (durable) → worker (re-anchored) → reviewer (adversarial,
spec-vs-diff) → receipts (evidence trail)** as one loop.

## Adoption Guidance

- For multi-session builds: put the spec in the repo first; treat any instruction that
  exists only in a transcript as not yet real.
- Re-anchor instead of resuming when a worker session exceeds a natural checkpoint —
  cheaper than dragging stale context, and it forces the spec to stay truthful.
- Reviewers verify against the spec and the diff; a worker's completion summary is
  never input to the verdict.

**Tags**: `flow-next`, `repo-owned-specs`, `worker-reanchoring`, `adversarial-review`,
`evidence-receipts`, `workflow-pattern`, `drift-control`
