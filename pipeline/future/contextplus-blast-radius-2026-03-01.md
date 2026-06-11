# Future: Blast Radius / Call-Graph Impact Analysis

- **Source**: https://github.com/ForLoopCodes/contextplus
- **Date Found**: 2026-03-01
- **Category**: MCP Server (code intelligence)
- **Status**: NOT ADOPTED — tracking the concept, not the specific tool

## The Gap

No tool in our current setup provides call-graph-level impact tracing before refactors. The question "if I change this function signature, what else breaks?" currently requires manual Grep + LSP `findReferences` + human judgment.

contextplus's `get_blast_radius` is the only tool we've seen that addresses this directly, but it requires Ollama running locally — a hard infrastructure dependency we don't want to add for one feature.

## What We're Watching For

A lighter tool that provides blast-radius / impact analysis WITHOUT requiring:
- Local GPU / Ollama instance
- A full MCP server with 10 other redundant tools (semantic search = mgrep, etc.)

Ideal form: a standalone CLI tool or a focused MCP with 1-3 tools, cloud-based or using tree-sitter AST parsing alone (no embeddings needed for call-graph tracing).

## Alternatives to Monitor

- **ast-grep** (`ast-grep.github.io`) — structural search/replace using AST patterns, Rust CLI
- **semgrep** (already integrated) — could potentially be extended for impact analysis
- **LSP `incomingCalls` / `outgoingCalls`** — built-in Claude Code LSP tool, already available but requires per-symbol manual queries
- **TypeScript compiler API** — `tsc --listFiles` + reference tracing, no external tool needed

## Revisit Trigger

- A focused blast-radius tool appears without Ollama dependency
- contextplus drops the Ollama requirement
- We add Ollama to our stack for other reasons (local model hosting, etc.)

## contextplus Full Assessment

- ~1k stars, 54 commits, MIT license
- 60%+ overlap with mgrep (semantic search)
- `propose_commit` conflicts with Claude Code write model
- "99% accuracy" claim has no published benchmarks
- Low maturity signal
