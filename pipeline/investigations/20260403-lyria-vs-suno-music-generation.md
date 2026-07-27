---
date: 2026-04-03
topic: "Look into Lyria for music generation generally, how does it compare to Suno?"
discord_message_id: "1489717674815525006"
status: complete
---

# Lyria 3 vs Suno: Music Generation Comparison

## Topic
Tweet referenced Google's Lyria model. Question: how does Lyria compare to Suno for music generation generally?

## Key Findings
- **Lyria 3** is Google DeepMind's most capable music generation model (as of early 2026); prior versions were Lyria 2 and Lyria RealTime
- Lyria 3 generates cohesive tracks up to **3 minutes** with natural musical flow, multi-language vocals, and image-to-music composition
- Access is through **Google's ecosystem**: Gemini, YouTube Dream Track, Google Vids, ProducerAI, Google AI Studio, and Vertex AI Studio — no standalone web UI for consumers
- **SynthID watermarking** is applied to all Lyria output (imperceptible, detectable via Google tools)
- **Suno** (v4, late 2024 baseline) is a standalone consumer product with simple web UI, strong vocal generation, song-structure awareness ("intro/chorus/outro" mode), and a generous free tier
- Lyria's key advantage is **programmability**: Vertex AI access enables enterprise integration, including batch generation and fine-tuning workflows
- Suno's key advantage is **UX accessibility**: any user can generate complete songs in 30 seconds with no API setup

## Details

Lyria 3 represents Google's push to make music generation a first-class multimodal output alongside image and video. The integration into Gemini means it's callable from agentic workflows today — if your workspace already uses Gemini MCP, Lyria is reachable without additional accounts. The SynthID watermark is significant: all output is traceable, which matters for any published or commercial use.

Suno occupies a different niche: it excels at fast, consumer-accessible full-song generation with strong default quality. The web interface has become the go-to for non-technical users wanting complete tracks with vocals. Suno's limitation is the lack of programmatic API depth — it has an undocumented API but no official production-grade SDK.

For **workspace music experiments**, the relevant question is: what's the goal? If generating game background music (the gacha game, etc.) programmatically, Lyria via Vertex AI or Google AI Studio is the more integrable option. If rapidly prototyping song ideas (e.g., for the blog or personal projects), Suno's web interface wins on speed-to-output. The LilyPond angle (referenced in a prior Discord message) is separate — that's notation-based composition with Opus 4.6, not latent diffusion generation.

## Relevance to Workspace
- **Games pipeline** (the gacha game, slime-survivor): Lyria Vertex API could be used for procedural soundtrack generation — worth evaluating when those games need audio assets
- **Blog/experiments**: Lyria's image-to-music feature is a potential creative tool for multi-modal blog content
- **LilyPond experiments**: Orthogonal — notation-based music generation via Claude Opus 4.6 and Lyria are complementary approaches (structure vs. generation)

## Recommended Actions
1. Test Lyria 3 via Gemini (already integrated via gemini-cli MCP) — ask it to generate a short track with a specific prompt, check if audio output is supported in the MCP response
2. If audio output isn't MCP-native, evaluate Google AI Studio's web UI for ad-hoc generation
3. Document Lyria access pattern in `experiments/` if Gemini MCP supports audio generation natively
4. Keep Suno for fast consumer-grade prototyping; use Lyria for any game soundtrack pipeline work
