# Evaluation Report: Gemini Embedding 2

## Basic Information
- **Source**: https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-embedding-2/
- **Category**: Multi-Model (Embedding Model)
- **License**: Proprietary (Google, API access)
- **Last Updated**: 2026-03-10 (public preview launch)
- **Stars/Validation**: N/A (official Google DeepMind product, not open-source)
- **Prior Evaluations**: `discord-inbox-20260310-gemini-embedding-2-evaluation.md` (62.5/100, NEEDS_RESEARCH), `model-update-google-gemini-embedding-2-2026-03-11-evaluation.md` (DUPLICATE, deferred)
- **This Evaluation**: Manual deep-dive requested to resolve NEEDS_RESEARCH status

---

## Technical Specifications (Verified)

| Property | Value | Source |
|----------|-------|--------|
| Model ID | `gemini-embedding-2-preview` | Google AI docs |
| Status | Public Preview | Google Blog (2026-03-10) |
| Modalities | Text, images, video, audio, PDFs | Unified embedding space |
| Default dimensions | 3,072 | Adjustable: 128, 768, 1,536, 3,072 (MRL) |
| Input token limit | 8,192 | Google AI docs |
| Languages | 100+ | Google Blog |
| Task instructions | Custom (e.g., `task:code retrieval`) | Vertex AI docs |
| MTEB English score | 68.32 (top rank) | MTEB leaderboard, Kavout analysis |
| MTEB Code score | 74.66 | Kavout analysis |
| Batch processing | Not available | Pricing page |
| Incompatibility | Not compatible with `gemini-embedding-001` | Requires full re-embedding |

### Pricing (Gemini API)

| Input Type | Free Tier | Paid (per 1M tokens) |
|------------|-----------|---------------------|
| Text | Free | $0.20 |
| Image | Free | $0.45 |
| Audio | Free | $6.50 |
| Video | Free | $12.00 |

### API Access

Available via:
- Gemini API (`embedContent` method)
- Vertex AI
- SDKs: Python (`google.genai`), JavaScript (`@google/genai`), Go

---

## Research Questions Answered

### 1. What does Gemini Embedding 2 offer?

A genuinely novel multimodal embedding model. The key innovation is mapping five modalities (text, images, video, audio, documents) into a single unified semantic space. This enables cross-modal retrieval -- e.g., using a text query to find a relevant video frame, or searching images by describing their content. Uses Matryoshka Representation Learning (MRL) for adjustable output dimensions without retraining. The `task:code retrieval` instruction tuning is noteworthy for code search applications.

### 2. Would this replace or complement mgrep for local code search?

**No replacement, marginal complement at best.**

mgrep (Mixedbread) is purpose-built for local code search with:
- Zero-config auto-indexing via file watcher
- Respects `.gitignore` automatically
- 96.9% accuracy on benchmarked queries (rate-calculations.ts)
- ~2-3s latency per search (cloud round-trip, but optimized pipeline)
- npm install, one-time login, no infrastructure

Gemini Embedding 2 would require:
- Custom MCP server or script wrapping the Gemini Embedding API
- Vector store infrastructure (ChromaDB, Qdrant, etc.) for indexed embeddings
- Indexing pipeline to embed all local files on change
- Auth setup (Google Cloud credentials or Gemini API key)
- Embedding retrieval + similarity search logic

The MTEB Code score of 74.66 is strong, but MTEB measures general-purpose text embedding quality, not specifically "find the right file in a 500-file codebase given a natural language query" -- which is exactly what mgrep benchmarks against. mgrep's Mixedbread embeddings are specialized for code search, and the empirical 96.9% match rate on our actual codebase is a more relevant metric than MTEB rankings.

**Verdict: Not a replacement. Not worth the infrastructure overhead for code search alone.**

### 3. Is there an MCP or API we could use to access it?

**No existing MCP server.** The gemini-cli MCP provides chat/analysis via `ask-gemini`, `gemini-analyze-image`, etc. -- it does NOT expose embedding endpoints. There is no official Google embedding MCP, and no third-party one was found in the MCP registry or GitHub.

