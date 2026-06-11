# Evaluation: Wake MCP - Terminal Session Context

- **Date**: 2026-02-06
- **Source**: https://github.com/joemckenney/wake
- **Category**: MCP
- **License**: MIT
- **Stars**: 68
- **Last Updated**: Jan 31, 2026 (v0.7.0)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 80 | Rust binary with curl installer, `claude mcp add` for registration. Clean setup. |
| Token efficiency impact | 25% | 60 | Eliminates manual copy-paste of terminal output. But queries return history data INTO context, so moderate savings at best. Net: slightly positive. |
| Capability expansion | 25% | 75 | Novel - no existing tool captures persistent terminal session context. Bash tool is one-shot, not session-aware. Useful for debugging sessions where Claude needs to see what was tried. |
| Maintenance burden | 15% | 60 | 68 stars, single maintainer (joemckenney), Rust codebase. Young project (v0.7.0). Active development but not battle-tested. |
| Community validation | 15% | 40 | 68 stars. Featured on HN Show HN. Growing but still small community. |

**Weighted Score**: (80x0.20) + (60x0.25) + (75x0.25) + (60x0.15) + (40x0.15) = 16 + 15 + 18.75 + 9 + 6 = **64.75/100**

## Cross-Validation

- **Claude Assessment**: 64.75/100
- **Codex Assessment**: Unavailable (MCP error)

## Security Concerns

- **CRITICAL**: Captures ALL terminal output including potential secrets (API keys, passwords, connection strings)
- SQLite storage is local (good for privacy) but unencrypted
- No documented filtering mechanism for sensitive data
- `wake shell` wraps the shell in a PTY - could interfere with existing shell hooks/integrations

## Decision

**FUTURE** - Score 64.75, in the 50-69 NEEDS_RESEARCH zone.

**Rationale**: Genuinely novel capability that addresses a real friction point (manual output copying during debugging). However:
1. Security risk from capturing secrets is unresolved
2. Only 68 stars / single maintainer = stability risk
3. Token efficiency is mixed (saves copy-paste but injects history into context)
4. v0.7.0 = pre-1.0, API may change

**Reconsideration Triggers**:
- Project reaches v1.0 with secret-filtering capabilities
- Stars exceed 200+ indicating broader adoption
- Security audit confirms safe data handling
- Documented integration with Claude Code's permission system
