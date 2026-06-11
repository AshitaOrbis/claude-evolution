# Discovery: Plugin `bin/` Executables

**Discovered**: 2026-04-03
**Source**: Claude Code v2.1.91 changelog
**Type**: Plugin System Extension
**Phase**: Evaluation Completed

---

## What It Is

Plugins can now ship executables under `bin/` within the plugin directory. These executables become invocable as bare commands from the Bash tool when the plugin is active.

```
my-plugin/
  bin/
    my-tool        ← becomes available as `my-tool` in Bash
    analyze-repo
  agents/
  skills/
```

## Use Cases

1. **Self-contained plugin tooling**: Plugins that need custom CLI helpers don't require separate global installation
2. **Evolution pipeline**: heartbeat.sh, version-tracker.sh, webhook-post.sh could be packaged as plugin bin/ entries for cleaner deployment
3. **MCP companion tools**: Plugins that wrap MCP servers could ship the server binary alongside the plugin definition

## Relationship to Existing Plugin System

- **Inline Plugin Declarations (v2.1.85+)**: Plugins can be declared in settings.json — now they can also ship executables
- **Agent Spawn Restrictions**: Agents have `tools: [Bash]` — bin/ executables are invocable via Bash, so this extends what agents can do within their tool budget

---

## Evaluation

```json
{
  "scores": null,
  "total": null,
  "decision": "DUPLICATE",
  "reasoning": "Already registered as ACTIVE (v2.1.91+) in registry/existing-capabilities.md under 'Plugin bin/ Executables'. Details, open questions, and deferred action item (revisit when packaging evolution scripts as formal plugin) already documented. No additional integration work needed.",
  "evaluated_at": "2026-04-04"
}
```
