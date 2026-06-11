# `ANTHROPIC_CUSTOM_MODEL_OPTION` Custom Model Picker Entry

**Source**: Claude Code v2.1.78 official release (2026-03-17)
**Discovered**: 2026-03-18
**Type**: Built-in feature (environment variable)
**Evaluated**: 2026-03-18

## What It Is

New env var that adds a custom entry to the Claude Code `/model` picker:

```bash
export ANTHROPIC_CUSTOM_MODEL_OPTION=my-model-id
export ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="My Model"           # optional display name
export ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION="Custom proxy" # optional description
```

## Use Cases

1. **Preview/beta model IDs**: Switch to model IDs not yet in the default picker list
2. **Proxy models**: Route through compatible API gateways
3. **Custom fine-tuned models**: Add fine-tuned Anthropic model IDs
4. **Quick model switching**: Add commonly-used model without editing config

## Redundancy Check

- `/model` command: Already exists — this EXTENDS it, not replaces it
- `model-router` agent: Different — that routes programmatically; this is UI/picker
- CLAUDE.md model table: Documents models; this enables picker access

**Result**: NOVEL — no existing mechanism adds custom model entries to the `/model` UI picker.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 95 | Single env var, zero config — trivially easy |
| Token efficiency | 50 | Neutral — no direct impact on token usage |
| Capability expansion | 65 | Convenience for accessing preview/beta models quickly; not a new capability class |
| Maintenance burden | 95 | Built-in feature — zero ongoing maintenance |
| Community validation | 85 | Official Anthropic v2.1.78 release |

**Weighted Score**: (95×0.20) + (50×0.25) + (65×0.25) + (95×0.15) + (85×0.15) = 19 + 12.5 + 16.25 + 14.25 + 12.75 = **74.75/100**

## Decision

**APPROVED** (74.75)

## Integration Notes

- Document in registry under "Model Management" or "Built-in Features"
- Add to `helpers/navigation/hook-environment-variables.md` (or a model-management reference)
- No need for a skill — pure documentation/awareness
- Practical use: set `ANTHROPIC_CUSTOM_MODEL_OPTION=claude-opus-5-0-preview` when next preview ships
- Also document the companion `_NAME` and `_DESCRIPTION` env vars
