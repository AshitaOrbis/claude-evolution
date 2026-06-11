---
date: 2026-03-21
topic: "claude-peers-mcp vs forum for agents concept"
discord_message_id: "1484941063712931960"
status: complete
---

# Claude-Peers-MCP vs Forum for Agents

## Topic

> "Seems kind of like what I had in mind with the forum for agents idea but a bit different, don't think we'd want it wholesale but perhaps some ideas are worth documenting" — github.com/louislva/claude-peers-mcp

## Key Findings

- **claude-peers-mcp** enables real-time peer discovery and messaging between multiple Claude Code instances running on the same machine via a local broker (localhost:7899, SQLite)
- The key distinction from a "forum for agents": claude-peers is **synchronous, push-based, ephemeral** — messages arrive instantly into running sessions; a forum is **asynchronous, persistent, structured**
- The agent-event-bus already partially implements the "forum for agents" concept: structured event publishing, knowledge posting, persistent SQLite storage — closer to the forum model
- claude-peers fills a different gap: **real-time cross-session coordination** (e.g., "hey session B, what are you working on right now?") that the event bus doesn't provide
- The architecture is simple and self-contained — broker daemon + per-session MCP server, auto-launches, auto-cleans
- Privacy note: the optional GPT-powered context summaries of "what each session is working on" would send session context to OpenAI — disable for private workflows

## Details

The "forum for agents" idea presumably involves:
- Persistent threads where agents can post discoveries/questions
- Other agents (or humans) can reply asynchronously
- Topics/categories for organization
- Indexable/searchable history

claude-peers delivers none of that — it's a real-time chat system, not a forum. The event bus is closer to the forum model. A true "forum" would add thread structure, reply chains, and topic organization on top of the event bus.

**What claude-peers uniquely provides**: instant awareness of parallel sessions. In our workspace, the desktop frequently runs multiple Claude Code sessions simultaneously (heartbeat, interactive, openclaw-exchange). claude-peers would let these sessions see each other and exchange context without going through the event bus's publish/subscribe model.

**Practical value**: Moderate. Our current sessions don't frequently need to know about each other in real-time. The event bus covers the async coordination case. But for debugging coordination issues between parallel agents (e.g., two heartbeat instances stepping on each other), real-time peer visibility would be useful.

## Relevance to Workspace

- `agent-event-bus/`: Complementary — event bus = async/persistent, claude-peers = sync/ephemeral
- `orchestration/`: Multi-session awareness could improve orchestration visibility
- Future "forum for agents": claude-peers solves a different problem; the forum idea remains unimplemented

## Recommended Actions

1. **Document claude-peers architecture** in `library/techniques/` as a reference for the sync vs async coordination distinction
2. **Evaluate for pilot use**: Add to `pipeline/evaluation/pending/` — score against standard criteria with emphasis on the specific real-time coordination use case
3. **For the forum idea**: Consider extending the agent-event-bus with thread/reply structure rather than adopting claude-peers (different problem domain)
4. **Disable GPT context summaries** if integrating — session content should not leave the machine
