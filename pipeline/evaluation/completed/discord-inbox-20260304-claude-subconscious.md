# Letta AI - Claude Subconscious

- **Date**: 2026-03-04
- **Source**: Discord #general inbox
- **URL**: https://github.com/letta-ai/claude-subconscious
- **Category**: unknown
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1478613128605339712

## Description

URL shared in Discord #general inbox without additional context.

## Classification

To be evaluated by the standard pipeline.

## Evaluation

**Score**: 58/100
**Decision**: NEEDS_RESEARCH
**Reason**: Claude Subconscious by Letta AI (876 stars) is a hooks-based persistent memory plugin for Claude Code. Uses 5 lifecycle hooks (SessionStart, UserPromptSubmit, PreToolUse, checkpoints, Stop) to maintain cross-session memory via a Letta agent. Technically interesting and addresses a real gap (cross-session memory across projects). However: (1) overlaps with Claude Code's built-in Official Memory System (v2.1.32+) and Agent Memory Frontmatter (v2.1.33+), (2) requires running a Letta server (external dependency), (3) "experimental" status, (4) 876 stars suggests moderate adoption. Key differentiator: Letta provides a single memory agent across ALL projects vs. Claude's per-project memory. Worth investigating whether the cross-project unification provides value beyond what we already have.

| Criterion | Weight | Score |
|-----------|--------|-------|
| Integration complexity | 20% | 50 (hooks-based, but requires Letta server) |
| Token efficiency impact | 25% | 50 (stdout injection of memories — unknown token cost) |
| Capability expansion | 25% | 60 (cross-project unified memory is novel) |
| Maintenance burden | 15% | 40 (experimental, Letta dependency) |
| Community validation | 15% | 60 (876 stars, Letta AI official) |

**Research questions**:
1. How does Letta's cross-project memory compare to Claude's built-in memory in practice?
2. What's the token overhead of memory injection per prompt?
3. Does the Letta server require GPU/significant resources?
4. Can the hook-based injection pattern be adopted without the Letta dependency?

**Investigation window**: 7 days (by 2026-03-15)

**Date**: 2026-03-08
**Auto-triaged**: Yes (batch evaluation)
