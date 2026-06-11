# Evaluation: OpenPlanter (ShinMegamiBoson)

- **Source**: https://github.com/ShinMegamiBoson/OpenPlanter
- **Date Evaluated**: 2026-03-13
- **Category**: Agent framework (domain-specific)
- **Decision**: REJECTED

## Summary

Recursive-language-model investigation agent with Tauri 2 desktop GUI and Python CLI, specialized for open-source intelligence (OSINT): cross-referencing corporate registries, campaign finance records, lobbying disclosures, and government contracts. 1,450 stars, 229 forks, v0.1.1 (single contributor, created 2026-02-20).

## Rejection Rationale

- **Domain-specific**: Purpose-built for OSINT/financial investigation — no applicable Claude Code patterns
- **No novel techniques**: Recursive sub-agent delegation already documented in registry. Knowledge graph visualization is Tauri-desktop-specific
- **Early stage**: v0.1.1, single contributor
- **No integration path**: Desktop GUI app, not an MCP server or extractable technique

## Quick Score

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 0 | Desktop GUI, not MCP/skill/technique |
| Token efficiency impact | 25% | 50 | Neutral |
| Capability expansion | 25% | 30 | Recursive delegation already exists |
| Maintenance burden | 15% | 50 | N/A (not integrating) |
| Community validation | 15% | 60 | 1,450 stars but v0.1.1, single contributor |

**Weighted Score**: 34.0/100

**Decision**: REJECTED (< 50 threshold)
