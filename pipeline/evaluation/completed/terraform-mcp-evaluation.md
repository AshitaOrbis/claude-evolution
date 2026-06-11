# Evaluation Report: Terraform MCP Server

**Date**: 2026-02-06
**Source**: https://github.com/hashicorp/terraform-mcp-server
**Category**: MCP Server
**License**: MPL-2.0
**Stars**: 1,200+

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 70 | 20% | 14.0 | Docker or binary install, TFE_TOKEN for HCP (optional), Registry access works without auth |
| Token Efficiency | 65 | 25% | 16.25 | Registry API docs are useful but verbose; provider documentation responses can be large |
| Capability Expansion | 60 | 25% | 15.0 | IaC is a gap, but we don't use Terraform today. Registry lookup is nice-to-have for generating configs |
| Maintenance Burden | 85 | 15% | 12.75 | Official HashiCorp, active development, v0.4.0 recent |
| Community Validation | 85 | 15% | 12.75 | 1.2k stars, official, 312 commits |
| **WEIGHTED TOTAL** | | | **70.75** | |

## Cross-Validation

Codex MCP unavailable during evaluation. Claude-only assessment.

## Decision: CONDITIONAL APPROVE (70.75/100)

**Rationale**: Borderline approve. The Registry access feature adds value even without active Terraform usage - Claude can generate accurate Terraform configs for our AWS infrastructure using real-time provider docs instead of training data. However, we manage AWS manually today (console/CLI), so IaC adoption is a prerequisite for full value. Approve with `defer_loading: true` and low priority.

**Routing**: Move to `pipeline/future/` - value is real but depends on IaC adoption decision. Score is borderline (70.75) and the "generate Terraform for AWS" use case alone doesn't justify integration overhead without a commitment to Terraform.

**Trigger for re-evaluation**: If we decide to adopt IaC for <private-project> AWS infrastructure, promote immediately.
