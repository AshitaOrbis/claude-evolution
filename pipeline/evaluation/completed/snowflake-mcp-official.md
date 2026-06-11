# Discovery: Snowflake MCP (Official)

**Source**: https://github.com/Snowflake-Labs/mcp
**Category**: MCP | Database | Data Warehouse
**Stars**: Official Snowflake-Labs repository
**Date Discovered**: 2026-02-06

---

## Summary

Official Snowflake MCP server providing AI agents with secure access to Snowflake data warehouse capabilities including Cortex AI, object management, SQL orchestration, semantic view consumption, and more. Managed MCP server infrastructure hosted by Snowflake.

---

## Potential Value

### Token Impact
**Neutral** - Query results returned to context, but eliminates manual connection/query construction overhead. Uses structured tool calls instead of raw SQL strings.

### Capability
**NOVEL** - Enterprise data warehouse access with AI features:
- **Cortex AI**: Built-in ML models (sentiment analysis, translation, etc.)
- **Cortex Analyst**: Natural language to SQL
- **Cortex Search**: Semantic search over Snowflake data
- **Semantic views**: Pre-defined data models for agent queries
- **Custom tools**: Expose Snowflake functions as MCP tools

Existing capabilities:
- **Bash + SQL CLIs**: Generic database access (psql, mysql, etc.)
- **Rube MCP**: May include Snowflake connector but NOT Cortex AI features

This MCP provides **Snowflake-specific AI features** that generic SQL access doesn't offer.

### Integration Effort
**Medium** - Requires:
1. Snowflake account with Cortex enabled
2. OAuth configuration
3. MCP server setup (managed or self-hosted)

---

## Key Features

1. **Managed infrastructure**: Snowflake hosts the MCP server (no deployment needed)
2. **Cortex AI integration**: Access to Snowflake's ML models
3. **Natural language queries**: Cortex Analyst converts plain English to SQL
4. **Semantic search**: Query data using embeddings
5. **Enterprise security**: OAuth 2.0, RBAC, audit logs

---

## Rube Comparison

| Feature | Snowflake MCP | Rube MCP |
|---------|---------------|----------|
| Snowflake connection | ✅ Yes | Possible (generic) |
| Cortex AI access | ✅ Yes | ❌ No |
| Cortex Analyst (NL→SQL) | ✅ Yes | ❌ No |
| Semantic search | ✅ Yes | ❌ No |
| Managed hosting | ✅ Yes | ✅ Yes |

**Conclusion**: IMPROVEMENT - If we use Snowflake, official MCP provides AI features generic connectors don't.

---

## Quick Assessment Score

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration complexity | 65/100 | Requires Snowflake account, OAuth setup, Cortex enabled |
| Token efficiency impact | 70/100 | Structured queries vs manual SQL, Cortex Analyst optimizes |
| Capability expansion | 90/100 | Cortex AI features are enterprise-grade and novel |
| Maintenance burden | 95/100 | Official Snowflake support, managed infrastructure |
| Community validation | 90/100 | Official product from Snowflake |

**TOTAL**: **80.5/100** (Weighted: 65×0.20 + 70×0.25 + 90×0.25 + 95×0.15 + 90×0.15)

---

## Recommended Action

☑ **Evaluate further** - Score 80.5/100 exceeds approval threshold (70+)

### Conditional Integration:
- **IF** we use Snowflake: Integrate immediately
- **IF NOT** using Snowflake: DEFER until needed

### Next Steps:
1. Determine if any current/planned projects use Snowflake
2. If yes: Test Cortex AI features vs manual SQL
3. Compare token costs: Cortex Analyst vs Claude generating SQL
4. Evaluate security model (OAuth, RBAC)

---

## Integration Blockers

- [ ] Requires Snowflake account (paid service)
- [ ] Cortex AI may require additional Snowflake pricing tier
- [ ] OAuth setup complexity
- [x] Official support (managed infrastructure)

---

## Use Cases

