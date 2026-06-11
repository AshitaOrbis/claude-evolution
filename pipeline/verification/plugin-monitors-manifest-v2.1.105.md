# Discovery: Plugin `monitors` Manifest Key (v2.1.105)

**Discovered**: 2026-04-14
**Source**: Claude Code v2.1.105 official changelog (github.com/anthropics/claude-code/releases)
**Category**: Plugin System / Background Process Management
**Redundancy Check**: NOVEL — Monitor Tool (v2.1.98) is a built-in tool; this is a declarative plugin-level manifest key

---

## What It Is

v2.1.105 adds a `monitors` manifest key to the plugin specification. Background monitors declared here **auto-arm at session start** or when the skill is invoked.

**Official changelog entry**:
> Added background monitor support for plugins via a top-level `monitors` manifest key that auto-arms at session start or on skill invoke

---

## Why It Matters

### Current Architecture
The built-in `Monitor` tool (v2.1.98) lets agents spawn background processes and stream stdout lines into the active session. But this requires EXPLICIT invocation — the agent must call the Monitor tool to start monitoring. There is no way for a plugin/skill to declare "always monitor X when I'm active."

### New Capability
- **Declarative background monitoring**: A plugin declares `monitors:` in its manifest → specified processes automatically start at session start or skill invoke
- **Zero-code monitor activation**: No explicit Monitor tool call needed in the workflow
- **Session-scoped**: Monitors arm when plugin is active, presumably stop with session end
- **Use cases for evolution pipeline**:
  - `capability-discoverer` plugin: auto-monitor a feed aggregator process for new discoveries
  - `evolution-orchestrator`: auto-monitor the event bus for heartbeat events without explicit tool calls
  - Heartbeat scripts: plugin that monitors version-tracker output and pipes to evolution pipeline

### Key Difference from Monitor Tool

| Aspect | Monitor Tool (v2.1.98) | `monitors` Manifest Key (v2.1.105) |
|--------|----------------------|----------------------------------|
| Activation | Explicit agent tool call | Declarative in manifest — automatic |
| Lifecycle | Per-invocation | Session start or skill invoke |
| Config location | Runtime (in Claude conversation) | Plugin manifest (static config) |
| Use case | Ad-hoc process monitoring | Persistent, always-on monitors |

---

## Open Questions (for integration step)

1. Exact `monitors` manifest syntax (need to verify from docs or official examples)
2. Does "auto-arm at session start" mean all installed plugins' monitors start, or only active/invoked plugins?
3. Process lifecycle: what stops the monitor? Session end? Explicit stop? Skill deinvoke?
4. Interaction with `CLAUDE_CODE_DISABLE_CRON` — does it suppress plugin monitors too?
5. Interaction with `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` — are monitor subprocesses env-scrubbed?

---

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 65 | Manifest key is straightforward; syntax verification needed before practical use; open questions |
| Token efficiency impact | 70 | Eliminates explicit Monitor tool calls from skills/agents — reduces per-session overhead |
| Capability expansion | 85 | New declarative monitoring pattern — no prior equivalent in the plugin system |
| Maintenance burden | 80 | Official Anthropic; manifest-level config, not code |
| Community validation | 85 | Official v2.1.105 release feature |

**Total**: (65×0.20) + (70×0.25) + (85×0.25) + (80×0.15) + (85×0.15) = 13 + 17.5 + 21.25 + 12 + 12.75 = **76.5**

**Decision**: APPROVED

**Reasoning**: Score 76.5 (above 70 threshold) despite open questions about manifest syntax. Official Anthropic v2.1.105 feature with novel declarative monitoring capability. Integration step must resolve syntax questions before writing example manifests. No env vars or settings.json changes — no empirical safety test required. Add to plugin system registry entry; verify exact syntax via official docs during integration.

**Evaluated**: 2026-04-15
