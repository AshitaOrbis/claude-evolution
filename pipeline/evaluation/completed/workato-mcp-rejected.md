# Workato Pre-Built MCP Servers

**Source**: https://www.workato.com/product-hub/now-available-pre-built-mcp-servers/
**Discovery Date**: 2026-02-06
**Category**: Workflow Automation / Integration Platform

## Summary

Pre-built MCP servers from Workato (enterprise automation platform) enabling workflows across Salesforce, Slack, Jira, Google Workspace through unified orchestration. Governance controls for rate limiting, usage policies, access controls. Announced February 5, 2026.

## Key Features

- Multi-app integration (Salesforce, Slack, Jira, Google Workspace)
- Unified orchestration layer
- Governance: Rate limiting, usage policies, access controls
- Pre-built (production-ready)
- Enterprise-focused

## Stack Match Analysis

**Platform Dependency**: ⚠️ **BLOCKER** - Requires Workato subscription
**Current Usage**: We don't use Workato (no enterprise automation platform)
**Alternative**: Rube MCP (500+ apps, already integrated)

## Redundancy Check

**Rube MCP** (already integrated):
- 500+ app integrations (Composio platform)
- Single MCP server replaces dozens
- OAuth 2.1 authentication
- Natural language → API translation
- SOC 2 compliant

**Workato MCP**:
- Specific apps (Salesforce, Slack, Jira, Google Workspace)
- Enterprise governance controls
- Requires Workato subscription

**Overlap**: ~80% functional overlap with Rube MCP

## Quick Assessment Scores

- Integration complexity: **20** (Requires Workato subscription)
- Token efficiency impact: **50** (Unknown, likely similar to Rube)
- Capability expansion: **40** (80% overlap with Rube MCP)
- Maintenance burden: **80** (Official Workato, enterprise-grade)
- Community validation: **60** (Official vendor, Feb 2026 launch)

**TOTAL**: **44/100** (Weighted)

## Recommended Action

- [ ] **REJECT** - Platform dependency + redundancy with Rube MCP
- Reason: Requires Workato subscription we don't have
- Alternative: Rube MCP covers 500+ apps (already integrated)
- Adoption trigger: If we adopt Workato platform, revisit

## Comparison: Workato vs Rube vs n8n

| Feature | Workato MCP | Rube MCP | n8n MCP |
|---------|-------------|----------|---------|
| Platform required | Workato | None | n8n instance |
| Apps | Salesforce, Slack, Jira, Google | 500+ | 525+ nodes |
| Our status | ❌ Not used | ✅ Integrated | Future (approved) |
| Governance | ✅ Enterprise | ✅ SOC 2 | ❌ Self-managed |
| Cost | Workato subscription | Free tier | n8n cost |

**Winner**: Rube MCP (already integrated, broader coverage, no platform lock-in)

## Similar Rejections

- GoodData MCP (44/100) - Platform dependency
- Teradata MCP (42/100) - Platform dependency
- CircleCI MCP (51.25/100) - Platform dependency

## Notes

- Workato is enterprise automation platform (Zapier/n8n competitor)
- Pre-built MCPs = production-ready (vs community n8n-mcp)
- Governance features are nice, but Rube MCP has SOC 2
- If Rube MCP didn't exist, this would score higher (~65-70/100)

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator
**Registry Match**: Unified Integration Platforms - Rube MCP (IMPLEMENTED)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 20/100 | 20% | 4.0 | Requires Workato subscription we don't have |
| Token Efficiency Impact | 50/100 | 25% | 12.5 | Unknown, likely similar to Rube MCP |
| Capability Expansion | 35/100 | 25% | 8.75 | 80% overlap with Rube MCP (500+ apps) |
| Maintenance Burden | 80/100 | 15% | 12.0 | Official Workato, enterprise-grade |
| Community Validation | 60/100 | 15% | 9.0 | Official vendor, Feb 2026 launch |
| **TOTAL** | | | **46.25/100** | REJECT |

### Redundancy Analysis

**Classification**: DUPLICATE (80% functional overlap)

**Existing capability**: Rube MCP (IMPLEMENTED)
- Rube: 500+ apps, OAuth 2.1, SOC 2 compliant, no platform required
- Workato: Salesforce/Slack/Jira/Google, governance controls, requires Workato subscription

**Overlap assessment**:
| Feature | Workato MCP | Rube MCP (existing) |
|---------|-------------|---------------------|
| Platform required | ✅ Required | ❌ None |
| App coverage | 4 specific apps | 500+ apps |
| Governance | Enterprise controls | SOC 2 compliant |
| Auth | Workato-managed | OAuth 2.1 |
| Status | ❌ Not used | ✅ Integrated |

**Verdict**: Rube MCP is superior (broader coverage, no platform lock-in)

### Decision

**REJECT** (Score: 46.25/100)

**Rejection Reasons**:
1. Platform dependency blocker (requires Workato subscription)
2. 80% functional overlap with Rube MCP (already integrated)
3. Narrower app coverage (4 apps vs 500+)
4. Platform lock-in (Workato ecosystem vs platform-agnostic Rube)
5. Falls below 50-point threshold (46.25/100)

**Adoption Trigger**: If we adopt Workato platform AND need governance features Rube lacks, revisit

**Comparison Hierarchy**:
- **Best**: Rube MCP (500+ apps, no platform, SOC 2) ✅ Integrated
- **Good**: n8n MCP (525+ nodes, requires n8n) - Future (approved 76.75/100)
- **Niche**: Workato MCP (4 apps, requires Workato) - Rejected

**Action**: Move to `pipeline/evaluation/completed/workato-mcp-rejected.md`
