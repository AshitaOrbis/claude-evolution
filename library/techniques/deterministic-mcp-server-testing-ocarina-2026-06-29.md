# Deterministic MCP Server Testing with Ocarina — Replay/Assertion Procedure

**Source**: https://github.com/msradam/ocarina
**Date**: 2026-06-29 (integrated 2026-07-19)
**Type**: technique (testing procedure; documentation-first, no runtime dependency)
**Score**: 76.5/100 (approved 2026-07-02)

## What This Adds

The companion playbook note
(`library/techniques/mcp-deterministic-playbooks-ocarina.md`) records *what* Ocarina
is; this note records the **testing procedure**: using YAML playbooks **with
assertions** to make MCP server evaluation reproducible and token-free.

An Ocarina test playbook = ordered tool calls with fixed inputs + assertions on each
output (schema shape, required fields, value constraints). Running it requires no model:
pass/fail comes from the assertions, identically every run. This replaces "an agent
poked at the server and it seemed fine" with a rerunnable artifact.

## The Procedure

1. **Enumerate** the candidate server's tools (`tools/list`); the playbook must touch
   every tool the evaluation claims to have assessed.
2. **Fix inputs** — deterministic, minimal, no live-data dependencies where avoidable.
   Nondeterministic backends (search, LLM-backed tools) get shape assertions, not
   content assertions.
3. **Assert on structure first**: response validity, declared schema conformance,
   error behavior on invalid input (a server that 500s or hangs on malformed input
   fails the playbook, and that IS the finding).
4. **Record the run artifact** (playbook + outputs + pass/fail) in the evaluation —
   this is the "Verification" evidence for the MCP security template
   (`pipeline/evaluation/templates/mcp-server-security.md`, check 4).
5. **Re-run on change**: server version bump, config change, or promotion from sandbox
   → identical playbook, diff the results. Regressions surface as assertion diffs, not
   as anecdotes.

## Boundaries

- **Documentation-first adoption**: Ocarina is young; it runs only inside the
  evaluation sandbox against candidate servers, never as a production dependency or
  against live servers holding real credentials.
- Playbooks execute real tool calls — treat playbook files as code under review, and
  point them only at sandboxed/staging instances.
- Deterministic testing pins *functional* behavior; it does not probe adversarial
  behavior — that remains the Litmus-style gate's job. The two together, plus the
  Capframe external signal, form the full MCP pre-integration battery.

**Tags**: `ocarina`, `mcp-testing`, `deterministic-testing`, `replay-assertions`,
`regression-testing`, `mcp-evaluation`, `sandbox`
