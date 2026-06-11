---
date: 2026-03-28
topic: "OpenSpace self-evolving AI agent framework for claude-evolution system"
discord_message_id: "1487314969350377535"
status: complete
---

# OpenSpace: Self-Evolving Agent Framework for Claude-Evolution

## Topic

> "Anything here we could implement in our Claude-evolution system?" — github.com/HKUDS/OpenSpace

## Key Findings

- **OpenSpace** is a self-evolving AI agent framework: agents automatically fix broken skills, improve successful patterns, and share learned capabilities across agents via a cloud skill hub
- Core loop mirrors claude-evolution's existing pipeline: discover → capture → integrate → share, but **fully automated and runtime-triggered** vs our manual/cron-triggered workflow
- Three mechanisms directly relevant to claude-evolution: **AUTO-FIX** (skills self-repair when tools/APIs change), **AUTO-IMPROVE** (successful execution patterns become better skill versions), **AUTO-LEARN** (captures winning workflows from actual usage)
- Integrates via **MCP server** — works with Claude Code, Codex, Cursor, OpenClaw — the exact toolchain we use
- Performance claims: **4.2x higher income** and **46% fewer tokens** on professional tasks vs baseline agents, though this is on a GDPVal benchmark (document/spreadsheet work), not general coding workflows
- The **collective intelligence component** (one agent learns, all benefit via cloud hub) is architecturally novel but raises privacy concerns for private workflow patterns

## Details

OpenSpace's self-evolution loop is the most relevant feature. Currently, claude-evolution relies on:
1. Manual discovery via cron/heartbeat agents
2. Human-reviewed evaluation pipeline
3. Manual integration (capability-integrator agent)

OpenSpace's AUTO-FIX/AUTO-IMPROVE would enable runtime skill repair and improvement without going through the full pipeline. The key difference: OpenSpace captures improvements at *execution time*, while we currently capture them at *planning time* (from discoveries and evaluations).

The **MCP interface** is a practical integration path — it could run as an additional MCP server alongside the existing ones. The cloud skill sharing is optional (local-only operation possible).

**Critical question**: Does OpenSpace's skill representation format (likely JSON or YAML skill definitions) map to our `~/.claude/skills/` structure? If skill formats are compatible, AUTO-LEARN could automatically generate skill candidates for human review in `pipeline/evaluation/pending/`.

The GDPVal benchmark results are impressive but apply to professional document/spreadsheet workflows — not our primary use case (capability discovery and integration). Transfer to our context is uncertain.

## Relevance to Workspace

- `claude-evolution/`: Direct architectural complement — fills the "runtime adaptation" gap in our pipeline
- `~/.claude/skills/`: Target output for AUTO-LEARN captured skills
- `pipeline/evaluation/pending/`: AUTO-LEARN output could feed this queue automatically
- `agent-event-bus/`: OpenSpace's skill sharing maps to event bus's knowledge distribution capability

## Recommended Actions

1. **Read the full README and architecture docs** before committing to integration — the GDPVal benchmark framing suggests document/office work focus
2. **Evaluate as claude-evolution capability** via standard pipeline (NEEDS_RESEARCH); the `capability-evaluator` should score it with focus on compatibility with our skill format
3. **Proof of concept**: Try running OpenSpace's MCP server alongside Claude Code for 1 week, focusing on AUTO-FIX for skills that break when APIs update
4. **Skip cloud skill sharing initially** — too much privacy risk for private workflow patterns; local-only mode if available
