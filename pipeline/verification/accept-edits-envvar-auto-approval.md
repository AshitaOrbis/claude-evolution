# Discovery: Accept Edits Mode — Env-Var Prefix Auto-Approval

**Source**: Official Claude Code v2.1.97 changelog  
**Discovered**: 2026-04-10  
**Category**: Permissions / Developer Experience  
**Type**: NOVEL (extension of existing accept-edits mode)

---

## What It Is

In accept-edits mode (where Claude auto-approves file edits but asks for confirmation on shell commands), bash commands prefixed with recognized safe environment variable wrappers or process managers are now auto-approved without requiring manual confirmation.

**Examples of auto-approved prefixes:**
- `nvm run node script.js` — nvm version-pinned node execution
- `python3 -c "..."` — direct Python interpreter
- `npx tsc --noEmit` — npx-run TypeScript compiler
- Similar process wrapper patterns

---

## Why It Matters

In accept-edits mode, every non-file-edit command triggers a confirmation prompt. For common development operations like running a linter after an edit, typechecking, or running tests with `nvm run`, this creates friction. The new behavior auto-approves these recognized-safe wrappers, which significantly reduces permission interruptions in typical dev workflows.

**For this setup:**
- We use `nvm` for Node.js version management (pnpm, tsc, etc.)
- Session-End Verification rule requires running tests/typecheck after changes
- accept-edits mode is used during autonomous iterations — this reduces confirmation overhead
- Note: Auto Mode (`permissions.defaultMode: "auto"`) is the active default; this feature applies in accept-edits mode specifically

---

## Redundancy Check

| Existing Capability | Conflict? |
|--------------------|-----------|
| Auto Mode (`permissions.defaultMode: "auto"`) | Partial — Auto Mode is broader (risk-based approval of all operations); this is narrower (specific prefix patterns in accept-edits mode) |
| Hook allowlists | No — hooks are event-based; this is interactive permission logic |

**Classification: NOVEL** — complementary to Auto Mode, not a duplicate.

---

## Evaluation

```json
{
  "scores": {
    "integration_complexity": 100,
    "token_efficiency": 50,
    "capability_expansion": 30,
    "maintenance_burden": 100,
    "community_validation": 100
  },
  "total": 70.0,
  "decision": "APPROVED",
  "reasoning": "Passive behavior, zero config, zero maintenance. Marginal capability expansion because Auto Mode already covers this use case on the primary workflow — this helps only when operating in accept-edits mode specifically. Worth a registry note so future sessions know nvm-prefixed commands auto-approve in accept-edits mode. No CLAUDE.md change needed (Auto Mode takes precedence)."
}
```

---

## Action Items

1. Verify which specific prefixes are recognized (test `nvm run` empirically when using accept-edits mode)
2. Registry documentation only — no active config change needed (Auto Mode already active)
