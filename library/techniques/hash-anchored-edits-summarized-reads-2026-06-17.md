# oh-my-pi Harness Patterns — Hash-Anchored Edits, Summarized Reads, LSP-First Context

**Source**: https://github.com/can1357/oh-my-pi
**Date**: 2026-06-17 (integrated 2026-07-19)
**Type**: technique (harness design patterns, extracted — not a tool adoption)
**Score**: 82.5/100 (approved 2026-06-23)

## What It Does

oh-my-pi is a community coding-agent harness whose documentation describes several
token-efficiency mechanisms worth knowing independently of the tool itself:

1. **Hash-anchored edits** — instead of matching an edit target by quoting a full
   `old_string`, the harness addresses regions by a short content hash anchor. The model
   references the anchor; the harness resolves it to the exact bytes. This cuts the
   redundant round-trip of echoing large verbatim spans into the context just to locate
   an edit, and fails closed when the underlying content changed (hash mismatch =
   stale-context signal, like an optimistic-concurrency check).
2. **Summarized reads** — file reads return a structural summary (signatures, headings,
   outline) by default, with full-fidelity reads on demand for the specific region being
   edited. The inversion: full content is the *escalation*, not the default.
3. **LSP-first context** — "where is this symbol defined/used" questions go to a
   language server rather than grep + full-file reads, returning precise, small answers.
4. **Optimized search** — search results are deduplicated and windowed before entering
   the context.

Upstream publishes benchmark claims for these; treat the claims as unverified until
benchmarked locally.

## Comparison to Current Workflow

| Mechanism | oh-my-pi | Claude Code today |
|-----------|----------|-------------------|
| Edit addressing | hash anchor | verbatim unique `old_string` (Edit tool) |
| Read default | summary, escalate to full | full lines (bounded by limit/offset) |
| Symbol navigation | LSP query | Grep/Glob + Read |
| Stale-edit detection | hash mismatch | read-before-edit requirement |

The interesting deltas are (1) and (2): Claude Code's Edit already requires uniqueness
but pays the verbatim-quote cost, and Read supports offsets but defaults to content, not
structure. The read-only part of (2) is approximable today with discipline: read the
outline (grep for signatures/headings) before reading bodies.

## When To Reach For This

- When designing any local harness, MCP tool, or subagent protocol that moves file
  content through a model: default to summaries + precise escalation, and use content
  hashes as cheap staleness checks on write paths.
- When a benchmark of edit-heavy sessions shows verbatim-echo cost dominating — that is
  the signal to prototype anchor-style addressing in a custom tool.

## Open Questions

- Do the published benchmark numbers replicate on this workspace's session mix?
- Does hash anchoring measurably reduce failed-Edit retries vs. unique-string matching?

**Tags**: `token-efficiency`, `harness-design`, `hash-anchored-edits`,
`summarized-reads`, `lsp`, `edit-addressing`, `oh-my-pi`
