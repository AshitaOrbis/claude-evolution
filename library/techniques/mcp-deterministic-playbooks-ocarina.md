# Ocarina — Deterministic MCP Playbooks (No LLM in the Loop)

**Source**: https://github.com/msradam/ocarina
**Date**: 2026-06-28 (integrated 2026-07-19)
**Type**: technique (optional evaluation harness, documented — not a runtime dependency)
**Score**: 78.25/100 (approved 2026-07-02)

## What It Does

Ocarina turns MCP workflows into **deterministic YAML playbooks** that execute without
a model in the loop: a playbook names the server, the tool calls in order, their
arguments, and what to do with outputs. Runs are reproducible byte-for-byte given the
same server state — no sampling, no prompt drift, no per-run token cost.

## Why This Matters

Two standing costs it attacks:

1. **Repeated tool-driving tokens.** Any MCP interaction an agent performs routinely
   (health check, fixed export, standard query sequence) pays model tokens every time to
   re-derive the same call sequence. A playbook pays once, at authoring time.
2. **Unreproducible MCP testing.** "The agent tried the server and it seemed fine" is
   not a regression test. A playbook is: same calls, comparable outputs, diffable across
   server versions.

## Where It Fits in This Pipeline

- **MCP evaluation harness (primary fit).** When evaluating a candidate MCP server,
  express the smoke tests as a playbook: list tools, call each with fixed inputs,
  capture outputs. Re-run the identical playbook after server updates or before
  promotion from sandbox — pairs with the Litmus behavioral gate
  (`library/techniques/mcp-litmus-safety-gate-2026-06-17.md`), which probes adversarial
  behavior while Ocarina pins down functional behavior. The companion note
  `library/techniques/deterministic-mcp-server-testing-ocarina-2026-06-29.md` covers the
  testing procedure in detail.
- **Routine MCP chores (secondary, later).** Fixed sequences currently driven by agents
  (event-bus maintenance queries, scheduled exports) are playbook candidates — but only
  after the harness use proves the tool out; it is young.

## Adoption Guidance

1. Start documentation-and-harness only: playbooks live in the evaluation sandbox, not
   in production automation.
2. A playbook is code — review it like a script (it executes tool calls with real
   side effects on whatever server it points at).
3. Keep playbooks pinned to sandbox/staging servers until the deterministic-testing
   procedure has caught at least one real regression; promote deliberately.

**Tags**: `ocarina`, `mcp-playbooks`, `deterministic-execution`, `no-llm-loop`,
`mcp-evaluation`, `token-efficiency`, `reproducibility`
