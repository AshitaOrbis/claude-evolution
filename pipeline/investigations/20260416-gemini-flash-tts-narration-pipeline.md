---
date: 2026-04-16
topic: "Would Gemini 3.1 Flash TTS be good for our article narration pipeline?"
discord_message_id: "1494191227183169596"
status: complete
---

# Gemini 3.1 Flash TTS: Fit for Article Narration Pipeline

## Topic
Original Discord message: "https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-3-1-flash-tts/ — Would this be good for our article narration pipeline?"

## Key Findings

- **Not the same as Flash Live**: Gemini 3.1 Flash TTS is a dedicated *text-to-speech output* model (Apr 2026), distinct from Gemini 3.1 Flash Live (Mar 2026), which handles real-time *audio input*. The narration pipeline needs TTS output — this is the right model.
- **Top-tier quality/cost positioning**: Elo score of 1,211 on the Artificial Analysis TTS leaderboard, placed in the highest quality-to-cost quadrant — better-positioned than ElevenLabs at current pricing tiers based on leaderboard data.
- **Audio Tags are a differentiator**: Natural language inline style controls (pace, tone, delivery) embedded directly in text. ElevenLabs requires SSML or separate API parameters; Flash TTS takes them inline, making prompt-driven narration far simpler.
- **Multi-speaker native**: Built-in multi-speaker support without complex speaker attribution JSON (unlike ElevenLabs `text_to_dialogue`). Useful for future dialogue-heavy pieces on Ashita Orbis.
- **Still in preview, no public pricing**: Currently available in Gemini API preview and Google AI Studio — pricing not yet announced. ElevenLabs pricing is known and the existing workspace integration is battle-tested.
- **Existing narration pipeline is unimplemented**: `experiments/article-podcast/` has a Python venv but no script yet. This is the ideal moment to evaluate Flash TTS as a candidate — nothing to migrate from.

## Details

### What's Different from Flash Live

The previous model-tracking note (April 12) flagged Gemini 3.1 Flash Live as "audio input / real-time dialogue" and noted it as not-applicable to the evolution system. Flash TTS is an entirely separate product: pure text-to-speech output, no audio input required. The naming is confusing but the distinction is clean: **Live = input, TTS = output**.

### Quality Assessment

The Artificial Analysis TTS leaderboard places Flash TTS at Elo 1,211. ElevenLabs' `eleven_multilingual_v2` (the model currently used in `autonovel-psyche/gen_audiobook.py`) scores well but sits in a different cost tier. The "most attractive quality-to-cost quadrant" claim suggests Flash TTS competes with or beats ElevenLabs Turbo models, which are the relevant comparators for article narration (cost-sensitive, moderate quality requirement).

### API Access Path

Flash TTS is accessible via the Gemini API — the same API used by the `mcp__gemini-cli` tools in the workspace. However, the existing Gemini CLI MCP is for text generation, not audio output. The Gemini API has a separate `speech.generate` endpoint. A dedicated Python script using the `google-generativeai` SDK (already a candidate for the article-podcast venv) would be the integration path, not the existing MCP.

### Feature Comparison for Article Narration

| Feature | ElevenLabs `eleven_multilingual_v2` | Gemini 3.1 Flash TTS |
|---------|-------------------------------------|----------------------|
| Quality/cost position | Good | Top quadrant (leaderboard) |
| Inline style control | Via SSML or parameters | Audio Tags (natural language, inline) |
| Multi-speaker | Requires speaker JSON | Native |
| Languages | 29 | 70+ |
| API status | Production, stable | Preview |
| Workspace integration | Configured + tested | None yet |
| Pricing | Known | TBD (preview) |
| SynthID watermark | No | Yes (auto) |

### Implementation Path

The narration pipeline investigation (April 10) recommended a single `experiments/article-podcast/convert.py` script adapted from `gen_audiobook.py`. That architecture works for both ElevenLabs and Flash TTS — the swappable component is just the TTS API call. A practical approach:

1. Implement the ElevenLabs version first (working integration, known pricing, less risk)
2. Add a `--provider gemini` flag once Flash TTS exits preview and pricing is published
3. A/B test on 2-3 articles to compare quality subjectively

This avoids blocking the pipeline on a preview API while still positioning for a switch when pricing is confirmed.

## Relevance to Workspace

This connects directly to three things: (1) the unimplemented `experiments/article-podcast/` experiment, (2) the 30+ Ashita Orbis articles identified as podcast candidates, and (3) the prior ElevenLabs investigation's recommendation to build `convert.py`. Flash TTS doesn't change the architecture — it changes the TTS backend. The question of "which TTS provider" is a config flag, not a structural decision.

## Recommended Actions

1. **Build `experiments/article-podcast/convert.py` with ElevenLabs now** — don't wait for Flash TTS pricing. The ElevenLabs integration is production-ready, the venv exists, and the workspace has a working reference implementation in `autonovel-psyche/gen_audiobook.py`.
2. **Watch for Flash TTS pricing announcement** — monitor Google AI Studio or the Gemini API pricing page. When pricing publishes, re-evaluate if it undercuts ElevenLabs for this use case.
3. **Note in `article-podcast/README.md`**: Flash TTS is a known future candidate for the TTS backend; the script should be written with provider-swappability in mind (`--provider` flag pattern).
4. **Do NOT block on the Gemini MCP** — Flash TTS requires the `google-generativeai` SDK audio endpoint, not the existing text-generation MCP. Treat as a separate integration.
