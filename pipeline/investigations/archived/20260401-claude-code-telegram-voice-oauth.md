---
date: 2026-04-01
topic: "claude-code-telegram for voice assistant + OAuth switching implications"
discord_message_id: "1488980874405085325"
status: complete
---

# claude-code-telegram: Voice Assistant Fit & OAuth Switching Risks

## Topic

> https://github.com/RichardAtCT/claude-code-telegram
>
> Not sure if this can be applied to our attempts to do a voice assistant to Claude code. Also would be worth looking into a setup like this that could work if we switch Oauths in Claude Code (presumably that'd make Claude remote control stop working?)

## Key Findings

- **claude-code-telegram** provides Telegram-based remote access to Claude Code with voice message transcription via Mistral Voxtral, OpenAI Whisper, or local whisper.cpp — directly relevant to voice → Claude Code workflows
- **We already have `experiments/voice-assistant/`** (Android APK client + voices.json config) — this is a mobile voice interface that likely covers different ground than Telegram-based transcription
- **Architecture overlap**: discord-claude-bot already handles text-based remote access via Discord; Telegram would add a parallel channel with native voice note support that Discord's bot interface lacks
- **OAuth/auth separation**: claude-code-telegram SDK mode uses `ANTHROPIC_API_KEY` (not OAuth); CLI mode inherits system Claude auth. Switching Claude OAuth would break CLI mode for all remote tools until re-auth, but SDK mode is unaffected
- **The Max plan constraint is key**: Our setup uses Max plan (no `ANTHROPIC_API_KEY`), which means `claude -p` CLI mode — OAuth-dependent. Switching accounts breaks remote control until `claude auth login` is re-run
- **Built-in voice mode** (Claude Code `/voice`, March 2026 discovery) makes some voice use cases redundant; its ~5% rollout is narrowing the gap

## Details

**What claude-code-telegram does well that Discord doesn't:**
Telegram natively supports voice notes as first-class messages — users can record and send audio directly in-app. The bot auto-transcribes these via configurable STT backends (Voxtral, Whisper, local). Discord's bot API treats voice differently and doesn't have the same send-a-voice-note UX. If the voice assistant goal is "talk to Claude Code from phone," Telegram is a more natural channel than Discord for that specific flow.

**Relationship to existing voice-assistant project:**
The `experiments/voice-assistant/` directory contains an Android APK and voices.json, suggesting an existing custom mobile client. That project likely targets a standalone app experience. claude-code-telegram would be a different approach — leverage Telegram as the UI layer rather than building a bespoke app. The Telegram approach is lower-maintenance (Telegram handles push notifications, background audio, cross-device sync) but requires Telegram as a dependency.

**The OAuth switching question:**
Claude Code on Max plan authenticates via OAuth to claude.ai (not an API key). All `claude` CLI invocations — including `claude -p` used in the discord-claude-bot and any CLI-mode remote tool — inherit this system-level session. If the OAuth is switched (different account login), the session token changes and any process that called `claude auth status` or spawned `claude -p` would fail with auth errors. Re-running `claude auth login` would restore function, but it's a manual step. **The discord-claude-bot remote control would stop working during the window between account switch and re-auth.** SDK mode (API key) for claude-code-telegram would be unaffected, but we're on Max, not API.

**Practical implication for account switching:**
If a second Claude account is ever needed (e.g., testing, separate project isolation), the cleanest approach is environment-level separation: different shell sessions or Docker containers with different `~/.claude/` directories, not switching the system-level auth. The workspace's existing direnv pattern for GitHub account sandboxing (revenue/ vs applications/) could be adapted for Claude auth isolation.

## Relevance to Workspace

- **discord-claude-bot**: Already handles remote Claude Code access via Discord. Adding Telegram would be additive — useful if Telegram is more natural for mobile voice workflows, redundant otherwise.
- **experiments/voice-assistant**: The existing project's APK-based approach and claude-code-telegram's Telegram-based approach are complementary rather than competing — different deployment targets.
- **discoveries/pending/voice-mode-march-2026.md**: Native `/voice` mode in Claude Code is the zero-dependency path; worth waiting on broader rollout before building third-party voice pipelines.
- **Max plan constraint**: SDK mode (API key) is unavailable; any integration must use CLI mode and accept OAuth dependency.

## Recommended Actions

1. **Defer full integration** — native `/voice` mode in Claude Code (pending broader rollout) would satisfy the core use case without adding Telegram as infrastructure
2. **Document whisper.cpp option** — local STT backend in claude-code-telegram is the most relevant piece for offline/private voice transcription; extract this technique independently of the Telegram bot
3. **Add auth-separation note to CLAUDE.md** — document that switching Claude OAuth breaks all `claude -p` remote tools and that direnv-style isolation is the safe alternative if multi-account setups are ever needed
4. **Evaluate as Telegram-specific feature** — if there's genuine demand for a Telegram-Claude interface (separate from Discord), the repo is ready to fork; evaluate against the cost of maintaining two remote-control channels
