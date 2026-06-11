# Wrap-Up Ritual Workflow

**Source**: [rohitg00/pro-workflow](https://github.com/rohitg00/pro-workflow)
**Category**: Workflow Pattern
**Stars**: Unknown (2026-02-06)
**Discovery Date**: 2026-02-06

## Summary

A structured session-end workflow pattern that treats documentation as external memory to enable multi-session continuity. The core principle: "what gets written down persists across sessions, while what stays in conversation memory disappears."

## Problem Addressed

Claude Code sessions are ephemeral:
- Each new session starts with zero knowledge of previous work
- Sessions can end abruptly or degrade after multiple compactions
- No built-in handoff mechanism between sessions
- Context pollution makes it hard to resume work cleanly

## Solution Pattern

**Wrap-Up Ritual Components**:
1. **Document current state** in persistent files (not just CLAUDE.md)
2. **Explicit next steps** with sufficient detail that Claude doesn't need to ask clarifying questions
3. **Trigger timing**: Wrap up when context usage reaches 70-85%
4. **Hand-off strategy**: Clear instructions for next session to pick up where you left off

**Key Insight**: If your next steps require Claude to ask "what does that mean?" — they're not specific enough.

## Implementation

The `pro-workflow` repo includes a `/wrap-up.md` command file that implements:
- Session state capture
- Context preservation guidelines
- Next-session resumption instructions
- Handoff checklist

## Relationship to Existing Capabilities

**COMPLEMENT to existing features**:
- Context Compaction (built-in): Automatic, lossy summarization during session
- Wrap-Up Ritual: Manual, lossless handoff BETWEEN sessions
- Session Resume (built-in): Resumes conversation state
- Wrap-Up Ritual: Resumes WORK state with explicit context

**Different from**:
- `/compact` command: Within-session summarization
- CLAUDE.md: Static project context (doesn't track session state)
- Official Memory System: Auto-recall of facts (doesn't track workflow state)

## Potential Value

**Token Impact**: Neutral to positive
- Reduces repeated context rebuilding in new sessions
- Prevents "what were we doing?" token waste
- Enables cleaner session starts with focused context

**Capability**: Session continuity workflow
- Novel pattern not explicitly documented in existing stack
- Addresses real pain point: multi-session workflow coherence
- Complements but doesn't duplicate existing memory/compaction features

**Integration Effort**: Easy
- Slash command implementation (`/wrap-up`)
- Documentation in CLAUDE.md
- Optional: SessionEnd hook to trigger reminder

## Quick Assessment Score

- Integration complexity: **85/100** (simple command + docs)
- Token efficiency impact: **70/100** (indirect savings from better handoffs)
- Capability expansion: **75/100** (addresses known gap in multi-session workflows)
- Maintenance burden: **90/100** (static command, no dependencies)
- Community validation: **60/100** (part of larger "pro-workflow" repo, no isolated stars)

**TOTAL**: **76/100**

## Recommended Action

[X] Evaluate further - Check if `pro-workflow` repo has explicit `/wrap-up.md` implementation we can adopt
[ ] Reject
[ ] Fast-track integration

## Redundancy Check

**Triggers checked**: "session end", "context preservation", "multi-session workflow", "session handoff"

**Result**: NO MATCH in existing-capabilities.md

**Classification**: NOVEL - Addresses known gap between auto-compaction (within-session) and session resume (conversation state) without covering work-state handoff.

---

## Evaluation

**Evaluator**: capability-evaluator
**Date**: 2026-02-06

### Scoring

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration Complexity | 85/100 | Slash command + docs (easy) |
| Token Efficiency | 70/100 | Indirect savings (better handoffs, less context rebuilding) |
| Capability Expansion | 75/100 | Session continuity workflow (distinct from compaction/resume) |
| Maintenance Burden | 90/100 | Static command, no dependencies |
| Community Validation | 60/100 | Part of pro-workflow repo, no isolated validation |
| **WEIGHTED TOTAL** | **76/100** | |

### Cross-Validation (Codex)
"Session handoff protocol is valuable. 76/100 - addresses multi-session coherence gap."

### Security
- [x] No external dependencies
- [x] Markdown output only
- [x] No network access

### Decision: APPROVE (76/100)

**Classification**: NOVEL (session handoff pattern)

**Integration Path**:
1. Create `/wrap-up` command in `~/.claude/commands/wrap-up.md`
2. Guidelines: state capture, next steps, context preservation
3. Add SessionEnd hook reminder (optional)
4. Test on 1-week multi-session task
5. Document in CLAUDE.md

**Complementarity**: Works WITH planning-with-files (defines handoff protocol for persistent files) and compaction (between-session vs within-session).
