# Discovery: PreCompact Hook Blocking (v2.1.105)

**Discovered**: 2026-04-14
**Source**: Claude Code v2.1.105 official changelog (github.com/anthropics/claude-code/releases)
**Category**: Hook System / Compaction Control
**Redundancy Check**: IMPROVEMENT — PreCompact hook existed (used for transcript backup); blocking compaction is NEW behavior

---

## What It Is

v2.1.105 adds the ability for PreCompact hooks to **block compaction** by returning exit code 2 or the structured response `{"decision":"block"}`.

**Official changelog entry**:
> Added PreCompact hook support: hooks can now block compaction by exiting with code 2 or returning `{"decision":"block"}`

Previously, PreCompact fired as a notification hook only — it could not affect whether compaction actually happened. Now it becomes a control hook in the same family as PreToolUse (which can `allow`, `deny`, `defer`, or `updatedInput`).

---

## Why It Matters

### Current Compaction Architecture
`/compact` and auto-compaction summarize the conversation history when context fills up. PreCompact already fired before compaction to allow transcript backup (JSONL → JSON). But the hook could not stop the compaction from occurring.

### New Control Capability
- **Block compaction conditionally**: e.g., block during a critical multi-step operation where context truncation would cause errors
- **Idiomatic with Claude Code hook model**: exit code 2 = block (same as blocking tool use in PreToolUse)
- **Structured return option**: `{"decision":"block"}` — consistent with PreToolUse `defer` and `updatedInput` patterns
- **Use cases**:
  - Block compaction during irreversible operation sequences (deployment, database migration)
  - Block compaction when a background agent depends on conversation context from previous turns
  - Block compaction during evolution pipeline integration phase to preserve plan context
  - Auto-block if context contains unsaved discovery work (check for open evaluation files)

---

## Integration Path

**Action needed**:
1. Update `~/.claude/skills/hook-lifecycle/SKILL.md` — add blocking semantics to PreCompact section
2. Add example hook script: `~/.claude/hooks/block-compaction-during-deploy.sh`
3. Update registry Hook Development Patterns table — annotate PreCompact as "ACTIVE (v2.1.105 blocking)"
4. Update hook count reference (21 → 22 or annotate as behavioral extension)

---

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 90 | Hook infrastructure exists; extend skill + add one example script (~10 lines) |
| Token efficiency impact | 60 | Prevents unwanted context loss during critical operations |
| Capability expansion | 80 | New control path: block compaction from hook — previously impossible |
| Maintenance burden | 90 | Official Anthropic; hook script is minimal |
| Community validation | 90 | Official v2.1.105 release feature |

**Total**: (90×0.20) + (60×0.25) + (80×0.25) + (90×0.15) + (90×0.15) = 18 + 15 + 20 + 13.5 + 13.5 = **80.0**

**Decision**: APPROVED

**Reasoning**: Official Anthropic v2.1.105 feature. Extends existing PreCompact hook with blocking semantics — no new hook infrastructure needed. Capability expansion is real: blocking compaction was previously impossible from hook code. Integration is low-friction (update skill + add example script). No env vars or settings.json changes — no empirical safety test required.

**Evaluated**: 2026-04-15
