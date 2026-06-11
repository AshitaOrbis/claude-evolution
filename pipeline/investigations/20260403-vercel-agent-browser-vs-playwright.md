---
date: 2026-04-03
topic: "How does this stack up to our better-playwright? Sounds like it also does electron apps"
discord_message_id: "1489720155238961303"
status: complete
---

# Vercel Agent-Browser vs Better-Playwright

## Topic
`vercel-labs/agent-browser` — a Rust-based browser automation CLI for AI agents. How does it compare to the current better-playwright MCP setup? Does it support Electron/desktop apps?

## Key Findings
- **agent-browser is browser-only** (Chrome via CDP) — no Electron or native desktop app support. The assumption that it handles Electron apps is incorrect.
- It's a **native Rust CLI binary**, not a Node.js library — minimal startup overhead, no npm dependencies to manage
- The `snapshot` command outputs an **accessibility tree with element references**, explicitly described as "best for AI" — a direct competitor to Playwright's getOutline
- Key advantage: **batch command execution** reduces per-command overhead, which matters for long agentic workflows
- Better-playwright MCP is currently used heavily in the workspace (browser automation for testing, site reviews, adversarial exploration) with 20+ tools and tight Claude Code integration
- **No real advantage over better-playwright** for current use cases — agent-browser is simpler but less capable

## Details

Agent-browser positions itself as a lightweight alternative to Playwright for AI agents: no browser installation management, a fast CLI interface, and accessibility-tree snapshots as the primary AI-readable representation. These are genuine improvements over vanilla Playwright for pure automation tasks.

However, the workspace already uses **better-playwright** which is a purpose-built MCP server wrapping Playwright. It already has the accessibility tree snapshot (`getOutline`), screenshot, click, type, and navigation tools that agent-browser provides. Better-playwright has the additional advantage of being fully integrated into the Claude Code tool system, with session management (`createPage`, `closePage`, `listPages`) and richer tools like `searchSnapshot` for semantic element finding.

Regarding **Electron/ChatGPT desktop app** — this was a misreading of the tool's scope. Agent-browser only controls Chrome. Automating Electron apps requires either Playwright's Electron mode (`playwright.chromium.launch` against an Electron app) or a custom Chromium DevTools Protocol hook. Neither agent-browser nor better-playwright currently support controlling the ChatGPT desktop app this way.

The Rust performance advantage is real but unlikely to matter: the bottleneck in agentic browser workflows is LLM latency between tool calls, not the browser automation library startup time.

## Relevance to Workspace
- **better-playwright MCP** (port 3102, already running): covers all agent-browser's use cases plus more
- **Electron/desktop automation**: not currently possible with either tool; would need Playwright Electron mode or a custom solution
- **Site review / QA workflows**: better-playwright remains the right choice; agent-browser offers nothing new for these use cases

## Recommended Actions
1. **No action needed** — better-playwright already exceeds agent-browser's capabilities for all current use cases
2. If Electron app automation is ever needed (e.g., automating ChatGPT desktop), investigate Playwright's Electron mode separately — neither tool currently supports it
3. Document the Electron automation limitation in `library/techniques/` to prevent re-investigation
