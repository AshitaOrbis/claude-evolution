# Discovery: MCP Tool Result Size Override

**Discovered**: 2026-04-03
**Source**: Claude Code v2.1.91 changelog
**Type**: MCP / Tool Enhancement
**Phase**: Evaluation Completed

---

## What It Is

MCP servers can annotate individual tool results with `_meta["anthropic/maxResultSizeChars"]` to raise the per-result size limit up to 500,000 characters. Without this annotation, large MCP results are truncated at the default limit.

```json
{
  "content": [{ "type": "text", "text": "...large schema..." }],
  "_meta": {
    "anthropic/maxResultSizeChars": 500000
  }
}
```

## Why It Matters

Large MCP responses (DB schemas, deep research payloads, full file listings) are currently truncated before reaching the model. This causes:
- Incomplete schema context → more round-trips to reconstruct
- Truncated Exa deep research → lost citations and content
- Partial event-bus query results → incorrect reasoning about agent state

This annotation lets MCP server authors opt specific tools into a 500K limit on a per-result basis.

## Integration Path

- **Client side**: No configuration needed — Claude Code honors the annotation automatically (v2.1.91+)
- **Server side**: MCP server authors must add `_meta["anthropic/maxResultSizeChars"]` to tool result payloads
- **Our servers**: `agent-event-bus` (SQLite queries), `codex` (research outputs), `exa` (deep_researcher) could all benefit

---

## Evaluation

```json
{
  "scores": null,
  "total": null,
  "decision": "DUPLICATE",
  "reasoning": "Already registered as ACTIVE (v2.1.91+) in registry/existing-capabilities.md under 'MCP Tool Result Size Override (maxResultSizeChars)'. Full details including action item against agent-event-bus already documented. No additional integration work needed.",
  "evaluated_at": "2026-04-04"
}
```
