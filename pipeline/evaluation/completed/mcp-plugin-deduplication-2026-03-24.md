# Integration: MCP Plugin Server Deduplication

**Score**: 73.5/100
**Decision date**: 2026-03-24
**Source**: code.claude.com changelog (March 2026)

## Action Required

### Registry Update

Add to `registry/existing-capabilities.md` under the **Plugin System** section (near v2.1.80 Plugin System entry):

```
| MCP Plugin Deduplication | ACTIVE | Plugin-provided MCP servers that match a manually-configured server (same command/URL) are automatically skipped. Manual config takes precedence. Prevents duplicate tool sets and tool disambiguation noise. |
```

Add to the v2.1.80 redundancy triggers: "plugin mcp deduplication", "duplicate mcp server", "mcp plugin conflict", "manual config precedence", "plugin tool dedup"

## No Installation Required

Already-shipped behavior. Registry annotation only.
