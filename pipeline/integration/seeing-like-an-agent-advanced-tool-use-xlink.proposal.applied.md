# Proposal: Add "Tool & Skill Authoring" Section to advanced-tool-use SKILL.md

**Item**: seeing-like-an-agent-tool-design-2026-04-20  
**Type**: skill cross-link  
**Status**: applied  
**Created**: 2026-04-20  
**File to modify**: `~/.claude/skills/advanced-tool-use/SKILL.md` (outside ~/claudeworkspace/)

**Resolved 2026-06-10**: Applied as proposed — added as `## 7. Tool & Skill Authoring` after the current Section 6 (Maintenance Philosophy, added since this proposal was written; Evidence-Based File Organization is now §5) and before Efficiency Metrics. Technique doc `library/techniques/seeing-like-an-agent-tool-design-2026-04-20.md` verified present; no §7 / progressive-disclosure section previously existed.

---

## What Changes

Add a new **Section 7: Tool & Skill Authoring (Progressive Disclosure)** to `~/.claude/skills/advanced-tool-use/SKILL.md`, after the existing Section 6 (Evidence-Based File Organization).

---

## Exact Content to Add

```markdown
---

## 7. Tool & Skill Authoring — Progressive Disclosure Principle

Source: [Seeing Like an Agent — Anthropic Engineering](https://claude.com/blog/seeing-like-an-agent) (2026-04-10)  
Full technique doc: `library/techniques/seeing-like-an-agent-tool-design-2026-04-20.md`

When writing SKILL.md files, agent descriptions, or MCP tool descriptions, the **progressive disclosure principle** applies: design from the agent's perceptual model, not a human's.

### SKILL.md Authoring

| Old pattern | New pattern (progressive disclosure) |
|-------------|--------------------------------------|
| Long system-level overview first | Decision tree / quick reference first |
| Explain every option and edge case | Document the 80% case; link full details below |
| Vague "use when needed" trigger | Explicit: "Trigger when [condition]" |
| Implementation-first description | Use-case-first: "This skill handles [Y]" |

The model perceives skills as tools — tool design principles apply directly.

### Agent Frontmatter `description` Field

The `description` field is the **discoverability surface**. Write it as:
> "Use this agent when [trigger condition]" — not "This agent does [implementation]"

### MCP Tool Description Writing

For any tool Claude needs to discover and invoke:
1. Lead with: "Use this when [specific trigger condition]"
2. Describe output format: "Returns [summary / structured JSON / etc.]"
3. Name parameters for self-documentation (`target_directory`, not `td`)
4. Test: strip the implementation — does the description alone tell Claude when to use it?

### The "Only This" Test

For every tool/skill result, ask: "If this were the ONLY thing Claude could see, could it take the correct next action?"

Tools that fail this test need their output restructured — usually by leading with an actionable summary.

### Relationship to Existing Patterns

- **Tool Search Tool** (v2.1.7+): Progressive disclosure is the supply-side complement to Tool Search's demand-side filtering. Well-described tools are found reliably; poorly-described tools are missed.
- **2KB skill cap + decision-tree-first layout**: These existing conventions ARE implementations of progressive disclosure — now with first-principles justification from Anthropic Engineering.
```

---

## Why This Requires Approval

`~/.claude/skills/advanced-tool-use/SKILL.md` is outside `~/claudeworkspace/` and directly modifies global Claude Code behavior. Per System File Guard, changes to `~/.claude/` require human approval.

---

## Impact Assessment

- **Low risk**: Documentation-only addition, no behavioral change, no env vars, no settings changes
- **High value**: Cross-links first-party Anthropic design principles to the most-used skill in the system
- **Size**: ~55 lines added to end of file (well under 2KB)
