# Discovery: MCP Registry (Official Anthropic)

**Source**: https://www.gentoro.com/blog/what-is-anthropics-new-mcp-registry
**Category**: Infrastructure | MCP
**Date**: 2026-02-06

## Summary

Anthropic's official upstream directory for MCP servers. Acts as authoritative "backbone" providing metadata (connection info for live servers, execution hints for local servers) rather than executable code. Uses DNS-like identity system with namespaces (reverse-DNS patterns like com.slack/calendar) and stable UUIDs. Authentication via DNS challenges or GitHub account verification.

## Potential Value

- **Integration complexity**: 40/100 (requires understanding namespace/UUID system)
- **Token efficiency impact**: 70/100 (improves discovery reliability, no runtime overhead)
- **Capability expansion**: 65/100 (authoritative directory, complements existing registries)
- **Maintenance burden**: 80/100 (official Anthropic support)
- **Community validation**: 85/100 (official Anthropic infrastructure)

**TOTAL**: 68/100

## Key Details

- **Status**: Announced September 2025 as "preview", appears operational now
- **Purpose**: Authoritative backbone (not user-facing discovery like Smithery/Glama)
- **Identity System**: Namespaces + stable UUIDs + authentication
- **Metadata stored**: Connection info (live servers), execution hints (local servers)
- **Does NOT replace**: Existing registries (Smithery, Mastra, Glama, MCP.so)

## Relationship to Existing Stack

- **Complementary**: Existing registries continue providing user-facing search/curation
- **Value-add**: Authoritative source for namespace ownership, stable identifiers
- **Integration**: May improve MCP discovery reliability in Claude Code

## Questions for Evaluation

1. Is MCP Registry already integrated into Claude Code 2.1.34?
2. Does it affect token efficiency or discovery speed?
3. What's the adoption path for users?
4. Does it enable new capabilities we don't have?

## Recommended Action

[X] Evaluate further - Determine if already integrated or requires action
[ ] Reject
[ ] Fast-track integration

---

## Evaluation

**Date**: 2026-02-06
**Context**: MCP Registry is infrastructure (not user-facing tool). Likely already integrated into Claude Code 2.1.34.

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 0/100 | 20% | 0.0 | **ALREADY INTEGRATED**: Anthropic infrastructure |
| Token Efficiency | 70/100 | 25% | 17.5 | Improves discovery reliability, no runtime cost |
| Capability Expansion | 50/100 | 25% | 12.5 | **INFRASTRUCTURE**: Authoritative directory, not new feature |
| Maintenance Burden | 100/100 | 15% | 15.0 | Official Anthropic support |
| Community Validation | 85/100 | 15% | 12.75 | Official Anthropic infrastructure |
| **TOTAL** | | | **57.75** | **DOCUMENT ONLY** |

### Decision: DOCUMENT ONLY

**Reason**: This is Anthropic's backend infrastructure, not a user-facing tool to integrate. Likely already active in Claude Code 2.1.34. Add to registry as documentation.

**Action**: Add to existing-capabilities.md under "MCP Infrastructure" section noting official registry for namespace/UUID management.
