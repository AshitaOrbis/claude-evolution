# Evaluation: Context Hub (andrewyng)

- **Date**: 2026-03-11
- **Source**: https://github.com/andrewyng/context-hub
- **Category**: Documentation / API Context Management
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | One npm install. Ships a `SKILL.md` for Claude Code: `cp $(npm root -g)/@aisuite/chub/skills/get-api-docs/SKILL.md ~/.claude/skills/get-api-docs.md`. Trivially adoptable |
| Token efficiency impact | 25% | 85 | Curated docs, language/version targeting, incremental fetch (`--file`), local caching, and agent annotations materially reduce web search and oversized context pulls |
| Capability expansion | 25% | 85 | Novel: curated versioned API docs + agent-writable annotations. Solves real problem (agents using outdated APIs). Agents can persist workarounds across sessions |
| Maintenance burden | 15% | 75 | Community-maintained markdown. Early stage (v0.1.1, launched March 5 2026) with some open issues, but Andrew Ng's team + community governance lowers internal burden |
| Community validation | 15% | 87 | 3,900 stars, 384 forks, ~1,400 weekly npm downloads as of 2026-03-11. Official launch by Andrew Ng (deeplearning.ai founder) |

- **Claude Score**: 88/100
- **Codex Score**: 83/100
- **Final Score**: 85.5/100

## Decision

APPROVED — High-impact, low-friction integration. Solves the outdated-API-docs problem with an easy CLI install and a pre-built Claude Code SKILL.md. Strong community validation from Andrew Ng's backing and rapid early adoption.

## Integration Notes

**Integration type**: MCP-adjacent skill installation

**Steps**:
1. `npm install -g @aisuite/chub`
2. Copy the skill: `cp $(npm root -g)/@aisuite/chub/skills/get-api-docs/SKILL.md ~/.claude/skills/get-api-docs.md`
3. Test with `chub search openai` and `chub get openai/chat --lang ts`
4. Update `registry/existing-capabilities.md` with Context Hub entry

**Pilot mode recommendation** (per Codex review): Use as optional context-enrichment tool, not a hard dependency. Content governance is still maturing (v0.1.1). Monitor for stability over the next 30 days before promoting to mandatory workflow.

**Concerns**:
- Early-stage v0.1.1 — some search/version-awareness gaps per open issues
- Content quality depends on community contributions
- Should not be sole source of truth for API docs
