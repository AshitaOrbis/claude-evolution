# mTarsier — MCP Config Manager Evaluation

- **Date Evaluated**: 2026-03-16
- **Original Discovery**: mtarsier-mcp-config-manager-2026-03-16.json
- **Source**: https://www.openpr.com/news/4425366/mtarsier-launches-free-open-source-tool-to-unify-mcp-server
- **GitHub**: https://github.com/mcp360/mTarsier
- **Decision**: REJECTED

## What It Is

mTarsier (by MCP360, MIT license) is a cross-platform desktop app (Tauri/Rust) released March 16, 2026 for managing MCP server configurations across multiple AI clients from a single interface. Also ships a `tsr` CLI with full feature parity.

**Confirmed capabilities:**
- GUI + CLI (`tsr list`, `tsr install`, `tsr config`, `tsr ping`)
- Cross-platform: macOS, Windows, **Linux** ✓
- Supports 15 clients: Claude Desktop, Claude Code, Cursor, VS Code, Windsurf, ChatGPT Desktop, Codex, Gemini CLI, GitHub Copilot CLI, others
- Auto-detects platform-specific config file locations
- JSON validation and auto-backups before changes
- Team sharing via `.tsr` snapshot files

**Limitations:**
- 10 GitHub stars on launch day (very early stage, high churn risk)
- CLI provides feature parity but no JSON stdout output mode documented
- No library API — only shell subprocess invocation for automation
- v1.0.0 — API stability not established

## Redundancy Check

ADDITIVE (different abstraction layer): Closest existing capabilities are `disabledMcpjsonServers` (settings.json toggle) and `defer_loading` (per-server config). Neither is a unified multi-client GUI manager. But our workflow primarily uses direct JSON editing of `~/.claude.json` — we know exactly where our configs live.

## Scoring

| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|---------|
| Integration complexity | 70 | 20% | 14.0 |
| Token efficiency impact | 50 | 25% | 12.5 |
| Capability expansion | 30 | 25% | 7.5 |
| Maintenance burden | 50 | 15% | 7.5 |
| Community validation | 30 | 15% | 4.5 |
| **Total** | | | **46.0** |

## Scoring Rationale

- **Integration complexity (70)**: `tsr` CLI exists and works. But no JSON output mode means automation requires text parsing — fragile for production use. Shell wrapping is workable but not ideal.
- **Token efficiency (50)**: Neutral.
- **Capability expansion (30)**: Very marginal. We already manage MCP configs via direct `~/.claude.json` editing. The multi-client abstraction would be useful if we managed 5+ AI clients regularly, but our primary client is Claude Code and our config management is already streamlined.
- **Maintenance burden (50)**: External dependency (third-party) with high churn risk at 10 stars. v1.0.0 suggests API instability.
- **Community validation (30)**: 10 stars on launch day. Far below the 100-star minimum for meaningful validation.

## Decision

**REJECTED (46.0)** — Low capability expansion for our workflow (we handle MCP config natively), very early stage (10 stars, v1.0.0), no programmatic API. The `tsr` CLI is promising but too immature for production use.

**Re-evaluation trigger**: When mTarsier reaches 500+ stars OR adds a JSON output mode to `tsr` (enabling reliable automation). At that point, re-evaluate as a potential enhancement to the MCP management playbook.
