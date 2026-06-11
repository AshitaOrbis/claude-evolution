# sandbox.network.deniedDomains (Claude Code v2.1.113) — Evaluation

- **Source**: Claude Code v2.1.113 changelog
- **Type**: Settings.json configuration key
- **Discovered**: 2026-04-18
- **Evaluated**: 2026-04-19

## What It Is

Adds `sandbox.network.deniedDomains` array to settings. Allows blocking specific domains *within* an existing sandbox network allowlist — fine-grained deny on top of coarse allow.

## Workspace Use Check

```bash
$ grep -rA5 '"sandbox"' ~/.claude/settings.json ~/claudeworkspace/.claude/settings.json 2>/dev/null
```

(Verified during evaluation: workspace does not currently configure `sandbox.network` settings. Sandbox mode is not active for any agent or session.)

## Redundancy Check

NOVEL within the sandbox configuration surface — no existing deny-within-allowlist primitive. Distinct from `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` (credential-level) and PID-namespace isolation (process-level).

## Scoring

| Criterion | Weight | Score | Reasoning |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Single settings.json key, zero code changes. |
| Token efficiency | 25% | 50 | Neutral — no token impact. |
| Capability expansion | 25% | 40 | Niche. Adds value only if sandbox network allowlists are in use. They aren't here. |
| Maintenance burden | 15% | 90 | Set-and-forget domain list, official Anthropic. |
| Community validation | 15% | 80 | Official Claude Code v2.1.113 release. |

**Total**: (90×0.20) + (50×0.25) + (40×0.25) + (90×0.15) + (80×0.15) = 18 + 12.5 + 10 + 13.5 + 12 = **66.0**

## Decision: REGISTRY-ONLY (document-and-monitor)

Score is in the NEEDS_RESEARCH band, but the research question ("are sandbox network settings in use?") is answered: **no**. Without an active sandbox network allowlist, `deniedDomains` has nothing to deny *within*. The feature is sound and well-designed; the workspace just doesn't have the precondition to benefit.

**Action**:
1. Add to `registry/existing-capabilities.md` under the v2.1.113 features section as ACTIVE-AVAILABLE.
2. Note as a candidate config when (a) running OpenClaw-style sandboxed agents that need internet but should avoid specific exfil domains, or (b) future security-hardened agent deployments come online.
3. No integration work required today.

**Reconsider when**: a sandboxed agent deployment with broad network access is added to the workspace.

## Cross-Validation Note

Codex MCP unreachable. Cross-validation not strictly needed — this is a documented Anthropic feature with an unambiguous configuration surface. The decision is gated on workspace state (no sandbox network configs), which is directly verifiable.
