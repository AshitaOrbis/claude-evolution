# Discovery: GPT-5.4 mini and nano Models

**Date**: 2026-03-26
**Type**: Model Release
**Provider**: OpenAI
**Status**: Released (March 17, 2026)

## Summary

OpenAI released two new models in the GPT-5.4 family on March 17, 2026:
- **GPT-5.4 mini**: Fast and efficient model optimized for coding and subagents
- **GPT-5.4 nano**: Ultra-efficient variant for cost-sensitive applications

Both models were released after the last model registry update (2026-03-09).

## Current Context

From `state/contemporary-models.json`:
- Last verified: 2026-03-09
- Primary models: GPT-5.4, Gemini 3.1 Pro, Claude Opus 4.6/Sonnet 4.6/Haiku 4.5
- Monitor section: Tracking Gemini 3.1 Flash-Lite, Gemini 3.1 Flash Image, GPT-5.4 Thinking, GPT-5.3-Codex-Spark

## New Models

### GPT-5.4 mini
- **Model ID**: `gpt-5.4-mini`
- **Released**: March 17, 2026
- **Purpose**: Fast, cost-effective model optimized for coding and subagent workflows
- **Inference Cost**: Lower than GPT-5.4 base
- **Use Cases**: Routing decisions, lightweight code generation, subagent delegation

### GPT-5.4 nano
- **Model ID**: `gpt-5.4-nano`
- **Released**: March 17, 2026
- **Purpose**: Ultra-efficient, minimal token consumption
- **Inference Cost**: Significantly lower than mini
- **Use Cases**: High-volume classification, batch processing, simple tasks

## Source URLs

- OpenAI announcement: https://openai.com/index/introducing-gpt-5-4-mini-and-nano/
- TechCrunch coverage: https://techcrunch.com/2026/03/05/openai-launches-gpt-5-4-with-pro-and-thinking-versions/
- OpenAI Model Release Notes: https://help.openai.com/en/articles/9624314-model-release-notes

## Recommended Action

1. **Add to monitor section** of `state/contemporary-models.json` with status `available`
2. **Evaluate for integration** into subagent routing strategy (potential replacement for Haiku in some contexts)
3. **Cost analysis**: Compare token pricing vs Claude Haiku 4.5 for subagent use cases
4. **Consider updating skills** that mention "Haiku for routing" to note mini/nano as alternatives

## Notes

- These are not preview/beta models — released to general API access
- No newer major versions detected (no GPT-5.5 or 6.x)
- Gemini latest remains 3.1 Pro (with 3.1 Flash variants in preview)
- Gemini 3 Pro Preview deprecated March 9, 2026 (already noted)

**Next step**: Evaluation pipeline will determine whether to integrate into CLAUDE.md model recommendations or skills.
