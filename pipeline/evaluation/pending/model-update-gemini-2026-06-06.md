# Discovery: Gemini 3.5 Series Models

**Date discovered**: 2026-06-06
**Status**: NEW models detected
**Source**: Google I/O 2026 announcements (2026-05-20)

## Summary

Google released multiple new Gemini models at I/O 2026, superseding Gemini 3.1 Pro as the primary model.

### Detected Models

| Model | Release | Notes | Relevance |
|-------|---------|-------|-----------|
| **Gemini 3.5 Flash** | ~2026-05-20 | Outperforms 3.1 Pro on coding/agentic benchmarks at **4x the speed** | HIGH - coding/agentic tasks |
| **Gemini 3.5** | ~2026-05-20 | Frontier intelligence + action for complex multi-step workflows | HIGH - may replace 3.1 Pro |
| **Gemini Omni Flash** | 2026-05-20 | Multimodal (image, audio, video input → video output) | MEDIUM - visual workflows |

## Current State

**Last verified**: 2026-05-09
**Current primary**: Gemini 3.1 Pro (id: `gemini-3-1-pro-preview`)
**Gap**: 28 days since last check

## Recommended Action

1. **Verify Gemini 3.5 Flash API availability** — Check Google AI SDK/API docs for model ID and API access
2. **Benchmark against 3.1 Pro** — Compare performance on visual-fidelity-inspector tasks
3. **Consider adoption** — If 3.5 Flash is GA and 4x faster, candidate for visual analysis agent
4. **Evaluate Gemini 3.5** as potential new primary model (if outperforms 3.1 Pro overall)

## Sources

- Google I/O 2026 announcements: https://blog.google/innovation-and-ai/technology/ai/io-2026-google-ai/
- MarkTechPost coverage: Gemini 3.5 Flash benchmarks and speed gains
- Google DeepMind models page: Gemini 3.5 series documentation

## Follow-Up

If Gemini 3.5 Flash proves faster/better for visual analysis:
- Update `visual-fidelity-inspector` agent to use 3.5 Flash
- Update registry with new model entry
- Deprecate or monitor 3.1 Pro performance
