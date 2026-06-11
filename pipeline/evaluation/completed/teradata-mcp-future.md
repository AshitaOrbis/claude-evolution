# Teradata Enterprise MCP

**Source**: https://www.teradata.com/insights/ai-and-machine-learning/enterprise-mcp-build-data-analyst-agent
**Discovery Date**: 2026-02-06
**Category**: Database / Data Analytics / Enterprise

## Summary

Enterprise-grade MCP from Teradata for building data analyst agents with agentic AI-powered analytics. Designed for secure, scalable analytics in autonomous enterprises. Announced January 27, 2026.

## Key Features

- Agentic reasoning for data analysis
- Autonomous enterprise stack (knowledge layer, agent layer, outcomes layer)
- Secure, scalable analytics
- Data analyst agent creation
- Enterprise-grade (Teradata brand)

## Stack Match Analysis

**Platform Dependency**: ❌ **BLOCKER** - Requires Teradata database
**Current Usage**: We use PostgreSQL, not Teradata
**Target Market**: Large enterprises with Teradata data warehouses

## Quick Assessment Scores

- Integration complexity: **10** (Requires Teradata we don't have)
- Token efficiency impact: **50** (Unknown)
- Capability expansion: **70** (IF we used Teradata, valuable)
- Maintenance burden: **80** (Official Teradata, enterprise support)
- Community validation: **60** (Official vendor, but niche market)

**TOTAL**: **42/100** (Weighted)

## Recommended Action

- [ ] **REJECT** - Platform dependency blocker
- Reason: We don't use Teradata databases
- Market: Large enterprises (not our scale)
- Alternative: AWS Labs Postgres MCP (our stack), DuckDB MCP (analytics)

## Similar Platform Rejections

- GoodData MCP (44/100) - Don't use GoodData
- BigQuery MCP (62/100) - Don't use BigQuery
- Datadog MCP (46/100) - Don't use Datadog

## Notes

- Teradata = enterprise data warehouse (Oracle/SAP scale)
- Overkill for our PostgreSQL + DuckDB analytics needs
- Good signal: More vendors launching MCPs (Teradata, Google, GoodData)

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: Database Operations - PostgreSQL via Bash, DuckDB MCP for analytics

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 10/100 | 20% | 2.0 | Requires Teradata database we don't have |
| Token Efficiency Impact | 50/100 | 25% | 12.5 | Unknown |
| Capability Expansion | 65/100 | 25% | 16.25 | IF we used Teradata, valuable |
| Maintenance Burden | 80/100 | 15% | 12.0 | Official Teradata, enterprise support |
| Community Validation | 60/100 | 15% | 9.0 | Official vendor, niche market |
| **TOTAL** | | | **51.75/100** | FUTURE |

### Redundancy Analysis

**Classification**: NOT REDUNDANT (platform-specific)

**Platform Mismatch**:
- Teradata: Enterprise data warehouse (Oracle/SAP scale)
- Our stack: PostgreSQL (OLTP) + DuckDB (OLAP)
- Market: Large enterprises vs our scale

**No overlap** - Teradata and PostgreSQL serve different markets

### Decision

**FUTURE** (Score: 51.75/100)

**Reasoning**:
1. Score in FUTURE range (50-69)
2. Platform dependency blocker (we don't use Teradata)
3. Enterprise-scale solution (not our scale)
4. Alternative exists: PostgreSQL + DuckDB cover our needs

**Why FUTURE instead of REJECT**:
- Score above 50 threshold (51.75/100)
- Official vendor MCP (enterprise-grade maintenance)
- Good signal: Major vendors adopting MCP ecosystem

**Adoption Trigger**: If we migrate to Teradata data warehouse, revisit

**Similar Decisions**:
- Grafana MCP: 64.5/100 (FUTURE) - Don't use Grafana YET
- Terraform MCP: 70.75/100 (FUTURE) - IaC adoption required
- Pulumi MCP: 64.0/100 (FUTURE) - Loses to Terraform for AWS

**Action**: Move to `pipeline/evaluation/completed/teradata-mcp-future.md` with adoption trigger
