# Discovery: `forceRemoteSettingsRefresh` Policy Setting

**Discovered**: 2026-04-04
**Source**: Claude Code v2.1.92 changelog
**Type**: Enterprise Policy / Managed Settings
**Phase**: Evaluation Completed

---

## What It Is

A new policy key for the managed-settings system that enforces fail-closed behavior on remote settings fetches. When set, the Claude Code CLI blocks startup until remote managed settings are freshly fetched from the server, and exits with failure if the fetch fails.

## Relationship to Existing Managed Settings

| Capability | Version | Function |
|------------|---------|---------|
| `managed-settings.d/` drop-in directory | v2.1.83 | Modular policy fragments, merged alphabetically at startup |
| `disableBypassPermissionsMode` | v2.1.83 | Locks permission mode via managed settings |
| `forceRemoteSettingsRefresh` | v2.1.92 (NEW) | Fail-closed startup enforcement — blocks until fresh remote fetch |

These are layered controls; `forceRemoteSettingsRefresh` is the **enforcement** layer, not a new settings target.

## Use Cases

1. **Compliance-critical environments**: Ensures no session starts with stale policy
2. **Enterprise policy rollout**: Guarantees policy changes are applied before any work starts
3. **Air-gapped teams with remote policy server**: Ensures the policy server is reachable; fail-closed behavior prevents policy bypass via network failure

## Relevance to Current Setup

**Low** — personal Max plan, no remote managed settings infrastructure. Adoption trigger: team account with centralized policy management.

---

## Evaluation

```json
{
  "scores": null,
  "total": null,
  "decision": "DUPLICATE",
  "reasoning": "Already registered as ACTIVE (v2.1.92+) in registry/existing-capabilities.md. Enterprise use cases, relationship to managed-settings.d/, and low relevance to current setup already documented. No additional integration work needed.",
  "evaluated_at": "2026-04-04"
}
```
