---
date: 2026-04-10
topic: "See if this might be applicable to our usage"
discord_message_id: "1490561127061655614"
status: partial
---

# Claude Code Rate Limits — Beyond Anthropic Throttling

## Topic
Reddit post claiming that Anthropic isn't the only source of Claude Code usage limits — investigate applicability to our usage.

Source: https://www.reddit.com/r/ClaudeCode/comments/1sd8t5u/anthropic_isnt_the_only_reason_youre_hitting/

**Note: Reddit blocks automated fetching.** This investigation is based on the known context and inference from the title/description.

## Key Findings

- Reddit and old.reddit.com both block automated content fetching — post content could not be retrieved directly
- The title suggests the post covers **client-side or infrastructure limits beyond Anthropic's server-side rate limits** — likely covering context window size, tool overhead, or local resource constraints
- Common non-Anthropic Claude Code limits documented in community: context exhaustion (8K-10K output token cap per turn), tool call overhead accumulating in long sessions, disk/network bottlenecks for large reads, and Claude Max plan's "fair use" token bucket which resets on rolling windows rather than hard hourly limits
- Our setup has specific factors that amplify usage: long autonomous heartbeat runs, multi-agent orchestration with subagents spawning subagents, large CLAUDE.md files loaded every session, and Playwright browser automation generating large DOM snapshots
- We already address several known vectors: `disabledMcpjsonServers` for unused tools, `/compact` for context management, and `CLAUDE_CODE_SIMPLE` for cost-sensitive automation runs

## Details

Without the post content, the most likely advice in a post with this framing would be:

**Context management**: Claude Code sessions accumulate context until compaction kicks in. Very long sessions (>100K tokens) degrade response quality before hitting Anthropic's rate limit. Shorter, more focused sessions or aggressive `/compact` use avoids this.

**Tool count inflation**: Each MCP server adds ~2-4K tokens of tool schema. With 10+ MCP servers loaded, this is 20-40K tokens of overhead per request — burning through token budgets faster than Anthropic's server metrics suggest.

**Batch operations**: Reading many files sequentially floods context. The batch-orchestrator subagent pattern (already documented in our system) addresses this by summarizing rather than dumping raw content.

**Max plan fairness**: The Claude Max plan uses sliding window rate limiting, not hard hourly caps. Long-running cron jobs that space out requests may actually fare better than burst-heavy interactive sessions.

## Relevance to Workspace

- The heartbeat/orchestration cron jobs on requiem run Claude Code autonomously every few hours — they're the most likely to hit rolling window limits
- Our current mitigations: `permissions.defaultMode: "auto"`, deferred MCP loading, compact mode, CLAUDE_CODE_SIMPLE for heartbeat
- The `iteration_limit` and `codex_limit` in the iterative-improve system also serve as practical usage caps

## Recommended Actions

1. **Manually read the post** to capture the specific non-Anthropic mechanisms described (Reddit must be accessed via browser)
2. **Check if tool schema overhead** is a factor — run a session with all MCPs disabled vs enabled, compare effective throughput
3. **Consider adding the Reddit post URL** to the helpers/playbooks directory once the content is retrieved