API access requires:
- `google.genai` Python SDK or `@google/genai` JavaScript SDK
- API key (Gemini API) or service account (Vertex AI)
- Direct `embedContent` API calls

Building a custom MCP would be the integration path, but that's non-trivial infrastructure work (embedding generation, vector storage, retrieval, indexing).

### 4. How does it compare to existing embedding models we use indirectly?

| System | Embedding Model | Use Case | Quality |
|--------|----------------|----------|---------|
| mgrep | Mixedbread (proprietary) | Local code search | 96.9% on our benchmark |
| Exa | Exa proprietary embeddings | Web semantic search | Excellent for web, not local |
| Gemini Embedding 2 | gemini-embedding-2-preview | General multimodal | MTEB English 68.32, Code 74.66 |

mgrep and Exa embeddings are consumed transparently -- we never interact with embeddings directly. Switching to Gemini Embedding 2 would require building the entire retrieval pipeline ourselves, trading a managed service for a DIY system.

### 5. What is the practical integration path?

**There is no lightweight integration path.** The options are:

**Option A: Build custom MCP (Heavy)**
1. Write MCP server wrapping Gemini Embedding API
2. Implement file indexing pipeline (watch for changes, embed on save)
3. Set up vector store (ChromaDB/Qdrant/in-memory)
4. Implement similarity search retrieval
5. Configure Google Cloud auth
6. Estimated effort: 2-3 days of development, ongoing maintenance

**Option B: Wait for ecosystem (Passive)**
1. Monitor for official Google embedding MCP
2. Monitor for LangChain/LlamaIndex MCP wrappers that include embeddings
3. Re-evaluate when GA release drops (expected Q2 2026)
4. Zero effort, zero risk

**Option C: Use for specific project (Targeted)**
1. If historical-nanochat or genealogy projects need multimodal search
2. Build project-specific embedding pipeline
3. Not a system-wide integration -- project-scoped

**Recommended: Option B.** The capability is real but the need is absent.

---

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 30/100 | 20% | 6.0 | No existing MCP. Would need custom MCP server + vector store + indexing pipeline + Google auth. Non-trivial infrastructure build for a preview API. |
| Token Efficiency Impact | 45/100 | 25% | 11.25 | Neutral to slightly positive. Embeddings themselves don't reduce Claude tokens. Better retrieval could theoretically reduce context needed in RAG scenarios, but we don't have RAG. The free tier means no direct cost. |
| Capability Expansion | 60/100 | 25% | 15.0 | Multimodal embedding is genuinely novel -- no existing tool maps text+image+audio+video into one space. However, no current workflow requires this. Code search (the only embedding use case today) is already solved by mgrep. |
| Maintenance Burden | 40/100 | 15% | 6.0 | Public preview with breaking changes possible. Incompatible with predecessor (full re-embed on upgrade). Would need vector store lifecycle management. Google API versioning adds ongoing maintenance. |
| Community Validation | 90/100 | 15% | 13.5 | Official Google DeepMind product. Available via Gemini API + Vertex AI. Documented integrations with LangChain, LlamaIndex, Weaviate, Qdrant, ChromaDB. Top MTEB rankings. |
| **WEIGHTED TOTAL** | | | **51.75/100** | |

---

## Cross-Validation

- **Claude Assessment**: 51.75/100
- **Codex Assessment**: 43/100
- **Variance**: 8.75 points
- **Consensus**: Achieved (both below 70 threshold, both flag redundancy with mgrep for code search, both acknowledge multimodal novelty but no current use case)

### Variance Analysis

Codex scored lower primarily on value proposition (35 vs my 45 for token efficiency) and integration difficulty (30 vs my 30 -- aligned). The ~9 point gap is within acceptable range and both reach the same conclusion: the capability is real but the integration case is not.

Codex raised a valid caution about the MTEB benchmark numbers (68.32 / 74.66) -- these were verified through MTEB leaderboard data and the Kavout analysis, but come from the Gemini Embedding 001 lineage rather than independent Embedding 2 benchmarks. The distinction matters: the "2" model adds multimodality on top of the text-only "001" foundation.

---

## Security Assessment

