# Daily Discovery Heartbeat

Execute these tasks in order. Save structured output for each phase.

## Phase 1: Capability Discovery

Search for new Claude Code capabilities, MCP servers, and workflow patterns.

### Sources to Search

1. **GitHub** (primary): Search for repos with topics `claude-code`, `mcp-server`, `ai-agent`, `claude-sdk` created or updated in the last 7 days
2. **Hacker News**: Search for posts mentioning "Claude Code", "MCP server", "AI agent framework" from the last 3 days
3. **Anthropic**: Check for new engineering blog posts or release announcements

### What to Look For

- New MCP servers that add useful capabilities
- Workflow patterns that improve token efficiency
- New Claude Code features or flags
- Agent orchestration techniques
- Prompt engineering patterns with measurable improvements

### Output Format

For each discovery, save a JSON file to `pipeline/evaluation/pending/`:

```json
{
  "title": "Discovery name",
  "source": "URL or source name",
  "type": "mcp_server | skill | agent | technique",
  "description": "What it does and why it matters",
  "discovered_at": "ISO date",
  "keywords": ["keyword1", "keyword2"]
}
```

### Redundancy Check

Before saving any discovery, check `registry/existing-capabilities.md` for matching keywords.
If a match is found, classify as DUPLICATE (skip) or IMPROVEMENT (save with comparison notes).

## Phase 2: Report

Save a summary report to `pipeline/discovery/daily/YYYYMMDD.md` with:
- Number of sources searched
- Number of discoveries found
- Number of duplicates filtered
- Brief description of each novel discovery

Output a JSON summary as the final line:
```json
{"discovered": 3, "duplicates": 1, "novel": 2}
```
