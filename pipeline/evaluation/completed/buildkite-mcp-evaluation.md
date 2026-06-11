# Evaluation Report: Buildkite MCP Server

**Date**: 2026-02-06
**Source**: https://github.com/buildkite/buildkite-mcp-server
**Category**: MCP Server
**License**: MIT
**Stars**: 42

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 70 | 20% | 14.0 | Standard MCP setup with API token |
| Token Efficiency | 55 | 25% | 13.75 | Unknown response format; pipeline/build data can be verbose |
| Capability Expansion | 20 | 25% | 5.0 | We do NOT use Buildkite. Zero value without the platform. |
| Maintenance Burden | 75 | 15% | 11.25 | Official Buildkite, 441 commits, active |
| Community Validation | 40 | 15% | 6.0 | 42 stars - very low adoption |
| **WEIGHTED TOTAL** | | | **50.0** | |

## Cross-Validation

Codex MCP unavailable during evaluation. Claude-only assessment.

## Decision: REJECT (50.0/100)

**Rationale**: We don't use Buildkite. Same reasoning as CircleCI - wrong platform for our stack. GitHub Actions via `gh` CLI covers our CI/CD needs.

**Routing**: Move to `archive/rejected/`.
