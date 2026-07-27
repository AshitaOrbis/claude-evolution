# StarRocks MCP - Cloud-Native OLAP Database

**Discovery Date**: 2026-02-06
**Source**: https://github.com/StarRocks/mcp-server-starrocks
**Category**: Database / Analytics
**Stars**: 144

---

## Description

MCP server bridging AI assistants and StarRocks databases, enabling SQL execution, database exploration, data visualization, and schema retrieval for cloud-native analytical workloads.

---

## Key Features

### Core Capabilities
- **SQL execution**: Direct queries and DDL/DML commands
- **Database exploration**: Browse databases and tables with schema retrieval
- **System metrics**: Access internal StarRocks metrics via `proc://` resource path
- **Data visualization**: Plotly chart generation from query results
- **Performance**: In-memory caching for optimization
- **Multi-transport**: stdio, HTTP, Streamable HTTP modes

### Technical Details
- **Purpose**: OLAP (Online Analytical Processing) workloads
- **Architecture**: Cloud-native analytics database
- **Configuration**: Environment variable setup
- **Output**: Comprehensive table/database summaries with row counts and sample data

### Use Cases
- Ad-hoc analytics queries via natural language
- Data exploration and discovery
- Quick dashboard generation (Plotly charts)
- System monitoring and performance analysis
- Schema documentation and understanding

---

## Redundancy Check

**Keywords extracted**: starrocks, olap, analytics database, data warehouse, sql analytics, plotly visualization, cloud-native database

**Search against registry**:

**Existing OLAP capability**:
- **DuckDB/MotherDuck MCP** (IMPLEMENTED): Embedded OLAP, file-based queries (CSV/Parquet/JSON), <100ms analytics

**Comparison**:
| Feature | StarRocks MCP | DuckDB MCP (Existing) |
|---------|---------------|----------------------|
| Architecture | Cloud-native server | Embedded (no server) |
| Data source | StarRocks database | Files (CSV/Parquet/Excel) |
| Setup | Requires StarRocks instance | Zero setup (embedded) |
| Visualization | Plotly integration | No built-in viz |
| Use case | Persistent data warehouse | Ad-hoc file analysis |
| System metrics | `proc://` monitoring | No system-level access |

**Classification**: **IMPROVEMENT** (conditional) - Better than DuckDB IF we have StarRocks deployments

---

## Integration Path

### Target Location
- **Type**: MCP Server
- **Location**: `~/.claude.json` mcpServers section
- **Category**: Database / Analytics (existing section)

### Installation Steps
1. Install StarRocks database (or access existing instance)
2. Install MCP server: `npm install -g @starrocks/mcp-server`
3. Configure environment variables:
   - `STARROCKS_HOST`
   - `STARROCKS_PORT`
   - `STARROCKS_USER`
   - `STARROCKS_PASSWORD`
   - `STARROCKS_DATABASE`
4. Add to `~/.claude.json`:
```json
{
  "mcpServers": {
    "starrocks": {
      "command": "mcp-server-starrocks",
      "env": {
        "STARROCKS_HOST": "localhost",
        "STARROCKS_PORT": "9030",
        "STARROCKS_USER": "root",
        "STARROCKS_PASSWORD": "password"
      }
    }
  }
}
```
5. Restart Claude Code to load MCP

### Dependencies
- StarRocks database instance (v2.5+ recommended)
- Network access to StarRocks
- Valid database credentials
- Node.js 18+

---

## Evaluation Considerations

### Strengths
- **Built-in visualization**: Plotly charts from queries (DuckDB lacks this)
- **System monitoring**: `proc://` resource for internal metrics
- **Cloud-native**: Designed for scalable analytics workloads
- **Official**: Developed by StarRocks team (first-party support)
- **Multi-transport**: Flexible deployment (stdio/HTTP/SSE)

