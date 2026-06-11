# Discovery: Smithery CLI

- **Source**: https://www.npmjs.com/package/@smithery/cli
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: Official CLI tool for installing and managing MCP servers from the Smithery registry. Acts as a package manager for MCP servers with client-agnostic installation (supports Claude, Cursor, Windsurf, Zed, etc.).
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

Smithery CLI is the official installer and manager for the Smithery MCP registry (smithery.ai). Key features:

- **Client-agnostic MCP installer**: Interactive client selection or specify via `--client` flag
- **Registry integration**: Access to largest MCP marketplace (13.7M+ tools tracked)
- **Smart configuration**: JSON-based config via `--config` flag to skip prompts
- **Version**: 3.1.6 (published 7 days ago as of search date)
- **Commands**: `install <server>`, `uninstall <server>` with interactive or automated flows

The registry includes official and community MCPs with built-in observability and distribution. Examples from registry: Exa Search, InfraNodus Knowledge Graphs, etc.

## Redundancy Check

**Status**: NOVEL

Checked against registry:
- **No existing MCP package manager**: We have `defer_loading`, MCP server configs, but no unified installer/manager
- **Not filesystem/git/database MCP**: This is infrastructure/tooling for managing MCPs themselves
- **Complements existing stack**: Would simplify adding new MCPs vs manual `~/.claude.json` editing

Triggers checked:
- "mcp installer", "package manager mcp", "registry installer" - no matches
- Tool Search Tool is for LOADING tools dynamically, not INSTALLING MCP servers
- Rube MCP is a unified API platform (500+ apps), not an MCP installer

This is a meta-tool for managing the MCP ecosystem itself, not a capability MCP.

## Evaluation Needs

1. **Token impact**: Zero (runs outside Claude, modifies config files)
2. **vs Manual config editing**: How much faster/safer than editing `~/.claude.json`?
3. **vs mcp-get**: michaellatman/mcp-get (505 stars) appears to be competing tool - need comparison
4. **Smithery registry quality**: Are Smithery MCPs vetted? Security model?
5. **Lock-in risk**: Does it only work with Smithery registry or support others?
6. **Client support**: Verify Claude Code support vs just Claude Desktop

**Key questions**:
- Does it work with Claude Code CLI (`claude mcp add`) or only GUI clients?
- Can it install from GitHub URLs or only Smithery registry?
- Does it handle OAuth MCPs, environment variables, complex configs?

---

## Evaluation (2026-02-06)

### Redundancy Check

**Status**: NOVEL

Existing capabilities:
- Manual MCP installation via `claude mcp add` (built-in CLI)
- Manual `~/.claude.json` editing
- No package manager for MCP servers

**Classification**: NOVEL - This is infrastructure tooling for managing MCPs themselves, not an MCP capability.

### Blocker: Insufficient Information

**Research needed**:
1. ❓ **Claude Code CLI compatibility**: Does `@smithery/cli` work with `claude` command or only GUI clients (Claude Desktop, Cursor)?
2. ❓ **Installation source flexibility**: Registry-only or supports GitHub URLs?
3. ❓ **Complex config handling**: OAuth, env vars, custom args?
4. ❓ **vs mcp-get comparison**: michaellatman/mcp-get (505 stars) - which is better?
5. ❓ **Smithery registry quality**: Are servers vetted? Security model?
6. ❓ **Lock-in risk**: Can it be bypassed with manual config later?

**Current knowledge gaps**: Cannot score without understanding if it supports Claude Code CLI (our environment) vs only GUI clients.

### Preliminary Scoring (Conditional)

**IF** it supports Claude Code CLI:

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 90/100 | 20% | 18.0 | npm install, zero infrastructure |
| Token efficiency impact | 100/100 | 25% | 25.0 | Zero tokens (runs outside Claude, modifies config files) |
| Capability expansion | 70/100 | 25% | 17.5 | Convenience over manual editing, but manual still works |
| Maintenance burden | 85/100 | 15% | 12.75 | Official Smithery tool, npm package maintenance |
| Community validation | 70/100 | 15% | 10.5 | Official Smithery CLI, 13.7M+ registry tools |

**CONDITIONAL TOTAL**: **83.75/100** (IF Claude Code compatible)

**IF** it only supports GUI clients: **REJECT** (doesn't work in our environment)

### Decision: NEEDS_MORE_INFO ⚠️

**Rationale**: Promising tool (83.75/100 IF compatible) but critical blocker: we don't know if it works with Claude Code CLI vs only GUI clients (Claude Desktop, Cursor, Windsurf). The `--client` flag mentions multiple clients but unclear if `claude` CLI is supported.

**Integration Path (IF approved after research)**:
1. Verify Claude Code CLI support: Test `npx @smithery/cli install <server> --client claude`
2. Compare with mcp-get: Which has better Claude Code integration?
3. Test with sample MCP: Install brave-search or exa via Smithery CLI
4. Verify config format matches `~/.claude.json` structure
5. Test OAuth MCP installation
6. Update registry with triggers: "mcp package manager", "smithery cli", "mcp installer", "registry installer"

**Research requirements**:
- Test installation: `npx @smithery/cli@latest install exa --client claude`
- Check docs: https://www.npmjs.com/package/@smithery/cli
- Compare with mcp-get: https://github.com/michaellatman/mcp-get
- Verify Claude Code compatibility in Smithery docs

**Next action**: MOVE TO FUTURE - Good score but needs compatibility verification before integration
