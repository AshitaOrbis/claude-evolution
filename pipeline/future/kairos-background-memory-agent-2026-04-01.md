# KAIROS — Always-On Background Memory Consolidation Agent

**Source**: https://wavespeed.ai/blog/posts/claude-code-leaked-source-hidden-features/
**Discovered**: 2026-04-01
**Status**: Upcoming — feature flag only, not yet available
**Estimated availability**: ~May 2026 (based on internal code comments in v2.1.88 sourcemap)

---

## What Is It?

Feature flag confirmed in Claude Code source leak (March 31, 2026, v2.1.88 npm sourcemap).

**KAIROS** (Greek: "at the right time") is an always-on background agent that:
- Autonomously consolidates memory while the user is idle
- Merges observations across sessions
- Maintains original work context during background consolidation
- Includes "Dream mode" for background ideation

---

## Why It Matters

The current memory system requires manual triggering (Context Librarian subagent). KAIROS would eliminate this friction by running autonomously — always consolidating without needing explicit invocation.

**Relationship to existing capabilities**:
- Context Librarian subagent: manually triggered extraction — KAIROS replaces this
- MEMORY.md system: hand-maintained files — KAIROS would auto-update these
- cog tiered memory: convention-based; KAIROS is agent-based

---

## Monitor For

- Official shipping announcement (likely Q2 2026)
- Whether it integrates with existing MEMORY.md file format or uses its own schema
- Whether it can be pointed at specific memory directories (workspace-scoped vs global)
- Configuration options for Dream mode / idle detection threshold

---

## Notes

Moved here from pipeline/evaluation/pending/ — not evaluatable until the feature ships.
When available, evaluate as a REPLACEMENT for Context Librarian subagent (IMPROVEMENT comparison).
