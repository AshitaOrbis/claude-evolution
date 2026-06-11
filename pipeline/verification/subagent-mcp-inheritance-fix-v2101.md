# Integration Report: Subagent MCP Inheritance Fix (v2.1.101)

**Date**: 2026-04-12
**Type**: technique (behavioral fix — documentation + audit)
**Status**: INTEGRATED

## What Was Integrated

Two behavioral bug fixes in v2.1.101 affecting subagent tool access:

1. **MCP Tool Inheritance from Dynamic Servers**: Subagents now inherit MCP tools added at runtime (hook injection, `claude mcp add` in session). Previously only static MCP tool lists propagated to Task subagents.

2. **Worktree Subagent File Access**: Agents with `isolation: worktree` now have full Read/Edit/Write access to files in their own worktree. Previously denied, requiring path workarounds.

## Integration Actions Taken

1. **Audit completed** — Three agents using `isolation: worktree` were reviewed:

   | Agent | isolation: worktree | MCP tools listed | Workarounds found? |
   |-------|--------------------|-----------------|--------------------|
   | `capability-discoverer` | Yes | Yes (intentional) | None |
   | `capability-evaluator` | Yes | Yes (intentional) | None |
   | `code-reviewer` | No | Yes (intentional) | N/A |

   **Conclusion**: No workarounds were added to compensate for either bug. Explicit MCP tool listings in frontmatter are intentional declarations, not bug compensation. No agent definition changes needed.

2. **Registry entry added** — Behavioral fixes documented in:
   - `## Claude Code v2.1.101 Features / Subagent Architecture Fixes` (new section, full details + redundancy triggers)

3. **Future guidance documented** — Added in registry details:
   - New worktree agents can use standard relative paths without path hacks
   - Dynamic MCP injection now reliably propagates to spawned subagents

## Verification

- **Automated**: Cannot verify directly without spawning a test subagent with a dynamically-injected MCP server
- **Passive verification**: Next session using worktree agents + dynamic MCP injection will confirm the fix
- **No regression risk**: No agent definitions were modified; this is documentation-only integration

## Source

- Discovery file: `pipeline/integration/subagent-mcp-inheritance-fix-v2101.json`
- Registry section: `## Claude Code v2.1.101 Features / Subagent Architecture Fixes`
- Evaluation score: 79.25/100 (APPROVED)
