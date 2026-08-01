# Agent Containment — Defense-in-Depth Note

**Source**: https://www.anthropic.com/engineering/how-we-contain-claude
**Date**: 2026-06-26 (integrated 2026-07-19)
**Type**: doc-update (safety design note)
**Score**: 82.5/100 (approved 2026-06-28)

## The Point of This Note

Companion to the containment *checklist*
(`library/techniques/agent-containment-2026-06-25.md`). Where the checklist says
*what* to configure, this note records the *design argument*: containment must be
**defense-in-depth**, because every individual layer fails in a known way.

## Why Single Layers Fail

- **Approval prompts fail via fatigue.** Anthropic's article makes this measurable, and
  this repo has its own proof: the April 2026 `~/.bashrc` incident shipped through an
  evaluation that concluded "zero workflow impact." A human or model *judging* an action
  safe is one fallible layer, never the boundary itself.
- **Instructions fail via context.** "Never write outside the workspace" in a prompt is
  one injected sentence away from being outweighed. Prompt-level rules are the weakest
  layer and must always be backed by a structural one.
- **Sandboxes fail via scope creep.** A sandbox with credentials inside it, or broad
  egress, contains nothing that matters — the boundary exists but encloses the wrong
  set.

## The Layered Design

Each layer assumes the ones above it have already failed:

1. Prompt-level rules (cheapest, weakest — catches honest mistakes)
2. Granular tool permissions (blocks whole action classes regardless of reasoning)
3. Filesystem sandboxing, workspace-scoped writes
4. Egress controls, deny-by-default network
5. OS/VM isolation for untrusted code and content
6. Hard resource limits (budget/time/operation caps) that stop the run mechanically

A failure should have to defeat several *independent* mechanisms — approval fatigue
defeats layer 1 but not layer 4; a prompt injection defeats layer 1 but not layer 3.

## Application Rule for This Pipeline

When evaluating any proposal that says "the agent will be instructed not to X," ask
which *structural* layer enforces X when the instruction fails. If the answer is none,
the proposal is approval-gated, not autonomous — route it to `pipeline/pending-approval/`.

**Tags**: `defense-in-depth`, `agent-containment`, `approval-fatigue`, `sandboxing`,
`layered-safety`, `structural-boundaries`
