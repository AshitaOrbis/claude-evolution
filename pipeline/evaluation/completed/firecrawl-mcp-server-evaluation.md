# Evaluation: Firecrawl MCP Server

- **Date**: 2026-03-01
- **Evaluator**: Claude Opus 4.6 + Codex GPT-5 cross-validation
- **Source**: https://github.com/mendableai/firecrawl (~66k stars)
- **MCP Package**: `firecrawl-mcp` (via npx)
- **Category**: MCP Server (Web scraping / content extraction)

## Redundancy Check

| Match Type | Result |
|------------|--------|
| WebFetch | PARTIAL — single URL extraction overlaps |
| `mcp__exa__crawling_exa` | PARTIAL — single URL content extraction overlaps |
| Brave/Exa search | PARTIAL — search capability overlaps |
| Multi-page crawl | **NOVEL** — no existing capability |
| Structured JSON extraction | **NOVEL** — no existing capability |
| Sitemap/URL discovery | **NOVEL** — no existing capability |

**Classification**: IMPROVEMENT (extends web content capabilities with novel crawl/extract)

## Scoring

| Criterion | Weight | Claude Score | Codex Score | Final | Rationale |
|-----------|--------|-------------|-------------|-------|-----------|
| Integration complexity | 20% | 82 | 90 | 82 | Cloud: easy (`npx -y firecrawl-mcp` + API key). Self-host: feasible but adds Docker ops. |
| Token efficiency impact | 25% | 70 | 75 | 70 | Clean markdown output reduces post-processing. Risk: crawl payloads can be very large. |
| Capability expansion | 25% | 82 | 85 | 82 | Multi-page crawl, sitemap mapping, and JSON schema extraction are genuinely novel. |
| Maintenance burden | 15% | 80 | 80 | 80 | Active development, SOC 2, Vercel-backed. Cloud = zero ops. |
| Community validation | 15% | 100 | 100 | 100 | ~66k stars (corrected from discovery's 85k claim). Top-tier. |

**Final Score: 81.4/100**

## Cross-Validation Notes

- **Stars correction**: Discovery listed 85k; Codex verified ~66k for core repo, ~5.6k for MCP repo. Score unchanged (still far exceeds 1k threshold).
- **Package name correction**: Install is `npx -y firecrawl-mcp` (no @mendable scope).
- **Token risk flagged**: `firecrawl_crawl` can return massive payloads. Prefer `firecrawl_map` + selective `firecrawl_scrape` for controlled extraction.
- **Codex scored higher** on integration (90 vs 82) and token efficiency (75 vs 70). Reconciled conservatively given self-hosting complexity and crawl payload risk.

## Decision: APPROVE (81.4/100)

Move to `pipeline/integration/` for integration.

## Integration Guidance

### Recommended Configuration

```bash
# Cloud (requires FIRECRAWL_API_KEY)
claude mcp add --transport stdio firecrawl -- npx -y firecrawl-mcp

# Self-hosted (free, no API key)
# Requires Docker: docker compose up -d (from firecrawl repo)
# Set FIRECRAWL_URL=http://localhost:3002
```

### Integration Targets

| Target | Action |
|--------|--------|
| `~/.claude.json` | Add firecrawl MCP server config |
| `registry/existing-capabilities.md` | Add entry under Web Content section |
| `~/.claude/skills/mcp-search-framework/SKILL.md` | Add firecrawl to decision tree for crawl/extract use cases |
| `helpers/navigation/mcp-inventory.md` | Add server to inventory |

### Usage Patterns

| Use Case | Tool | Notes |
|----------|------|-------|
| Single URL content | `firecrawl_scrape` or existing WebFetch | Use existing for simple cases |
| Multi-page documentation | `firecrawl_map` → selective `firecrawl_scrape` | Map first, then scrape specific pages |
| Structured data extraction | `firecrawl_extract` with JSON schema | Novel — define schema for consistent output |
| Site discovery | `firecrawl_map` | Novel — enumerate all URLs on a domain |

### Cost Policy

- Prefer self-hosted for high-volume crawls
- Cloud API for occasional single-page extraction
- Monitor API usage if using cloud tier

## Redundancy Triggers

"firecrawl", "web scraping mcp", "site crawler mcp", "multi-page crawl", "structured extraction mcp",
"firecrawl_scrape", "firecrawl_crawl", "LLM-ready web content", "web to markdown mcp",
"site mapping mcp", "firecrawl_map", "firecrawl_extract", "json schema extraction mcp"
