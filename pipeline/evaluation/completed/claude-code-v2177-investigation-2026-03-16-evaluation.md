# Claude Code v2.1.77 / claude-agent-sdk — Evaluation

- **Date Evaluated**: 2026-03-16
- **Original Discovery**: claude-code-v2177-investigation-2026-03-16.json
- **Source**: https://github.com/anthropics/claude-code/commit/48b1c6c0ba0b0644c97d2014d68f0c94ef157904
- **Decision**: APPROVED (primary: claude-agent-sdk); Registry Update (secondary: v2.1.75 Windows path change)

## Findings Summary

**v2.1.77 does not exist** — latest confirmed release is v2.1.76 (March 14, 2026). The breaking changes fall on v2.1.75 (Windows path, March 13, 2026). The primary value in this investigation is the **claude-agent-sdk**, which is a significant new official capability.

## Item 1: Windows Managed-Settings Path Change (v2.1.75)

- **Breaking change**: `C:\ProgramData\ClaudeCode\managed-settings.json` → `C:\Program Files\ClaudeCode\managed-settings.json`
- **Impact on our system**: Zero — Linux/desktop setup. No MDM/enterprise Windows deployment.
- **Action**: Registry note only. No integration needed.

## Item 2: claude-agent-sdk (Primary Value)

The official rename from `@anthropic-ai/claude-code` SDK mode to `@anthropic-ai/claude-agent-sdk`. **Not a minor rename** — this is a well-documented, substantially-featured official Anthropic SDK for programmatic agent building.

### Key Capabilities

```typescript
import { query, type ClaudeAgentOptions } from '@anthropic-ai/claude-agent-sdk';

// Async generator: runs full agent loop programmatically
for await (const event of query({
  prompt: 'implement X',
  allowedTools: ['Read', 'Edit', 'Bash'],
  permissionMode: 'acceptEdits',
  hooks: {
    PreToolUse: async (tool) => { /* in-process callback */ },
    PostToolUse: async (tool, result) => { /* ... */ },
  },
  agents: {
    'my-subagent': {
      description: 'What it does',
      prompt: 'Instructions...',
      allowedTools: ['Read'],
    }
  },
  mcpServers: [{ /* programmatic MCP connection */ }],
  resume: sessionId,  // session persistence
})) {
  // process events
}
```

Also available as Python: `pip install claude-agent-sdk`

### Comparison to Current Approach

| Aspect | Current (Claude Code CLI) | claude-agent-sdk |
|--------|--------------------------|------------------|
| Hooks | Shell scripts in ~/.claude/hooks/ | In-process callbacks |
| Subagents | .md files in ~/.claude/agents/ | Inline `AgentDefinition` objects |
| Session | Per-session, not resumable programmatically | `resume: sessionId` |
| Tool control | settings.json allowedTools | Per-query `allowedTools` array |
| MCP | Global ~/.claude.json config | Per-query `mcpServers` config |

## Scoring (claude-agent-sdk)

| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|---------|
| Integration complexity | 60 | 20% | 12.0 |
| Token efficiency impact | 50 | 25% | 12.5 |
| Capability expansion | 90 | 25% | 22.5 |
| Maintenance burden | 100 | 15% | 15.0 |
| Community validation | 100 | 15% | 15.0 |
| **Total** | | | **77.0** |

## Scoring Rationale

- **Integration complexity (60)**: Requires TypeScript/Python code to use (library), not drop-in like a skill file. But docs are excellent and the API is clean. Using it alongside Claude Code CLI (not replacing it) is the intended pattern.
- **Token efficiency (50)**: Neutral — different paradigm (programmatic vs CLI). In-process hooks avoid subprocess overhead.
- **Capability expansion (90)**: Genuinely novel. In-process hooks (vs shell scripts), inline subagent definition (vs .md files), programmatic MCP attachment, session resume — these are capabilities our current system cannot do.
- **Maintenance burden (100)**: Official Anthropic package. Clear versioning, migration guide, official support.
- **Community validation (100)**: Official Anthropic release. The authoritative programmatic interface to Claude's agent loop.

## Decision

**APPROVED (77.0)**

### Integration Actions

1. **Update claude-api skill** (`~/.claude/skills/claude-api/SKILL.md`): Add documentation on claude-agent-sdk as the programmatic interface. Distinguish from claude-code-sdk (old name). Include `query()` pattern examples.

2. **Update registry** (`registry/existing-capabilities.md`): Add entry under new "Programmatic Agent Building" section. Note the rename from claude-code-sdk → claude-agent-sdk.

3. **Registry note (v2.1.75)**: Add to versions.json — Windows path change, relevant for enterprise/MDM but not our setup.

4. **Consider for**: Any future scripts that need to run agent loops programmatically (e.g., heartbeat orchestration, test harnesses that need isolated sessions with specific tools).

### Migration Note

If any existing scripts use `@anthropic-ai/claude-code` in SDK mode (not CLI mode), migrate to `@anthropic-ai/claude-agent-sdk`. Check migration guide: docs.claude.com/en/docs/claude-code/sdk/migration-guide
