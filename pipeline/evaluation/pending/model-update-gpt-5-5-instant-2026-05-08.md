# Model Discovery: GPT-5.5 Instant (May 2026)

**Date Found**: 2026-05-08
**Detection Method**: Contemporary models freshness check

## Summary

OpenAI released **GPT-5.5 Instant** on May 5, 2026. This is a new variant of the GPT-5.5 line, rolling out as the default ChatGPT model and replacing GPT-5.3 Instant.

## Model Details

- **Name**: GPT-5.5 Instant
- **Model ID**: `gpt-5-5-instant`
- **Released**: 2026-05-05
- **Status**: General availability (default for ChatGPT Plus, Pro, Business, Enterprise)
- **Use Case**: "Smarter, clearer, and more personalized" — described as higher accuracy than GPT-5.3 Instant
- **Relationship**: Variant of GPT-5.5 base (released 2026-04-23), successor to GPT-5.3 Instant

## Sources

- OpenAI official: https://openai.com/index/gpt-5-5-instant/
- MWM article: https://mwm.ai/articles/openai-upgrades-chatgpt-default-model-to-gpt-5-5-instant-in-may-2026
- Releasebot: https://releasebot.io/updates/openai/chatgpt

## Current State (claude-evolution)

| Model | Current Version |
|-------|-----------------|
| GPT Codex (primary) | GPT-5.5 (gpt-5.5) as of 2026-04-23 |
| GPT Instant replacement | GPT-5.3 Instant (legacy) |
| Gemini (primary) | Gemini 3.1 Pro (gemini-3.1-pro-preview) |

## Recommendation

**SCOPE**: Add GPT-5.5 Instant as a monitor-tier variant (not replacing primary GPT-5.5).

**Rationale**:
- GPT-5.5 is already primary codex model (code review, complex reasoning)
- GPT-5.5 Instant is a lower-latency variant optimized for conversation/clarity
- Could be useful for discovery runs (faster, cheaper) or persona/testing workflows
- Not a replacement for primary GPT-5.5 at this time

**Action**: Add to `state/contemporary-models.json` monitor section as `gpt_55_instant`.

## Gemini Status

Gemini 3.1 Pro remains current. Gemini 4 is expected later in 2026 but not yet released.

## Note

GPT-5.5-Cyber was already detected in April and is in the monitor section. No action needed there.
