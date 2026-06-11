# Discovery: `disableSkillShellExecution` Setting

**Discovered**: 2026-04-03
**Source**: Claude Code v2.1.91 changelog
**Type**: Security / Settings
**Phase**: Evaluation Completed

---

## What It Is

A new boolean settings key that disables inline shell execution within skills, custom slash commands, and plugin commands. When enabled, shell blocks in SKILL.md files are not executed.

## Use Cases

1. **CI/CD environments**: Prevent skills from running arbitrary shell during automated runs
2. **Untrusted plugin sources**: Marketplace plugins with shell blocks can be sandboxed
3. **Read-only agent contexts**: Researcher agents that shouldn't execute shell from skill prompts

## Relationship to Existing Controls

| Control | Scope | Mechanism |
|---------|-------|-----------|
| `CLAUDE_CODE_SIMPLE` | All native tools | Env var, restricts to Read/Edit/Glob/Grep+Bash |
| `disableBypassPermissionsMode` | Permission mode locking | managed-settings |
| `disableSkillShellExecution` | Skill/plugin shell only | Settings key (new) |

These are complementary, not overlapping.

---

## Evaluation

```json
{
  "scores": null,
  "total": null,
  "decision": "DUPLICATE",
  "reasoning": "Already registered as ACTIVE (v2.1.91+) in registry/existing-capabilities.md. Config key, use cases, relationship to CLAUDE_CODE_SIMPLE, and adoption trigger already documented. No additional integration work needed.",
  "evaluated_at": "2026-04-04"
}
```
