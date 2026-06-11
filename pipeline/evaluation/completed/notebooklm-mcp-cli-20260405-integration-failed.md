{
  "title": "NotebookLM MCP Server + CLI (notebooklm-mcp-cli)",
  "source": "https://github.com/jacob-bd/notebooklm-mcp-cli",
  "type": "mcp_server",
  "evaluation_score": 77.5,
  "evaluation_decision": "APPROVED",
  "integration_status": "FAILED",
  "integration_date": "2026-04-05",
  "failure_reason": "npm package not found"
}

## Integration Failure Report (2026-04-05)

**Error**: `npm install -g notebooklm-mcp-cli` → HTTP 404 from npm registry.

### Root Cause

The evaluation file specified `npm install -g notebooklm-mcp-cli` as the install command, likely derived directly from the GitHub repository slug (`jacob-bd/notebooklm-mcp-cli`). This is an AI-generated install instruction that was never verified against the actual npm registry.

**Confirmed non-existent packages:**
- `notebooklm-mcp-cli` — 404
- `@jacob-bd/notebooklm-mcp-cli` — 404

**Related packages that DO exist:**
- `notebooklm-mcp` by pleaseprompto (v1.2.1, 2025-12-27) — DIFFERENT author, different project
- `notebooklm` by kaelenhou (v0.1.1, 2026-01-16) — TypeScript API client, not MCP

### What To Do Next (Re-research Required)

1. **Verify GitHub repo existence**: Check if `https://github.com/jacob-bd/notebooklm-mcp-cli` actually has 3.3k stars as claimed. If the repo is real, find the actual npm package name from its `package.json`.
2. **Alternative**: The repo may install via `npx github:jacob-bd/notebooklm-mcp-cli` or use a different package scope.
3. **Or**: The evaluation may have hallucinated the repo/star count entirely (3.3k stars is notable for a niche tool). Verify the GitHub repo exists before spending more research time.

### Verification Steps for Re-integration

```bash
# Check if repo exists and find correct package name
curl -s https://api.github.com/repos/jacob-bd/notebooklm-mcp-cli | jq '{stars: .stargazers_count, name: .name, description: .description}'

# Find npm package name from repo's package.json
curl -s https://raw.githubusercontent.com/jacob-bd/notebooklm-mcp-cli/main/package.json | jq '.name'
```

### Recommendation

Move to re-research. If GitHub repo confirms the package name, re-queue to integration with corrected install command. If repo doesn't exist or star count is wrong, re-evaluate with corrected data (score may drop below 70 if community_validation was inflated).

**Do NOT install from `notebooklm-mcp` (pleaseprompto)** — different project, different author, not evaluated.
