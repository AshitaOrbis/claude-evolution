# Discovery: OTEL_LOG_RAW_API_BODIES Env Var

**Source**: Claude Code v2.1.111 changelog (April 16, 2026)  
**Type**: NOVEL capability  
**Priority**: Low-Medium

---

## What

New environment variable `OTEL_LOG_RAW_API_BODIES` that emits full API request and response bodies as OpenTelemetry log events for debugging.

---

## Claimed Capabilities

- Emits complete API request payloads (prompts, tool definitions, parameters) as OTEL log events
- Emits complete API response bodies (model output, tool calls, usage data) as OTEL log events
- Integrates with existing OTEL observability stack (Jaeger, Zipkin, OpenTelemetry Collector)
- Companion to existing v2.1.101 OTEL vars: `OTEL_LOG_USER_PROMPTS`, `OTEL_LOG_TOOL_DETAILS`, `OTEL_LOG_TOOL_CONTENT`

---

## Comparison Against Existing

| Var | Purpose | Granularity |
|-----|---------|-------------|
| `OTEL_LOG_USER_PROMPTS` (v2.1.101) | Logs user message content | Message level |
| `OTEL_LOG_TOOL_DETAILS` (v2.1.101) | Logs tool call details | Tool level |
| `OTEL_LOG_TOOL_CONTENT` (v2.1.101) | Logs tool response content | Tool result level |
| `OTEL_LOG_RAW_API_BODIES` (v2.1.111) | Logs **full raw API request + response** | API level (most verbose) |

This is a superset of the existing OTEL vars — raw bodies include everything the others capture plus system prompt, model parameters, caching metadata, and usage tokens.

---

## Redundancy Check

- **Existing OTEL vars** (v2.1.101): DOCUMENTED in versions.json but not yet in registry
- `OTEL_LOG_RAW_API_BODIES` is NOVEL relative to existing vars — different granularity level (raw wire format vs structured fields)
- **Current setup**: No OTEL stack running on requiem — these vars have no receiver

---

## Evaluation Questions

1. Do we have (or plan to add) an OTEL collector on requiem?
2. Is raw API body logging useful for debugging prompt caching failures (cache miss diagnosis)?
3. Does enabling this affect performance (serialization overhead)?
4. Security concern: raw bodies include full system prompts — are OTEL logs secured?

---

## Preliminary Assessment

**Score estimate**: 55-65/100 — LOW PRIORITY for integration

**Reasoning**:
- No OTEL stack currently deployed → zero immediate value
- Debugging via raw logs is superseded by `--debug` flag for interactive use
- High security surface area: full prompt content in log stream
- Would pay off only if we run a central observability stack across heartbeat/cron sessions

**Deferred trigger**: Evaluate when/if a centralized observability stack is deployed for automation pipelines. Until then, rely on `--debug` for interactive debugging and structured log files for automation.

---

## Final Evaluation

```json
{
  "evaluation": {
    "scores": {
      "integration_complexity": 30,
      "token_efficiency": 55,
      "capability_expansion": 55,
      "maintenance_burden": 80,
      "community_validation": 85
    },
    "total": 58.25,
    "decision": "NEEDS_RESEARCH",
    "reasoning": "Companion to existing OTEL vars (v2.1.101) but adds raw wire-format logging — more verbose, higher security surface (full system prompt in logs). No OTEL collector on requiem makes integration_complexity=30 (requires infrastructure we don't have). Deferred until observability stack is deployed. Security concern: raw API bodies include system prompts.",
    "evaluated_at": "2026-04-20"
  }
}
```
