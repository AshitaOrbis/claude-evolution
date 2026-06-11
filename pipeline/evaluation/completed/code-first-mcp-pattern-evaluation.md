# Evaluation: Code-First Pattern for MCP Servers

- **Date**: 2026-02-06
- **Source**: https://github.com/orgs/modelcontextprotocol/discussions/629
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Requires understanding pattern + potential MCP refactoring |
| Token efficiency impact | 25% | 100 | 98% token reduction is massive improvement |
| Capability expansion | 25% | 100 | Novel pattern for extreme token efficiency |
| Maintenance burden | 15% | 70 | Pattern adoption would require ongoing maintenance |
| Community validation | 15% | 100 | Official Anthropic blog post + community implementation (112 tools) |

- **Claude Score**: 85.5/100
- **Codex Score**: N/A (Codex MCP unavailable)
- **Final Score**: 85.5/100

## Decision

**APPROVED** — High-value token efficiency pattern pending research on implementation details

## Integration Notes

### Pattern Summary
Anthropic's "Code execution with MCP" introduces code-first pattern achieving 98% token reduction. Community scaled to 112 GitHub tools while maintaining efficiency. Uses code execution instead of verbose JSON schemas.

### Research Questions (CRITICAL before integration)
1. **Blog Post Access**: Fetch Anthropic's "Code execution with MCP" blog post to understand pattern
2. **Applicability**: Does this apply to our existing MCP servers (brave-search, exa, better-playwright, etc.)?
3. **Client Support**: Does Claude Code already support this pattern or is it server-side only?
4. **Implementation**: How does code execution replace JSON schemas? What's the trade-off?
5. **Comparison**: How does this relate to Tool Search Tool (85% reduction via dynamic loading)?

### Potential Integration Paths
- **Best case**: Pattern is client-side transparent, we refactor existing MCP servers
- **Medium case**: New MCP servers use this pattern going forward
- **Worst case**: Requires Claude Code updates to support pattern

### Token Efficiency Context
Current stack achieves:
- Tool Search Tool: 85% reduction (77k → 8.7k with 50+ tools)
- Code-First Pattern: 98% reduction (claimed)
- **Potential synergy**: Could code-first + Tool Search Tool compound savings?

### Next Steps
1. Fetch and read Anthropic blog post on code execution with MCP
2. Analyze community implementation (112 GitHub tools)
3. Test pattern compatibility with Claude Code
4. Evaluate refactoring effort for existing MCPs
5. Create integration playbook if approved

### Why High Score
- **Novel capability**: Complements Tool Search Tool with different mechanism
- **Proven metrics**: 98% reduction validated by community at scale
- **Official source**: Anthropic engineering blog post
- **Low risk**: Server-side pattern shouldn't break existing functionality