- [x] No sensitive permissions required (API key, but standard for Google services)
- [x] No excessive data access (embedding API receives input, returns vectors)
- [ ] License compatible -- Proprietary Google API (not open source, but standard SaaS terms)
- [x] No known vulnerabilities
- [ ] API keys manageable -- Would require Gemini API key or Google Cloud service account

**Data consideration**: Using Gemini Embedding 2 for code search would send code snippets to Google's API for embedding. This is similar to how mgrep sends to Mixedbread's cloud, but adds another cloud dependency.

---

## Existing Alternatives

| Capability | Existing Solution | Status | Quality |
|------------|------------------|--------|---------|
| Semantic code search | mgrep (Mixedbread) | Integrated, working | 96.9% accuracy |
| Web semantic search | Exa MCP | Integrated, working | Excellent |
| Multimodal analysis | Gemini 3.1 Pro (gemini-cli) | Integrated, working | Chat/analysis, not embeddings |
| Image understanding | Claude multimodal (Read tool) | Built-in | Direct image analysis |
| PDF search | Read tool (page ranges) | Built-in | Text extraction |

**Gap analysis**: The only genuinely unserved capability is cross-modal similarity search (e.g., "find images similar to this text description" across a local corpus). No current workflow requires this.

---

## Comparison to Prior Evaluation

The automated heartbeat evaluation (2026-03-12) scored this 62.5/100 (NEEDS_RESEARCH). This manual deep-dive arrives at 51.75/100 after researching the specific questions. The difference:

| Factor | Heartbeat Score | Manual Score | Reason for Change |
|--------|----------------|-------------|-------------------|
| Integration Complexity | 47 | 30 | Confirmed: no MCP exists, full infra build required |
| Token Efficiency | 52 | 45 | Confirmed: no RAG pipeline means no efficiency gain |
| Capability Expansion | 75 | 60 | Downgraded: multimodal is novel but no use case exists today |
| Maintenance Burden | 45 | 40 | Confirmed: preview instability + re-embedding on upgrade |
| Community Validation | 90 | 90 | Unchanged: strong vendor signal |

The heartbeat was slightly optimistic because it hadn't confirmed the absence of an MCP or the infrastructure requirements. The research questions are now answered.

---

## Recommendation

**DECISION**: [x] REJECT (<70)

**Score: 51.75/100** (Claude) / 43/100 (Codex) -- consensus REJECT

**Rationale**: Gemini Embedding 2 is a technically impressive multimodal embedding model from Google DeepMind, leading MTEB benchmarks and unifying five modalities into one embedding space. However, it fails the practical integration test for the Claude Code ecosystem on three fronts: (1) no existing MCP or lightweight integration path -- would require building a custom MCP server, vector store, and indexing pipeline; (2) the only current embedding use case (semantic code search) is already well-served by mgrep at 96.9% accuracy; (3) no current workflow requires multimodal embeddings (text+image+audio+video retrieval). The free tier pricing is attractive, but the infrastructure cost is measured in development time, not API fees.

**Re-evaluation Triggers** (document for future reference):
1. **Official Google Embedding MCP** released (check MCP registry quarterly)
2. **GA release** of Gemini Embedding 2 (expected Q2 2026) -- removes preview instability concern
3. **Multimodal search use case** emerges in a project (historical-nanochat image search, genealogy document OCR+search, game asset search)
4. **mgrep degradation** or Mixedbread service issues that require an alternative embedding provider

**Integration Path** (if re-evaluated and approved):
1. Build Node.js MCP server wrapping `@google/genai` SDK `embedContent` method
2. Add vector store (ChromaDB recommended -- lightweight, Python/JS, local)
3. Implement file watcher for incremental re-indexing
4. Add to `~/.claude.json` MCP config
5. Create skill guide with decision tree (when to use Gemini embeddings vs mgrep vs Grep)

---

## Registry Update

Add to `registry/existing-capabilities.md` redundancy triggers for the existing mgrep/semantic search section:

```
"gemini embedding", "multimodal embedding", "cross-modal search", "unified embedding space", "gemini-embedding-2"
```

This ensures future discoveries about Gemini embeddings or multimodal embedding models route to this evaluation before spending research effort.
