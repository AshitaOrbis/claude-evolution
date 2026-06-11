# Perplexity - PPLX Embed State-of-the-Art Embedding Models

- **Date**: 2026-02-26
- **Source**: Discord #general inbox
- **URL**: https://research.perplexity.ai/articles/pplx-embed-state-of-the-art-embedding-models-for-web-scale-retrieval
- **Category**: unknown
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1476665036108992654

## Description

URL shared in Discord #general without additional context.

## Classification

To be evaluated by the standard pipeline.

## Evaluation

**Score**: 20/100
**Decision**: REJECTED
**Reason**: PPLX Embed is Perplexity's embedding model for web-scale retrieval. Infrastructure-level ML model, not an MCP server or Claude Code tool. We already have mgrep (Mixedbread embeddings) for semantic search and Exa for neural web search. No integration path — would need to build a custom retrieval system around it.

| Criterion | Weight | Score |
|-----------|--------|-------|
| Integration complexity | 20% | 10 (no MCP/CLI, requires custom build) |
| Token efficiency impact | 25% | 20 (theoretical, no direct application) |
| Capability expansion | 25% | 20 (embedding model, overlaps with existing search) |
| Maintenance burden | 15% | 10 (API dependency) |
| Community validation | 15% | 40 (Perplexity, reputable source) |

**Date**: 2026-03-08
**Auto-triaged**: Yes (batch evaluation)
