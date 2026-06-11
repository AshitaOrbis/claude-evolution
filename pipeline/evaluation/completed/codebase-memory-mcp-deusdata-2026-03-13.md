# Discovery: Codebase Memory MCP (DeusData)

- **Source**: https://github.com/DeusData/codebase-memory-mcp
- **Date Found**: 2026-03-13
- **Category**: mcp
- **Summary**: MCP server that indexes a local codebase into a persistent knowledge graph using AST parsing across 64 languages. Claims 99% fewer tokens than grep for code exploration via sub-millisecond structural queries. Single Go binary, no Docker, no API keys required. Provides call graph tracing, dead code detection, and Cypher-like query language.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Key Features

- 64 language support (Python, Go, JS, TS, Rust, Java, C++, etc.)
- Call graph tracing: "what calls ProcessOrder?" returns full chain in <100ms
- Dead code detection with smart entry point filtering
- Cross-service HTTP linking (finds REST calls between services)
- Cypher-like query language for ad-hoc structural exploration
- Architecture overview with Louvain community detection
- Architecture Decision Records that persist across sessions
- 14 MCP tools (also works with Codex CLI, Cursor, Windsurf)
- CLI mode for direct terminal use without MCP client
- Benchmarked on 35 real open-source repos (78 to 49K nodes, including Linux kernel)
- Latest release: v0.4.6, open source MIT licensed

## Redundancy Check

**Existing capabilities checked**:
- mgrep (Mixedbread): Semantic TEXT search of codebase — cloud-based, natural language queries
- Grep (built-in): Exact string/regex search
- Explore agent: Broad codebase exploration via Read/Glob/Grep

**Classification**: NOVEL

**Reasoning**: mgrep is semantic text/embedding search; codebase-memory-mcp provides AST-based structural knowledge graph (call graphs, type hierarchies, dead code). Fundamentally different data: text proximity vs code structure. Complementary, not overlapping. The "99% token reduction" claim targets a different use case than mgrep — navigating code structure vs finding relevant files by concept.

## Potential Value for Evolution System

- Structural navigation of large codebases without dumping file content
- Call graph queries for tracing agent invocation chains
- Dead code detection for pipeline cleanup audits
- Would replace Read/Glob chains for "what calls X?" queries with single sub-ms MCP call
