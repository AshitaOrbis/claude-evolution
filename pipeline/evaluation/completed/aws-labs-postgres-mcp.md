# AWS Labs Aurora Postgres MCP Server (Official)

**Source**: https://github.com/awslabs/mcp (8,065 stars)
**Discovery Date**: 2026-02-06
**Category**: Database / AWS (Official)

## Summary

Official AWS Labs MCP server for Aurora Postgres with **natural language to SQL** conversion. Converts human-readable questions into Postgres-compatible SQL and executes against Aurora Postgres clusters. Built-in documentation access and best practices.

## Key Features

- **Natural language to SQL**: Convert questions to structured queries
- Read-only by default, `--allow-writes` flag for transactions
- Connection reuse for improved performance
- Built-in Aurora Postgres documentation and best practices
- Docker runtime required
- UV (Astral) + Python 3.10+
- AWS credentials integration
- **Tools**: `readonly_query` and likely `write_query` (with flag)

## Potential Value

**Stack Match**: ✅ PERFECT - We use AWS RDS PostgreSQL (Aurora-compatible)
**Current Gap**: We use psql CLI (zero-token but manual SQL writing)
**Novel Capability**: Natural language → SQL conversion (huge UX win)

## Quick Assessment Scores

- Integration complexity: **65** (Docker + UV + Python + AWS creds setup)
- Token efficiency impact: **60** (Adds MCP overhead, but NL→SQL saves prompt tokens)
- Capability expansion: **85** (Natural language queries = major UX improvement)
- Maintenance burden: **95** (Official AWS Labs, 8k stars, Apache 2.0)
- Community validation: **100** (Official AWS, 8,065 stars, 176 issues = active)

**TOTAL**: **77.5/100** (Weighted)

## Recommended Action

- [x] **EVALUATE FURTHER** - Strong candidate for integration
- Key advantages:
  1. Official AWS Labs (vs community T1nker version)
  2. Natural language to SQL (not just query execution)
  3. Built-in Aurora docs and best practices
  4. 8k stars vs 22 stars
- Comparison needed: NL→SQL value vs token overhead
- Use case: <private-project> data analysis, <private-project>-v2 queries

## Comparison: AWS Labs vs T1nker vs psql CLI

| Feature | psql CLI | T1nker MCP | AWS Labs MCP |
|---------|----------|------------|--------------|
| Stars | N/A (built-in) | 22 | 8,065 |
| Maintenance | PostgreSQL.org | Community | Official AWS |
| Natural language | ❌ | ❌ | ✅ |
| Token cost | 0 (Bash) | MCP overhead | MCP overhead |
| Write queries | ✅ | ❌ (read-only) | ✅ (with flag) |
| Aurora docs | ❌ | ❌ | ✅ |
| Setup complexity | Zero | Low | Medium |

**Winner**: AWS Labs MCP for NL→SQL, psql CLI for token efficiency

## Registry Check

Database Operations section says:
- ✅ Bash psql is preferred (zero-token)
- ✅ DuckDB MCP integrated (OLAP analytics)
- ❌ Database MCP scored 24.5/100 (rejected for token overhead)

**BUT**: That evaluation didn't consider **natural language to SQL** capability (AWS Labs' key differentiator)

## Next Steps

1. Test AWS Labs MCP with sample queries
2. Measure token overhead vs prompt token savings (NL vs SQL)
3. Compare to Claude's native SQL generation (no MCP)
4. Decision: If NL→SQL saves net tokens, approve; otherwise reject

## Notes

- AWS Labs has multiple MCP servers (Aurora DSQL, Aurora Postgres, etc.)
- DSQL is separate product (distributed SQL), not relevant for us
- Focus on Aurora Postgres MCP server

---

## Evaluation

**Evaluator**: capability-evaluator
**Date**: 2026-02-06

### Scoring

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration Complexity | 65/100 | Docker + UV + Python + AWS creds + DB connection config |
| Token Efficiency | 55/100 | MCP overhead BUT NL→SQL saves prompt tokens (net unclear) |
| Capability Expansion | 70/100 | NL→SQL major UX win, but psql already works well |
| Maintenance Burden | 95/100 | Official AWS Labs, 8k stars, Apache 2.0, active |
| Community Validation | 100/100 | Official AWS (vs 22-star community version) |
| **WEIGHTED TOTAL** | **71.75/100** | |

### Cross-Validation (Codex)
"NL→SQL is valuable but adds complexity. 71/100 - approve if query-heavy workflows, otherwise psql CLI sufficient."

### Security
- [x] Official AWS Labs
- [x] Apache 2.0 licensed
- [x] Read-only by default
- [x] Write queries require explicit flag
- [x] AWS credential management (standard practice)

### Decision: FUTURE (71.75/100)

**Rationale**: Scores above 70, BUT current psql CLI works well. NL→SQL advantage unclear without usage data.

**Adoption Trigger**: If <private-project> or <private-project>-v2 involves heavy ad-hoc queries where NL→SQL saves time.

**Integration Path** (when triggered):
1. Docker setup for MCP server
2. Configure AWS RDS connection
3. Test NL→SQL vs manual SQL for 10 common queries
4. Measure net token efficiency (MCP overhead - prompt savings)
5. If net positive, integrate
