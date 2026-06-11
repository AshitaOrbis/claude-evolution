# Evaluation: websocat-mcp - WebSocket Operations MCP Server

- **Date**: 2026-02-06
- **Source**: https://github.com/shivam-jainn/websocat-mcp
- **Category**: mcp
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 60 | Requires Bun runtime dependency, git clone + build |
| Token efficiency impact | 25% | 30 | Adds MCP tool tokens; Bash `websocat` CLI achieves same at zero token cost |
| Capability expansion | 25% | 45 | WebSocket is novel but rarely needed; Bash alternative exists |
| Maintenance burden | 15% | 30 | New/small repo, Bun dependency, unknown maintenance trajectory |
| Community validation | 15% | 20 | Unknown star count, appears very new (2026), single developer |

- **Claude Score**: 37.5/100
- **Codex Score**: N/A (clear rejection)
- **Final Score**: 37.5/100

## Decision

**REJECTED** - Bash `websocat` CLI provides identical WebSocket functionality at zero token cost. MCP wrapper adds overhead without value.

## Rejection Rationale

1. **Anti-pattern match**: "MCP wrappers of CLI tools" pattern from registry (<25 score expected)
2. **Zero-token alternative**: `websocat` CLI via Bash tool provides connect/send/receive/manage with no MCP overhead
3. **Low use frequency**: WebSocket operations are rare in our workflows
4. **Bun dependency**: Additional runtime requirement for marginal tool
5. **Low community validation**: New repo with unknown adoption

## Alternative

```bash
# Zero-token WebSocket via Bash
websocat ws://example.com/socket
echo "message" | websocat ws://example.com/socket
```
