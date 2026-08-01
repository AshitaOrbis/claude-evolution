# ctx — Task-Scoped Skill/MCP Recommendation

**Source**: https://github.com/stevesolun/ctx
**Date**: 2026-06-17 (integrated 2026-07-19)
**Type**: technique (evaluation candidate, approval-gated)
**Score**: 80.5/100 (approved 2026-06-23)

## What It Does

`ctx` recommends a small, task-relevant bundle of capabilities — skills, agents, MCP
servers, harness options — out of a large installed graph, so a session loads only what
the task at hand needs. It targets the same problem this workspace attacks with deferred
MCP loading and path-scoped rules: standing context is rent, and most installed
capability definitions are irrelevant to any single task.

Upstream signals at evaluation time: 508 stars, MIT license, test suite, and dry-run /
update / uninstall controls (i.e., it can be exercised without letting it mutate
anything).

## Why It Matters Here

The workspace already has ~16 MCP servers, 80+ skills, and a large agent roster. Tool
Search + deferred loading solved the *schema token* cost, but selection is still manual:
the session (or the user) decides which skills/agents are relevant. A recommender that
maps "task description → minimal capability bundle" is the missing selection layer —
IF its catalog quality is good enough to trust.

## Proposed Evaluation (approval-gated, dry-run only)

1. Run `ctx` in dry-run mode against a sample of 5–10 real task descriptions from recent
   sessions (coding, research, pipeline maintenance).
2. Compare its recommended bundle against what the session actually used (transcript
   ground truth).
3. Score: precision (did it recommend junk?), recall (did it miss the skill that was
   actually needed?), and token delta vs. loading everything.
4. Only consider any automated use if precision is high — a recommender that omits a
   needed capability silently degrades sessions, which is worse than the current manual
   status quo.

## Guardrails

- Dry-run only until catalog quality is validated; never let it install/uninstall.
- Treat its recommendations as a shortlist for a human/agent to confirm, not as an
  auto-loader.
- Re-check against `registry/existing-capabilities.md` before adopting — overlaps with
  the deferred-MCP-loading and rules-directory patterns already in place.

## Open Questions

- Does its catalog understand locally-authored skills, or only public ones?
- How stale does its capability graph get, and what is the refresh cost?

**Tags**: `context-management`, `token-efficiency`, `skill-selection`, `mcp-selection`,
`recommender`, `dry-run-evaluation`, `ctx`
