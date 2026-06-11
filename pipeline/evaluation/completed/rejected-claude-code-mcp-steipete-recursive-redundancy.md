# Evaluation Report: claude-code-mcp (steipete)

## Basic Information
- **Source**: https://github.com/steipete/claude-code-mcp
- **Category**: MCP Server (Wrapper)
- **License**: MIT
- **Last Updated**: May 17, 2025 (v1.10.2)
- **Stars/Validation**: 1,000+ stars
- **Repository Status**: Active, well-maintained

## Critical Context

**IMPORTANT CONSTRAINT**: We are evaluating this for integration **INTO Claude Code where we are already running**.

This MCP was designed for external AI agents (Cursor, Windsurf, ChatGPT) to invoke Claude Code. Using it inside Claude Code creates a problematic architectural pattern.

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 50/100 | Straightforward npm install, but requires MCP server setup in ~/.claude.json and recursive CLI invocation |
| Token Efficiency Impact | 10/100 | NEGATIVE: Network roundtrip + JSON serialization overhead vs native operations. No token savings. |
| Capability Expansion | 0/100 | ZERO VALUE. Task tool + subagents already provide agent-in-agent pattern natively with better efficiency |
| Maintenance Burden | 30/100 | Dependency on external MCP server, requires monitoring, potential breakage from Claude CLI updates |
| Community Validation | 100/100 | 1k+ stars, MIT license, active maintenance, 117 forks |
| **WEIGHTED TOTAL** | **23.5/100** | **STRONG REJECTION** |

## Cross-Validation

- **Claude Assessment**: 23.5/100 (Redundant, recursive, no value)
- **Gemini Assessment**: 0/100 (Pointless recursion, use native Task tool instead)
- **Variance**: 23.5 points (Both agree: REJECT)
- **Consensus**: Strong consensus to reject

## The Core Problem: Recursion Pattern

```
Current Architecture (✓ GOOD):
Claude Code (Host)
  → Task tool
    → Spawns subagent (Claude instance #2)
      → Returns results to host

With claude-code-mcp (✗ BAD):
Claude Code (Host)
  → MCP client
    → JSON serialize request
      → Network call to MCP server
        → MCP server invokes: claude --dangerously-skip-permissions [prompt]
          → Spawns NEW Claude CLI instance
            → Serializes response
              → Network return
                → MCP client deserializes
                  → Host processes

Token overhead: +50-100% per operation
Latency: +network roundtrip time
Debugging: More complex stack traces
```

## Existing Alternatives (What We Already Have)

| Need | Current Solution | Why It's Better |
|------|------------------|-----------------|
| Sub-agent workflows | Task tool + 15+ subagents | Native context sharing, zero network overhead, built-in |
| Multi-step operations | batch-orchestrator subagent | Context-aware, returns summaries not raw data |
| Parallel execution | Task tool with parallel dispatch | Native support, proven track record |
| File operations | Read/Edit/Write/Bash tools | Direct, no serialization |
| Git operations | Bash tool | Direct filesystem access |

## Security Assessment

- [x] No sensitive permissions required (but bypasses permissions intentionally)
- [x] No excessive data access (but runs with `--dangerously-skip-permissions`)
- [x] License compatible (MIT)
- [x] No known vulnerabilities
- [✓] Permissions bypass is intentional design feature

**Security Note**: The `--dangerously-skip-permissions` flag is required by design, but when used recursively (Claude Code calling Claude Code), this creates unnecessary permission-bypass chains.

## Registry Check

From `existing-capabilities.md`:

**Redundancy triggers**: "multi-agent management", "agent orchestration", "agent in agent", "nested agents", "sub-agents"

**Status**: DUPLICATE of existing capability

| Existing Capability | Implementation | Why Better |
|---------------------|-----------------|-----------|
| Multi-agent orchestration | `Task` tool + subagents | Native, no overhead, proven |
| Agent-in-agent pattern | SubAgent delegation | Direct context sharing |
| Context isolation | All subagents use separate contexts | Proper encapsulation |
| Parallel execution | Task tool with concurrent dispatch | Built-in support |

**Previous Evaluation** (from registry):
> claude-code-mcp (steipete) | 87.5→REJECT | Useless inside Claude Code; Task tool already provides subagents

## Use Case Analysis

### ✓ Valid Use Cases (External)
- **Cursor user** wants to offload complex refactor to Claude Code → claude-code-mcp bridges the gap
- **Windsurf user** needs better file editing → Delegates to Claude Code via MCP
- **ChatGPT user** in Cursor → Can invoke Claude Code operations
- **External agent** needs deterministic code operations → Uses this MCP

### ✗ Invalid Use Cases (Internal to Claude Code)
- "I want a sub-agent to edit files" → Use `Task` with subagent
- "I need parallel operations" → Use `Task` with parallel dispatch
- "I want to run another Claude instance" → Use `Task` directly
- "I need agent-in-agent pattern" → `Task` tool provides this natively

**Verdict**: Every use case we'd have inside Claude Code is already solved better by existing tools.

## Recommendation

**DECISION**: [✓] **REJECT** (<70 threshold, 23.5/100)

**Rationale**:
claude-code-mcp is architecturally sound for **external** AI agents (Cursor, Windsurf) to gain Claude Code capabilities. However, integrating it INTO Claude Code creates a recursive anti-pattern that adds network overhead, token costs, and debugging complexity. The `Task` tool with 15+ specialized subagents already provides the "agent-in-agent" capability that claude-code-mcp attempts to enable, but with:
- Zero network overhead (same process)
- Better context sharing (native integration)
- Simpler debugging (one call stack)
- Proven track record (already integrated)

**Kill Signal Hit**: ✓ **ARCHITECTURAL REDUNDANCY**
- Redundant capability: Task tool already does agent-in-agent delegation natively
- Adds recursion: Would create Claude Code → MCP → Claude Code loop
- Token inefficient: Network serialization overhead for operations we can do directly

## Integration Path (If Overruled)

If there were unknown value discovered:

1. Install via npm: `@steipete/claude-code-mcp`
2. Add to `~/.claude.json` mcpServers
3. Configure environment: `CLAUDE_CLI_NAME` (if needed)
4. Accept permissions: `claude --dangerously-skip-permissions` (one-time)
5. Test with simple wrapper subagent

**But don't do this.** Use `Task` tool instead.

## Conditions for Future Reconsideration

Would only reconsider if:
- [ ] New Claude Code feature makes recursive delegation efficient (unlikely)
- [ ] Task tool is removed and no replacement exists (won't happen)
- [ ] Use case discovered that Task tool cannot handle (none identified)
- [ ] Performance testing shows MCP overhead is negligible (<5%) (very unlikely)

## Document References

- Registry check: `existing-capabilities.md` line 451-454
- Previous evaluation: Same project, rejected 2025-01-16
- Architecture: `~/.claude/skills/advanced-tool-use/SKILL.md`
- Task tool design: Native Claude Code feature

---

**Evaluation Date**: 2026-01-24
**Evaluator**: capability-evaluator subagent
**Status**: ARCHIVED (Final decision)
