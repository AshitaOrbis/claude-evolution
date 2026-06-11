# Discovery: PreToolUse Hook `AskUserQuestion` Satisfaction (v2.1.85)

**Source**: GitHub releases atom feed — Claude Code v2.1.85 official changelog
**Date Discovered**: 2026-03-28 (backfill — identified in 2026-03-27 investigation, file not created)
**Category**: Hook System Extension
**Version**: Claude Code v2.1.85+

---

## What It Is

`PreToolUse` hooks can now return a response that fully satisfies a pending `AskUserQuestion` dialog, bypassing the normal user interaction flow.

**Return format**:
```json
{
  "permissionDecision": "allow",
  "updatedInput": {
    "question_id": "...",
    "answer": "..."
  }
}
```

Previously, `AskUserQuestion` dialogs blocked execution until a human responded in the terminal (or IDE panel). With this change, a `PreToolUse` hook can intercept the call and inject the answer programmatically — enabling fully headless operation in pipelines where unattended runs are expected.

---

## Registry Comparison

**Existing capability**: `PreToolUse` hooks exist and support `additionalContext` injection, `permissionDecision: "allow"`, and blocking via exit code 2. Documented in Hook Development Patterns.

**What's new**: The `updatedInput` field is a NEW return value that closes the loop on `AskUserQuestion` dialogs. The hook can now provide not just a permission decision but also the actual answer to the question Claude is asking. This is a distinct interaction mode not covered by existing `additionalContext` or `permissionDecision` alone.

**Classification**: IMPROVEMENT — extends the PreToolUse hook return schema with a new capability (headless `AskUserQuestion` satisfaction). Not covered by any existing registry entry.

---

## Evaluation

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 85 | Modify existing hook scripts to add `updatedInput` on matching `AskUserQuestion` calls — no new infrastructure |
| Token efficiency impact | 25% | 50 | Neutral on tokens directly; reduces stall points in headless runs (indirect efficiency gain) |
| Capability expansion | 25% | 95 | Closes a real gap: AskUserQuestion dialogs currently stall unattended runs. This eliminates the stall entirely via hook logic |
| Maintenance burden | 15% | 90 | Additive to existing hook system; scripts opt in to handling AskUserQuestion — no breaking changes |
| Community validation | 15% | 100 | Official Anthropic release note in GitHub atom feed |

**Weighted score**: (0.20 × 85) + (0.25 × 50) + (0.25 × 95) + (0.15 × 90) + (0.15 × 100)
= 17 + 12.5 + 23.75 + 13.5 + 15
= **81.75 / 100** → APPROVED (threshold: 70)

---

## Practical Use Cases

1. **Heartbeat/cron runs**: When Claude asks a clarifying question mid-pipeline, a hook can auto-answer from a predefined answer set (e.g., "yes", "proceed", "skip") based on question context.

2. **CI/CD integration**: Automated code review pipelines where `AskUserQuestion` is used for human oversight can delegate answers to a CI decision function (branch policy, PR labels, etc.).

3. **Evolution pipeline**: When `capability-discoverer` or `capability-evaluator` asks a question during a background run, the hook can handle routine cases (proceed/skip) automatically, surfacing only novel questions to Discord.

4. **iterative-improve**: During headless persona testing phases, any unexpected `AskUserQuestion` call can be answered with a safe default rather than blocking the loop.

---

## Implementation Notes

- Check `tool_name` or hook payload to identify `AskUserQuestion` calls
- Build a lookup of known question patterns → safe default answers
- For unknown questions, fall back to NOT returning `updatedInput` (user interaction proceeds normally)
- Combine with the v2.1.85 `if` conditional field to only run this hook for `AskUserQuestion` tool calls

**Example config**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "if": "tool_name == 'AskUserQuestion'",
        "hooks": [{"type": "command", "command": "~/.claude/hooks/headless-question-handler.sh"}]
      }
    ]
  }
}
```

---

## Integration Path

1. Add entry to Hook Development Patterns table in `registry/existing-capabilities.md`
2. Update Hook Lifecycle skill to document `updatedInput` return schema
3. Optionally: create `~/.claude/hooks/headless-question-handler.sh` for pipeline use

**Effort**: Low — 1-2 hook script + registry update

---

## References

- Official source: `https://github.com/anthropics/claude-code/releases/tag/v2.1.85` (GitHub atom feed entry)
- Changelog text: "PreToolUse hooks can now satisfy `AskUserQuestion` by returning `updatedInput` alongside `permissionDecision: "allow"`, enabling headless integrations that collect answers via their own UI"
- Related: v2.1.85 conditional `if` field (evaluated 2026-03-27, score 88.25/100)
