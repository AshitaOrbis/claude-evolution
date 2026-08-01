# Transcript Bloat Analysis Recipe (claude-session-analyzer)

**Source**: https://github.com/yonk-labs/claude-session-analyzer
**Date**: 2026-06-25 (integrated 2026-07-19)
**Type**: technique (optional read-only analysis recipe)
**Score**: 74/100 (approved 2026-06-28)

## What It Does

claude-session-analyzer is a local tool that inspects Claude Code transcript files and
reports token/cost/time usage broken down by session, by skill, and by standing-context
component (global instructions, skills, MCP tool definitions). It answers the question
the weekly bloat check approximates from file sizes: **where do the tokens actually go
at runtime?**

## The Recipe (read-only, optional)

1. **Copy, don't point.** Work on *copies* of transcript samples, never the live
   `~/.claude/projects/` files. Redact anything sensitive before analysis if outputs
   will leave the machine (they shouldn't need to).
2. **Sample representatively** — a mix of interactive sessions, cron/headless runs, and
   long orchestrator sessions; bloat profiles differ sharply between them.
3. **Run the analyzer locally** on the copies; no network, no credentials.
4. **Read three signals**:
   - *High-cost skills* — skills whose standing definitions cost more than their usage
     justifies (context-rent candidates for demotion to pointers).
   - *High-cost sessions* — session shapes that burn tokens on repeated re-reads or
     oversized tool results (candidates for subagent delegation / spill-to-file).
   - *Standing-context share* — what fraction of each session's tokens is fixed
     overhead before any work happens.
5. **Feed findings into existing loops** — the weekly bloat report and the
   prune-constraints audit, which currently lack per-skill runtime attribution.

## Caveats

- Low community validation at evaluation time; treat outputs as directional, and
  spot-check a couple of its numbers against raw transcript token counts before trusting
  a ranking.
- Installation is NOT required for this integration — the recipe is documented for
  optional use during bloat sweeps.
- Transcripts are private data: analysis stays local, results reported in aggregate.

**Tags**: `transcript-analysis`, `token-bloat`, `standing-context`, `per-skill-cost`,
`bloat-sweep`, `context-rent`, `claude-session-analyzer`
