# Evaluation: MCP-tidy - Unused MCP Server Identification

- **Date**: 2026-02-06
- **Source**: https://github.com/nnnkkk7/mcp-tidy
- **Category**: CLI Tool / Technique
- **License**: MIT
- **Stars**: 2 (was reported as higher in discovery, confirmed 2 on GitHub)
- **Last Updated**: Jan 2026

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 80 | `brew install` or `go install`. Easy. |
| Token efficiency impact | 25% | 25 | Tool Search Tool already provides 85% token reduction dynamically at runtime. MCP-tidy is one-time housekeeping. Marginal incremental value. |
| Capability expansion | 25% | 30 | IMPROVEMENT over manual `disabledMcpjsonServers` management, but Tool Search Tool renders MCP bloat a non-issue at runtime. This solves yesterday's problem. |
| Maintenance burden | 15% | 70 | Go binary, MIT, low maintenance. But needs periodic re-runs. |
| Community validation | 15% | 20 | 2 GitHub stars. Essentially no community validation. |

**Weighted Score**: (80x0.20) + (25x0.25) + (30x0.25) + (70x0.15) + (20x0.15) = 16 + 6.25 + 7.5 + 10.5 + 3 = **43.25/100**

## Registry Overlap Check

**Tool Search Tool** (IMPLEMENTED, score 89/100):
- Automatic, zero-configuration, 85% token reduction
- Handles dynamic tool loading at runtime
- Supports up to 10,000 tools in catalog

**disabledMcpjsonServers** (IMPLEMENTED):
- Manual but effective for explicit control

**MCP-tidy adds**: Usage statistics from transcript logs. This is informational but not actionable given Tool Search Tool handles the runtime problem automatically.

## Decision

**REJECT** - Score 43.25, below threshold.

**Rationale**: MCP-tidy solves a problem that Tool Search Tool already handles dynamically and automatically. The one-time housekeeping value (removing unused servers from config) is marginal when Tool Search Tool ensures unused servers' tools never load into context. With only 2 stars and the core problem already solved, integration is not justified.

**Alternative**: Document "run `mcp-tidy stats` occasionally for config hygiene" as a tip in the MCP inventory helper, rather than formally integrating.
