---
date: 2026-05-04
topic: "Look into this for potential integration into Claude code/Hermes/Codex"
discord_message_id: "1500908944497840309"
status: complete
---

# TinyFish.ai — Web Agent Infrastructure Platform

## Topic
"Look into this for potential integration into Claude code/Hermes/Codex — https://www.tinyfish.ai/"

## Key Findings

- **TinyFish is MCP-native** infrastructure providing AI agents live web access via four APIs: Search, Fetch, Agent, and Browser — drops directly into Claude Code as an MCP server
- **Stealth/anti-bot browser** is the standout capability we don't currently have — sub-250ms cold starts, Chromium with anti-detection bypass; Better Playwright is not stealthy and gets blocked by Cloudflare/bot-detection systems
- **89.9% accuracy on Mind2Web** benchmark — leading web agent accuracy, surpasses most open-source alternatives; relevant if we need reliable multi-step web automation beyond Playwright
- **Generous free tier**: search/fetch are free; paid credits only for agent steps (1 credit = 1 step) and browser sessions (1 credit = 4 minutes); 500 free credits on signup — enough for a full evaluation
- **Significant overlap with existing stack**: Brave/Exa/WebFetch already cover ~80% of the search+fetch use case; TinyFish's unique value is stealth browsing and managed multi-step web agent tasks
- **Hermes fit is strong**: Hermes uses its own Chrome CDP browser, which has no anti-bot bypass — TinyFish as an external API call from Hermes would unlock blocked sites without replacing its existing toolset

## Details

### What TinyFish Is

TinyFish positions itself as "the native web layer for AI" — an infrastructure service offering four complementary APIs:

1. **Search** — real-browser-rendered web search returning structured JSON from dynamic pages (including JavaScript-heavy SPAs)
2. **Fetch** — converts any URL to clean markdown, JSON, or HTML via real browser rendering
3. **Agent** — multi-step web automation (navigate, click, fill forms, authenticate)
4. **Browser** — stealth Chromium sessions with anti-bot bypass (sub-250ms cold start)

The platform is MCP-native and works with Claude, Cursor, and other MCP-compatible clients with "zero routing code" — it auto-selects which API to use.

### Overlap Analysis with Existing Workspace Stack

| Use Case | Current Tool | TinyFish | Delta |
|----------|-------------|----------|-------|
| Keyword web search | Brave Search MCP | Search API | Marginal; Brave already strong |
| Semantic search | Exa MCP | Search API | No gain; Exa wins on semantic |
| Page fetch/content extraction | WebFetch (built-in) + Exa crawling | Fetch API | Minor; existing tools sufficient |
| Browser automation (standard) | Better Playwright MCP | Browser/Agent API | Overlap; Better Playwright works fine for non-blocked sites |
| **Stealth/anti-bot browsing** | **Nothing** | **Browser API** | **UNIQUE VALUE — we lack this** |
| Multi-step web agent tasks | Better Playwright + custom agent prompts | Agent API | Managed vs. DIY; TinyFish more reliable |

### Anti-Bot / Stealth Browsing Gap

This is TinyFish's strongest differentiator for the workspace. Better Playwright uses a regular Chrome instance — it gets blocked by Cloudflare, Imperva, and similar bot-detection layers on a significant fraction of sites. This matters for:

- **Discovery/research runs** that hit news sites, Twitter embeds, or SaaS product pages with bot protection
- **<private-project> persona testing** if any third-party integrations have bot-detection
- **Historical nanochat data sourcing** from sites that gate content behind bot detection

### Integration Paths

**For Claude Code (MCP)**: TinyFish is directly MCP-compatible. Adding it as an MCP server would give Claude Code access to all four APIs natively. Given we already have Brave + Exa + WebFetch + Better Playwright, the primary use case would be as a fallback when those fail (blocked sites, dynamic content that WebFetch can't render).

**For Hermes**: Hermes uses its own Chrome CDP browser (`--cdp-url` flag) with no anti-bot capability. The cleanest integration is calling TinyFish's REST API directly from within Hermes tasks via `curl` or the Python SDK — no MCP layer needed, just an API key in Hermes's environment.

**For Codex**: Codex (GPT-5.5) has OpenAI's native web search. TinyFish adds browser agent capability that OpenAI's search tool doesn't provide. Could be called as an external tool if Codex needs to interact with (not just read) a web page.

### Benchmark Credibility

89.9% on Mind2Web is a real and meaningful claim — Mind2Web is a well-established web navigation benchmark using real tasks on 137 websites. For reference, GPT-4V (at benchmark publication time) was ~30-40%. However, benchmarks measure capability ceiling, not everyday reliability, and the specific task distribution matters.

## Relevance to Workspace

- **Immediate gap covered**: stealth browsing is a genuine hole in the current stack
- **Discovery pipeline**: heartbeat runs hitting bot-protected sources would benefit from TinyFish's Browser API as fallback
- **Hermes enhancement**: directly addresses Hermes's weakest point (browser capability limited to unprotected sites)
- **Claude Evolution registry**: belongs under Browser Automation section as a complementary capability to Better Playwright, not a replacement

## Recommended Actions

1. **Add to evaluation pipeline** — create `pipeline/evaluation/pending/tinyfish-browser-mcp.md` and score it (likely 70-75 range given overlap with existing tools but unique anti-bot value)
2. **Pilot with 500 free credits** — test the Browser API specifically against 2-3 sites that Better Playwright currently fails on (e.g., Cloudflare-protected research sites)
3. **Hermes integration if pilot succeeds** — add `TINYFISH_API_KEY` to Hermes environment, use Browser API as fallback when Chrome CDP gets blocked
4. **Register in capabilities registry** under Browser Automation as "PILOT PENDING" to prevent duplicate evaluation
