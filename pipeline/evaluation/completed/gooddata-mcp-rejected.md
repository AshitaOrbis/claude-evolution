# GoodData MCP Server (Experimental)

**Source**: https://www.gooddata.com/docs/cloud/experimental-features/mcp-server/
**Discovery Date**: 2026-02-06
**Category**: Data Analytics / BI

## Summary

Experimental MCP server from GoodData (BI/analytics platform) exposing GoodData features to external MCP clients. Enables natural language interaction with GoodData analytics, dashboards, and data models.

## Key Features

- Natural language interaction with GoodData
- Access to GoodData analytics features
- Secure, consistent data access
- Experimental feature (active development)
- Connect from custom MCP clients (chatbots, IDE assistants)

## Stack Match Analysis

**Platform Dependency**: ❌ **BLOCKER** - Requires GoodData Cloud subscription
**Current Usage**: We don't use GoodData (no BI platform currently)
**Alternative**: DuckDB MCP for ad-hoc analytics (already integrated)

## Quick Assessment Scores

- Integration complexity: **20** (Requires GoodData subscription we don't have)
- Token efficiency impact: **50** (Unknown - no specs)
- Capability expansion: **70** (BI platform access would be valuable IF we used it)
- Maintenance burden: **40** (Experimental, behavior may change)
- Community validation: **60** (Official GoodData, but experimental status)

**TOTAL**: **44/100** (Weighted)

## Recommended Action

- [ ] **REJECT** - Platform dependency blocker
- Reason: Requires GoodData Cloud subscription
- We don't have a BI platform (DuckDB MCP covers ad-hoc analytics)
- Adoption trigger: If we adopt GoodData Cloud, revisit

## Similar Rejections

- Datadog MCP (46/100) - Don't use Datadog
- CircleCI MCP (51.25/100) - Don't use CircleCI
- Grafana MCP (64.5/100, FUTURE) - Don't use Grafana YET

## Notes

- First-party vendor MCP (like Grafana, Datadog pattern)
- Experimental status = breaking changes expected
- Natural language analytics would be valuable IF platform adoption happens

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: DevOps & Infrastructure - Platform dependency rejections (Grafana, Datadog, CircleCI)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 20/100 | 20% | 4.0 | Requires GoodData subscription we don't have |
| Token Efficiency Impact | 50/100 | 25% | 12.5 | Unknown (no specs, experimental) |
| Capability Expansion | 65/100 | 25% | 16.25 | BI access valuable IF we used it |
| Maintenance Burden | 40/100 | 15% | 6.0 | Experimental status, behavior may change |
| Community Validation | 60/100 | 15% | 9.0 | Official vendor but experimental |
| **TOTAL** | | | **47.75/100** | REJECT |

### Redundancy Analysis

**Classification**: NOT REDUNDANT (platform-dependent)

**Platform Dependency Kill Signal**:
- Requires GoodData Cloud subscription (blocker)
- We don't have BI platform (DuckDB MCP covers ad-hoc analytics)
- Similar pattern to rejected platform MCPs: Datadog (46/100), Grafana (64.5/100, FUTURE)

### Decision

**REJECT** (Score: 47.75/100)

**Rejection Reasons**:
1. Platform dependency blocker (requires GoodData Cloud subscription)
2. We don't use GoodData or any BI platform currently
3. DuckDB MCP already provides analytics capabilities (OLAP)
4. Experimental status = potential breaking changes
5. Falls below 50-point threshold (47.75/100)

**Adoption Trigger**: If we adopt GoodData Cloud platform, revisit

**Similar Rejections**:
- Datadog MCP: 46.0/100 (don't use Datadog)
- CircleCI MCP: 51.25/100 (don't use CircleCI)
- Teradata MCP: 42.0/100 (don't use Teradata)

**Action**: Move to `pipeline/evaluation/completed/gooddata-mcp-rejected.md`
