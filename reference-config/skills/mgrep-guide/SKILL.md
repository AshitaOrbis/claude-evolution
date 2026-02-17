# mgrep Semantic Search Guide

mgrep is a semantic search tool by Mixedbread that **replaces built-in Grep for most searches**. It uses embeddings to understand query intent rather than just matching keywords.

## Decision Tree: mgrep vs Grep

```
Is this an EXACT string search (function name, variable, import)?
  └─ YES → Use built-in Grep (instant, complete)
  └─ NO ↓

Is this a semantic/natural language query?
  └─ YES → Use mgrep (understands intent)
  └─ NO ↓

Do you need relevance ranking (most important file first)?
  └─ YES → Use mgrep (returns confidence scores)
  └─ NO → Either works, prefer mgrep for complex queries
```

## Quick Reference

| Query Type | Tool | Example |
|------------|------|---------|
| Exact string | **Grep** | `handleSubmit`, `import { foo }` |
| Semantic concept | **mgrep** | "where is authentication handled?" |
| Natural language | **mgrep** | "rate calculation formula" |
| Regex pattern | **Grep** | `error.*handling` |
| Exploratory | **mgrep** | "API error responses" |

## Decision Examples

These optimized examples demonstrate correct tool selection:

### Grep Examples (Exact Matches)

**Query:** `'import { useState }'` | Context: Finding imports
**Decision:** Grep - Exact import statement, instant literal match

**Query:** `'@Injectable()'` | Context: Finding decorators
**Decision:** Grep - Exact decorator syntax pattern

**Query:** `'function\\s+handleAuth'` | Context: Regex search
**Decision:** Grep - Regex pattern with character classes

### mgrep Examples (Semantic Queries)

**Query:** `'where is authentication handled?'` | Context: Understanding code flow
**Decision:** mgrep - Natural language query requiring semantic understanding

**Query:** `'API error handling'` | Context: Understanding error patterns
**Decision:** mgrep - Semantic understanding finds relevant files (92.8% match confidence)

**Query:** `'rate calculation formula'` | Context: Business logic
**Decision:** mgrep - Semantic understanding finds relevant files (96.9% match confidence)

## Usage

```bash
# Semantic search (natural language)
mgrep "where do we handle auth?" src/

# With content preview
mgrep "rate calculation" . --content -m 10

# Web search integration
mgrep --web --answer "how to implement JWT refresh"
```

## Auto-Indexing (Zero Maintenance)

- **SessionStart hook** automatically runs `mgrep watch` in background
- **SessionEnd hook** automatically stops the watcher
- **File changes** are auto-detected and re-indexed (no manual re-indexing needed)
- **Respects** `.gitignore` (add `.mgrepignore` for additional exclusions)

## Overhead

| Resource | Impact |
|----------|--------|
| Memory | Minimal (lightweight file watcher) |
| CPU | Negligible (only on file events) |
| Network | Initial sync + delta changes only |
| Latency | ~2-3s per search (cloud round-trip) |

## Limits

- **Max file size**: 1 MB per file (configurable via `MGREP_MAX_FILE_SIZE`)
- **Max file count**: 1,000 per directory (configurable via `MGREP_MAX_FILE_COUNT`)
- **Free tier**: 2M store tokens/month

## Performance Benefits

Semantic search can dramatically improve search accuracy compared to keyword matching:

| Search Type | Traditional Grep | mgrep Semantic Search |
|-------------|------------------|----------------------|
| Natural language | Misses context | High confidence matches |
| Business logic | Literal string only | Understands concepts |
| Code patterns | Regex required | Intent-based discovery |
