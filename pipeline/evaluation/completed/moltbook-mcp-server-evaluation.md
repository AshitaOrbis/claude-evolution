# Evaluation: MoltBook MCP Server

- **Date**: 2026-02-06
- **Source**: https://github.com/punkpeye/awesome-mcp-servers/issues/1802
- **Category**: mcp
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 30 | No actual repository found - only an issue reference in awesome-mcp-servers |
| Token efficiency impact | 25% | 55 | Would be lower overhead than OpenClaw Docker approach |
| Capability expansion | 25% | 25 | Redundant with existing OpenClaw integration for MoltBook access |
| Maintenance burden | 15% | 20 | No repo to evaluate, unknown developer, social network content = security risk |
| Community validation | 15% | 15 | GitHub issue only, no actual repo, no stars, no documentation |

- **Claude Score**: 32.5/100
- **Codex Score**: N/A (clear rejection)
- **Final Score**: 32.5/100

## Decision

**REJECTED** - No actual repository exists (only a GitHub issue reference). Redundant with existing OpenClaw integration which provides superior security isolation.

## Rejection Rationale

1. **No repository**: Source is just a GitHub issue in awesome-mcp-servers, not an actual MCP server
2. **Security concerns**: Direct MCP access to social network content in main context lacks OpenClaw's sandbox isolation
3. **Redundancy**: OpenClaw integration already provides MoltBook access with Docker sandbox + output validation
4. **Trust model mismatch**: MoltBook content is untrusted; OpenClaw's isolated agent model is appropriate

## Reconsideration Trigger

- If an actual repo appears with documented security model and content validation
- If OpenClaw integration proves too heavyweight for frequent MoltBook access
