# Discovery: Model-Invokable Built-in Slash Commands via Skill Tool

**Discovered**: 2026-04-15  
**Source**: Claude Code v2.1.108 GitHub release notes  
**Version**: v2.1.108 (April 14, 2026)  
**Type**: Native Claude Code Enhancement  
**Status**: APPROVED

---

## What It Is

The model can now **discover and invoke built-in slash commands** via the Skill tool, not just user-defined skills. Specifically called out in the changelog:

> "The model can now discover and invoke built-in slash commands like `/init`, `/review`, and `/security-review` via the Skill tool"

**Before v2.1.108**: Skill tool only exposed user-defined skills from `~/.claude/skills/` and plugin-provided skills. Built-in slash commands (`/init`, `/review`, `/security-review`, etc.) required explicit user invocation.

**After v2.1.108**: Built-in slash commands are discoverable by the model via the Skill tool. The model can autonomously invoke them as part of agent workflows.

---

## Why It Matters

This is a **significant agent autonomy expansion**. Built-in commands include:

| Command | Purpose | Agent Use Case |
|---------|---------|----------------|
| `/init` | Initialize CLAUDE.md for a new project | `feature-implementer` agent auto-initializing context |
| `/review` | Code review skill | `code-reviewer` agent self-invoking the skill |
| `/security-review` | Security audit | `security-auditor` agent autonomous audit trigger |

Previously, these could only be triggered by the user typing the slash command. Now:
- A `feature-implementer` subagent can invoke `/init` to bootstrap project context before starting work
- A `code-reviewer` subagent can invoke `/review` on a specific PR as part of its workflow
- The `security-auditor` can invoke `/security-review` autonomously on changed files
- The evolution heartbeat can invoke `/security-review` on new discoveries without user input

---

## Redundancy Check

Existing capabilities:
- User-defined skills via Skill tool — DIFFERENT (user-defined vs built-in commands)
- Manual slash command invocation — DIFFERENT (requires user typing)
- Agent spawning via Task tool — DIFFERENT (spawns a new agent, doesn't invoke built-in commands)

**NOVEL** — no existing mechanism allows the model to invoke built-in Claude Code commands autonomously.

---

## Open Questions (for integration step)

- What built-ins are discoverable? The changelog mentions `/init`, `/review`, `/security-review` — likely more.
- Permission model: does autonomous invocation require user approval?
- Interaction with `disableSkillShellExecution`: does it restrict model-invoked built-ins?

---

## Evaluation

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 85 | Automatic — no config needed; agent prompts may need updating to reference the new capability |
| Token efficiency impact | 70 | More powerful agents = more token-efficient per task |
| Capability expansion | 95 | Significant new agent autonomy class — built-in commands now part of autonomous workflows |
| Maintenance burden | 85 | Agent definitions may need updating to leverage; official Anthropic feature |
| Community validation | 85 | Official Anthropic (v2.1.108 release) |

**Total**: (85×0.20) + (70×0.25) + (95×0.25) + (85×0.15) + (85×0.15) = 17 + 17.5 + 23.75 + 12.75 + 12.75 = **83.75**

**Decision**: APPROVED

**Reasoning**: Official Anthropic v2.1.108 feature. Highest capability expansion score (95) among this batch — built-in command autonomy is a qualitative shift in what agents can do. Integration path: update agent definitions (`code-reviewer`, `security-auditor`, `feature-implementer`) to leverage built-in skill invocation; document in registry under "Skill Tool". No env vars or config changes — no safety test required.

**Evaluated**: 2026-04-15
