# Repo Prompt MCP Server

**Source**: https://www.producthunt.com/products/repo-prompt
**Date**: 2026 (Product Hunt listing)
**Category**: MCP Server - Code Context Analysis
**Product Hunt**: Listed as launched in 2026

## Description

MCP server that automates assembling the perfect context for your project. Turns Repo Prompt into a backend for Claude Code, Cursor, and Codex, giving them "context analysis and discovery they can't do on their own."

**Key Capabilities**:
- Automated context assembly for projects
- Context analysis and discovery
- Integration with Claude Code, Cursor, Codex
- Reduces manual context gathering

## Why It Might Matter

- Context assembly is a common pain point
- Could reduce token overhead from over-contexting
- "Perfect context" implies intelligent selection
- Product Hunt launch = community interest

## Redundancy Check

**Keywords searched**: "context assembly", "repo context", "project context mcp", "context analysis", "codebase context"

**Registry match**: Potential overlap with existing tools

**Existing capabilities that provide context**:
1. **Built-in Read/Grep/Glob** - Direct file access and search
2. **mgrep** - Semantic search for relevant files (already integrated)
3. **Task subagents** - Can be instructed to "find relevant context"
4. **batch-orchestrator** - Processes multiple files without context pollution

**Classification**: **NEEDS RESEARCH** - Unclear differentiation from existing stack

## Questions Before Evaluation

1. **What does "context analysis" mean exactly?**
   - File relevance scoring?
   - Dependency graph analysis?
   - Token budget optimization?

2. **What's the baseline comparison?**
   - What can't Claude Code/Cursor/Codex do that this adds?
   - Is this better than "use mgrep + batch-orchestrator"?

3. **Token overhead**:
   - How many tokens does the MCP itself consume?
   - Does it save more tokens than it costs?

4. **GitHub repo**:
   - Need to see code, stars, documentation
   - Community validation unclear from Product Hunt alone

## Integration Path (If Approved)

**Type**: MCP Server
**Target**: `~/.claude.json` mcpServers section
**Blocker**: Need GitHub repo URL, installation instructions

## Preliminary Assessment

**CANNOT SCORE** - Insufficient information

| Criterion | Score (0-100) | Reasoning |
|-----------|---------------|-----------|
| Integration complexity | ? | No GitHub repo found yet |
| Token efficiency | ? | Unclear if net positive or negative |
| Capability expansion | 40 | mgrep + batch-orchestrator may cover this |
| Maintenance burden | ? | Unknown maintainer, activity level |
| Community validation | 30 | Product Hunt listing, no GitHub stars visible |

**Estimated Score**: **NEEDS RESEARCH** (50-69 range, requires blocker resolution)

## Action Required

Move to **research phase**:

1. Find GitHub repository
2. Read documentation to understand "context analysis"
3. Compare token overhead vs savings
4. Check for overlap with mgrep semantic search
5. Evaluate against File Context Server MCP (rejected at 45/100 for similar claims)

## Notes

- Product Hunt listing provides minimal technical details
- "Context analysis they can't do on their own" is a strong claim - validate
- Similar to File Context Server MCP (rejected) - may be same pattern
- If it's just "smarter grepping," mgrep already does this
- If it's dependency graph analysis, may be valuable for large projects

**Status**: **PENDING RESEARCH** - Need GitHub repo and detailed docs

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Redundancy Classification

**Match**: Potential overlap with mgrep + batch-orchestrator + Read/Grep/Glob
**Classification**: NEEDS RESEARCH (insufficient information)

### Scoring

**CANNOT SCORE** - Insufficient technical information

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration complexity | ? | No GitHub repo or installation details |
| Token efficiency | ? | Unclear if net positive or negative |
| Capability expansion | 40/100 | mgrep + batch-orchestrator may cover this (provisional) |
| Maintenance burden | ? | Unknown maintainer, activity level |
| Community validation | 30/100 | Product Hunt listing, no GitHub stars visible |

### Decision

**NEEDS RESEARCH** - Move to research phase

**Blockers**:
1. Find GitHub repository
2. Read documentation to understand "context analysis"
3. Compare token overhead vs savings
4. Check for overlap with mgrep semantic search
5. Evaluate against File Context Server MCP (rejected at 45/100)

**Research Questions**:
- What does "context analysis" mean? (file relevance scoring, dependency graphs, token optimization)
- What can't Claude Code do that this adds?
- Is this better than mgrep + batch-orchestrator?
- Token overhead of MCP itself?

**Priority**: LOW - Likely redundant with existing stack