### Relevant to Our Stack:
- ❌ <private-project> v2 uses PostgreSQL (not Snowflake)
- ❓ Future data analytics projects may need enterprise warehouse
- ❓ <private-project> project: Could use Snowflake for storing processed statements

### Strong Use Cases Elsewhere:
- Enterprise data analytics
- Multi-tenant SaaS with large datasets
- BI tool replacement (natural language queries)
- ML model deployment via Cortex AI

---

## Notes

- **MCP revision**: Supports 2025-06-18
- **Announced**: October 2025
- **Managed hosting**: Zero infrastructure management
- **Competitive**: Databricks also has MCP servers (Unity Catalog, Vector Search, Genie)
- **Integration guide**: Official docs at docs.snowflake.com/mcp

---

## Evaluation (2026-02-06)

### Redundancy Check

**Status**: IMPROVEMENT (conditional - IF we used Snowflake)

Existing capabilities:
- Bash tool: Database CLI access (psql, mysql, sqlcmd, etc.)
- Rube MCP: Generic database connectors

**Classification**: IMPROVEMENT - Provides Snowflake-specific AI features (Cortex AI, Cortex Analyst) that generic SQL access doesn't offer.

### Context Check

**CRITICAL**: We don't use Snowflake.

Current stack:
- <private-project> v2: PostgreSQL on AWS RDS
- Revenue pipeline: SQLite/PostgreSQL
- No data warehouse, no Snowflake account

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 40/100 | 20% | 8.0 | Requires paid Snowflake account, Cortex enablement, OAuth setup |
| Token efficiency impact | 70/100 | 25% | 17.5 | Cortex Analyst optimizes queries, structured tool calls |
| Capability expansion | 85/100 | 25% | 21.25 | Cortex AI features (ML models, semantic search) are novel |
| Maintenance burden | 95/100 | 15% | 14.25 | Official Snowflake support, managed infrastructure |
| Community validation | 90/100 | 15% | 13.5 | Official product from Snowflake |

**WEIGHTED TOTAL**: **74.5/100**

### Cross-Validation with Codex

Codex assessment: 78/100 ("Excellent if you use Snowflake, otherwise irrelevant")
Variance: 3.5 points (consensus achieved)

### Decision: FUTURE (Conditional Approval) 🔮

**Rationale**: Scores 74.5/100 (above 70 threshold), official Snowflake product with strong Cortex AI features. HOWEVER, we don't use Snowflake and have no immediate plans to adopt it. Integration would require paid Snowflake account (~$40/month minimum + Cortex costs).

**Adoption Trigger**: IF we adopt Snowflake data warehouse → integrate immediately

**Why FUTURE not REJECT**:
- Strong score (74.5/100) - meets approval threshold
- Official support - high quality, maintained
- Novel capabilities - Cortex AI features (ML models, semantic search, NL→SQL)
- No blocker except platform adoption

**Current projects don't need Snowflake**:
- <private-project> v2: PostgreSQL sufficient (relational data, not warehouse scale)
- <private-project>: Could use Snowflake but PostgreSQL cheaper for MVP
- Revenue pipeline: SQLite/PostgreSQL sufficient

**Future scenarios where Snowflake becomes relevant**:
- Multi-tenant SaaS at scale (100k+ users)
- BI/analytics with large datasets (TB+)
- Enterprise data warehouse needs
- ML model deployment on structured data

**Integration Path (when triggered)**:
1. Sign up for Snowflake trial or paid account
2. Enable Cortex AI features (may require upgrade)
3. Configure OAuth authentication
4. Add MCP server config to `~/.claude.json`
5. Test Cortex Analyst (NL→SQL), Cortex Search (semantic search)
6. Update registry with triggers: "snowflake mcp", "cortex ai", "cortex analyst", "data warehouse mcp", "semantic search snowflake"

**File disposition**: Move to `pipeline/evaluation/completed/` with FUTURE note

**Kill signals triggered**: Platform dependency (don't use Snowflake) - but NOT a permanent rejection
