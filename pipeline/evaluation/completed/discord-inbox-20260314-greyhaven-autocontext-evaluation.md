# Evaluation: GreyHaven AI AutoContext

**Date**: 2026-03-14
**Source**: Discord #general inbox
**URL**: https://github.com/greyhaven-ai/autocontext
**Evaluated**: 2026-03-14

---

## What It Is

A closed-loop system for improving agent behavior across repeated runs. Key capabilities:
- Executes tasks, evaluates outcomes, updates persistent knowledge bases (playbooks)
- Distills successful patterns from frontier models into cheaper local models via MLX fine-tuning
- Multi-agent feedback loops with specialized roles (competitor, analyst, coach, architect, curator)
- **MCP server**: `autoctx mcp-serve` — direct integration with Claude Code
- GreyHaven also maintains `greyhaven-ai/claude-code-config` (explicit Claude ecosystem alignment)

**Stats**: ~415 stars, last commit January 11, 2026 (261 commits, moderate velocity)

---

## Redundancy Check

| Existing Capability | Match? |
|---------------------|--------|
| capability-discoverer + evaluator + integrator pipeline | PARTIAL — similar closed-loop concept but different implementation |
| instinct-system / hindsight-agent-memory | PARTIAL — persistent improvement across sessions |
| hook lifecycle + memory system | PARTIAL — session state preservation |

**Verdict**: IMPROVEMENT candidate — similar concept (closed-loop agent self-improvement) implemented differently. Key differentiator: AutoContext has explicit MLX distillation into smaller models, which we don't have. The MCP server integration could complement our pipeline rather than replace it.

---

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 65 | MCP server available (`autoctx mcp-serve`), but requires understanding how to connect with existing pipeline |
| Token efficiency impact | 25% | 50 | Neutral — doesn't reduce Claude Code session token usage; focuses on cross-session learning |
| Capability expansion | 25% | 60 | Incremental over existing pipeline; novel aspect is MLX distillation (local model fine-tuning) which we don't have |
| Maintenance burden | 15% | 65 | Third-party, active but modest pace (Jan 2026 last commit), 415 stars |
| Community validation | 15% | 70 | 100-1k stars range (415); explicit Claude Code ecosystem alignment via companion repo |

- **Total Score**: (65×0.20) + (50×0.25) + (60×0.25) + (65×0.15) + (70×0.15)
- = 13 + 12.5 + 15 + 9.75 + 10.5 = **60.75/100**

## Decision

**NEEDS_RESEARCH** (60.75/100)

---

## Research Questions

1. Does AutoContext's MCP server (`autoctx mcp-serve`) actually improve Claude Code workflows in practice, or does it duplicate existing pipeline functionality?
2. Is the MLX distillation (local model fine-tuning) relevant for our use case — or is it Apple Silicon specific and therefore non-portable?
3. How does `greyhaven-ai/claude-code-config` relate — is it useful independently of the full AutoContext system?
4. Has development slowed significantly after January 2026?

---

## Comparison vs Existing System

| Feature | AutoContext | Our Pipeline |
|---------|-------------|--------------|
| Closed-loop improvement | ✓ | ✓ (capability-discoverer → evaluator → integrator) |
| Persistent playbooks | ✓ | ✓ (helpers/ directory) |
| Multi-agent roles | ✓ | ✓ (specialized subagents) |
| MCP integration | ✓ | ✓ (native) |
| Local model distillation | ✓ (MLX) | ✗ |
| Claude Code config templates | ✓ | ✓ (CLAUDE.md hierarchy) |

Key differentiator to investigate: MLX distillation pipeline.

---

## Redundancy Triggers

"autocontext", "closed-loop agent improvement", "greyhaven", "autoctx", "MLX distillation", "agent playbooks", "self-improving agent", "multi-agent feedback", "coach architect curator agent"
