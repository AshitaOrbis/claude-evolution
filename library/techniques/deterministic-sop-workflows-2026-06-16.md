# Deterministic SOP Workflows for High-Risk Recurring Tasks

**Source**: https://github.com/s0912758806p/agentic-sop-to-work
**Date**: 2026-06-16 (integrated 2026-07-19)
**Type**: technique (workflow pattern)
**Score**: 73.5/100 (approved 2026-07-08)

## What It Does

agentic-sop-to-work converts human standard operating procedures into deterministic,
gated agent workflows. Instead of handing an agent a prose SOP and trusting it to follow
along, the SOP is decomposed into single-tool steps, each wrapped in hermetic gates:
a command gate (the exact command that may run), a schema gate (the shape the output must
match), and a trace gate (evidence recorded per step). Side effects only happen at
explicitly controlled points, after human approval.

This matches the April 2026 lesson from this pipeline's own history (the
`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` incident): autonomous changes need empirical gates,
not trust in changelogs or prose reasoning.

## The Pattern

1. **Decompose** the recurring task into steps that each use exactly one tool/command.
2. **Gate each step hermetically** — declare the allowed command, the expected output
   schema, and record a trace. A step that produces out-of-schema output halts the run
   instead of improvising.
3. **Emit DRAFT outputs** — the workflow's product (config change, report, PR) is
   produced as a draft artifact, never applied directly.
4. **Approve at controlled points** — a human (or a stricter gate) reviews the draft
   before any side effect executes.

## When To Use

- Recurring ops tasks where fabrication or uncontrolled autonomy is costly: config
  migrations, dependency bumps, release checklists, data transformations.
- Anywhere this repo currently relies on an agent "following the playbook" from prose —
  candidates: heartbeat maintenance jobs, queue-GC procedures, integration runs like
  this one.
- NOT for exploratory or creative work — determinism buys safety at the cost of
  flexibility; use it only where the procedure is genuinely fixed.

## Relationship to Existing Practice

This is the same philosophy as the existing sandbox-test-before-propose rule in
`INTEGRATE-APPROVED.md`, generalized from config changes to any recurring procedure.
The DRAFT-then-approve step is already how `pipeline/pending-approval/` works; the new
part is per-step command/schema/trace gating rather than end-of-run review only.

## Open Questions

- Whether the repo's own heartbeat scripts are worth porting to explicit per-step gates,
  or whether the existing `set -euo pipefail` + jq validation is close enough.
- Tool maturity: the upstream repo is young; adopt the pattern, not the dependency.

**Tags**: `deterministic-workflow`, `sop`, `gated-execution`, `draft-outputs`,
`approval-gate`, `ops-safety`, `recurring-tasks`
