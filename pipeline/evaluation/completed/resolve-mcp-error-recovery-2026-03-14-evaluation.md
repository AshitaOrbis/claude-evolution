# Evaluation: Resolve MCP — Structured Error Recovery for AI Agents

**Source**: https://github.com/modelcontextprotocol/servers#3541
**Type**: mcp_server
**Discovered**: 2026-03-14
**Evaluated**: 2026-03-14

---

## What It Is

A proposed MCP server in the official `modelcontextprotocol/servers` repository (PR/addition #3541) providing structured error recovery for AI agents across 20+ services. Claims:
- Monitors for service failure conditions across 20+ integration targets
- Provides structured recovery actions (retry, fallback, alert, abort)
- Designed for agentic pipeline contexts

**⚠️ Verification required**: This was identified via PR/issue reference `#3541`, not a confirmed merged addition. The PR status (merged vs pending) was not verified.

---

## Redundancy Check

| Existing Capability | Match? |
|---------------------|--------|
| Self-healing pipeline skill | PARTIAL — workflow-level recovery, not protocol-level |
| Hook lifecycle (PreToolUse/PostToolUse) | PARTIAL — can intercept errors but recovery logic is manual/custom |
| Two-Failure Reset Rule | PARTIAL — session-level reset, not per-tool recovery |
| Bayesian error recovery playbook | DOCUMENTATION only, not automated |

**Verdict**: NOVEL if it provides automated structured recovery at the MCP protocol level. No existing capability provides deterministic multi-service recovery logic between Claude's reasoning and tool execution.

---

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 70 | pip install + configure + add to ~/.claude.json — standard MCP setup IF package exists |
| Token efficiency impact | 25% | 60 | Reduces wasted turns from failed tool calls; prevents retry spirals |
| Capability expansion | 25% | 70 | Novel automated error recovery layer at protocol level; fills genuine gap |
| Maintenance burden | 15% | 65 | In official MCP repo (good signal) but third-party maintainer |
| Community validation | 15% | 70 | Official modelcontextprotocol/servers repo inclusion (IF PR is merged) |

- **Total Score**: (70×0.20) + (60×0.25) + (70×0.25) + (65×0.15) + (70×0.15)
- = 14 + 15 + 17.5 + 9.75 + 10.5 = **66.75/100**

## Decision

**NEEDS_RESEARCH** (66.75/100) — Promising but unverified; key blocker is whether PR #3541 is actually merged

---

## Research Questions (Priority Order)

1. **BLOCKING**: Is PR #3541 merged into `modelcontextprotocol/servers`? Check via GitHub API: `https://github.com/modelcontextprotocol/servers/pull/3541`
2. What is the pip package name? (`resolve-mcp`? `mcp-resolve`? Something else?)
3. Which 20+ services does it support? Do any overlap with our stack (brave-search, exa, playwright, discord, event-bus)?
4. How configurable is the recovery logic — per-service rules or fixed behavior?
5. Does it work with our existing MCP servers, or does each server need to declare elicitation/recovery endpoints?

---

## If PR is Merged: Upgrade Path

Score would increase:
- Community validation: 70 → 80 (confirmed in official repo)
- Integration complexity: 70 → 75 (confirmed package available)
- Revised total: ~68-70 → potential APPROVE threshold

---

## Redundancy Triggers

"resolve mcp", "error recovery mcp", "agentic error handling", "service failure recovery", "structured recovery mcp", "mcp error retry", "deterministic error recovery", "tool failure recovery"
