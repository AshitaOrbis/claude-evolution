# Evaluation: Miro MCP Server (Final Resolution)

- **Date**: 2026-02-06 (resolves NEEDS_RESEARCH from earlier evaluation)
- **Source**: https://github.com/miroapp/miro-ai (official), https://developers.miro.com/docs/mcp-intro
- **Category**: MCP
- **License**: MIT
- **Stars**: 11 (miroapp/miro-ai official repo)
- **Status**: Beta
- **Previous Score**: 66.0/100 (NEEDS_RESEARCH)

## Updated Research Findings

1. **Official Miro MCP is HTTP-based**: `claude mcp add --transport http miro https://mcp.miro.com` -- very easy setup
2. **Requires Miro account**: Free tier exists but limited. Some tools use "Miro AI Credits" (paid feature)
3. **Tools exposed**: `board_get_items`, `board_get_image_data`, `context_get_board_docs`, plus creation tools
4. **We do NOT have a Miro subscription**: This is the kill signal
5. **Only 11 stars on official repo**: Very new, beta status, limited adoption
6. **Enterprise requires admin enablement**: Additional friction for teams

## Revised Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 85 | Official HTTP MCP, one-command setup. Very easy IF you have a Miro account. |
| Token efficiency impact | 25% | 50 | Neutral with defer_loading. Tools add context only when invoked. |
| Capability expansion | 25% | 35 | Novel (visual collaboration) BUT we have no Miro subscription. Zero usability without account. Mermaid diagrams cover basic diagramming needs via Bash. |
| Maintenance burden | 15% | 80 | Official Miro-maintained, Anthropic collaboration. Low burden. |
| Community validation | 15% | 40 | Only 11 stars on official repo. Beta status. Very early. |

**Weighted Score**: (85x0.20) + (50x0.25) + (35x0.25) + (80x0.15) + (40x0.15) = 17 + 12.5 + 8.75 + 12 + 6 = **56.25/100**

## Resolution

Previous evaluation scored 66.0 with optimistic capability expansion (55). After research:
- Confirmed we have NO Miro subscription (kill signal for usability)
- Only 11 stars on official repo (beta, early adoption)
- Mermaid/ASCII diagrams via Bash tool cover basic diagramming at zero token cost

**REJECT** - Score revised down to 56.25/100.

**Rationale**: Official vendor MCP with clean integration, but completely unusable without a Miro subscription we do not have. The visual collaboration capability is real but inaccessible. Mermaid diagrams serve basic needs.

**Reconsideration Triggers**:
- Active Miro subscription acquired
- Miro MCP exits beta with free-tier full support
- Project requiring heavy visual collaboration with team members who use Miro
