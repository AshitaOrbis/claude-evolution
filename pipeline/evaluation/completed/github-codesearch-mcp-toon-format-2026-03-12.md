# Discovery: GitHub Code Search MCP (TOON Token-Efficient Format)

- **Source**: https://lobehub.com/mcp/hudrazine-github-codesearch-mcp
- **Date Found**: 2026-03-12
- **Category**: mcp
- **Summary**: Lightweight MCP server wrapping GitHub's code search API with token-efficient TOON (Token-Optimized Output Notation) format. Strips extraneous fields from GitHub API responses and returns compact structured results, reducing per-search token overhead significantly compared to raw GitHub API output. Targets Claude Code workflows that frequently search GitHub codebases.
- **Potential Value**: Medium
- **Integration Complexity**: Easy

## Key Features

- GitHub code search via `code_search` tool
- TOON output format: removes redundant fields (repo metadata, URLs, raw blobs) from results
- Focused output: file path, match content, repository name, line numbers
- Complements Exa `get_code_context_exa` for GitHub-specific searches

## Redundancy Check

**Existing search capabilities**:
- Exa `get_code_context_exa`: AI-native semantic code search (broader web, not GitHub-specific)
- Brave `brave_web_search`: Keyword search, not code-optimized
- GitHub MCP (official): Full GitHub API access, not token-optimized

**Classification**: NOVEL — GitHub-specific code search with token-efficient output format. Fills gap between full GitHub MCP (heavy) and Exa code search (not GitHub-specific). The TOON format is specifically designed to reduce token overhead for high-frequency code search workflows.

## Integration Path

- Install as MCP server in `~/.claude.json`
- Use when searching specific GitHub repositories by code content
- Complementary to Exa (semantic/neural) for different search patterns: keyword/exact → this MCP; semantic/conceptual → Exa
