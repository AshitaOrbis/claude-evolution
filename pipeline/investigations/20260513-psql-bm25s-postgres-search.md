---
date: 2026-05-13
topic: "Look into this: https://github.com/Intelligent-Internet/psql_bm25s"
discord_message_id: "1504138877970026617"
status: complete
---

# psql_bm25s: Native PostgreSQL BM25 Lexical Search Extension

## Topic
User asked to look into `github.com/Intelligent-Internet/psql_bm25s` — a PostgreSQL extension for BM25 search — without specifying a target project, implying general workspace relevance assessment.

## Key Findings

- **What it is**: A C + PL/pgSQL PostgreSQL extension that implements BM25-family lexical ranking as a native index access method — the Python `bm25s` reference library, adapted for database durability (WAL, crash recovery, replication)
- **Performance**: 3.97x median QPS vs the Python reference; on the 8.8M-doc MSMARCO corpus: 96.67 QPS vs 1.61 QPS for Python
- **Three consistency modes**: `realtime` (synchronous stats update), `eventual` (async), `manual` (explicit refresh) — designed for mutable workloads with INSERT/UPDATE/DELETE
- **Hybrid search ready**: C-backed helpers for BM25/vector late-fusion without requiring a hard vector extension dependency (could pair with pgvector)
- **Multi-field indexing** with query-time weight tuning — useful for structured documents
- **Primary workspace use case**: <private-project> v2 (AWS + PostgreSQL) if scenario/project search is ever needed; no existing search feature in v2
- **Historical nanochat**: Not applicable — corpus is parquet files, no PostgreSQL layer
- **Project is by Intelligent-Internet** — same org behind the Zenith long-running agent harness investigated 2026-05-08

## Details

psql_bm25s addresses the gap between the lightweight Python `bm25s` reference (fast for static read-only retrieval) and the persistence + write semantics required by a live database. It compiles as a PostgreSQL extension and registers a new index access method — you add a `bm25s_index` to any text column and it behaves like a B-tree: write-ahead logging, crash recovery, logical replication.

The "mutable workload" design is the core engineering contribution. Traditional BM25 requires corpus-wide IDF statistics, which become stale on writes. The three consistency modes let you trade accuracy for throughput: `realtime` recomputes stats synchronously (correct but locks), `eventual` batches updates (fast, slightly stale), `manual` gives full control. This is a sensible engineering trade-off that plain PostgreSQL full-text search (`ts_vector` / `ts_rank`) doesn't offer in a tunable way.

The 3.97x median QPS claim is across 15 BEIR benchmark datasets, which is a reasonable cross-domain benchmark suite. The big number (96.67 vs 1.61 on MSMARCO) is partly because the Python baseline is single-threaded and PostgreSQL parallelizes query execution — not a pure algorithmic win, but relevant for production use.

Hybrid BM25+vector search (combining with pgvector) is a well-supported pattern: BM25 catches keyword-exact matches that dense embeddings miss; vector search catches semantic matches that BM25 misses. The extension provides late-fusion helper functions in C, which keeps the join overhead low.

## Relevance to Workspace

**<private-project> v2** (PostgreSQL): If search over scenarios, CIP project names, or bond terms is ever needed, this is a better-fit than rolling custom `ts_vector` logic. Currently v2 has no search feature, so this is a "when we need it" backlog item. The hybrid BM25+vector mode would pair well with pgvector if semantic search over scenario descriptions is ever required.

**Historical Nanochat**: No PostgreSQL layer, all data in parquet shards — not applicable.

**Agent Event Bus**: Uses SQLite, not PostgreSQL — not compatible without infrastructure change.

**Intelligent-Internet**: This is the second project from this org evaluated this month (Zenith on 2026-05-08). Their output quality appears solid; worth monitoring.

## Recommended Actions

1. Add to <private-project> v2 backlog as a search capability option for when scenario/project search is needed
2. Note the Intelligent-Internet org for future monitoring (active, quality releases)
3. No immediate integration needed — no current <private-project> search requirement
