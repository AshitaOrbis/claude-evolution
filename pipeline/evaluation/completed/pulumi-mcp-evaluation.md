# Evaluation Report: Pulumi MCP Server

**Date**: 2026-02-06
**Source**: https://github.com/pulumi/mcp-server
**Category**: MCP Server
**License**: Unknown (check repo)
**Stars**: Unknown (remote server focus)

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 80 | 20% | 16.0 | Remote URL option = zero local install, but requires Pulumi Cloud account + OAuth |
| Token Efficiency | 60 | 25% | 15.0 | Unknown API response verbosity; Pulumi Neo delegation adds overhead |
| Capability Expansion | 45 | 25% | 11.25 | IaC gap exists but we don't use Pulumi; overlaps with Terraform MCP for same gap |
| Maintenance Burden | 85 | 15% | 12.75 | Official Pulumi, remote = auto-updates |
| Community Validation | 60 | 15% | 9.0 | Official but lower visibility than Terraform MCP, remote-first is new pattern |
| **WEIGHTED TOTAL** | | | **64.0** | |

## Cross-Validation

Codex MCP unavailable during evaluation. Claude-only assessment.

## Comparison with Terraform MCP

If we adopt IaC, we should pick ONE platform. Terraform wins for our use case:
- Larger community (1.2k vs unknown stars)
- HCL is industry standard for AWS IaC
- More documentation and examples available
- Terraform Registry is the largest IaC module ecosystem

Pulumi's TypeScript support is appealing but insufficient to overcome Terraform's ecosystem advantage.

## Decision: FUTURE (64.0/100)

**Rationale**: Good MCP with innovative remote hosting pattern, but loses head-to-head with Terraform MCP for our AWS use case. We don't use Pulumi and wouldn't choose it over Terraform. The remote MCP pattern is interesting for future reference.

**Routing**: Move to `pipeline/future/` - only relevant if we specifically choose Pulumi over Terraform for IaC.
