{
  "title": "NotebookLM MCP Server + CLI (notebooklm-mcp-cli)",
  "source": "https://github.com/jacob-bd/notebooklm-mcp-cli",
  "type": "mcp_server",
  "description": "Unified package providing both a CLI ('nlm') and MCP server ('notebooklm-mcp') for Google NotebookLM. Enables Claude Code to create and query NotebookLM notebooks programmatically — uploading documents, generating summaries, extracting citations, and asking questions against a source-grounded knowledge base. Auto-configures via 'nlm setup add claude-code'. Particularly relevant for research-heavy workflows where NotebookLM's grounded Q&A complements Claude's reasoning. Completely refactored in January 2026.",
  "discovered_at": "2026-04-05",
  "keywords": ["notebooklm", "google", "mcp", "research", "knowledge-base", "notebooks", "citations", "documents", "grounded-QA", "RAG", "document-upload"]
}

## Redundancy Check

- Not present in registry (no "notebooklm" entry).
- Closest existing capability: Exa deep_researcher (web-based RAG) and WebFetch (single URL). Neither provides persistent source-grounded notebook management.
- Classification: **NOVEL** — new capability category (document notebook management with grounded Q&A).

## Evaluation Notes

**Value proposition**: NotebookLM's core differentiator is source-grounded citations — it only answers from uploaded documents and cites exact passages. This is orthogonal to what Exa/Brave provide (open web search). Useful for:
- Uploading research papers and querying against them during genealogy research
- Building persistent knowledge bases per project (the finance app docs, blog research, etc.)
- Source-grounded citation extraction for Ashita Orbis posts

**Risk factors**:
- Uses unofficial Google API (Playwright-based automation of NotebookLM UI, likely)
- May break on UI changes (low maintainability score)
- Requires Google account with NotebookLM access
- 54 stars at discovery time (low community validation)

**Preliminary score estimate**: 55-65/100 (low stars + unofficial API offset by unique capability gap)

**Recommended action**: Full evaluation. Focus on: (1) Is it Playwright-based or real API? (2) Maintenance history (commits, issues). (3) Does it duplicate research capabilities Exa already covers?

---

## Evaluation (2026-04-05)

**Verified facts** (web research, 2026-04-05):
- Uses **undocumented internal Google APIs** (not Playwright, not official API). Auth via `nlm login` session credential.
- **3.3k stars** (actively climbing as of evaluation date)
- **Very active**: latest commit April 4, 2026 (v0.5.16); multiple releases/week
- **3 open issues** — maintainer fixed an internal API break (RPCError code 3) within 4 days
- **First-class Claude Code support**: `nlm setup add claude-code` auto-configures
- Session expiry requires periodic `nlm login` re-auth

```json
{
  "evaluation": {
    "scores": {
      "integration_complexity": 70,
      "token_efficiency": 70,
      "capability_expansion": 100,
      "maintenance_burden": 50,
      "community_validation": 90
    },
    "total": 77.5,
    "decision": "APPROVED",
    "reasoning": "Genuinely novel capability — persistent source-grounded notebooks with citation extraction, not covered by any existing capability (Exa provides open web search, not document-grounded Q&A). 3.3k stars and active maintenance (multiple releases/week, 4-day API break fix) upgrade from the discovery's 55-65 estimate. Key risk is undocumented internal Google API with periodic breakage expected, offset by highly responsive maintainer. Token efficiency scored minor savings (70) because document-heavy workflows (genealogy research, blog research) avoid pasting full document content into context. Primary integration path: install nlm package, run 'nlm setup add claude-code', add to known MCPs in registry. Periodic re-login overhead is acceptable for interactive sessions; not suitable for headless cron use without WSL/headless auth workaround (issue #127 open)."
  }
}
```

## Integration Instructions

1. Install: `npm install -g notebooklm-mcp-cli`
2. Authenticate: `nlm login` (opens browser for Google auth)
3. Configure: `nlm setup add claude-code` (auto-writes to Claude Code MCP config)
4. Verify: `nlm notebooks list` should return existing notebooks
5. Add to registry under new "Document Knowledge Base" capability category
6. Note: Re-run `nlm login` when session expires (periodic maintenance)
