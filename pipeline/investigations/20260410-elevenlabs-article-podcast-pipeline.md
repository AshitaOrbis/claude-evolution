---
date: 2026-04-10
topic: "Well want to find a bunch of articles to turn to podcasts with 11 labs"
discord_message_id: "1492280687263354952"
status: complete
---

# ElevenLabs Article-to-Podcast Pipeline

## Topic
Original Discord message: "https://x.com/i/status/2042709620544635010 — Well want to find a bunch of articles to turn to podcasts with 11 labs"

## Key Findings

- **`experiments/article-podcast/` already exists** — a Python venv is set up but no scripts have been written yet. It's infrastructure waiting for implementation.
- **Working ElevenLabs integration already in workspace** — `autonovel-psyche/gen_audiobook.py` uses `text_to_dialogue` (multi-voice) and handles chunking, rate limiting, retries, and MP3 output. The article-to-podcast script needs the simpler `text_to_speech` endpoint (single narrator), not dialogue.
- **30+ Ashita Orbis posts are ready-made article candidates** — found in `applications/ashitaorbis/shared/content/archive/posts/` (001–013) and `shared/content/posts/` (014+). These are essay-format pieces that would read well as podcasts.
- **Best Ashita Orbis candidates** (analytical/narrative vs. technical how-to): posts on dead blog theory, context window epistemology, AI as mirror, 10,000 conversations, dead internet theory, behaviorism in RL, etymology tax — all substantial enough (~800–2000 words) to make compelling 5–12 min episodes.
- **Voice assistant experiment** also uses ElevenLabs (`eleven_multilingual_v2`) confirming the API key is configured for the workspace.
- **ElevenLabs Projects** (their native long-form tool) exists but the web scraping confirmed the workspace approach — a custom Python script calling the TTS API directly — is more controllable and already proven.

## Details

### What Already Exists

The workspace has a battle-tested ElevenLabs pipeline in `autonovel-psyche/gen_audiobook.py`. It chunks text at 4,500 chars per call, handles retries with backoff, rate-limits at 3s between calls, and concatenates audio parts into a final MP3. The core difference for articles vs. audiobooks: audiobooks use `text_to_dialogue` (multi-voice, requires speaker attribution JSON) — articles need `text_to_speech` (single narrator, raw text in).

The `experiments/article-podcast/` directory has a Python venv already created with Python 3.12. It's a blank slate waiting for a script. The `elevenlabs` Python package is likely already installed given the autonovel project; if not, it needs to be added.

### Pipeline Design (recommended)

```
input: markdown article file
  → strip frontmatter, headers, markdown syntax
  → clean text for speech (remove code blocks, tables, URLs)
  → chunk at ~4500 chars (sentence boundaries)
  → ElevenLabs TTS (eleven_multilingual_v2 or turbo_v2_5)
  → concatenate MP3 chunks
output: article-slug.mp3
```

A single script at `experiments/article-podcast/convert.py` with:
- `convert.py <path-to-post.md>` — single article
- `convert.py --batch <directory>` — bulk convert
- `--voice` flag to select narrator voice
- `--test` flag to do first 10 seconds only (same pattern as gen_audiobook.py)

### Article Candidates (Ashita Orbis)

**Tier 1 — strongest podcast material** (narrative/analytical):
- `006-what-10000-ai-conversations-reveal.md` — data-driven, accessible
- `007-ai-as-mirror.md` — philosophical, good spoken cadence
- `010-context-window-epistemology.md` — conceptual depth
- `016-dead-internet-theory.md` — cultural analysis
- `014-behaviorisms-hidden-legacy-in-reinforcement-learning.md` — intellectual
- `the-etymology-tax.md` (research) — standalone essay

**Tier 2 — good but may need light editing for audio**:
- `008-the-autonomous-development-stack.md` — has technical lists
- `013-persona-testing.md` — has some table structure
- `012-red-teaming-your-business-ideas.md`

**Avoid** (for now): posts that are primarily structured with code blocks, numbered lists, or tables — these don't translate to audio without preprocessing.

### Beyond Ashita Orbis

The user specifically said "find a bunch of articles" which may include external articles. The GPT Pro response `P15-ai-audio-indie-games.md` and various orchestration research documents are potential internal candidates. For external articles, a fetch-and-clean step (WebFetch → strip HTML → TTS) would extend the pipeline.

### Publishing Consideration

Ashita Orbis has no podcast/audio feature currently. Options range from: (1) local-only for personal consumption, (2) hosting MP3s on S3 and linking from blog posts, (3) eventually building a proper podcast feed (RSS with enclosures). Starting with option 1/2 makes sense — get the conversion working first.

## Relevance to Workspace

This directly builds on two existing experiments (`article-podcast/` and `autonovel-psyche/`) and feeds into the Ashita Orbis content strategy. The voice assistant already demonstrates ElevenLabs is production-ready in this workspace. Building the script also reuses the chunking/retry logic from `gen_audiobook.py`, keeping the implementation effort low.

## Recommended Actions

1. **Write `experiments/article-podcast/convert.py`** — single-voice TTS script adapted from `gen_audiobook.py`, replacing `text_to_dialogue` with `text_to_speech`, adding markdown-stripping logic
2. **Start with 3 Tier 1 posts** as test batch: `006`, `007`, `010` — listen to output, tune voice and settings
3. **Document the article selection criteria** in `article-podcast/README.md` so the batch process is repeatable
4. **Optionally host outputs on S3** and add audio player to Ashita Orbis post template (low effort, high value for accessibility)
