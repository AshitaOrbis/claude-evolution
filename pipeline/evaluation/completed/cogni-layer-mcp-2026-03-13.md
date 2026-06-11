# Discovery: CogniLayer — Persistent Code Memory + Graph MCP

- **Source**: https://github.com/LakyFx/CogniLayer
- **Date Found**: 2026-03-13
- **Category**: mcp
- **Summary**: 17-tool MCP server providing persistent session memory and code knowledge graph for Claude Code and Codex CLI. Claims 80–200K+ token savings per session by eliminating re-explanation overhead between sessions and subagent handoffs. Includes subagent protocol for context-efficient delegation, TUI dashboard, crash recovery, and hybrid search (semantic + structural).
- **Potential Value**: High
- **Integration Complexity**: Medium

## Key Features

- Persistent memory across Claude Code sessions (no re-explaining context)
- Code knowledge graph (structural + relationships)
- Subagent protocol: subagents return compact summaries instead of dumping full context to parent
- Hybrid search: semantic + structural queries
- TUI dashboard for memory inspection
- Crash recovery (session state preserved)
- 17 MCP tools
- Compatible with Claude Code and Codex CLI

## Redundancy Check

**Existing capabilities checked**:
- mgrep: Semantic text search — text-based, no session persistence
- Auto-memory (`autoMemoryDirectory`, v2.1.74): CLAUDE.md-based markdown memory
- Memory MCP (official modelcontextprotocol/servers): Basic knowledge graph for entities/facts
- codebase-memory-mcp (DeusData, above): AST-based structural code graph

**Classification**: NOVEL (with overlap notes)

**Reasoning**:
- Session persistence aspect: IMPROVEMENT over existing auto-memory (CLAUDE.md) — structured code-aware memory vs flat markdown
- Subagent protocol: NOVEL — explicit mechanism for compact context passing between subagents
- Token savings claims (80–200K/session) would be highly relevant to evolution pipeline
- More complex than codebase-memory-mcp (harder to evaluate independently)
- v0.x software — maturity risk

## Concerns

- Less battle-tested than codebase-memory-mcp (fewer stars/releases visible)
- 17 tools = higher context overhead if Tool Search Tool doesn't prune well
- Overlap with Memory MCP and auto-memory makes scoring harder
