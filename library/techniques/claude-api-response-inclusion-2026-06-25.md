# Claude API Token Efficiency — response_inclusion + Code-Execution Cell Limits

**Source**: https://platform.claude.com/docs/en/release-notes/overview
**Date**: 2026-06-25 (integrated 2026-07-19)
**Type**: technique (official API feature note)
**Score**: 84.5/100 (approved 2026-06-28)

## response_inclusion for Server-Side Web Tools

The Anthropic API's server-side web tools (`web_search_20260318`,
`web_fetch_20260318`) support a **`response_inclusion`** control governing how much of
each result block is returned into the conversation context. For agentic workflows that
issue many searches/fetches but act on only a fraction of the content, trimming the
included payload cuts context growth at the source — the model still *used* the full
result server-side; the conversation only carries what the next turn needs.

When to reach for it:

- High-fan-out research loops (many queries, few load-bearing results) — include
  summaries/snippets rather than full blocks.
- Long-running agent sessions where accumulated tool results are the dominant context
  cost (the same failure mode the local PostToolUse/spill-to-file patterns address, but
  fixed at the API layer for server-side tools).
- NOT when downstream turns must quote or diff the fetched content verbatim — fidelity
  fetches should keep full inclusion.

## Code Execution Tool — 90-Second Cell Limit

The same release notes disclose that the code execution tool
(`code_execution_20260521`) enforces a **90-second per-cell execution limit**. Plan
long-running work as multiple short cells with checkpointed intermediate state (write
partial results to the sandbox filesystem between cells) instead of one monolithic cell
that will be killed mid-run.

## Relevance Here

Most workspace automation runs through Claude Code (subscription), not the raw API, so
this lands mainly in: (a) any future direct-API tooling built in this repo, and (b) the
registry as capability knowledge so evaluations of "context bloat from web tools" don't
reinvent an official control. It is the API-layer sibling of the local techniques
already indexed (spill-to-file, summarized reads, PostToolUse sandboxing).

**Tags**: `anthropic-api`, `response-inclusion`, `web-search-tool`, `web-fetch-tool`,
`code-execution`, `cell-limit`, `token-efficiency`
