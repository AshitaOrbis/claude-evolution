# Managed Agents — MCP Tunnels, Self-Hosted Sandboxes, Spill-to-File

**Source**: https://docs.anthropic.com/en/release-notes/overview
**Date**: 2026-06-27 (integrated 2026-07-19; release notes dated 2026-05-19)
**Type**: technique (documentation-only capability record)
**Score**: 82/100 (approved 2026-07-02)

## What the Release Notes Add

Four Managed Agents / API capabilities relevant to this workspace's private-infra and
token-efficiency concerns. Documentation only — nothing here connects any private MCP
server or changes runtime state.

1. **MCP tunnels for private-network servers.** A Managed Agent running in Anthropic's
   cloud can reach an MCP server on a private network through a tunnel — no public
   endpoint, no inbound firewall hole. Relevance: requiem's Tailscale-only servers
   (agent-event-bus on :7777, personal hub) could in principle serve a cloud agent
   without being exposed publicly.
2. **Self-hosted sandboxes.** Managed Agents can execute in a sandbox the operator
   hosts, keeping filesystem and network inside owned infrastructure while Anthropic
   manages the agent loop. Relevance: the containment checklist's "OS sandbox/VM"
   layer, but with the agent harness outsourced.
3. **Active-session MCP/tool configuration updates.** Tool and MCP config can change
   *during* a session rather than only at start. Relevance: long-running orchestrators
   could gain/drop capabilities per phase instead of front-loading every server.
4. **Automatic spill-to-file for tool outputs over 100K tokens.** Oversized tool
   results are written to a file and referenced, not injected into context. Relevance:
   the official server-side twin of the local PostToolUse/context-mode pattern this
   pipeline evaluated for Playwright snapshots and grep dumps.

## How Claude Evolution Could Use This (future experiments)

- **Tunnel experiment**: cloud Managed Agent ↔ tunneled agent-event-bus, measuring
  whether the private event bus can coordinate cloud + local agents. Approval-gated —
  it extends a private server's audience.
- **Spill-to-file expectation**: when designing MCP tools, stop hand-building 100K+
  defenses for surfaces the platform now spills automatically; keep local defenses for
  the sub-100K bloat band the platform ignores.
- **Phase-scoped tooling**: orchestrator plans could declare per-phase MCP needs,
  leaning on mid-session config updates instead of the everything-at-startup pattern.

## Caveats

- All four are Managed-Agents/API-plane features; Claude Code CLI sessions do not get
  them automatically — verify surface-by-surface before assuming parity.
- The tunnel experiment touches private-infrastructure exposure and stays behind the
  usual approval gate.

**Tags**: `managed-agents`, `mcp-tunnels`, `self-hosted-sandbox`, `spill-to-file`,
`dynamic-mcp-config`, `token-efficiency`, `private-network`
