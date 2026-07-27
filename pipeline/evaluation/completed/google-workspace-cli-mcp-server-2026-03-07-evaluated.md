# Discovery: Google Workspace CLI with Built-in MCP Server

- **Source**: https://github.com/googleworkspace/cli | https://winbuzzer.com/2026/03/06/google-workspace-cli-mcp-server-ai-agents-xcxwbn/
- **Date Found**: 2026-03-07
- **Date Evaluated**: 2026-03-07
- **Category**: mcp
- **Summary**: Google's official Workspace CLI (`gws`, npm `@googleworkspace/cli`) exposes full Workspace API surface (Gmail, Drive, Calendar, Docs, Sheets, Chat, Admin) via MCP. Includes prompt injection defense via `--sanitize` (Google Cloud Model Armor) and compact tool mode (~26 tools vs 200-400).
- **Score**: 74/100 (APPROVED — deferred to the revenue pipeline's revival)
- **Status**: FUTURE — integrate when revenue pipeline comes back online

## Research Answers (2026-03-07)

### 1. Package Identity
- **Package**: `@googleworkspace/cli` (npm)
- **Install**: `npm install -g @googleworkspace/cli`
- **GitHub**: https://github.com/googleworkspace/cli
- Written in Rust, distributed as pre-compiled binary via npm
- NOT part of gcloud SDK — separate tool

### 2. Account Requirements
- **Personal Gmail accounts work** — no paid Workspace subscription required
- **Requires**: Google Cloud project for OAuth credentials (~45 min setup)
- Unverified Cloud projects limited to ~25 OAuth scopes
- Advanced Protection users blocked from personally-owned OAuth apps

### 3. MCP Status (CRITICAL CAVEAT)
- **v0.5.0**: Added `--tool-mode compact|full` and `-s` service selector
- **v0.7.x**: Full MCP support via `gws mcp -s drive,gmail,calendar`
- **v0.8.0 (March 7, 2026)**: `mcp` subcommand REMOVED — no explanation in release notes
- Possible replacement: `--transport streamable-http` mentioned in some guides
- **Recommendation**: Pin to v0.7.x for stdio transport, or wait for v0.8.x clarification

### 4. Tool Surface
| Service | Operations |
|---------|-----------|
| Gmail | Search, read, send, drafts, labels |
| Drive | List, search, create, update, delete files/folders/permissions |
| Calendar | List/create/modify events, availability |
| Sheets | Range reads/writes, formula preservation |
| Docs | Create, text insertion, formatting |
| Chat | Messaging |
| Admin | Scope-restricted admin APIs |

**Compact mode** (`--tool-mode compact`): Reduces 200-400 tools → ~26 meta-tools + `gws_discover`. Critical for Claude Code token efficiency.

### 5. Sanitization (Model Armor)
- `--sanitize "projects/P/locations/L/templates/T"` flag
- Scans API responses for prompt injection before they reach the agent
- `GOOGLE_WORKSPACE_CLI_SANITIZE_MODE`: `warn` (default) or `block`
- Latency: unbenched, but adds a cloud API round-trip (~50-200ms estimated)

### 6. Claude Code Configuration (pre-v0.8.0)
```json
{
  "mcpServers": {
    "gws": {
      "command": "gws",
      "args": ["mcp", "-s", "drive,gmail,calendar,sheets,docs", "--tool-mode", "compact"]
    }
  }
}
```

## Scoring

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 60 | OAuth setup is non-trivial (~45 min); v0.8.0 removed MCP command |
| Token efficiency | 25% | 85 | Compact mode (~26 tools); structured API > browser automation |
| Capability expansion | 25% | 90 | NOVEL — fills Gmail/Drive/Calendar/Sheets gap completely |
| Maintenance burden | 15% | 80 | Official Google project, pre-v1.0 with breaking changes expected |
| Community validation | 15% | 60 | New project (March 2026), HN coverage, some OAuth friction reported |

**Weighted Score**: 0.20×60 + 0.25×85 + 0.25×90 + 0.15×80 + 0.15×60 = 12 + 21.25 + 22.5 + 12 + 9 = **76.75** → rounded to **74** (penalty for v0.8.0 MCP removal uncertainty)

## Decision: APPROVED — FUTURE

**Why not integrate now**: v0.8.0 removed the `mcp` subcommand, creating uncertainty. Also, no active Workspace workflows in current projects. The revenue pipeline is mothballed.

**When to integrate**: When the revenue pipeline comes back online OR when v0.8.x restores MCP support.

**Integration trigger**: Revenue pipeline reactivation → check `gws` MCP status → install v0.7.x or latest with MCP → add to `~/.claude.json`

## Disambiguation

| Project | Relationship |
|---------|-------------|
| `googleworkspace/cli` (`gws`) | Official Google CLI — THIS discovery |
| `taylorwilsdon/google_workspace_mcp` | Third-party Python MCP server (separate) |
| A2A protocol | Agent-to-agent interop (different layer) |
| Google Agentspace | Enterprise agent platform (separate product) |
| `gemini-cli-extensions/workspace` | Gemini CLI companion extension |
