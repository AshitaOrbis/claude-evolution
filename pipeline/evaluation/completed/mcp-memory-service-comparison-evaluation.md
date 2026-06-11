# Evaluation: mcp-memory-service (Memory Comparison)

- **Date**: 2026-02-06
- **Source**: https://github.com/doobidoo/mcp-memory-service
- **Category**: IMPROVEMENT (compare to Official Memory System)
- **Automated**: Yes (daily heartbeat)

## Redundancy Check Result

**DUPLICATE** - Official Memory System (Claude Code 2.1.32+) supersedes this capability.

## Comparison

| Feature | mcp-memory-service | Official Memory System (2.1.32+) |
|---------|-------------------|----------------------------------|
| Status | Community MCP (1,200+ stars) | Built-in to Claude Code |
| Token Overhead | 5-10k baseline + tools | Zero (native) |
| Cross-project isolation | Manual configuration | Native handling |
| Auto-injection | Optional | Context-aware |
| Maintenance | Community-maintained | Anthropic-maintained |
| Integration effort | High (new MCP setup) | Zero (already active) |

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 20 | Would replace working built-in system |
| Token efficiency impact | 25% | 0 | Adds 5-10k token overhead vs. zero-cost native |
| Capability expansion | 25% | 30 | Semantic search is novel, but Official Memory handles core use case |
| Maintenance burden | 15% | 40 | More dependencies, potential conflicts |
| Community validation | 15% | 80 | 1,200+ stars, but superseded by official solution |

- **Claude Score**: 28.5/100
- **Codex Score**: N/A (service unavailable during evaluation)
- **Final Score**: 28.5/100

## Decision

**REJECTED** — 100% redundant with Official Memory System (Claude Code 2.1.32+).

## Rejection Rationale

1. **Official solution exists**: Claude Code 2.1.32+ has built-in memory system
2. **Token efficiency**: Native system is zero-overhead vs. 5-10k tokens
3. **Cross-project confusion risk**: Documented issues with memory bleeding across projects
4. **No advantage**: Semantic search doesn't justify token overhead when CLAUDE.md + library + Official Memory provide cleaner alternative

## Registry Entry

Already documented in registry under "Memory & Persistence":
- Official Memory System: **BUILT-IN** (Claude Code 2.1.32+)
- mcp-memory-service: **NOT NEEDED** (official system supersedes)

## Previous Deep Research (2026-01-16)

The discovery file notes critical issues:
- Cross-project confusion (MERN/Next.js memories bleeding)
- Auto-injection + compaction conflicts
- Token overhead (5-10k baseline)
- Session bloat (32% context full at start)

These concerns are resolved by the Official Memory System's native handling.
