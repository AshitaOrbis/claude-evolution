# GitHub MCP Server — Dynamic Toolset Discovery (`--dynamic-toolsets`) — Evaluation

- **Source**: https://github.com/github/github-mcp-server
- **Type**: MCP server improvement (IMPROVEMENT over existing)
- **Comparison target**: `pipeline/evaluation/completed/github-mcp-2026-updates-discovery.md` (scored 66/100, classified FUTURE 2026-02-06)
- **Evaluated**: 2026-03-19

## What It Is

GitHub's official MCP server now supports `--dynamic-toolsets` flag (or `GITHUB_DYNAMIC_TOOLSETS=1` env var). Instead of loading all tools at startup, tools are discovered and enabled in response to user prompts — reducing context clutter and tool count confusion. Available via Docker.

## Prior Evaluation Context

The February 2026 evaluation scored GitHub MCP at 66/100 (FUTURE) — below the 70 threshold, primarily because:
- Capability expansion was low (40/100): gh CLI already handles our workflows
- Token efficiency was 50/100: MCP adds 2-3k overhead vs zero-cost Bash
- **Conclusion**: "gh CLI works well, zero tokens, transparent. No churn justified."

## How This Feature Changes the Assessment

`--dynamic-toolsets` directly addresses the token overhead concern: tools only load when requested rather than all upfront. This is architecturally equivalent to Claude Code's Tool Search Tool (deferred loading) but applied at the GitHub MCP server level. Conceptually similar to `disabledMcpjsonServers` but more granular and dynamic.

**Does Tool Search Tool already handle this?** Partially — Tool Search Tool handles deferred schema loading for MCP tools in general. But `--dynamic-toolsets` is a server-side feature that controls which toolsets are even available, not just which schemas are loaded. Complementary, not redundant.

## Redundancy Check

**IMPROVEMENT** (confirmed). Prior evaluation documents known GitHub MCP capabilities. Dynamic toolsets is a new feature not in the February evaluation. Addresses one of the two weak scoring criteria (token efficiency).

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 85 | Simple flag addition to existing Docker config. Prior evaluation already documented installation path. |
| Token efficiency impact | 60 | Dynamic loading reduces per-session overhead meaningfully. However, gh CLI remains zero-token — this reduces the gap but doesn't invert it. Net: moderate improvement over static GitHub MCP. |
| Capability expansion | 50 | Same as February evaluation — incremental over gh CLI. Dynamic toolsets is a quality-of-life improvement, not a new GitHub capability. We still don't use GitHub Projects (the main differentiator). |
| Maintenance burden | 95 | Official GitHub repository, 26.7k+ stars, actively maintained. |
| Community validation | 100 | 26.7k+ stars (ecosystem standard). Official GitHub announcement. |

**Weighted Score**: (85×0.20) + (60×0.25) + (50×0.25) + (95×0.15) + (100×0.15)
= 17 + 15 + 12.5 + 14.25 + 15 = **73.75/100**

## Decision

**APPROVED** (73.75 ≥ 70 threshold)

**Rationale**: Dynamic toolsets tips the score over the threshold by improving the token efficiency story. More importantly, this changes the risk calculus: the prior "don't adopt" argument was based partly on overhead concerns. With dynamic toolsets, those concerns are substantially reduced. The integration is low-risk (just a flag) and keeps the door open for GitHub Projects or Copilot agent workflows without full overhead commitment.

**Note**: APPROVED means updating the registry and noting this feature is available — not necessarily installing GitHub MCP immediately. The workflow-fit question (do we need it over gh CLI?) remains the adoption trigger, but the technical barrier is lower now.

## Integration Actions

1. **Registry update**: Update `registry/existing-capabilities.md` GitHub MCP entry. Change status from FUTURE (66/100) to NOTE (73.75/100, improvement). Add `--dynamic-toolsets` feature to the entry.

2. **Future trigger update**: The February evaluation listed three adoption triggers:
   - We start using GitHub Projects heavily
   - gh CLI pain points emerge
   - Enterprise OAuth needs

   No triggers met yet — but when they are, note that `--dynamic-toolsets` reduces the token overhead concern.

3. **Integration file**: This evaluation file serves as the record. No installation action needed until adoption triggers are met.

## Prior Evaluation Reference

Full context: `pipeline/evaluation/completed/github-mcp-2026-updates-discovery.md`
- Previous score: 66/100 (FUTURE)
- Delta from this improvement: +7.75 points (primarily token efficiency: 50→60)
- Status change: FUTURE → APPROVED (with deferred adoption pending trigger conditions)
