# Evaluation: Google Chrome WebMCP Official Browser Standard

- **Date**: 2026-02-23
- **Source**: https://webmcp.link/ + https://venturebeat.com/infrastructure/google-chrome-ships-webmcp-in-early-preview-turning-every-website-into-a + https://www.eweek.com/news/google-webmcp-chrome-ai-web-standard-preview/
- **Category**: technique / browser-automation
- **Automated**: Yes (daily heartbeat)
- **Type**: IMPROVEMENT over existing `Chrome DevTools MCP + WebMCP` (community `@mcp-b/chrome-devtools-mcp` package)

## Scores

| Criterion | Weight | Claude | Codex | Rationale |
|-----------|--------|--------|-------|-----------|
| Integration complexity | 20% | 80 | 70 | Same `navigator.modelContext.registerTool()` API already in use; however Codex notes it's still early preview (Chrome 146 Canary, flag/preview program) — not a pure drop-in yet |
| Token efficiency impact | 25% | 50 | 50 | Neutral; potential savings real only where sites actually expose WebMCP tools |
| Capability expansion | 25% | 70 | 80 | Significant improvement — native browser standard expands beyond our controlled apps; any website can adopt |
| Maintenance burden | 15% | 90 | 70 | Official support reduces third-party package risk, but preview APIs/specs can still change through 2026 |
| Community validation | 15% | 100 | 100 | Official Chrome announcement + W3C standard + `webmachinelearning/webmcp` ~1.6k stars |

- **Claude Score**: 74.5/100
- **Codex Score**: 72.0/100
- **Final Score**: 73.25/100

## Decision

APPROVED — Official W3C browser standard validates and improves our existing implementation; integration action is a registry update + compatibility verification, not a full reimplementation.

## Integration Notes

**Type**: Technique/registry update
**Target**: `registry/existing-capabilities.md` — update `Chrome DevTools MCP + WebMCP` entry

**Actions required:**
1. Update registry entry status to note Chrome 145/146 ships WebMCP natively (early preview)
2. Add note: `@mcp-b/chrome-devtools-mcp` may become optional in Chrome 145+ once stable
3. Verify `@mcp-b/chrome-devtools-mcp` compatibility with native Chrome WebMCP API
4. Track progress toward stable release (currently Canary/flag-gated)

**Key findings from Codex:**
- Chrome DevTools blog post published 2026-02-10: https://developer.chrome.com/blog/webmcp-epp
- GitHub repo: https://github.com/webmachinelearning/webmcp (~1.6k stars)
- Still in early preview program (not stable — spec can change)

**Concerns:**
- Don't migrate away from `@mcp-b/chrome-devtools-mcp` yet — preview APIs unstable
- Monitor for Chrome stable channel release before changing implementation
- WSL port forwarding requirement unchanged regardless of native vs package

**Reconsideration**: Re-evaluate when Chrome WebMCP ships to stable channel (Chrome 148+?).
