# Integrate Approved Items

Process all items in `pipeline/integration/`. For each approved discovery:

## Integration Types

| Discovery Type | Target | Example |
|---------------|--------|---------|
| MCP Server | Claude Code MCP config | Add to `~/.claude.json` or project `.mcp.json` |
| Skill/Workflow | `~/.claude/skills/[name]/SKILL.md` | Create skill with instructions |
| Agent | `~/.claude/agents/[name].md` | Create agent definition |
| Technique | Update existing skill or CLAUDE.md | Add pattern to relevant docs |

## Integration Steps

For each item:

1. **Classify** the integration type
2. **Create** the appropriate file (skill, agent, config)
3. **Test** that the integration works (run a simple verification)
4. **Update** `registry/existing-capabilities.md` with new entry
5. **Move** to `pipeline/verification/` with integration report

## Safety Rules

- Never overwrite existing files without explicit comparison
- Always add redundancy triggers to the registry
- If integration fails, move back to `pipeline/evaluation/completed/` with failure notes
- Log all changes for rollback

## Output

```json
{"integrated": 2, "failed": 0, "items": [{"title": "...", "type": "skill", "status": "success"}]}
```
