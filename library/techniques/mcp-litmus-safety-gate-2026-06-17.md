# Polygraph Litmus — MCP Pre-Integration Behavioral Safety Gate

**Source**: https://github.com/polygraphso/litmus
**Date**: 2026-06-17 (integrated 2026-07-19)
**Type**: technique (evaluation-pipeline procedure)
**Score**: 71.75/100 (approved 2026-06-23)

## What It Does

Litmus is an MCP behavioral testing harness: it exercises a candidate MCP server and
checks how it behaves under adversarial conditions, rather than how its README says it
behaves. Checks include:

- **Tool-output injection** — does the server emit content crafted to steer the consuming
  model (embedded directives, fake system messages) in its tool results?
- **Permission / egress behavior** — what does the server actually touch and where does
  it actually connect, versus what it declares?
- **Canary data handling** — plant marked data in inputs; verify it does not leak into
  logs, third-party calls, or unrelated outputs.
- **Adversarial input behavior** — malformed/hostile inputs should degrade safely, not
  trigger surprising tool behavior.

## The Procedure Adopted Here

Before proposing any new third-party MCP server for integration, the evaluation should
include **Litmus-style behavioral evidence** — either an actual Litmus run in a sandbox,
or an equivalent manual check covering the same four axes. README review alone is not
sufficient evidence; this is the same "empirical gates over changelog trust" lesson the
pipeline already learned in April 2026, applied to MCP servers specifically.

Practical checklist for an MCP candidate evaluation:

1. Run the server in an isolated sandbox (no credentials, scratch filesystem).
2. Capture tool outputs for a handful of normal calls — grep them for
   instruction-shaped content (injection axis).
3. Observe filesystem + network activity vs. the server's declared scope (permission /
   egress axis).
4. Feed a canary string through each tool input; verify it appears only where expected.
5. Record results in the evaluation JSON before the item reaches `pipeline/integration/`.

## Caveats

- Litmus itself is young with low community validation — adopt the *procedure*; treat
  the tool as one implementation of it, and re-check its maturity before depending on it.
- Complements, does not replace, static config scanning (secrets, path scope) — those
  are covered by the separate agentlint-class proposals.

**Tags**: `mcp-safety`, `pre-integration-gate`, `behavioral-testing`,
`prompt-injection`, `egress-audit`, `canary-testing`, `litmus`
