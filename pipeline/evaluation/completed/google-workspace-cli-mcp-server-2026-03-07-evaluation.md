# Evaluation: Google Workspace CLI with Built-in MCP Server

- **Date**: 2026-03-07
- **Source**: https://winbuzzer.com/2026/03/06/google-workspace-cli-mcp-server-ai-agents-xcxwbn/
- **Category**: mcp
- **Automated**: Yes (daily heartbeat)
- **Status**: NEEDS_RESEARCH

## Redundancy Check

Registry search: "google workspace", "gmail mcp", "google drive mcp", "google calendar mcp", "google docs mcp" — **no matches**. Classification: **NOVEL**.

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Medium-hard: install path unclear (gcloud SDK vs. separate CLI?), gcloud auth setup required, potential paid Workspace subscription requirement — cannot confirm from secondary source |
| Token efficiency impact | 25% | 50 | Unknown: likely more efficient than Playwright for Workspace tasks, but no data; neutral assumption |
| Capability expansion | 25% | 100 | NOVEL: entire Gmail/Drive/Calendar/Docs/Sheets API surface currently unavailable; significant capability gap filled |
| Maintenance burden | 15% | 70 | Official Google project (strong signal), but Google has documented deprecation history for CLI tools; occasional updates expected |
| Community validation | 15% | 60 | Official Google product (high credibility) but source is secondary news article (WinBuzzer); actual GitHub repo/npm package unconfirmed; actual install command unknown |

- **Claude Score**: 67/100
- **Codex Score**: N/A (skipped)
- **Final Score**: 67/100

## Decision

NEEDS_RESEARCH — Capability expansion is genuinely novel and high-value (100/100), but integration complexity is unclear due to unconfirmed package identity and account requirements. Score of 67 puts it in research range.

## Research Questions

1. **Package identity**: Is this `google-workspace-cli` npm package, part of `gcloud` SDK, or a separate product? What is the exact install command?
2. **Account requirement**: Requires paid Google Workspace subscription, or works with personal Gmail/Google account?
3. **GitHub/docs URL**: What is the official repository or documentation page? (Not the WinBuzzer article)
4. **Token efficiency**: Any benchmarks vs. Playwright-based Workspace access for typical tasks (email search, Drive read)?
5. **`--sanitize` latency**: Does Model Armor sanitization add meaningful latency to Workspace API calls?

## Reconsideration Triggers

- If confirmed to work with personal Google accounts: integration complexity drops → score likely 75+
- If official GitHub repo found with install docs: integration complexity confirmed → likely proceed to full approval
- If requires paid enterprise subscription: score drops to <50 (same as Claude Code Security enterprise-only rejection pattern)
