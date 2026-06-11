# Evaluation Report: claude-code-mcp (steipete) - FINAL

## Basic Information
- **Source**: https://github.com/steipete/claude-code-mcp
- **Category**: MCP Server (Claude Code CLI Wrapper)
- **License**: MIT
- **Last Updated**: May 17, 2025 (v1.10.2)
- **Stars/Validation**: 1,000+ stars
- **Repository Status**: Active, well-maintained

## Evaluation Context

**CRITICAL**: We are evaluating this for use **inside Claude Code where we are already running**.

This MCP wraps the Claude Code CLI as an MCP tool, enabling external AI models (Cursor, Windsurf, ChatGPT) to invoke Claude Code. The described "agent-in-agent pattern" would create a recursive loop when used inside Claude Code itself.

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 50/100 | Standard MCP install, but creates recursive CLI invocation pattern |
| Token Efficiency Impact | 10/100 | **NEGATIVE**: Adds network + JSON serialization overhead vs native operations |
| Capability Expansion | 0/100 | **ZERO VALUE**: Task tool already provides agent-in-agent natively |
| Maintenance Burden | 30/100 | External dependency, requires Claude CLI monitoring, breakage risk |
| Community Validation | 100/100 | 1k+ stars, MIT, active maintenance, 117 forks |
| **WEIGHTED TOTAL** | **23.5/100** | |

## Cross-Validation
- **Claude Assessment**: 23.5/100
- **Codex Assessment**: Not performed (obvious redundancy)
- **Gemini Assessment** (from previous eval): 0/100 ("Pointless recursion")
- **Consensus**: Strong rejection

## The Recursive Redundancy Problem

### Current Architecture (✓ OPTIMAL)
```
Claude Code (Host)
  → Task tool
    → Spawns subagent (isolated Claude instance)
      → Direct context access
      → Returns results
```

### With claude-code-mcp (✗ ANTI-PATTERN)
```
Claude Code (Host)
  → MCP client call
    → JSON serialization
      → Network roundtrip to MCP server
        → MCP server spawns: `claude --dangerously-skip-permissions [prompt]`
          → NEW Claude CLI process
            → Performs operations
            → Serializes response
              → Network return
                → JSON deserialization
                  → Host receives result

Token overhead: +50-100% per operation
Latency: +network roundtrip (50-200ms)
Complexity: Double the process count
Debugging: Nested call stacks
```

## Existing Alternatives

| Need | Current Solution | Why It's Superior |
|------|------------------|-------------------|
| Sub-agent workflows | `Task` tool + 15+ specialized subagents | Native, zero network overhead |
| Agent-in-agent pattern | SubAgent delegation via `Task` | Direct context sharing |
| Multi-step operations | `batch-orchestrator` subagent | Context-aware summarization |
| Parallel execution | `Task` tool with concurrent dispatch | Built-in, proven |
| File operations | Read/Edit/Write/Bash | Direct filesystem access |
| Git operations | Bash tool + Git best practices | No serialization overhead |
| Context isolation | All subagents use separate contexts | Proper encapsulation |

## Registry Check: DUPLICATE

From `existing-capabilities.md`:

**Redundancy triggers**: "agent-in-agent", "multi-agent orchestration", "sub-agents", "agent within agent"

**Status**: DUPLICATE of existing capability

| Existing Capability | Status | Implementation |
|---------------------|--------|----------------|
| Multi-Agent Orchestration | **IMPLEMENTED** | Task tool + 15+ specialized subagents + evolution-orchestrator |
| Context Isolation | **IMPLEMENTED** | All subagents use separate contexts |
| Subagent Delegation | **IMPLEMENTED** | Task tool with specialized agents |

**Previous evaluations**:
- 2026-01-16: Rejected (moved to discoveries/rejected/)
- 2026-01-24: Comprehensive evaluation completed (23.5/100)

## Use Case Analysis

### ✓ Valid Use Cases (EXTERNAL to Claude Code)
- **Cursor user** wants Claude Code's superior file operations → Bridge via MCP
- **Windsurf user** needs deterministic refactoring → Delegate to Claude Code
- **ChatGPT user** working in Cursor → Invoke Claude Code capabilities
- **Custom AI agent** needs code operations → Use this MCP

