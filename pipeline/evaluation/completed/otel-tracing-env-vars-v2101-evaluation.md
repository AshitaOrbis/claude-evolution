# OTEL Tracing Opt-In Env Vars (v2.1.101) — Evaluation

**Evaluated**: 2026-04-12
**Source**: Claude Code v2.1.101 release notes (HIGH confidence)
**Decision**: NEEDS_RESEARCH -> pipeline/future/
**Cross-validated**: Codex (GPT-5.4)

## Summary

v2.1.101 adds three opt-in env vars for OpenTelemetry tracing:
- `OTEL_LOG_USER_PROMPTS=1` — includes prompt text in trace spans
- `OTEL_LOG_TOOL_CONTENT=1` — includes tool invocation content
- `OTEL_LOG_TOOL_DETAILS=1` — includes detailed tool metadata
- W3C `TRACEPARENT` env var propagated to Bash subprocesses

Community quickstart: ColeMurray/claude-code-otel

## Scoring

| Criterion | Weight | Claude | Codex | Final |
|-----------|--------|--------|-------|-------|
| Integration complexity | 20% | 60 | 55 | 58 |
| Token efficiency impact | 25% | 60 | 40 | 50 |
| Capability expansion | 25% | 75 | 65 | 70 |
| Maintenance burden | 15% | 60 | 70 | 65 |
| Community validation | 15% | 90 | 45 | 68 |

**Claude total**: 68.25 | **Codex total**: 54.25 | **Final (avg)**: 61.25

## Key Research Findings

1. **CLAUDE_CODE_ENABLE_TELEMETRY relationship**: Unclear — docs don't state if OTEL_LOG_* vars require it as prerequisite
2. **ColeMurray/claude-code-otel**: Exists but appears community-maintained, not official Anthropic
3. **Local-only export**: Not built-in — requires OTLP collector (Jaeger, etc.) or custom exporter. No simple file/SQLite output
4. **Performance overhead**: Undocumented, no published benchmarks
5. **Feature is real**: Confirmed in v2.1.101 release notes

## Decision Rationale

Both Claude and Codex agree the feature is real and novel (distributed tracing of Claude Code sessions), but integration requires:
- External OTLP infrastructure (collector process)
- Unclear prerequisite relationship with CLAUDE_CODE_ENABLE_TELEMETRY
- No local-only export option without additional setup

**Action**: Move to pipeline/future/. Revisit when:
- Anthropic provides official OTEL integration docs
- Local-only export becomes available
- ColeMurray/claude-code-otel matures with clear quickstart

## Extractable Value

The W3C TRACEPARENT propagation to Bash subprocesses is independently useful for debugging subprocess chains in heartbeat runs — worth noting in registry even without full OTEL adoption.
