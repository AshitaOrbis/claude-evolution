---
date: 2026-03-19
topic: "Stateful parallel searches - could it improve our research subagent?"
discord_message_id: "1484322206669606982"
status: partial
---

# Stateful Parallel Searches for Research Subagent

## Topic

> "Update to parallel here, stateful searches. I wonder if something like that could prove useful applied to a research subagent? Or even just implementing the ability with our parallel setup?" — x.com/i/status/2034762829421478364

## Key Findings

- The Twitter/X URL could not be fetched (payment required); the investigation relies on interpreting the user's framing
- "Stateful parallel searches" refers to running multiple search threads simultaneously where each thread maintains its own context/state across multiple search iterations — rather than independent parallel queries
- Our existing `Parallel-Search-MCP` and `Parallel-Task-MCP` run **parallel but stateless** queries — each search is independent
- **Stateful search** would mean: multiple search "sessions" run simultaneously, each remembering prior results and refining queries iteratively, sharing discoveries with each other
- This maps to the `web-researcher` subagent's current limitation: it searches broadly but can't do concurrent, cross-referencing search threads

## Details

The pattern the user is likely referencing is analogous to **parallel chain-of-thought** research: instead of one researcher progressively refining a query, run 3-4 concurrent researchers each starting from different angles, with a coordinator that merges findings and identifies conflicts.

This could enhance our `web-researcher` subagent in two ways:

1. **Parallel topic threads**: For complex research questions, spin up 3 subtopic threads simultaneously (e.g., "what is X?" + "how has X been used?" + "what are criticisms of X?"), each with own search history
2. **Cross-referencing**: A coordinator agent reads all threads' partial results and can redirect threads based on what others found

**Existing capability gap**: The Parallel-Task-MCP's `createTaskGroup` runs items from a list — this is parallel but not stateful (each item is independent). Stateful parallel research would require each "thread" to be a persistent subagent with memory.

**Implementation sketch**:
- Use 3 `web-researcher` subagents run concurrently as background agents
- Each receives a subtopic + instruction to save intermediate findings
- A coordinator (main session) reads all thread outputs at intervals and injects cross-referencing prompts
- Final synthesis merges all threads

## Relevance to Workspace

- `~/.claude/agents/web-researcher.md`: Prime enhancement target
- `Parallel-Task-MCP`: Infrastructure already exists; stateful layer requires subagent memory
- `agent-event-bus/`: Could serve as the state-sharing medium between parallel search threads

## Recommended Actions

1. **Access the original tweet**: Visit x.com/i/status/2034762829421478364 in a browser to see what specific tool/technique was demonstrated
2. **Prototype the coordinator pattern**: Try running 2-3 web-researcher background agents on a complex research question, with manual coordination in the main session
3. **Evaluate for `web-researcher` v2**: If the coordination pattern proves valuable, bake it into an enhanced web-researcher agent definition
4. **Monitor Parallel-Task-MCP updates**: The tool may gain stateful support; watch for new capabilities
