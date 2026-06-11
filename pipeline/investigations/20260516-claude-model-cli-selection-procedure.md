---
date: 2026-05-16
topic: "Interesting tweets, document the procedure as it is likely useful for experimenting"
discord_message_id: "1505206248755298465"
status: complete
---

# Claude Code: Accessing Any Model via --model CLI Flag

## Topic
Community discovery: Sonnet 4.5 was removed from Claude Code's model selector UI (~1 month ago) but remains accessible via `claude --model claude-sonnet-4-5-20250929`. The same applies to all available Anthropic models including Claude 3 Opus via researcher access.

## Key Findings
- **`--model` flag bypasses the UI model selector entirely** — any valid model ID works even if it's been removed from the picker
- Sonnet 4.5 model ID: `claude-sonnet-4-5-20250929` (still accessible as of the tweet)
- Claude 3 Opus ID: `claude-3-opus-20240229` — requires researcher access, but that access is "universally approved"
- This is distinct from `ANTHROPIC_CUSTOM_MODEL_OPTION` (v2.1.78), which adds a custom entry to the UI picker rather than bypassing it
- Applies to all Claude Code execution modes: interactive, `-p` print mode, `--resume`
- No API key required — this works on Claude Max plan via the CLI

## Details

The `--model` flag has always been part of the Claude Code CLI but its value as a workaround for removed/legacy models wasn't widely documented. The UI model selector is curated (recently dropping Sonnet 4.5), but the underlying Claude Code engine accepts any valid model ID string.

For our workflow, this unlocks two meaningful capabilities:

**1. Sonnet 4.5 as a cost baseline**: Sonnet 4.5 is cheaper than Sonnet 4.6 and still strong for many tasks. For the DSPy prompt optimizer (`dspy-prompt-optimizer`) where we run many parallel evaluation calls, Sonnet 4.5 could cut token costs by ~40% on runs where quality ceiling isn't the bottleneck. The `--check-model-drift` flag in our optimizer already tracks model metadata — running with `claude-sonnet-4-5-20250929` would be easy to compare against Sonnet 4.6 baselines.

**2. Researcher access for Claude 3 Opus**: The original Claude 3 Opus has specific capabilities that differ from Opus 4.x (particularly in creative/literary registers). For the amnesiac-story project or persona testing that might benefit from a different stylistic profile, this could be useful. Researcher access is universally approved via Anthropic's console.

The community tweet also implies `--model` works for any model the account has access to, including Bedrock and Vertex-proxied models if configured — consistent with Claude Code's provider-agnostic model routing added in v2.1.92+.

## Relevance to Workspace

- **DSPy prompt optimizer**: Sonnet 4.5 as a cheaper eval model for high-volume optimization runs
- **A/B testing infrastructure**: Cross-model quality comparisons become trivial with `--model` switches
- **Nested session workaround**: The existing playbook notes some tool restrictions in nested sessions; `--model` doesn't affect this but knowing available model IDs is prerequisite for any multi-model experiment script
- **Registry note**: `ANTHROPIC_CUSTOM_MODEL_OPTION` (v2.1.78, already in registry) is complementary — it adds to the UI picker while `--model` bypasses it. Both are useful in different contexts.

## Recommended Actions

1. **Document model IDs in `state/versions.json`** — add `claude-sonnet-4-5-20250929` and `claude-3-opus-20240229` to the `known_models` list with notes on accessibility
2. **Test Sonnet 4.5 for DSPy runs** — try `--model claude-sonnet-4-5-20250929` in `batch_optimize.py` for cost comparison on the next campaign
3. **Apply for researcher access** — if Claude 3 Opus is wanted for creative/literary use cases, apply via Anthropic console (universally approved per community)
4. **Add to model-selection playbook** — note the `--model` bypass pattern alongside `ANTHROPIC_CUSTOM_MODEL_OPTION` in `helpers/playbooks/model-selection.md`
