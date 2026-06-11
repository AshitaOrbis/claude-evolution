# Discovery: mcp-analyst (Local CSV/Parquet Analysis)

**Source**: https://github.com/unravel-team/mcp-analyst
**Category**: MCP | Data Processing
**Stars**: Not explicitly stated (from Unravel team)
**Date Discovered**: 2026-02-06

---

## Summary

MCP server that empowers Claude to analyze large local CSV or Parquet files **without uploading full files**. Performs data analysis operations locally on your machine, preserving privacy and avoiding data transfer overhead.

---

## Potential Value

### Token Impact
**Neutral to Positive** - Avoids uploading full datasets to context, instead performs analysis locally and returns only results. For large datasets (GB+), this could save massive token costs vs. pasting CSV content.

### Capability
**NOVEL** - Fills a specific gap: analyzing structured data files larger than context window limits. Existing tools:
- **Read tool**: Can read files but limited by context window
- **Bash + CLI tools**: Can process but requires manual scripting
- **Rube MCP**: Doesn't provide local file analysis

This MCP provides structured data analysis operations (aggregations, filters, groupby) on local files without manual scripting.

### Integration Effort
**Easy** - Standard Python MCP via uvx:
```bash
uvx mcp-analyst --file_location /path/to/data/
```

---

## Key Features

1. **Local processing**: No data upload to external services
2. **Large file support**: Can handle datasets larger than LLM context
3. **Parquet support**: Efficient columnar format for analytics
4. **Structured operations**: Query-like operations without manual pandas scripting

---

## Rube Comparison

| Feature | mcp-analyst | Rube MCP |
|---------|-------------|----------|
| Local CSV analysis | ✅ Yes | ❌ No |
| Privacy (no upload) | ✅ Yes | N/A |
| Cloud data sources | ❌ No | ✅ 500+ apps |
| Large file handling | ✅ Yes | N/A |

**Conclusion**: COMPLEMENTARY - Rube connects to cloud apps, mcp-analyst analyzes local files. No overlap.

---

## Quick Assessment Score

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration complexity | 90/100 | Single uvx command, Python-based |
| Token efficiency impact | 85/100 | Avoids uploading large datasets to context |
| Capability expansion | 80/100 | Fills local file analysis gap |
| Maintenance burden | 70/100 | Community project, unclear maintenance SLA |
| Community validation | 60/100 | Stars unclear, but from "Unravel team" |

**TOTAL**: **77/100** (Weighted: 90×0.20 + 85×0.25 + 80×0.25 + 70×0.15 + 60×0.15)

---

## Recommended Action

☑ **Evaluate further** - Score 77/100 exceeds approval threshold (70+)

### Next Steps:
1. Verify GitHub stars and community activity
2. Test with sample CSV/Parquet files
3. Compare performance vs. Bash + pandas scripting
4. Document token savings on large datasets (>10MB)

---

## Integration Blockers

- [ ] Verify Python dependencies don't conflict with existing tools
- [ ] Test with various file sizes (1MB, 10MB, 100MB+)
- [ ] Confirm tool descriptions are clear for Claude to invoke correctly

---

## Notes

- Listed in TensorBlock awesome-mcp-servers under Data Analysis category
- "Empowers Claude to efficiently analyze large local CSV or Parquet datasets without uploading full files"
- Key differentiator: LOCAL processing vs cloud-based data connectors

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator

### Redundancy Check

**Registry Match**: NO existing local CSV/Parquet analysis tool. Bash + pandas exists but requires manual scripting.

**Classification**: **IMPROVEMENT vs DuckDB MCP** (discovered in same batch)

### Comparison: mcp-analyst vs DuckDB MCP

| Feature | mcp-analyst | DuckDB MCP | Winner |
|---------|-------------|------------|--------|
| OLAP optimization | ❓ Unknown | ✅ Vectorized/columnar | **DuckDB** |
| File formats | ⚠️ CSV/Parquet | ✅ CSV/Parquet/JSON/Excel | **DuckDB** |
| Query language | ⚠️ Limited ops | ✅ Full SQL | **DuckDB** |
| Performance | ❓ Unknown | ⚡ <100ms | **DuckDB** |
| Cloud persistence | ❌ No | ✅ MotherDuck | **DuckDB** |
| Extensions | ❌ No | ✅ S3/PostgreSQL/spatial | **DuckDB** |
| Community | ❓ Unknown stars | 🌟 20k+ (DuckDB) | **DuckDB** |
| Maintenance | ❓ Unclear SLA | ✅ Official MotherDuck | **DuckDB** |

**Conclusion**: DuckDB MCP is strictly superior - more features, better performance, official support, full SQL, extensions.

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 90/100 | 20% | 18.0 | Simple uvx install |
| Token efficiency impact | 80/100 | 25% | 20.0 | Avoids uploading large datasets |
| Capability expansion | 50/100 | 25% | 12.5 | Redundant with DuckDB MCP (superior alternative) |
| Maintenance burden | 60/100 | 15% | 9.0 | Community project, unclear maintenance |
| Community validation | 50/100 | 15% | 7.5 | Stars unclear, from "Unravel team" |

**TOTAL**: **67.0/100** ⚠️ **FUTURE (REDUNDANT with DuckDB)**

### Decision: FUTURE → Move to pipeline/evaluation/completed/ with note

**Rationale**: Scores 67/100, below approval threshold (70+). More critically, **DuckDB MCP (87.25/100) is strictly superior** for the same use case:
- More file formats
- Full SQL vs limited operations
- OLAP-optimized performance
- Cloud persistence option
- Official backing + 20k+ community

**Recommendation**: Integrate DuckDB MCP instead. Mark mcp-analyst as "superseded by DuckDB MCP".

**Reconsider if**: DuckDB MCP has issues (integration problems, MotherDuck costs excessive, performance disappointing). mcp-analyst could be fallback.
