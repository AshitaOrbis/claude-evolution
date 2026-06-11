# Discovery: Claude Code `managed-settings.d/` Drop-in Directory (v2.1.83)

**Discovered**: 2026-03-25
**Source**: Claude Code v2.1.83 release notes (github.com/anthropics/claude-code/releases)
**Type**: NOVEL — built-in Claude Code feature (enterprise policy management)
**Classification**: Claude Code Feature > Enterprise / Policy Management

---

## What It Is

Claude Code v2.1.83 introduces a `managed-settings.d/` drop-in directory alongside the existing `managed-settings.json`. It allows separate teams, MDM policies, or admin layers to deploy independent policy fragments that are merged alphabetically at load time.

**Directory structure:**
```
/etc/claude/managed-settings.json          ← existing monolithic config (still works)
/etc/claude/managed-settings.d/
  ├── 00-baseline-security.json            ← loaded first (alphabetical)
  ├── 10-team-frontend.json
  └── 20-team-backend.json                 ← loaded last (wins on conflict)
```

On macOS, the path is under `~/Library/Application Support/Claude/`.
On Linux, it follows XDG config conventions.

---

## Why It Matters

**Before**: Enterprise deployments had a single `managed-settings.json`. If multiple teams or MDM layers needed to contribute policy, they had to coordinate on a single file — creating merge conflicts and tight coupling between policy owners.

**After**: Each team deploys a separate fragment. Baseline security policies (`00-*`) load first, team-specific overrides (`10-*`, `20-*`) layer on top. Alphabetical merge ensures deterministic conflict resolution.

**Enterprise use cases:**
- Security team: `00-security.json` — disable bypass permissions mode, lock to normal mode
- Frontend team: `10-frontend.json` — allow specific MCP servers, custom tool permissions
- Backend team: `10-backend.json` — different allowed tools and MCP configs
- MDM push: each Jamf/Intune policy pushes one fragment without knowing about others

---

## Relevance to Current Setup

**Direct relevance: LOW.** This is an enterprise multi-team feature. The current setup is single-user desktop (requiem). There is no `managed-settings.json` in use.

**Indirect relevance: MEDIUM.** The `permissions.disableBypassPermissionsMode` field (also v2.1.83) is available in managed settings — relevant for understanding Auto Mode lockdown options. Also relevant if consulting work touches enterprise Claude Code deployments.

**Integration surface for personal use**: Could use `managed-settings.d/` to modularize local policy without a single monolithic settings file. Minor ergonomic improvement only.

---

## Evaluation Notes

**Redundancy check**: No existing modular policy management capability in registry. The existing `managed-settings.json` is documented as enterprise-only. This is **NOVEL** but enterprise-targeted.

**Integration complexity**: Low for enterprises with MDM. Near-zero for single-user setups.

**Token efficiency impact**: Neutral — load-time configuration, not per-conversation.

**Capability expansion**: NOVEL in enterprise policy space. Irrelevant for personal setup but worth knowing.

**Maintenance burden**: Low — built-in feature, no external dependencies.

**Community validation**: Official Anthropic release.

**Preliminary score estimate**: 55-65 (novel but low personal relevance, enterprise-only utility)

---

## Version

Claude Code v2.1.83, released 2026-03-25
