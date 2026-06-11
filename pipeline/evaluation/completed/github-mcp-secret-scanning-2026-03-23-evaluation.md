{
  "id": "github-mcp-secret-scanning-2026-03-23",
  "title": "GitHub MCP Server — Secret Scanning for AI Coding Agents",
  "source_url": "https://github.blog/changelog/2026-03-17-secret-scanning-in-ai-coding-agents-via-the-github-mcp-server/",
  "type": "feature",
  "discovered": "2026-03-23",
  "redundancy_status": "IMPROVEMENT",
  "redundancy_comparison": "Semgrep MCP (in registry) provides real-time SAST + secrets detection DURING code generation. This adds GitHub's native scanner for PRE-COMMIT/PRE-PR checks. Different scope and trigger. Also: GitHub MCP itself is currently FUTURE/deferred in registry.",
  "description": "The official GitHub MCP Server now includes a secret scanning tool that checks code changes for exposed credentials before committing or opening a PR. Uses GitHub's pattern library (160+ detectors, 28 new in March 2026 including Lark, Vercel, Snowflake, Supabase). Integrates directly into the AI coding workflow when GitHub MCP is in use.",
  "announcement_date": "2026-03-17",
  "pattern_updates": "28 new detectors from 15 providers (March 2026). 39 detectors now have push protection enabled by default including Airtable, Databricks, Heroku, PostHog, Shopify.",
  "registry_context": "GitHub MCP (official, 26.7k stars) is in FUTURE status in the registry as of 2026-03-19 evaluation. The adoption triggers were: GitHub Projects usage, gh CLI pain points, or enterprise OAuth need. This feature strengthens the security argument for eventual adoption.",
  "evaluation": {
    "date": "2026-03-23",
    "scores": {
      "integration_complexity": 100,
      "token_efficiency": 50,
      "capability_expansion": 35,
      "maintenance_burden": 100,
      "community_validation": 100
    },
    "total": 71.25,
    "decision": "APPROVED",
    "reasoning": "Zero integration cost — this is a registry annotation update only. Official GitHub changelog announcement with 160+ detection patterns is high community validation. Capability expansion is limited because (1) GitHub MCP itself is deferred and (2) Semgrep already covers secrets detection during code generation. The value is informational: it strengthens the security case for GitHub MCP adoption when the existing triggers are met. Action: update the GitHub MCP FUTURE registry entry to note secret scanning as an additional value-add feature.",
    "action": "Registry annotation only — update GitHub MCP FUTURE entry in registry/existing-capabilities.md to note secret scanning capability."
  }
}
