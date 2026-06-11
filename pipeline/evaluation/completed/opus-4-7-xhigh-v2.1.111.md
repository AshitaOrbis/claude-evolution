# Discovery: Claude Opus 4.7 with xhigh Effort Tier

**Source**: Claude Code v2.1.111 changelog (April 16, 2026)  
**Type**: New Model + New Capability  
**Priority**: HIGH

---

## What

Claude Opus 4.7 is a new Anthropic model that ships with a new "xhigh" effort tier, enabling tuning along the speed↔intelligence axis via `/effort`. Auto mode for Max subscribers is explicitly available with Opus 4.7.

v2.1.112 immediately patched an "Opus 4.7 temporarily unavailable" error in auto mode, confirming rapid availability.

---

## Claimed Capabilities

- **Model ID**: `claude-opus-4-7` (verify via `/model` picker before deploying)
- **xhigh effort**: New effort level above existing `max` — extended intelligence mode at cost of throughput speed
- **Speed↔intelligence tuning**: `/effort` now positions the model on this curve
- **Auto mode on Max plan**: Confirmed working with Opus 4.7 for Max subscribers

---

## Comparison Against Existing

| Dimension | Opus 4.6 (current) | Opus 4.7 (new) |
|-----------|-------------------|----------------|
| Model ID | `claude-opus-4-6` | `claude-opus-4-7` (likely) |
| Max effort | `max` (existing) | `xhigh` (new tier above max?) |
| Speed option | `/effort` low/medium | `/effort` tunable speed vs intelligence |
| Auto mode (Max) | Supported | Explicitly confirmed |
| Context window | 1M (GA) | Unknown — assume same |
| Pricing | $5/$25/M | Unknown — verify |

---

## Redundancy Check

- **Existing**: Opus 4.6 is the current primary Opus model — `claude-opus-4-6` / `opus` shorthand
- **Evolution-orchestrator**, **code-reviewer**, and planning agents use `model: opus`
- The `opus` shorthand may or may not auto-resolve to Opus 4.7 — **verify empirically**

---

## Evaluation Questions

1. Does the `opus` shorthand in agent frontmatter resolve to Opus 4.7 or stay on 4.6?
2. What is Opus 4.7's exact model ID and pricing?
3. What does `xhigh` effort concretely mean? Is it a new effort level (`low/medium/high/max/xhigh`) or a tunable parameter?
4. Is there a measurable capability improvement over 4.6 on our typical workloads (planning, evaluation, code review)?
5. Does Opus 4.7 + xhigh replace `ultrathink` use cases?

---

## Preliminary Assessment

**Score estimate**: 80-90/100 (pending verification)

**Integration direction**:
- If `opus` shorthand resolves to 4.7: zero-config benefit — update CLAUDE.md model table and done
- If separate model ID: update agent definitions that benefit from xhigh effort (evolution-orchestrator, code-reviewer for complex analyses)
- Heartbeat/cron: keep Sonnet (cost/speed priority); Opus 4.7 for evaluation/planning only
- `xhigh` effort: evaluate for multi-file planning sessions where Opus 4.6 max was insufficient

**Actions before integration**:
1. Run `claude --version` to confirm 4.7 availability in current build
2. Use `/model` picker to find exact model ID
3. Test a planning task comparing Opus 4.6 max vs Opus 4.7 xhigh
4. Check pricing via Anthropic pricing page

---

## Final Evaluation

```json
{
  "evaluation": {
    "scores": {
      "integration_complexity": 0,
      "token_efficiency": 65,
      "capability_expansion": 75,
      "maintenance_burden": 100,
      "community_validation": 100
    },
    "total": 58.75,
    "decision": "REJECTED",
    "reasoning": "DUPLICATE: This item is superseded by pipeline/integration/20260418-claude-opus-4-7-xhigh-auto-mode-max.json which has a complete, higher-quality evaluation (score: 83.0, APPROVED) and is already queued for integration. integration_complexity=0 because the integration would be redundant. No action needed on this entry — track progress via the 20260418 integration item.",
    "evaluated_at": "2026-04-20"
  }
}
```
