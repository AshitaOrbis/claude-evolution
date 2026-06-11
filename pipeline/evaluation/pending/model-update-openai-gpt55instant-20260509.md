# Discovery: GPT-5.5 Instant Release

**Date**: 2026-05-09
**Source**: OpenAI official announcement, TechCrunch
**Model**: GPT-5.5 Instant

## Current Status

- **Previous default**: GPT-5.3 Instant (ChatGPT)
- **New model**: GPT-5.5 Instant
- **Release date**: May 5, 2026
- **Status**: Now default model for ChatGPT, available in API as `chat-latest`

## Details

OpenAI released GPT-5.5 Instant on May 5, 2026, which replaces GPT-5.3 Instant as the default ChatGPT model. This is a new intelligence tier separate from the existing GPT-5.5 and GPT-5.5 Pro variants.

## Sources

- [TechCrunch: OpenAI releases GPT-5.5 Instant](https://techcrunch.com/2026/05/05/openai-releases-gpt-5-5-instant-a-new-default-model-for-chatgpt/)
- [OpenAI: GPT-5.5 Instant announcement](https://openai.com/index/gpt-5-5-instant/)

## Recommended Action

1. Add GPT-5.5 Instant to `state/contemporary-models.json` monitor section
2. Evaluate for potential use as cost-optimized alternative to GPT-5.5 for heartbeat/discovery tasks
3. Consider using for faster interactive loops (e.g., website reviews, quick analyses)
4. Document in agents/skills if adopted

## Integration Notes

- Model ID: `gpt-5-5-instant` (API) or `chat-latest` (ChatGPT)
- Status: Stable (GA)
- Use case: ChatGPT default, cost-effective alternative to GPT-5.5 for most tasks
