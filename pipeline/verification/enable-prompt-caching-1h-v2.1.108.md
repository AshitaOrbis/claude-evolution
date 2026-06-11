# Discovery: Prompt Cache TTL Control (`ENABLE_PROMPT_CACHING_1H`)

**Discovered**: 2026-04-15  
**Source**: Claude Code v2.1.108 GitHub release notes  
**Version**: v2.1.108 (April 14, 2026)  
**Type**: Native Claude Code Enhancement  
**Status**: APPROVED

---

## What It Is

Two new environment variables for explicit prompt cache TTL control:

- `ENABLE_PROMPT_CACHING_1H` — opt into 1-hour prompt cache TTL (explicit, reliable; useful for API key, Bedrock, Vertex, Foundry)
- `FORCE_PROMPT_CACHING_5M` — force 5-minute TTL (testing/debugging use)
- `ENABLE_PROMPT_CACHING_1H_BEDROCK` — deprecated alias for Bedrock (still honored)

**Companion**: Claude Code v2.1.108 now also shows a startup warning when any `DISABLE_PROMPT_CACHING*` variable is set.

---

## Why It Matters

Prior to v2.1.108:
- Users with `DISABLE_TELEMETRY` were silently getting 5-minute TTL instead of 1 hour (bug — now fixed)
- TTL was implicit — no env var to explicitly pin it

After v2.1.108:
- Explicit opt-in to 1hr TTL regardless of telemetry settings
- Complements `--exclude-dynamic-system-prompt-sections` (v2.1.97) which prevents cache key invalidation from rotating sections

**For heartbeat runs**: Our setup doesn't have `DISABLE_TELEMETRY`, so we were likely getting 1hr TTL already. However, `ENABLE_PROMPT_CACHING_1H` makes this explicit and reliable — a guarantee rather than an implicit default.

**For testing**: `FORCE_PROMPT_CACHING_5M` enables testing cache expiry behavior without waiting 1 hour.

---

## Redundancy Check

Existing capabilities:
- `--exclude-dynamic-system-prompt-sections` — controls WHAT is in the cache key (complements, not replaces)
- `/cost` with cache breakdown — observability for cache effectiveness

No existing capability controls the TTL duration. **NOVEL**.

---

## Implementation

```bash
# ~/.bashrc — explicit 1-hour TTL guarantee for all sessions
export ENABLE_PROMPT_CACHING_1H=1

# Heartbeat cron invocations (in addition to existing --exclude-dynamic-system-prompt-sections)
ENABLE_PROMPT_CACHING_1H=1 claude -p --exclude-dynamic-system-prompt-sections "..."

# Debug/testing — force short TTL to verify cache miss behavior
FORCE_PROMPT_CACHING_5M=1 claude -p "..."
```

---

## Evaluation

**Empirical Safety Test**: PASSED (`{"passed": true, "permission_forced": false, "sandbox_failed": false, "exit_code": 0, "warnings": []}`)

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 95 | One env var in ~/.bashrc — drop-in |
| Token efficiency impact | 80 | Explicit guarantee vs implicit 1hr TTL; prevents silent 5m TTL on DISABLE_TELEMETRY setups |
| Capability expansion | 60 | Mostly confirms existing behavior explicitly; FORCE_PROMPT_CACHING_5M is genuinely new |
| Maintenance burden | 98 | Zero — set once, never touch |
| Community validation | 80 | Official Anthropic (v2.1.108 release) |

**Total**: (95×0.20) + (80×0.25) + (60×0.25) + (98×0.15) + (80×0.15) = 19 + 20 + 15 + 14.7 + 12 = **80.7**

**Decision**: APPROVED

**Reasoning**: Passed empirical safety test. Official Anthropic v2.1.108 feature. The primary value is making explicit what was previously implicit (1hr TTL guarantee), complementing `--exclude-dynamic-system-prompt-sections` already in use. `FORCE_PROMPT_CACHING_5M` adds a new debugging capability. Integration path: add to `~/.bashrc` and heartbeat cron invocations. Requires approval gate (env var → ~/.bashrc). Write proposal to pipeline/pending-approval/.

**Evaluated**: 2026-04-15
