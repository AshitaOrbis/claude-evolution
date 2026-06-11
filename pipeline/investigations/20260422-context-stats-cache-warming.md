---
date: 2026-04-22
topic: "context-stats for managing usage + cache warming theory for long context sessions"
discord_message_id: "1496563841386021025"
related_message_id: "1496563705003905054"
status: complete
---

# Context-Stats & Cache Warming Theory for Long Claude Sessions

## Topic

Two related Discord messages (32 seconds apart):
1. "Look into [context-stats](https://github.com/luongnv89/context-stats) for managing usage"
2. "Also look into the theory of keeping long context 'warm' in cache with a minimal prompt every ~59 minutes"

## Key Findings

- **context-stats is a Python analytics layer for Claude Code** — tracks token usage, costs, cache efficiency, and a degradation metric (MI score) across sessions. Three tiers: live status line, session deep-dives, aggregate cross-project reports.
- **It includes a built-in cache keep-warm command**: `context-stats cache-warm on 30m` fires heartbeats every 4 minutes to prevent the default 5-minute TTL from expiring during pauses.
- **The "~59 minute" cache warm idea maps exactly to the 1-hour TTL cache**: Anthropic's prompt cache has two TTLs — 5 min (default) and 1 hour (via `ENABLE_PROMPT_CACHING_1H`). A ~59-minute heartbeat keeps the 1-hour cache alive indefinitely.
- **The workspace already has `ENABLE_PROMPT_CACHING_1H` approved (score 80.7)** from v2.1.108, pending integration into `~/.bashrc`. This makes a 59-minute warm strategy directly actionable.
- **Cache economics**: 5-min TTL cache hits cost 0.1x (90% savings); 1-hr TTL cache writes cost 2x but hits also 0.1x. For long agentic sessions with large system prompts, warming is high-value.
- **The workspace has no existing cache warm mechanism** — the heartbeat cron fires sessions but doesn't keep a prior session's cache alive between runs.

## Details

### context-stats Tool

context-stats is a pip-installable analytics wrapper for Claude Code. It hooks into the status line feature to write per-interaction CSV data locally to `~/.claude/statusline/`. The CLI reads this to generate:

**Level 1 — Live**: Color-coded context zones (Planning → Code-only → Dump → ExDump → Dead) and an MI (Model Intelligence) score calibrated against the MRCR v2 benchmark, which estimates session quality degradation as context fills. This is a meaningful metric the workspace doesn't currently expose.

**Level 2 — Session**: Post-session exports showing cache efficiency, interaction timelines, and cost breakdowns per session.

**Level 3 — Aggregate**: Cross-project cost reports over weeks/months — the gap we currently have (we know what tools we use, but not what they cost across sessions).

The **cache keep-warm** command (`context-stats cache-warm on 30m`) targets the default 5-minute TTL by firing a background process every 4 minutes. This is the same idea as the user's "~59 minutes" concept, applied to the shorter TTL.

### Cache Warming Theory

Anthropic's prompt cache TTL mechanics:

| TTL | Write Cost | Hit Cost | Use Case |
|-----|-----------|----------|----------|
| 5 min (default) | 1.25x | 0.1x | Frequent use (< 5 min between prompts) |
| 1 hour (`ENABLE_PROMPT_CACHING_1H`) | 2x | 0.1x | Agentic workflows, long sessions |

The 1-hour TTL was added in Claude Code v2.1.108 (April 14, 2026) and is already approved for workspace integration. A "cache warm" strategy for 1-hour TTL means: during a long agentic run or research session, fire a minimal prompt (e.g., empty system prompt echo or trivial question) every ~59 minutes to reset the TTL clock, paying only 0.1x instead of 2x on the next real invocation.

**When this matters**: For a 100K-token system prompt at Opus pricing ($5/MTok), a cache miss costs $0.625 (write) vs. a hit at $0.05. Over a 4-hour session with 8 agent invocations:
- Without warming: potentially 4 cache writes ($2.50) + 4 hits ($0.20) = $2.70
- With warming: 1 write + 7 hits ($0.625 + $0.35) = $0.975 → ~64% savings on system prompt processing

The critical insight is that the ScheduleWakeup tool already in the workspace can implement this — a minimal warm prompt every 270 seconds (4.5 min, within the 5-min TTL) or every 3540 seconds (59 min, within the 1-hour TTL) depending on which TTL is in use.

### Relationship to Existing Workspace Capabilities

The workspace already has:
- `ENABLE_PROMPT_CACHING_1H` approved (v2.1.108) but not yet integrated into `~/.bashrc` or heartbeat crons
- `--exclude-dynamic-system-prompt-sections` (v2.1.97) which prevents cache key invalidation from rotating sections
- ScheduleWakeup for periodic timers within sessions
- Heartbeat cron that fires new sessions but doesn't warm existing ones

context-stats would add: cost observability (currently absent) + MI degradation tracking + the 5-minute cache warm for pauses.

## Relevance to Workspace

**High relevance on two fronts:**

1. **context-stats analytics gap**: We track capabilities discovered but not session costs or quality degradation. The MI score (quality at current context fill) and aggregate cost reports would directly inform decisions about when to compact, when to start new sessions, and which projects are consuming disproportionate resources.

2. **Cache warm strategy**: The workspace has several long-running agentic patterns (iterative-improve, heartbeat, publication-review) with large system prompts. The `ENABLE_PROMPT_CACHING_1H` integration is already approved — adding a 59-minute warm heartbeat is a natural complement.

## Recommended Actions

1. **Integrate `ENABLE_PROMPT_CACHING_1H`** into `~/.bashrc` and heartbeat cron invocations — it's already approved (score 80.7), just needs the `update-config` skill to add the env var. This is the prerequisite for the 59-minute warm strategy to be meaningful.

2. **Pilot context-stats** for 1–2 weeks to evaluate the analytics value before full adoption. Install: `pip install context-stats`. Key metric to evaluate: does the MI score's MRCR v2 calibration actually predict session degradation that matches subjective experience?

3. **Implement a minimal 59-min cache warm for long agentic runs** — not via context-stats, but via ScheduleWakeup within the `/loop` and iterative-improve skill. When a run exceeds 45 minutes, set a ScheduleWakeup(delaySeconds=3300) that fires a minimal `claude -p "."` invocation to refresh the cache TTL. This is ~3 lines of shell.

4. **Add context-stats to EVALUATE-PENDING.md** for formal scoring — it's a capability expansion candidate (analytics + cache warm) that the evolution system should track formally.
