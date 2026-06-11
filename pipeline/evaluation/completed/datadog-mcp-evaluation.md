# Evaluation Report: Datadog MCP Server

**Date**: 2026-02-06
**Source**: https://github.com/winor30/mcp-server-datadog
**Category**: MCP Server
**License**: Apache 2.0
**Stars**: 125

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 55 | 20% | 11.0 | API key setup straightforward, but requires Datadog subscription ($$$) |
| Token Efficiency | 50 | 25% | 12.5 | Unknown response verbosity; 20 tools moderate |
| Capability Expansion | 30 | 25% | 7.5 | We don't use Datadog. Zero value without the platform. Grafana MCP is stronger for monitoring. |
| Maintenance Burden | 40 | 15% | 6.0 | Community project, single maintainer risk (winor30), not official Datadog |
| Community Validation | 60 | 15% | 9.0 | 125 stars, active but low adoption |
| **WEIGHTED TOTAL** | | | **46.0** | |

## Cross-Validation

Codex MCP unavailable during evaluation. Claude-only assessment.

## Comparison with Grafana MCP

Grafana MCP is superior in every dimension:
- Official (Grafana) vs community (single dev)
- 2.2k stars vs 125 stars
- 40+ tools vs 20 tools
- If we adopt monitoring, Grafana is the better bet

## Decision: REJECT (46.0/100)

**Rationale**: We don't use Datadog, this is community-maintained (not official), and Grafana MCP is the stronger monitoring option if we ever need observability. No path to value without a Datadog subscription.

**Routing**: Move to `archive/rejected/`.
