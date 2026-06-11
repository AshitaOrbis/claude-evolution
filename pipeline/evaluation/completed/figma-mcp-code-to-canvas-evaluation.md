# Evaluation: Figma MCP Server (Code to Canvas)

- **Date**: 2026-02-22
- **Source**: https://www.figma.com/blog/the-future-of-design-is-code-and-canvas/
- **Guide**: https://github.com/figma/dev-mode-mcp-server-guide
- **Category**: MCP server
- **Automated**: No (manual evaluation)

## Key Facts (from Codex research)

- **Type**: Official Figma MCP server (remote hosted + desktop in-app server)
- **Guide repo stars**: ~250
- **Direction**: Code → Figma (push AI-generated code into editable Figma layers)
- **Install (remote)**: `claude mcp add --transport http figma https://mcp.figma.com/mcp`
- **Install (desktop)**: `claude mcp add --transport http figma-desktop http://127.0.0.1:3845/mcp`
- **Also available as**: Claude Code plugin (`claude plugin install figma@claude-plugins-official`)
- **Free tier**: Available on all plans including Starter, but limited to 6 tool calls/month
- **Higher tiers**: Pro/Org/Enterprise with Dev/Full seats get higher limits
- **Launched**: Feb 17, 2026 (Anthropic partnership, alongside Claude Sonnet 4.6)

## Scores

| Criterion | Weight | Claude Score | Codex Score | Rationale |
|-----------|--------|-------------|-------------|-----------|
| Integration complexity | 20% | 90 | 100 | Single `claude mcp add` command. Requires Figma account. Very easy but not zero-config (auth needed). |
| Token efficiency impact | 25% | 50 | 50 | MCP overhead for tool schemas. The operation itself (push code to Figma) is capability-focused, not token-saving. Both agree: neutral. |
| Capability expansion | 25% | 75 | 100 | Novel code→Figma workflow. BUT: we don't currently have an active design review workflow with Figma. It's novel in theory but the actual usage gap is speculative. Codex's 100 assumes active Figma use. |
| Maintenance burden | 15% | 95 | 100 | Figma hosts remote MCP — zero maintenance. Desktop server ships in app. Near-zero burden. |
| Community validation | 15% | 85 | 100 | Official Figma + Anthropic partnership is very strong. Guide repo ~250 stars. Not 1k+ but official partnership trumps star count here. |

- **Claude Score**: (90×0.20) + (50×0.25) + (75×0.25) + (95×0.15) + (85×0.15) = 18 + 12.5 + 18.75 + 14.25 + 12.75 = **76.25/100**
- **Codex Score**: (100×0.20) + (50×0.25) + (100×0.25) + (100×0.15) + (100×0.15) = 20 + 12.5 + 25 + 15 + 15 = **87.5/100**
- **Final Score**: Average = **(76.25 + 87.5) / 2 = 81.9/100**

## Score Reconciliation

Codex scored 87.5, Claude 76.25. Key disagreement:
- **Capability expansion**: Codex gave 100 (Novel), Claude gave 75 (Significant improvement). The capability is genuinely novel — no existing Figma integration. But we don't have an active design review workflow that would use this daily. It fills a theoretical gap, not an active workflow pain point. 75 reflects "novel but not immediately impactful for us."

## Decision

**APPROVED** (81.9/100) — Novel design-code bridge with official backing. Adopt when Figma is actively in the workflow.

## Integration Notes

- **Type**: MCP server (remote hosted by Figma)
- **Where**: `claude mcp add` or Claude Code plugin
- **Registry update**: Add to new "Design Tools" section or under "UI Quality & Design"
- **Concerns**:
  - Free tier: 6 calls/month is very restrictive for iterative work
  - Only useful with active Figma usage (<private-project>-v2 has some Figma work)
  - Code→Figma direction only (not bidirectional design sync)
- **Status recommendation**: FUTURE — Approved but adopt when we establish a regular design review workflow in Figma. Similar treatment to Grafana/Terraform MCPs.

## Adoption Triggers

- Regular design→dev→persona test pipeline involving Figma
- <private-project>-v2 UI redesign requiring designer collaboration
- Need for visual QA beyond persona testing (export to Figma for designer review)

## Redundancy Triggers

"figma mcp", "code to canvas", "figma integration", "design handoff mcp", "figma code push", "code to figma", "figma design sync", "figma mcp server"
