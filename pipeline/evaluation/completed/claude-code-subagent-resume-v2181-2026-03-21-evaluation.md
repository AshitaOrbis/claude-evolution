# Discovery: Autonomous Subagent Resume (v2.1.81)

**Source**: Claude Code v2.1.81 official release (2026-03-20)
**Discovery Date**: 2026-03-21
**Evaluated**: 2026-03-21
**Type**: Built-in agent capability (zero integration cost)

---

## What It Is

Claude can now autonomously decide to resume a previously spawned subagent rather than always creating a fresh one. This is a model-level capability, not just an API change.

**Before (v2.1.77–2.1.80):**
- Developer explicitly called `SendMessage({to: agentId})` to resume a stopped agent
- The model itself always spawned fresh subagents via `Task` tool

**After (v2.1.81):**
- Claude (the orchestrator) can choose to resume a subagent it previously spawned
- Subagents accumulate context across multiple orchestrator turns
- Enables stateful multi-step workflows without developer-managed resume logic

---

## Agent Lifecycle Context

| Mechanism | Who Decides | When Introduced |
|-----------|------------|-----------------|
| `Agent` resume parameter | Developer | Removed in v2.1.77 |
| `SendMessage({to: agentId})` | Developer | v2.1.77 |
| Autonomous subagent resume | Model (Claude) | v2.1.81 |

The model can now use judgment to decide: "this subagent has relevant state — resume it" vs "spawn fresh." This is particularly valuable for:
- Multi-step research workflows where subagents accumulate source context
- Long-running capability-discoverer runs that can continue from where they left off
- Agent pipelines where intermediate subagent state is expensive to recreate

---

## Redundancy Check

| Trigger | Match | Notes |
|---------|-------|-------|
| SendMessage resume (v2.1.77) | IMPROVEMENT | Developer-initiated resume → model-initiated resume |
| Task tool subagents | COMPLEMENTARY | Fresh spawn vs stateful resume — both still valid |

---

## Scoring

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 100 | Zero — model behavior, no config required |
| Token efficiency impact | 25% | 70 | Reuse accumulated context vs respawn saves context rebuilding |
| Capability expansion | 25% | 70 | Novel but incremental on existing SendMessage resume |
| Maintenance burden | 15% | 100 | Zero — built-in model capability |
| Community validation | 15% | 100 | Official Anthropic release (v2.1.81) |

**Weighted Score**: (100×0.20) + (70×0.25) + (70×0.25) + (100×0.15) + (100×0.15)
= 20 + 17.5 + 17.5 + 15 + 15 = **85.0/100** → **APPROVED**

---

## Integration Plan

1. Add to registry under Multi-Agent Patterns: `Autonomous subagent resume | IMPLEMENTED (v2.1.81) | Model-initiated; Claude decides to resume vs spawn fresh`
2. Update `~/.claude/agents/INDEX.md` — note that agents now accumulate state across resumptions
3. Update `helpers/playbooks/model-selection.md` or agent design patterns — note when to prefer resumable agents vs fresh spawns
4. Interaction with `isolation: worktree` needs investigation — resumed agents in worktrees may have stale state if files changed

---

## Notes

- Builds on `SendMessage auto-resume` (v2.1.77) which allowed API-level resume
- This is model-initiated — Claude decides when resume is appropriate
- No developer action required; model uses judgment autonomously
- Worth testing: does the model correctly decide not to resume when context would be stale?
