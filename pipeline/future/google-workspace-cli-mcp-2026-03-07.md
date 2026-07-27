# Future: Google Workspace CLI MCP (`gws`)

**Evaluated**: 2026-03-07 (Score: 74/100 — APPROVED)
**Status**: Deferred — integrate when the revenue pipeline comes back online
**Full evaluation**: `pipeline/evaluation/completed/google-workspace-cli-mcp-server-2026-03-07-evaluated.md`

## Quick Reference

- **Package**: `npm install -g @googleworkspace/cli`
- **GitHub**: https://github.com/googleworkspace/cli
- **Services**: Gmail, Drive, Calendar, Sheets, Docs, Chat, Admin
- **Account**: Personal Gmail works (needs Google Cloud project for OAuth, ~45 min setup)
- **Token efficiency**: Use `--tool-mode compact` (~26 tools vs 200-400)

## Integration Trigger

When the revenue pipeline comes back online:
1. Check if `gws mcp` subcommand has been restored (removed in v0.8.0)
2. If not, pin to v0.7.x: `npm install -g @googleworkspace/cli@0.7`
3. Set up Google Cloud OAuth project
4. Add to `~/.claude.json`:
```json
{
  "mcpServers": {
    "gws": {
      "command": "gws",
      "args": ["mcp", "-s", "gmail,drive,sheets", "--tool-mode", "compact"]
    }
  }
}
```

## Use Cases for the Revenue Pipeline

- Email outreach campaigns (Gmail)
- Customer tracking spreadsheets (Sheets)
- Asset management (Drive)
- Meeting scheduling for client calls (Calendar)