### ✗ Invalid Use Cases (INSIDE Claude Code)
- "I want a sub-agent to edit files" → **Use Task tool**
- "I need parallel operations" → **Use Task with parallel dispatch**
- "I want to run another Claude instance" → **Use Task directly**
- "I need agent-in-agent pattern" → **Task tool provides this natively**

**Verdict**: Every internal use case is already solved better by existing tools.

## Security Assessment
- [x] No sensitive permissions required
- [x] No excessive data access (though runs with `--dangerously-skip-permissions`)
- [x] License compatible (MIT)
- [x] No known vulnerabilities
- [⚠️] Permission bypass intentional but creates unnecessary chains when recursive

## Kill Signals Triggered

✅ **RECURSIVE REDUNDANCY** (Primary)
- Creates Claude Code → MCP → Claude Code loop
- Task tool already does this natively with zero overhead

✅ **TOKEN EFFICIENCY NEGATIVE**
- Adds network serialization cost vs direct operations
- No token savings, only increases

✅ **CONFLICTS WITH EXISTING CRITICAL TOOLS**
- Task tool provides same capability optimally
- Would create confusion about which to use

## Recommendation

**DECISION**: ✅ **REJECT** (23.5/100 - Far below 70 threshold)

**Rationale**:

claude-code-mcp is an excellent tool for its intended audience: **external AI agents** (Cursor, Windsurf, ChatGPT) that need Claude Code's capabilities. However, integrating it INTO Claude Code where we're already running creates a recursive anti-pattern with:

**Costs**:
- Network overhead (50-200ms per operation)
- JSON serialization/deserialization (token bloat)
- Double process spawning (resource waste)
- Complex debugging (nested call stacks)
- Permission bypass chains (security complexity)

**Benefits**:
- None. Task tool already provides agent-in-agent delegation natively.

**Architecture comparison**:
- **Task tool**: Claude Code → direct subagent spawn → result (optimal)
- **claude-code-mcp**: Claude Code → MCP client → network → MCP server → `claude` CLI → result (wasteful)

**Analogies**:
- Like running `vim` inside Vim to edit a file
- Like using `ssh localhost` to run a local command
- Like calling an API wrapper when you have the library imported

## Integration Path

**DO NOT INTEGRATE**. Use `Task` tool instead.

If somehow forced to integrate:
1. `npm install -g @steipete/claude-code-mcp`
2. Add to `~/.claude.json` mcpServers
3. Configure `CLAUDE_CLI_NAME` environment variable
4. Test with simple delegation
5. **Then immediately remove and use Task tool**

## Conditions for Future Reconsideration

Would only reconsider if ALL of these occur (extremely unlikely):

- [ ] Claude removes Task tool (won't happen - core feature)
- [ ] MCP overhead becomes negligible (<5% vs native) (requires protocol redesign)
- [ ] Task tool cannot handle identified use case (none exists)
- [ ] Recursive delegation becomes officially recommended pattern (contradicts architecture)

**Probability of reconsideration**: <1%

## References

- Previous evaluation: `rejected-claude-code-mcp-steipete-recursive-redundancy.md` (2026-01-24)
- Registry entry: `existing-capabilities.md` line 451-454
- Architecture guide: `~/.claude/skills/advanced-tool-use/SKILL.md`
- Discovery report: `reports/daily/discovery-report-2026-01-16.md`
- Task tool documentation: Native Claude Code feature

## Related Discoveries

Similar patterns evaluated and rejected:

| Tool | Score | Similar Issue |
|------|-------|---------------|
| Claude Flow | 56.25 | 100 MCP tools with agent orchestration - overlap with Task tool |
| HCOM | 64.5 | Inter-instance communication - Task tool already returns results |
| task-orchestrator | 60.5 | Task management - TodoWrite + batch-orchestrator sufficient |

All suffered from the same problem: **trying to add via MCP what's already built-in natively**.

---

**Evaluation Date**: 2026-01-26 (Confirmed final)
**Evaluator**: capability-evaluator subagent (Opus)
**Status**: ARCHIVED - Final rejection confirmed
**Action**: No further evaluation needed
