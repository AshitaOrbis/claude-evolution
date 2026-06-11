---
date: 2026-05-04
topic: "Investigate this: https://hermes-workspace.com/"
discord_message_id: "1500965270272086167"
status: complete
---

# Hermes Workspace — Open-Source AI Agent Command Center

## Topic
"Investigate this: https://hermes-workspace.com/"

## Key Findings

- **This is NOT our Hermes** — hermes-workspace.com is a completely separate open-source project (GitHub: `outsourc-e/hermes-workspace`, 3.2k stars, MIT) that happens to share the name. Our Hermes is the Nous Research model running as `hermes-gateway-kimi.service` on requiem.
- **Swarm Mode is the standout feature** — orchestrates multiple persistent agents simultaneously with a live dashboard; this is the closest open-source equivalent to our `batch-orchestrator` + evolution pipeline patterns
- **2,000+ skills marketplace** dwarfs our ~100 internal skills and is worth mining for patterns applicable to claude-evolution
- **MCP-native** — already supports Model Context Protocol, meaning it could connect to our existing Brave, Exa, Playwright, and event-bus MCP servers with minimal setup
- **Mobile-first PWA with full feature parity** — install on dashi home screen, access full agent capabilities without Termux; directly relevant to our mobile friction problem
- **Dual-daemon architecture**: UI on port 3000 + gateway on port 8642; gateway handles model routing, memory, and skills persistence — similar to our `agent-event-bus` on port 7777 but broader scope
- **v2.2.0 released May 4, 2026** — active development, same-day as this investigation

## Details

### What It Is

hermes-workspace.com is the UI layer for a project called "Hermes Agent" (not Nous Research's Hermes model). It provides a unified interface combining:

- **Multi-model chat** with SSE streaming across Claude, GPT, Gemini, and any OpenAI-compatible endpoint (including local Ollama models)
- **Integrated file browser + cross-platform terminal** — browser-based terminal with full color support, directly usable without SSH
- **Memory browsing and editing** — browse, search, and manually edit agent memory across sessions; similar intent to our auto-memory system but with an explicit UI
- **2,000+ skills marketplace** — far larger than our ~100 claude-evolution skills; includes third-party integrations, patterns, and reusable prompts
- **Multi-agent dashboard with Swarm Mode** — spawn parallel agents with preset personas, monitor their real-time tool execution and thinking, coordinate across them; analogous to our batch-orchestrator but visual and interactive
- **MCP support** — connects to existing MCP servers using standard protocol
- **PWA** — installable on Android (dashi), desktop, and tablet with full offline capability

### Name Collision Warning

The naming overlap with our workspace "Hermes" (`hermes-gateway-kimi.service`, `hermes --profile kimi`) could cause significant confusion if this project were integrated. Any documentation, cron jobs, or agent prompts referencing "Hermes" would become ambiguous. If evaluated for integration, it should be aliased or renamed internally (e.g., "HermesUI" or "AgentDash").

### Overlap with Existing Workspace

| Capability | Our Current Stack | Hermes Workspace | Assessment |
|------------|-------------------|------------------|------------|
| Multi-model routing | Model-router subagent + CLAUDE.md reference table | Multi-model chat UI | HW is more interactive; our system is automated/headless |
| Agent memory | Auto-memory file system (`~/.claude/projects/`) | Memory browser + edit UI | Complementary — HW adds visual editing |
| Skills library | ~100 skills in `~/.claude/skills/` | 2,000+ marketplace | HW's marketplace is worth mining for patterns |
| Parallel agents | `batch-orchestrator` subagent | Swarm Mode | HW is interactive; ours is programmatic — different use cases |
| Agent monitoring | Discord webhook posts | Live tool inspector | HW is richer for interactive debugging |
| MCP connectivity | Native Claude Code | MCP support | Same protocol — HW could use all our MCPs |
| Mobile access | SSH via Termux | PWA | HW dramatically reduces mobile friction |
| Event bus | `agent-event-bus` port 7777 | Gateway port 8642 | Different scope; HW gateway is broader |

### Swarm Mode vs. Our Batch-Orchestrator

Swarm Mode lets you define named agent personas, spawn them simultaneously, and watch their parallel execution in a live dashboard. Our `batch-orchestrator` is programmatic and headless. The use cases differ: Swarm is better for exploratory, interactive multi-agent tasks where you want to see the work; batch-orchestrator is better for automated pipeline steps. These are complementary rather than competing.

### Skills Marketplace Signal

2,000+ skills is a significant corpus for pattern-mining. Even if we don't adopt the platform itself, the skill definitions (what tasks are worth encoding as skills, how they're structured) are useful inputs to our claude-evolution skills audit. Worth a targeted crawl.

## Relevance to Workspace

- **Dashi/mobile**: A PWA agent dashboard is the cleanest solution to our mobile friction problem — more practical than ssh + tmux + Claude Code on a phone screen
- **claude-evolution skills**: The marketplace catalog could surface skill patterns we haven't considered and help prioritize our next skills development cycle
- **Interactive debugging**: The live tool inspector and Swarm Mode dashboard could be useful when debugging complex multi-agent pipelines that are currently opaque in Discord webhook form
- **Naming conflict**: Must be resolved before any integration — our existing `hermes-*` cron infrastructure would collide

## Recommended Actions

1. **Resolve name collision first** — decide on an alias (e.g., "AgentDash") before any further evaluation to prevent documentation contamination
2. **Mine the skills marketplace** — crawl/export the 2,000+ skill catalog and run it through the claude-evolution redundancy checker to identify novel patterns
3. **Pilot the PWA on dashi** — lowest-risk evaluation: install hermes-workspace.com PWA on phone, test whether it's usable as a mobile agent interface vs. current SSH workflow
4. **Add to evaluation pipeline** — create `pipeline/evaluation/pending/hermes-workspace-agent-ui.md` with initial score estimate ~65-70 (high capability, high overlap with existing stack, name collision adds integration friction)