### Concerns
- **Infrastructure dependency**: Requires StarRocks database (we don't have one)
- **DuckDB overlap**: We already have OLAP via DuckDB (embedded, zero-setup)
- **Token overhead**: Database schemas and results can be verbose
- **Low adoption**: 144 stars (moderate community validation)
- **Use case fit**: Do we need persistent data warehouse vs ad-hoc file analysis?

### Questions for Evaluation
1. **Infrastructure**: Do we have or plan to deploy StarRocks?
2. **DuckDB comparison**: Can DuckDB + external Plotly cover 90% of use cases?
3. **Data architecture**: Do we need persistent warehouse vs file-based analytics?
4. **The finance app**: Could this power analytics for production app?
5. **Evolution metrics**: Could we track pipeline metrics in StarRocks?

---

## Estimated Score Preview

| Criterion | Expected Score (0-100) | Reasoning |
|-----------|------------------------|-----------|
| Integration complexity | 40 | Requires StarRocks deployment (high barrier) |
| Token efficiency impact | 60 | Database results can be verbose; caching helps |
| Capability expansion | 50 | Redundant with DuckDB unless we deploy StarRocks |
| Maintenance burden | 75 | Official StarRocks support (stable) |
| Community validation | 60 | 144 stars = moderate adoption |
| **ESTIMATED TOTAL** | **57** | Below threshold UNLESS we deploy StarRocks |

---

## Strategic Considerations

### DuckDB vs StarRocks Decision Matrix

| Scenario | Recommended Tool | Reasoning |
|----------|------------------|-----------|
| Ad-hoc file analysis (CSV/Excel) | **DuckDB** | Zero setup, embedded, fast |
| Small-scale analytics (<1M rows) | **DuckDB** | Embedded = zero infrastructure |
| Persistent data warehouse | **StarRocks** | Cloud-native, scalable |
| Production app analytics | **StarRocks** | Multi-user, concurrency |
| Evolution pipeline metrics | **DuckDB** | Local files, no infrastructure |
| Finance-app analytics | **PostgreSQL + DuckDB** | OLTP + OLAP hybrid |

### Current Architecture Assessment

**Existing databases**:
- **PostgreSQL** (the finance app): OLTP workloads
- **DuckDB** (via MCP): OLAP workloads, file-based

**Gap analysis**:
- Do we need persistent, multi-user OLAP? **NO** (single-user workflows)
- Do we need cloud-scale analytics? **NO** (small datasets)
- Do we have StarRocks infrastructure? **NO**

**Conclusion**: DuckDB covers our OLAP needs. StarRocks is **FUTURE** (if we scale to multi-user analytics).

---

## Next Steps

1. **Infrastructure assessment**: Do we plan to deploy StarRocks? (BLOCKER)
   - If YES → Continue evaluation
   - If NO → Mark as **FUTURE** (premature)

2. **DuckDB gap analysis**: What can't DuckDB do that StarRocks can?
   - Persistent warehouse
   - Multi-user concurrency
   - Cloud-native scaling
   - Built-in viz (but we can add Plotly externally)

3. **Use case validation**: Which projects need persistent OLAP?
   - The finance app analytics?
   - Evolution pipeline metrics?
   - Revenue tracking?

4. **Cost-benefit**: StarRocks deployment cost vs DuckDB embedded benefits

---

## Related Discoveries

- DuckDB MCP (IMPLEMENTED, embedded OLAP)
- PostgreSQL (OLTP, via Bash)
- Database Query MCP (rejected, 24.5/100)

**Pattern**: OLAP MCP servers emerging but DuckDB embedded approach is winning for solo/small teams

---

## Decision Framework

```
IF we deploy StarRocks OR have existing StarRocks:
    → EVALUATE (score likely 70+)
ELSE IF we need persistent multi-user OLAP:
    → FUTURE (valuable but requires infrastructure first)
ELSE IF DuckDB covers our needs:
    → SKIP (avoid infrastructure overhead)
```

**Current assessment**: **SKIP** (DuckDB sufficient for current scale)

**Reconsideration triggers**:
- The finance app reaches 1M+ rows (scale trigger)
- Multi-tenant analytics needed (concurrency trigger)
- Real-time dashboard requirements (streaming trigger)

---

## Evaluation

**Date**: 2026-02-06
**Context**: We have DuckDB MCP (embedded OLAP). No StarRocks infrastructure.

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 40/100 | 20% | 8.0 | **BLOCKER**: Requires StarRocks deployment |
| Token Efficiency | 60/100 | 25% | 15.0 | Caching helps but results can be verbose |
| Capability Expansion | 30/100 | 25% | 7.5 | **REDUNDANT**: DuckDB covers our OLAP needs |
| Maintenance Burden | 75/100 | 15% | 11.25 | Official StarRocks support |
| Community Validation | 60/100 | 15% | 9.0 | 144 stars = moderate |
| **TOTAL** | | | **50.75** | **FUTURE** |

### Decision: FUTURE

**Reason**: Infrastructure dependency - we don't have StarRocks. DuckDB (embedded) covers current OLAP needs. Valuable IF we scale to multi-user analytics or deploy StarRocks.

**Adoption trigger**: If the finance app reaches 1M+ rows, multi-tenant analytics needed, or real-time dashboards required.
