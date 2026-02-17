# Source Aggregation Skill

> RSS feeds and search queries for AI capability discovery

## Overview

This skill provides curated RSS feeds, search queries, and aggregation patterns for discovering new Claude Code capabilities, MCP servers, and AI development techniques.

## RSS Feed Registry

### Tier 1: High-Signal AI Engineering (Check Daily)

| Source | Feed URL | Focus |
|--------|----------|-------|
| **Simon Willison** | `https://simonwillison.net/atom/everything/` | LLM tools, Claude, practical AI |
| **Anthropic Engineering** | `https://raw.githubusercontent.com/Olshansk/rss-feeds/refs/heads/main/feeds/feed_anthropic_engineering.xml` | Official Anthropic updates |
| **Normal Tech** | `https://www.normaltech.ai/feed` | Critical AI analysis (Princeton, formerly AI Snake Oil) |

**Note**: Normal Tech feed (formerly AI Snake Oil) is very large. May require RSS MCP with pagination rather than WebFetch.

### Tier 2: Aggregator Newsletters (Check 2-3x/Week)

| Source | Feed URL | Focus |
|--------|----------|-------|
| **The Batch** | `rsshub://deeplearning/the-batch` | Weekly AI news (Andrew Ng) |
| **Ben's Bites** | `https://www.bensbites.com/feed` | AI tools & startups |
| **TLDR AI** | Use web search or `https://tldr.tech/ai` | Daily AI digest |

### Tier 3: Community Sources (Weekly Scan)

| Source | Feed URL | Focus |
|--------|----------|-------|
| **HN AI Posts** | `https://hnrss.org/newest?q=claude+OR+anthropic+OR+mcp` | Hacker News AI discussions |
| **HN Show AI** | `https://hnrss.org/show?q=AI+OR+LLM+OR+agent` | New AI projects |
| **Reddit ClaudeAI** | `rsshub://reddit/subreddit/ClaudeAI` | Community discussions |

## RSSHub Protocol

The RSS MCP supports `rsshub://` URLs which route through RSSHub instances:

```
rsshub://deeplearning/the-batch     → RSSHub The Batch feed
rsshub://reddit/subreddit/ClaudeAI → Reddit r/ClaudeAI
rsshub://github/trending/daily     → GitHub trending
```

## Usage with RSS MCP

### Fetch Single Feed

```
mcp__rss__get_feed
  url: "https://simonwillison.net/atom/everything/"
  count: 5
```

### Fetch RSSHub Feed

```
mcp__rss__get_feed
  url: "rsshub://deeplearning/the-batch"
  count: 10
```

### Fetch All Items

```
mcp__rss__get_feed
  url: "[feed_url]"
  count: 0  # 0 = all items
```

## Discovery Search Queries

### GitHub Searches (via Exa or Web Search)

| Purpose | Query |
|---------|-------|
| New MCP servers | `"mcp server" OR "model context protocol" site:github.com` |
| Claude Code tools | `"claude-code" OR "claude code" plugin site:github.com` |
| AI agent patterns | `"ai agent" "multi-agent" framework 2026` |
| Anthropic official | `site:github.com/anthropics` |

### News Searches (via Brave News)

| Purpose | Query |
|---------|-------|
| Claude updates | `Anthropic Claude announcement` |
| MCP ecosystem | `"model context protocol" OR MCP tools` |
| AI coding tools | `AI coding assistant developer tools` |

## Aggregation Workflow

### Daily Discovery Run

```
1. Fetch Tier 1 feeds (3 sources, ~15 items)
2. Run GitHub search for new MCP servers
3. Run Brave News search for announcements
4. Deduplicate and filter by relevance
5. Create discovery reports for evaluation
```

### Weekly Deep Scan

```
1. Fetch ALL tiers (6+ sources)
2. Use deep_researcher for "Claude Code new capabilities 2026"
3. Check GitHub trending in AI/ML topics
4. Review reddit discussions for pain points
5. Compile weekly discovery report
```

## Feed Health Monitoring

Some feeds may become stale. Check:

| Feed | Health Check | Last Verified |
|------|--------------|---------------|
| Simon Willison | Excellent, daily updates | 2026-01-15 ✅ |
| Anthropic Eng | Good, weekly updates | 2026-01-15 ✅ |
| Normal Tech | Large feed, use RSS MCP | 2026-01-15 ⚠️ |
| Ben's Bites | Excellent, daily updates | 2026-01-15 ✅ |
| GitHub-hosted | May need manual refresh | - |
| RSSHub | Depends on instance availability | - |
| hnrss.org | Very reliable | - |

## Adding New Feeds

When discovering a valuable source:

1. Find RSS/Atom feed URL (check `/feed`, `/rss`, `/atom`)
2. Test with RSS MCP: `get_feed(url, count=3)`
3. Evaluate signal-to-noise ratio
4. Add to appropriate tier in this file

## Alternative: WebFetch for Non-RSS Sources

For sources without RSS:

```
WebFetch
  url: "https://www.anthropic.com/news"
  prompt: "Extract latest announcements and their dates"
```

**Note**: WebFetch works well for most feeds but has limitations:
- Cannot handle very large feeds (>2KB processed content)
- No pagination support
- For production use, configure RSS MCP server

## Integration with Discovery Systems

Discovery automation should:

1. Read this skill for feed URLs
2. Fetch feeds using RSS MCP (or WebFetch as fallback)
3. Extract potential discoveries
4. Run redundancy checking
5. Create discovery reports for novel findings

## Feed URL Quick Reference

```
# Copy-paste ready URLs

# Tier 1 - Daily
https://simonwillison.net/atom/everything/
https://raw.githubusercontent.com/Olshansk/rss-feeds/refs/heads/main/feeds/feed_anthropic_engineering.xml
https://www.normaltech.ai/feed

# Tier 2 - 2-3x/Week
rsshub://deeplearning/the-batch
https://www.bensbites.com/feed

# Tier 3 - Weekly
https://hnrss.org/newest?q=claude+OR+anthropic+OR+mcp
https://hnrss.org/show?q=AI+OR+LLM+OR+agent
rsshub://reddit/subreddit/ClaudeAI
```

## Setup: RSS MCP with Local RSSHub

### Current Configuration

RSS MCP is installed at `~/.claude-mcp-servers/rss-mcp/` with local RSSHub instance.

**Local RSSHub:**
- Location: `~/.claude-mcp-servers/rsshub/`
- Port: `http://localhost:1200`
- Start command: `cd ~/.claude-mcp-servers/rsshub && npx tsx lib/index.ts`

**RSS MCP Config** (in `~/.claude.json`):
```json
"rss": {
  "type": "stdio",
  "command": "node",
  "args": ["~/.claude-mcp-servers/rss-mcp/node_modules/rss-mcp/dist/index.js"],
  "env": {
    "PRIORITY_RSSHUB_INSTANCE": "http://localhost:1200"
  }
}
```

### Starting Local RSSHub

If RSSHub isn't running:
```bash
cd ~/.claude-mcp-servers/rsshub
nohup npx tsx lib/index.ts > rsshub.log 2>&1 &
```

Verify: `curl http://localhost:1200/`

### Benefits over WebFetch
- Proper pagination (count parameter)
- RSSHub protocol support (`rsshub://` URLs)
- Handle large feeds
- Local instance = no timeouts
