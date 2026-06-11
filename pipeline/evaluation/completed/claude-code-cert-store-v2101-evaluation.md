# CLAUDE_CODE_CERT_STORE + OS CA Trust by Default (v2.1.101) — Evaluation

**Evaluated**: 2026-04-12
**Source**: Claude Code v2.1.101 release notes (HIGH confidence)
**Decision**: APPROVED (registry-only documentation update)
**Cross-validated**: Codex (GPT-5.4)

## Summary

v2.1.101 trusts the OS CA certificate store by default. Previously, enterprise TLS proxies required manual CA injection. New env var `CLAUDE_CODE_CERT_STORE=bundled` reverts to bundled CAs only.

## Scoring

| Criterion | Weight | Claude | Codex | Final |
|-----------|--------|--------|-------|-------|
| Integration complexity | 20% | 95 | 85 | 90 |
| Token efficiency impact | 25% | 50 | 50 | 50 |
| Capability expansion | 25% | 20 | 35 | 28 |
| Maintenance burden | 15% | 100 | 90 | 95 |
| Community validation | 15% | 100 | 70 | 85 |

**Claude total**: 66.5 | **Codex total**: 61.25 | **Final (avg)**: 63.88

## Decision Rationale

Both Claude and Codex agree: this is a security improvement that's **transparent for our environment** (native Ubuntu Linux, no enterprise TLS proxy). Zero action required — OS CA trust is automatic and beneficial (validates against system-maintained CA bundle rather than potentially stale bundled certs).

**CLAUDE_CODE_CERT_STORE=bundled** only needed for:
- Air-gapped environments
- Policy-override scenarios where OS CAs shouldn't be inherited
- Neither applies to requiem

**Action**: Add registry entry documenting the behavioral change. No active integration step.

## Registry Entry

```
| `CLAUDE_CODE_CERT_STORE` | **ACTIVE (v2.1.101)** | OS CA certificate store trusted by default (was bundled-only). Set `CLAUDE_CODE_CERT_STORE=bundled` to revert. No action needed for standard Linux setups — transparent security improvement. Only use bundled mode for air-gapped or policy-override environments. |
```
