# Discovery: Dynamic Model Selection for Subagents (v2.1.81)

**Source**: Claude Code v2.1.81 official release (2026-03-20)
**Discovery Date**: 2026-03-21
**Evaluated**: 2026-03-21
**Type**: Built-in agent capability (zero integration cost)

---

## What It Is

The orchestrating Claude instance can now dynamically choose which model a subagent uses when invoking it via the `Task` tool — at invocation time, not just at definition time.

**Before (static only):**
```yaml
# Agent definition — model fixed at definition
---
name: my-agent
model: haiku
---
```

**After (dynamic selection):**
Claude can specify the model for a subagent dynamically when invoking via Task tool, based on the complexity of the specific task being delegated.

---

## Why It Matters

Enables **runtime model routing** within a single orchestrated workflow:
- Simple discovery tasks → Haiku (fast, cheap)
- Code review, analysis → Sonnet
- Complex reasoning, planning → Opus

This is distinct from:
- Static `model:` frontmatter — set at definition time, doesn't adapt to task complexity
- `model-router` subagent — routes tasks to models via a separate routing step
- `ANTHROPIC_CUSTOM_MODEL_OPTION` — adds custom entries to picker, doesn't affect subagent invocation

**Key benefit**: The evolution-orchestrator and other pipeline orchestrators can select the right model for each step without maintaining separate agent definitions per model tier.

---

## Redundancy Check

| Trigger | Match | Notes |
|---------|-------|-------|
| Static model frontmatter | IMPROVEMENT | Static set at definition → dynamic at invocation time |
| model-router subagent | COMPLEMENTARY | Router routes tasks to separate agents; this routes model within one agent invocation |
| ANTHROPIC_CUSTOM_MODEL_OPTION | ORTHOGONAL | Picker configuration, not subagent invocation routing |

---

## Scoring

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 85 | Built-in, but requires learning exact invocation syntax (TBD) |
| Token efficiency impact | 25% | 85 | Routing simple tasks to Haiku = significant cost reduction per workflow |
| Capability expansion | 25% | 85 | Novel: runtime model routing without separate agent definitions |
| Maintenance burden | 15% | 90 | Very low — model behavior, minimal config |
| Community validation | 15% | 100 | Official Anthropic release (v2.1.81) |

**Weighted Score**: (85×0.20) + (85×0.25) + (85×0.25) + (90×0.15) + (100×0.15)
= 17 + 21.25 + 21.25 + 13.5 + 15 = **88.0/100** → **APPROVED (HIGH PRIORITY)**

---

## Integration Plan

1. Investigate exact invocation syntax — what parameter enables dynamic model on Task tool call?
2. Update `~/.claude/agents/evolution-orchestrator.md` to use dynamic model selection per sub-task
3. Update `~/.claude/agents/INDEX.md` Multi-Model section with dynamic model selection guidance
4. Update `~/.claude/CLAUDE.md` Multi-Model Delegation table to note dynamic selection is now available
5. Update `helpers/playbooks/model-selection.md` with decision rules for dynamic vs static model assignment
6. Add to registry under Multi-Model Orchestration

---

## Research Needed Before Full Integration

- What is the exact syntax for specifying model dynamically in Task tool invocation?
- Does it use a `model` parameter on the Agent tool call, or a different mechanism?
- Interaction with existing `model:` frontmatter — does dynamic override static?
- Does this work with the `model` shorthand (`haiku`, `sonnet`, `opus`) or requires full model ID?
