# Discovery: /team-onboarding Command

**Source**: Claude Code v2.1.101 changelog (April 10, 2026)
**Discovered**: 2026-04-11
**Moved to future**: 2026-04-11 (current version v2.1.96; requires v2.1.101)
**Type**: Built-in Claude Code slash command (native, no MCP)

---

## What Is It?

A new built-in slash command `/team-onboarding` that **generates a teammate ramp-up guide from your local Claude Code usage patterns**.

The changelog states: "Added `/team-onboarding` command to generate a teammate ramp-up guide from your local Claude Code usage."

---

## Why It Matters

Current gap: When onboarding a new contributor to a project that heavily uses Claude Code, there's no structured way to communicate the local Claude Code setup, workflows, conventions, and non-obvious patterns. Typical approach is manual documentation in CLAUDE.md files.

`/team-onboarding` appears to analyze actual local usage (session transcripts, hooks, skills, CLAUDE.md hierarchy) and synthesize a human-readable ramp-up guide tailored to the specific project's patterns.

**Potential use cases**:
1. **claude-evolution project**: Generate a guide covering evolution pipeline, subagent patterns, hook integrations
2. **The finance app**: Generate a guide covering AWS deployment, PostgreSQL, iterative-improve workflow
3. **Workspace-wide**: Generate a high-level guide for any new device/session context

---

## Evaluation

```json
{
  "scores": {
    "integration_complexity": 95,
    "token_efficiency": 50,
    "capability_expansion": 65,
    "maintenance_burden": 95,
    "community_validation": 90
  },
  "total": 74.25,
  "decision": "APPROVED",
  "reasoning": "Official Anthropic feature (v2.1.101). Zero install complexity, zero maintenance. Capability expansion is moderate (65) because this is primarily a solo project and team onboarding need is low-frequency. Token efficiency is neutral (50) — analysis-heavy command but not used in automated loops. The novel capability is auto-generating human-readable contributor guides from actual usage data rather than manually maintained CLAUDE.md."
}
```

## Redundancy Check

| Existing Capability | Overlap | Assessment |
|---------------------|---------|------------|
| CLAUDE.md hierarchy | Manual onboarding docs | `/team-onboarding` auto-generates what CLAUDE.md files describe manually |
| `workspace-assessment` skill | Workspace state overview | Different scope: assessment is for task planning; onboarding is for new contributors |
| `context-librarian` subagent | Archives conversation insights | Different: librarian archives insights; team-onboarding generates human-facing guides |

**Verdict**: NOVEL — no equivalent auto-generation of human-readable contributor guides exists.

---

## Action When Available

After upgrading to v2.1.101+:
1. Run `/team-onboarding` in claude-evolution directory
2. Examine output format and data sources
3. Assess whether output is useful vs reading CLAUDE.md directly
4. Note token cost of analysis
5. Move to integration or completed accordingly

---

## Questions to Investigate on Activation

1. What data sources does it analyze? (Session transcripts? CLAUDE.md? hooks? git history?)
2. Output format — Markdown document? Inline response? Saved file?
3. Does it work per-project (cwd) or workspace-wide?
4. Privacy implications — does it include session transcript content?
