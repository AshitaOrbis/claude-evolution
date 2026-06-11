# Evaluation: MCP Elicitation Support (v2.1.76)

**Source**: Claude Code v2.1.76 GitHub release notes (2026-03-14)
**Type**: Claude Code built-in feature (MCP protocol extension)
**Discovered**: 2026-03-14
**Evaluated**: 2026-03-14

---

## What It Is

MCP servers can now request structured user input mid-task via an interactive dialog. Two input modalities:
1. **Form fields** — server specifies field names, types, validation; user fills in dialog
2. **Browser URL** — server opens a browser URL for OAuth flows, web-based configuration, etc.

Two new hook types:
- `Elicitation` hook — fires when a server requests input; can pre-fill or transform the dialog
- `ElicitationResult` hook — fires after user responds; can override result before it reaches the server

---

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 85 | Built-in; no changes needed for existing MCPs. Elicitation/ElicitationResult hook scripts are optional low-effort additions. |
| Token efficiency impact | 25% | 50 | Neutral overall — adds a dialog turn but ElicitationResult hook pre-fill eliminates that turn for known values. Net neutral. |
| Capability expansion | 25% | 90 | Genuine protocol expansion. First-class interactive/OAuth flows in MCP; unlocks new class of dynamic MCP servers. No existing capability covers server-initiated structured input. |
| Maintenance burden | 15% | 90 | Zero maintenance — Anthropic-managed built-in feature. Hook scripts (if written) have minimal ongoing burden. |
| Community validation | 15% | 85 | Official Anthropic release in v2.1.76. Protocol-level endorsement; major version milestone. |

- **Total Score**: (85×0.20) + (50×0.25) + (90×0.25) + (90×0.15) + (85×0.15)
- = 17 + 12.5 + 22.5 + 13.5 + 12.75 = **78.25/100**

## Decision

**APPROVED** (78.25/100)

---

## Redundancy Check

No existing capability covers mid-session structured input requests from MCP servers:
- **Pre-configured MCP settings** (`~/.claude.json`) — static, not runtime
- **AskUserQuestion tool** — Claude-initiated, not MCP-server-initiated
- **PreToolUse/PostToolUse hooks** — can intercept calls but cannot generate dialogs

**Verdict**: NOVEL. No redundancy.

---

## Integration Targets

### 1. Hook Lifecycle Skill (PRIMARY)
Add `Elicitation` and `ElicitationResult` to hook types reference table.
Bump hook count 18 → 20.
File: `~/.claude/skills/hook-lifecycle/SKILL.md`

### 2. Registry Update
Add to existing-capabilities.md under Hook Lifecycle section. Document the ElicitationResult automation pattern (secrets pre-fill via hook script reading from local store).

### 3. No MCP Server Changes Needed
Existing MCPs are unaffected. This is opt-in per server. No changes to current MCP inventory.

---

## Open Questions (Research Before Full Integration)

1. Which existing MCP servers (Playwright, Exa, Discord) have added elicitation support yet?
2. What is the hook script input format for `Elicitation` and `ElicitationResult`?
3. Does `ElicitationResult` receive the full form schema (field names + types) or only the user's response?

---

## Redundancy Triggers (for future checks)

"mcp elicitation", "mcp structured input", "mcp dialog", "mcp form fields", "server input request", "elicitation hook", "ElicitationResult hook", "mid-task user input", "mcp authentication dialog", "mcp browser url", "interactive mcp", "runtime mcp configuration"
