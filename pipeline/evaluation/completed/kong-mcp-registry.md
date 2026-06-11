# Kong MCP Registry

**Source**: https://konghq.com/company/press-room/press-release/kong-introduces-mcp-registry
**Date**: 2026-02-02
**Category**: Enterprise Infrastructure - MCP Governance Platform
**Status**: Tech preview in Kong Konnect

## Description

Kong MCP Registry is an **enterprise directory** within Kong Konnect's Catalog for centrally managing, discovering, and governing MCP servers at scale. It's not an MCP server itself - it's a **registry service** for managing MCP servers in enterprise environments.

**Key Features**:

1. **Dynamic Discovery**
   - Centralized enterprise catalog of approved MCP servers
   - Self-service discovery without hardcoded configurations
   - Integration with Kong Konnect API governance

2. **Policy-Based Controls**
   - Only approved MCP servers accessible to agents
   - Centralized visibility into tool usage, health, failures
   - Compliance with AI Alliance Interoperability Framework

3. **API-Linked Visibility**
   - Links MCP servers to underlying APIs
   - Tracks dependencies, ownership, applied policies
   - Enterprise observability for AI agent tools

## Why It Matters (For Enterprises)

- **Governance at scale** - Control which MCP servers agents can use
- **Security compliance** - Audit trail, approval workflows
- **Operational visibility** - Health monitoring, failure tracking
- **Enterprise adoption** - Solves "MCP sprawl" problem

## Redundancy Check

**Keywords searched**: "mcp registry", "mcp governance", "enterprise mcp management", "mcp catalog", "ai tool governance"

**Registry match**: NONE

**Classification**: **NOVEL** - Enterprise infrastructure, not a capability we need

**Overlap**: N/A - This is for enterprises managing hundreds of MCP servers across teams

## Applicability to Our Environment

**Our scale**:
- Single developer
- ~10 MCP servers in `~/.claude.json`
- Manual configuration acceptable
- No team governance needs

**Enterprise scale (Kong's target)**:
- Hundreds of developers
- Thousands of MCP servers
- Policy enforcement required
- Audit compliance mandated

## Preliminary Assessment

| Criterion | Score (0-100) | Reasoning |
|-----------|---------------|-----------|
| Integration complexity | N/A | Cloud service, not local tool |
| Token efficiency | N/A | Infrastructure service |
| Capability expansion | 20 | Solves enterprise problem we don't have |
| Maintenance burden | N/A | Kong-hosted service |
| Community validation | 70 | Kong is established (200k+ GitHub stars on Kong Gateway) |

**Estimated Score**: **REJECTED** (~25/100 for solo/small team use)

## Decision

**Status**: **REJECTED** - Not applicable to single-developer or small team environments

**Rejection Reason**: Enterprise-scale infrastructure addressing problems we don't have. Kong MCP Registry is designed for organizations with:
- 100+ developers using AI tools
- Governance/compliance requirements
- Centralized IT control over tool access

**Future Reconsideration Trigger**: If we build a team of 10+ developers with compliance requirements

## Notes

- Excellent product for the right audience (enterprise IT/platform teams)
- Indicates maturation of MCP ecosystem (governance layer emerging)
- Not an MCP server - a meta-infrastructure for managing MCP servers
- Kong Konnect is a paid cloud platform

---

## Evaluation

**Evaluated**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Scoring Breakdown

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | N/A | 20% | 0 | Cloud service, not local tool (not integrable) |
| Token Efficiency | N/A | 25% | 0 | Infrastructure service (no token impact) |
| Capability Expansion | 15/100 | 25% | 3.75 | Solves enterprise problem we don't have (10 MCP servers vs 1000s) |
| Maintenance Burden | 100/100 | 15% | 15.0 | Kong-hosted SaaS (zero maintenance) |
| Community Validation | 70/100 | 15% | 10.5 | Kong Gateway has 200k+ stars, established vendor |
| **TOTAL** | | | **29.25/100** | |

### Cross-Validation: Not Required
Score far below 50 threshold - clear rejection case.

### Redundancy Check

**Classification**: NOVEL (but not applicable) - Enterprise infrastructure for scale we don't have

**Our scale**: 1 developer, ~10 MCP servers, manual config acceptable
**Kong's target**: 100+ developers, 1000+ MCP servers, policy enforcement, compliance

### Decision

**STATUS**: REJECTED (Score: 29.25/100)

**Rejection Reasons**:
1. **Wrong scale** - Designed for enterprises managing hundreds of MCP servers
2. **Not integrable** - Cloud platform, not a local tool/MCP
3. **Zero value at our scale** - Manual `~/.claude.json` management is sufficient
4. **Paid platform** - Requires Kong Konnect subscription

**Kill Signal**: "Platform-specific tool for problems we don't have"

### Notes

- Indicates healthy MCP ecosystem maturation (governance layer emerging)
- Excellent product for the RIGHT audience (enterprise platform teams)
- Similar pattern to Datadog/CircleCI MCPs - great tools, wrong fit
- DO NOT reconsider unless team scales to 10+ developers with compliance needs
