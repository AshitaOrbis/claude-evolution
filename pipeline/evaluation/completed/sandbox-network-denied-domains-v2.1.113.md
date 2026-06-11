# Discovery: sandbox.network.deniedDomains (v2.1.113)

**Date Discovered**: 2026-04-18  
**Source**: Claude Code v2.1.113 official changelog  
**Type**: NOVEL  
**Priority**: Low-Medium

---

## What It Is

Claude Code v2.1.113 adds `sandbox.network.deniedDomains` to the sandbox settings. This allows blocking specific domains even when a broader network allowlist is already configured.

**Before v2.1.113**: Sandbox network control was coarse — either allow all network access or restrict it broadly.  
**After v2.1.113**: Allow broad access but explicitly deny specific domains within the allowlist.

---

## Configuration

```json
{
  "sandbox": {
    "network": {
      "deniedDomains": [
        "github.com",
        "exfil-endpoint.example.com",
        "competitor-service.io"
      ]
    }
  }
}
```

---

## Relevance

| Scenario | Value |
|----------|-------|
| Agent with web access that should avoid code hosting platforms | Block github.com/gitlab.com while allowing other web access |
| Security-conscious sandbox with known exfil endpoints | Block specific risky domains without full lockdown |
| Research agents allowed internet but not internal services | Block internal domain names from sandboxed agents |
| CI/CD runners with network allowlist | Prevent specific external calls even with broad allowlist |

---

## Comparison to Existing Approaches

| Approach | Granularity | Direction | Config Location |
|----------|-------------|-----------|-----------------|
| **sandbox.network.deniedDomains** | Domain-level deny | Deny within allowlist | settings.json sandbox section |
| Existing sandbox allowlist | Coarse allow/deny | Allow specific domains | settings.json sandbox section |
| CLAUDE_CODE_SUBPROCESS_ENV_SCRUB | Credential-level | Strip secrets from child env | ~/.bashrc env var |
| PID namespace isolation (Linux) | Process-level | Isolate subprocesses | Automatic v2.1.98+ |

---

## Current Workspace Assessment

**Does this workspace use sandbox network settings?** Unknown — verify via:
```bash
cat ~/.claude/settings.json | grep -A5 '"sandbox"'
cat ~/claudeworkspace/.claude/settings.json | grep -A5 '"sandbox"'
```

If no sandbox network settings are configured, this feature has low immediate value. The use case primarily targets:
1. Sandbox-enabled agent deployments where network allowlists exist
2. Security-conscious environments where specific domain blocking is needed

**Relevance score**: Low for interactive sessions. Medium-high for security-hardened agent deployments.

---

## Evaluation Criteria Estimate

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 85 | Simple settings.json key — zero code changes |
| Token efficiency impact | 25% | 50 | Neutral — no token impact |
| Capability expansion | 25% | 55 | Useful but niche; only adds value if sandbox network already configured |
| Maintenance burden | 15% | 90 | Set-and-forget domain list |
| Community validation | 15% | 80 | Official Anthropic v2.1.113 |

**Estimated score**: ~65 (NEEDS_RESEARCH range — check if sandbox network settings are in use)

---

## Open Questions

1. Are any sandbox network settings currently configured in `~/.claude/settings.json` or project settings?
2. Is there a specific agent or workflow where domain-level blocking would add security value?
3. Does `deniedDomains` support wildcards (e.g., `*.github.com`) or only exact domain matches?
4. Does this apply to MCP server connections, or only to subprocess network calls?

## Recommended Action

NEEDS_RESEARCH — verify whether sandbox network settings are in use. If yes, evaluate specific `deniedDomains` candidates. If no sandbox network settings exist, this is a document-and-monitor item (low immediate value, potentially useful for future agent security hardening).
