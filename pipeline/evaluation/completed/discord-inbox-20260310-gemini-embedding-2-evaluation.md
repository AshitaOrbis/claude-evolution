# Evaluation: Gemini Embedding 2

- **Date**: 2026-03-12
- **Source**: https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-embedding-2/
- **Category**: multi-model
- **Automated**: Yes (daily heartbeat)
- **Status**: NEEDS_RESEARCH

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 47 | Not available via existing gemini-cli MCP. Would require new Gemini API integration + vector store pipeline. Full RAG infrastructure build from scratch. |
| Token efficiency impact | 25% | 52 | Embeddings don't directly affect token usage. Indirect benefit if better retrieval reduces context needed — but only realized if RAG pipeline is built. |
| Capability expansion | 25% | 75 | Genuinely novel: first natively multimodal embedding space (text + images + video + audio + PDFs). Unified representation would be a real expansion over current text-only mgrep. |
| Maintenance burden | 15% | 45 | Public preview status — breaking changes possible. Incompatible with `gemini-embedding-001`, requiring full re-embedding on upgrade. Index lifecycle overhead. |
| Community validation | 15% | 90 | Official Google announcement, available via Gemini API + Vertex AI, documented ecosystem (LangChain, LlamaIndex, Weaviate, Qdrant, ChromaDB). Strong vendor signal. |

- **Claude Score**: 63.0/100
- **Codex Score**: 62.0/100
- **Final Score**: 62.5/100

## Decision

NEEDS_RESEARCH — Strong multimodal capability but no current integration path or use case. The system has no vector store pipeline; building one would be heavyweight infra work. Decision hinges on whether there's a concrete near-term use case (e.g., multimodal search for the genealogy or historical-nanochat projects).

## Integration Notes

Key research questions:
1. Is there a lightweight MCP server wrapping the Gemini Embedding 2 API?
2. Is there a concrete use case in the current project stack that requires multimodal embeddings? (historical-nanochat images? genealogy document search?)
3. Does GA release stabilize the incompatibility with `gemini-embedding-001`?
4. Would `mgrep` (Mixedbread) be replaceable, or would Gemini Embedding 2 serve a different niche?

Re-evaluation trigger: when Gemini Embedding 2 reaches GA status (expected Q2 2026) — check if a ready-made MCP exists then.

Note: Also pending evaluation as `model-update-google-gemini-embedding-2-2026-03-11.md` — that file should be evaluated in the next run and may reach a different routing decision if it has more detail.
