---
date: 2026-04-15
topic: "https://github.com/pablodelucca/pixel-agents - Seems like an interesting UI idea"
discord_message_id: "1494110589835022346"
status: complete
---

# Pixel Agents: Visualizing AI Agents as Pixel Art Characters in VS Code

## Topic
"https://github.com/pablodelucca/pixel-agents — Seems like an interesting UI idea"

## Key Findings
- VS Code extension that renders each Claude Code agent as an animated pixel art character in a customizable office environment
- **Non-invasive**: reads Claude Code's JSONL transcript files — no modification to Claude Code or agents required
- **Sub-agent visualization**: Task tool sub-agents appear as linked characters, directly relevant to our Agent/Task-heavy evolution system
- Character animations reflect real activity states: typing (writing files), walking (searching), sitting (reading), idle
- Speech bubbles signal when an agent needs user input — useful for unattended runs
- Canvas 2D + React 19 + TypeScript/Vite frontend; BFS pathfinding for character movement
- Available on VS Code Marketplace; works on Linux, macOS, Windows (compatible with requiem)
- Custom furniture/asset packs loadable from any directory; office layouts persist across sessions

## Details

Pixel Agents addresses a real pain point in multi-agent workflows: the agents are invisible. You know they're running because you launched them, but their moment-to-moment activity is opaque unless you read logs. This extension makes that activity legible through spatial metaphor — each agent occupies a desk, moves through the office, and performs animations that map to what it's actually doing.

The JSONL approach is the smart architectural choice here. Claude Code already writes detailed transcript files to `~/.claude/projects/*/` as a side effect of normal operation. Pixel Agents parses these in real time without injecting hooks or modifying any config. This means it can be installed and removed freely without affecting the underlying system — a clean boundary.

The sub-agent linking is the feature most relevant to our setup. When Claude Code spawns a Task sub-agent, Pixel Agents recognizes the parent-child relationship and renders them as connected characters. Our evolution heartbeat regularly spawns 3–5 sub-agents in parallel (capability-discoverer, capability-evaluator, etc.), which would map directly to a small team of animated characters working in the same office.

The office layout editor (with undo/redo and custom asset support) is the "interesting UI idea" the user flagged — it suggests this is designed to be a persistent, personalized workspace, not just a debug view. The community asset packs path makes it extensible for branding or theming.

## Relevance to Workspace

The evolution system's heartbeat runs spawn multiple parallel agents via the Task tool and track their activity through the agent-event-bus. Pixel Agents would add a visual layer on top of what the event-bus already tracks programmatically. The two are complementary rather than redundant: event-bus is machine-readable coordination; Pixel Agents is human-readable at-a-glance status.

The user runs Claude Code as their primary development environment (VS Code extension), and requiem is native Linux — both fully supported. Installing this would be low-effort and zero-risk given the JSONL-only read approach.

The JSONL parsing technique itself is also worth noting: our activity-monitor.sh watches logs, but Pixel Agents demonstrates a richer pattern for extracting structured agent state from transcript files. If we ever want to build a custom dashboard, this architecture is worth studying.

## Recommended Actions
1. **Install from VS Code Marketplace** and run it during the next heartbeat cycle to see how the sub-agent visualization looks in practice — low-effort evaluation with real data.
2. **Evaluate JSONL parsing approach** against our existing activity-monitor.sh as a potential upgrade path if we want richer agent state visibility from the workspace side.
