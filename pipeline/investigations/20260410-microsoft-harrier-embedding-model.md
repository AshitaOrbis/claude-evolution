---
date: 2026-04-10
topic: "Look into this for both local embedding and if it could be useful for search somehow"
discord_message_id: "1491114199865364662"
status: complete
---

# Microsoft Harrier — Open-Source Embedding Model for Local Use and Search

## Topic
Microsoft open-sourced Harrier, described as an "industry-leading embedding model." Investigate its specs, local deployment feasibility, and applicability to our search and memory systems.

Source: https://blogs.bing.com/search/April-2026/Microsoft-Open-Sources-Industry-Leading-Embedding-Model

## Key Findings

- **Harrier** is Microsoft's new open-source embedding model series, achieving **#1 on the multilingual MTEB-v2 benchmark** as of April 6, 2026
- Designed specifically for **agentic AI systems** — optimized for memory management, cross-source retrieval, and multi-step context maintenance
- Key performance claim: better first-pass retrieval → higher factual accuracy, lower latency, fewer retries in RAG pipelines
- **Local deployment status is unclear** — HuggingFace pages returned 401 (authentication required or model gated), suggesting either early access restriction or the model isn't yet publicly downloadable
- Specific technical specs (dimensions, context length, model size) were not available in the blog post; the HF model page was inaccessible
- Multilingual MTEB-v2 benchmark emphasis makes this interesting for multi-language scenarios, though our primary use cases are English

## Details

The timing is notable: Harrier was announced April 6, 2026, and we're at April 10. The 401 on HuggingFace suggests either a staged rollout (gated access before public release) or that the model requires a Microsoft account/agreement. This is a pattern Microsoft uses for Azure AI-integrated models — the GitHub repo may exist but weights require Azure access.

**Potential relevance to our systems:**

1. **mgrep semantic search**: Currently uses Mixedbread embeddings via cloud round-trip (~2-3s). A locally-hosted Harrier model could replace this with local inference if the model is small enough to run on requiem. No GPU constraints listed in the blog post — but MTEB-leading models are typically 7B+ which would require the desktop GPU.

2. **Agent event bus memory**: The event bus uses SQLite with text search. A Harrier-powered vector store layer could enable semantic querying of agent activity rather than keyword matching — useful for the `query_knowledge` tool.

3. **Genealogy research**: The research genealogy project could use embeddings to find related records across sources (census + vital records + newspaper mentions). Multi-source retrieval is exactly what Harrier is optimized for per Microsoft.

4. **Historical nanochat evaluation**: Embedding-based semantic similarity between historical texts could help measure how well the synthetic evaluation sets cover the temporal knowledge space.

**Competition context**: Harrier is competing with:
- `nomic-embed-text` (768d, runs locally via Ollama)
- `mxbai-embed-large` (1024d, popular on Ollama)
- `text-embedding-3-large` (OpenAI, API only, 3072d)
- `all-MiniLM-L6-v2` (384d, very small, local)

MTEB-v2 #1 is significant if it holds — but the multilingual benchmark may not reflect English-only performance, and agentic optimization may mean it underperforms on pure semantic similarity tasks.

## Relevance to Workspace

- `agent-event-bus/` — could enhance `query_knowledge` with semantic search
- mgrep integration — potential local embedding replacement for cloud round-trips
- `research/genealogy/` — multi-source record matching
- `research/historical-nanochat/` — evaluation set semantic coverage measurement

## Recommended Actions

1. **Monitor availability**: Check HuggingFace weekly until model becomes publicly accessible; the 401 suggests imminent release
2. **When available**: Check model size — if ≤3B params, test locally on requiem; if 7B+, assess VRAM cost against current GPU usage
3. **Benchmark on our use cases** rather than trusting MTEB-v2: run against our mgrep queries and agent-bus knowledge queries to measure relevance improvement
4. **Note for mgrep replacement decision**: If Harrier runs locally at ≤500ms/query, it's a strong candidate to replace the cloud mgrep round-trip and eliminate the 2M token/month free tier constraint
