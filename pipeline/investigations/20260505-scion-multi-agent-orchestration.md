---
date: 2026-05-05
topic: "Look into this for orchestrating our Claude code and Codex, potentially Hermes? What would the advantages be?"
discord_message_id: "1501299370971107338"
status: complete
---

# SCION: Container-Isolated Multi-Agent Orchestration

## Topic
Investigate GoogleCloudPlatform/scion for orchestrating Claude Code, Codex, and Hermes in parallel. What advantages would it bring?

## Key Findings

- SCION runs multiple AI agents (Claude Code, Codex, Gemini CLI, OpenCode) concurrently in isolated Docker containers, each with its own git worktree and credentials — true OS-level isolation vs our current filesystem-only worktree isolation
- Install is straightforward (`go install ...`; `scion init`); local mode is "relatively stable," hub/Kubernetes rough around the edges
- The core coordination model is **self-organizing**: agents receive a shared CLI tool and figure out coordination themselves via natural language, rather than a fixed orchestration graph
- Our workspace already covers most of what SCION offers through Claude Code's native tooling: `isolation: worktree` frontmatter, `dispatching-parallel-agents` skill, `evolution-orchestrator`, `Task` tool with 15+ subagents
- The **genuine gap** SCION fills: peer-level parallelism across different AI runtimes (Claude Code + Codex + Hermes all writing code simultaneously, each with separate credentials/processes), as opposed to our current hub-spoke model (Claude Code orchestrates Codex via MCP, Hermes is separately managed)
- Hermes already runs in Docker on requiem; Codex is accessed via MCP proxy — SCION could surface both as true equals alongside Claude Code rather than subordinates
- Kubernetes support is early-stage — skip for now; Docker local mode is the relevant target for requiem

## Details

SCION is Google Cloud's experimental answer to a real problem: when you want multiple AI coding agents to collaborate on the same project simultaneously, filesystem-level isolation (git worktrees) is usually enough for the *files*, but credential separation, process isolation, and inter-agent signaling require something heavier. SCION uses Docker containers to give each agent its own execution environment, then provides a thin shared CLI so agents can message each other and pull/push from the same git remote.

The "less is more" coordination philosophy is notable. Rather than imposing a rigid DAG or orchestrator role, SCION trusts the models themselves to decide who does what. This is philosophically close to Claude Code's experimental Agent Teams feature (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), though SCION operates at the harness level across heterogeneous AI frameworks rather than within a single Claude Code session.

For our specific stack, the most interesting configuration would be: Claude Code (main session) + Codex (containerized, its own worktree) + Hermes (already Docker-based) all working on the same feature branch simultaneously. Today, Codex is an MCP-proxied tool that Claude Code calls sequentially; Hermes is a separate Docker sandbox accessed via `hermes-gateway-kimi.service`. SCION could promote them to true peers — all three contributing code in parallel to a shared git remote — with merge/review handled either by one of the agents or by a human at the end.

The main friction points: Go is required to build the CLI; Docker on Linux is straightforward on requiem; the `.scion/agents` directory must be gitignored to avoid nested worktree issues. Hub and Kubernetes modes are noted as <80% reliable — for our purposes only local Docker mode is worth evaluating.

## Relevance to Workspace

- **Claude Code + Codex parallelism**: Our `codex-coder` and `codex-researcher` subagents are strictly sequential MCP calls. SCION enables truly concurrent Codex execution on separate worktrees — useful for the evolution pipeline's parallel discovery/evaluation phases.
- **Hermes integration**: Hermes runs on `hermes-gateway-kimi.service` and is already containerized. Wrapping it as a SCION agent would formalize the interface and give it proper worktree isolation aligned with Claude Code's git state.
- **Agent Teams alternative**: Agent Teams requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` and is token-intensive; SCION is model-agnostic and doesn't multiply a single session's token usage — it's additive across separate API quotas.
- **Lowest-effort trial**: Point SCION at `applications/<private-project>-v2` with Claude Code + Codex as agents; see if the parallel commits are useful or create merge chaos.

## Recommended Actions

1. **Evaluate against registry** — `Multi-Agent Orchestration: IMPLEMENTED` in existing-capabilities; SCION is an *augmentation* (container peers) not a replacement. Score in the 65-75 range (useful but heavy; Docker overhead; experimental status).
2. **Pilot on <private-project>-v2** — small-scope test: spawn Claude Code + Codex via SCION on a feature branch, compare output quality and merge friction against current sequential approach.
3. **Hermes bridge design** — document how `hermes-gateway-kimi.service` would be wrapped as a SCION agent harness; check if the existing `hermes` subagent prompt can serve as the agent system prompt.
4. **File as NEEDS_RESEARCH** in evaluation pipeline — more data needed on whether the self-coordination model works reliably or devolves into conflicting commits.
