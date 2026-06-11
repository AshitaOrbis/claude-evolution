# AWS PostgreSQL MCP Server (T1nker-1220)

**Source**: https://github.com/T1nker-1220/aws-postgress-mcp-server
**Discovery Date**: 2026-02-06
**Category**: Database / AWS

## Summary

Read-only SQL query access to AWS PostgreSQL databases via MCP. Provides `query` tool for SELECT queries and database introspection. Configuration via environment variables.

## Key Features

- Read-only SQL query execution (SELECT queries)
- Database information retrieval
- Environment variable configuration (host, port, user, password, database)
- TypeScript/Node.js implementation (pnpm)

## Potential Value

**Stack Match**: ✅ PERFECT - We use AWS RDS PostgreSQL
**Current Gap**: We access PostgreSQL via Bash (psql) which is zero-token
**Novel Capability**: MCP structured interface vs CLI

## Quick Assessment Scores

- Integration complexity: **75** (Simple: pnpm install + env vars)
- Token efficiency impact: **40** (Adds MCP overhead vs zero-token psql)
- Capability expansion: **50** (Structured output, but psql has --json flag)
- Maintenance burden: **60** (Community-maintained, 22 stars, recent Jan 2026)
- Community validation: **35** (Only 22 stars, very new)

**TOTAL**: **52/100** (Weighted)

## Recommended Action

- [ ] **NEEDS RESEARCH** - Compare MCP vs psql --json for our use cases
- Blocker: Token efficiency questionable vs built-in psql
- Key question: Does structured MCP interface justify token overhead?
- Consider: Official AWS Labs postgres-mcp-server (7.9k stars) vs this (22 stars)

## Notes

- Two implementations found:
  1. T1nker-1220/aws-postgress-mcp-server (22 stars, community)
  2. awslabs/mcp postgres server (7.9k stars, official AWS Labs)
- Need to evaluate AWS Labs version separately (likely higher score)
- Registry check: Database Operations section says psql via Bash is preferred

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: Database Operations - "Bash provides zero-token database access via native CLIs"

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 75/100 | 20% | 15.0 | Simple pnpm install + env vars |
| Token Efficiency Impact | 30/100 | 25% | 7.5 | Adds 2-3k MCP overhead vs zero-token psql |
| Capability Expansion | 45/100 | 25% | 11.25 | Structured output exists via psql --json |
| Maintenance Burden | 60/100 | 15% | 9.0 | Community-maintained, 22 stars, recent |
| Community Validation | 35/100 | 15% | 5.25 | Only 22 stars, very new |
| **TOTAL** | | | **48.0/100** | REJECT |

### Redundancy Analysis

**Classification**: DUPLICATE

**Existing capability**: Bash tool + psql CLI (zero tokens)
- PostgreSQL CLI provides: Query execution, JSON output (--json), connection management (.pgpass)
- Registry explicitly states: "Bash provides zero-token database access via native CLIs"
- MCP overhead: 2-3k tokens for exact same functionality

**Community alternative**: AWS Labs Postgres MCP (7.9k stars) vs this (22 stars)
- If we wanted MCP approach, official AWS Labs version is superior choice
- Community validation: 7,900 vs 22 stars (359x difference)

### Decision

**REJECT** (Score: 48.0/100)

**Rejection Reasons**:
1. 100% functional overlap with psql via Bash (zero tokens)
2. Token efficiency negative (adds cost with zero benefit)
3. Low community validation (22 stars vs 7.9k AWS Labs alternative)
4. Registry explicitly documents psql as preferred approach
5. Falls below 50-point threshold (48.0/100)

**Adoption Trigger**: None - psql via Bash is optimal for our stack

**Action**: Move to `pipeline/evaluation/completed/aws-postgres-mcp-rejected.md`
