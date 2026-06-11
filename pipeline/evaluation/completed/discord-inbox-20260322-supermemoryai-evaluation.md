# Supermemory: Memory Engine for LLMs

- **Date**: 2026-03-22
- **Source**: Discord #general inbox
- **URL**: https://github.com/supermemoryai
- **Category**: mcp, tool, memory-system
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1485304531695833331

## Description

Supermemory is a memory engine and platform designed to give LLMs extended context capabilities. It functions as a "Memory API for the AI era," providing fast, scalable persistent knowledge retention across AI interactions. The platform includes IDE plugins for Cursor and other development environments, memory benchmarking tools, and a universal MCP (Model Context Protocol) implementation for accessing memories across different LLM platforms without authentication. It also features AST-aware code chunking for contextually relevant code retrieval during development tasks.

## Relevance

This could be directly useful for enhancing agent memory capabilities in Claude Code workflows, particularly for maintaining project-specific context across sessions. The MCP implementation could integrate with the evolution system for improved memory persistence and recall patterns.

## Classification

Evaluated by standard pipeline.

---

## Evaluation

**Date evaluated**: 2026-03-23
**Redundancy status**: DUPLICATE — covered by native memory system

**Reasoning**: The registry explicitly notes that "Official Memory System is a native, zero-token-overhead system that replaces the need for community memory MCPs." Supermemory is a community memory MCP. The registry's redundancy triggers include "memory mcp", "persistent memory", "knowledge base". While Supermemory's AST-aware code chunking angle is marginally novel, the core capability (persistent memory across sessions) is already handled by Claude Code 2.1.32+ Official Memory System and Agent Memory Frontmatter (2.1.33+). Adding an external SaaS dependency with authentication overhead to replace a zero-cost built-in is a net negative.

**Scores**:

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 40 | External service with auth, not needed given built-in system |
| Token efficiency impact | 25% | 20 | Native memory is zero-token; this adds MCP overhead and external calls |
| Capability expansion | 25% | 25 | Core capability covered by Official Memory System + Agent Memory Frontmatter |
| Maintenance burden | 15% | 40 | External SaaS dependency, potential auth changes, service availability risk |
| Community validation | 15% | 50 | GitHub organization presence but no specific star count cited |

**Weighted score**: (40×0.20) + (20×0.25) + (25×0.25) + (40×0.15) + (50×0.15) = 8 + 5 + 6.25 + 6 + 7.5 = **32.75/100**

**Decision**: **REJECTED**

**Kill signal**: 100% functional overlap with native memory system. External SaaS memory MCP fails the same test as claude-mem (deprecated) — the official system replaced community MCPs in this space.
