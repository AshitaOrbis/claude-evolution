# Evaluation: Pydantic Monty - Sandboxed Python Subset in WebAssembly

- **Date**: 2026-02-07
- **Source**: https://simonwillison.net/2026/Feb/6/pydantic-monty/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 30 | Hard - Requires Rust toolchain, WebAssembly compilation, understanding of Python subset limitations. Not a drop-in replacement for standard Python. Significant learning curve. |
| Token efficiency impact | 25% | 50 | Neutral - Doesn't directly affect Claude Code token usage. Designed for browser/untrusted web environments where Python doesn't natively run, not our CLI context. |
| Capability expansion | 25% | 30 | Limited - We already run Python via Bash tool with full standard library access. Monty's sandboxing is designed for browser contexts. For untrusted agent code execution, we have OpenClaw's Docker-based sandbox (more mature isolation). |
| Maintenance burden | 15% | 40 | Medium-High - Requires maintaining Rust+WASM toolchain, tracking Python subset compatibility, managing Pydantic version coupling. Browser-focused = not our deployment environment. |
| Community validation | 15% | 90 | High - Official Pydantic release from trusted team. Covered by Simon Willison (reliable technical source). Pydantic has strong credibility (27.6k stars, widely adopted). |

- **Claude Score**: 45.5/100
- **Codex Score**: N/A (MCP connection error)
- **Final Score**: 45.5/100

## Decision

**REJECTED** — Solves a problem we don't have (sandboxed Python in browser environments).

## Why Rejected

1. **Wrong execution context**: Monty is designed for WebAssembly/browser environments. Claude Code runs in a terminal with direct OS access. We execute Python via `bash -c "python script.py"` with full standard library.

2. **Redundant sandboxing**: For untrusted code execution (e.g., OpenClaw agent), we use Docker containers with filesystem isolation and egress proxy. This provides stronger security than WASM sandboxing and works for all languages, not just Python subsets.

3. **Python subset limitations**: Monty runs a limited Python subset. We need full Python capabilities for data processing, API calls, file I/O, etc. Trading full Python for sandboxing makes no sense in our context.

4. **Integration complexity vs value**: Rust toolchain + WASM compilation + subset limitations = high complexity for zero practical benefit in CLI environment.

## Comparison to Existing Solutions

| Solution | Use Case | Security Model | Language Support |
|----------|----------|----------------|------------------|
| **Bash + Python** | Trusted code execution | OS permissions | Full Python + stdlib |
| **OpenClaw Docker** | Untrusted agent code | Container isolation | All languages |
| **Pydantic Monty** | Browser Python execution | WASM sandbox | Python subset only |

Our existing solutions cover both trusted (Bash) and untrusted (Docker) execution contexts with stronger capabilities.

## Future Reconsideration Triggers

- If we build browser-based tools that need client-side Python execution
- If we need to embed Python in WebAssembly applications
- If we develop browser extensions requiring sandboxed Python

**Current status**: Not applicable to Claude Code CLI workflows. Archive as rejected.
