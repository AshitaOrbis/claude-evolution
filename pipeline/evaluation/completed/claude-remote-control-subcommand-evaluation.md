# Evaluation: `claude remote-control` Subcommand

- **Date**: 2026-02-24
- **Source**: Claude Code v2.1.51 official release
- **Category**: CLI Features / Automation
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 0 | Enterprise-gated: `claude remote-control --help` returns "Remote Control is not enabled for your account. Contact your administrator." Cannot integrate without admin enablement — same blocker as Claude Code Security (enterprise-only). |
| Token efficiency impact | 25% | 50 | Neutral — affects session management, not token usage. |
| Capability expansion | 25% | 20 | High theoretical capability (persistent session control, Discord integration) but zero practical expansion given account restriction. |
| Maintenance burden | 15% | 100 | Official Anthropic feature; if accessible, zero additional maintenance. |
| Community validation | 15% | 85 | Official Anthropic release in v2.1.51 (installed as v2.1.52). |

- **Claude Score**: 45.25/100
- **Codex Score**: N/A (skipped — enterprise gate is determinative)
- **Final Score**: 45.25/100

## Decision

REJECTED — Enterprise-gated feature: `claude remote-control` returns "Contact your administrator" error on current account. Functionally inaccessible, same pattern as Claude Code Security rejection (47.5/100, 2026-02-21).

## Integration Notes

- Rejected due to account-level access restriction, not technical merit
- **Reconsideration trigger**: If account is upgraded to enterprise plan with admin access, re-evaluate — theoretical capability is high (75–85/100 range)
- **Monitor**: Track if Anthropic extends remote-control to Pro/Max plans in future releases
- Feature remains interesting for: stateful session management, Discord bot integration, CI/CD pipeline control
