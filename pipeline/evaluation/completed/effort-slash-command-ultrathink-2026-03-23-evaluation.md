{
  "id": "effort-slash-command-ultrathink-2026-03-23",
  "title": "/effort Slash Command + ultrathink Keyword — Interactive Reasoning Budget",
  "source_url": "https://www.jdhodges.com/blog/how-to-change-claude-code-effort-levels-in-vs-code-effort/",
  "source_url_2": "https://pasqualepillitteri.it/en/news/381/claude-code-march-2026-updates",
  "type": "feature",
  "discovered": "2026-03-23",
  "version_introduced": "v2.1.76 (/effort command); ultrathink keyword (exact version unclear, likely same)",
  "redundancy_status": "IMPROVEMENT",
  "redundancy_comparison": "Registry has 'Effort Controls (API)' (four levels low/medium/high/max, API feature) and 'effort frontmatter' (v2.1.78+, for agent/skill definitions). The /effort slash command and ultrathink keyword are NOT documented in the registry.",
  "description": "Two related features for interactive reasoning budget control in Claude Code sessions: (1) /effort command: type in prompt box to cycle through Low/Medium/High/Max effort levels per session; visible in logo/spinner so you know what effort level is active. (2) ultrathink keyword: per-turn override that bumps effort to High for just the next response, then reverts to session default. The `ultrathink` keyword is a per-prompt escalation; `/effort` is a session-wide setting.",
  "usage": {
    "effort_command": "/effort — cycles Low/Medium/High/Max. Current level shown in spinner.",
    "ultrathink": "Include 'ultrathink' in a prompt to temporarily bump effort to Max for that response only.",
    "works_during_response": "As of v2.1.70, /effort works even while Claude is actively responding."
  },
  "relationship_to_existing": {
    "api_effort_parameter": "API-level parameter for programmatic invocations (heartbeat scripts). Different interface.",
    "effort_frontmatter": "Static declaration in agent/skill definitions. Different interface.",
    "slash_command": "Interactive runtime control for human users. NOT in registry.",
    "ultrathink": "Per-turn keyword override. NOT in registry."
  },
  "evaluation": {
    "date": "2026-03-23",
    "scores": {
      "integration_complexity": 95,
      "token_efficiency": 70,
      "capability_expansion": 60,
      "maintenance_burden": 95,
      "community_validation": 80
    },
    "total": 77.75,
    "decision": "APPROVED",
    "reasoning": "Zero integration cost (built-in feature, registry documentation update only). Fills a genuine documentation gap — three distinct effort interfaces (API param, frontmatter field, /effort slash command) are conflated in the registry's single 'Effort Controls' entry. The ultrathink keyword is entirely absent. Token savings are real: users/agents running simple tasks can drop to Low effort, preserving token budget. Community validation via multiple blog posts documenting both features. Fast-track as registry update.",
    "action": "FAST_TRACK: Update registry Reasoning section to document /effort slash command and ultrathink keyword as distinct interfaces from API effort parameter and effort frontmatter."
  }
}
