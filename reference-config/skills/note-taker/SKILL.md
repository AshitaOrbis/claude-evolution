# Note Taker Skill

A skill for managing persistent notes across Claude Code sessions.

## Description

This skill helps Claude capture and persist important information discovered during coding sessions so it's available in future conversations. Notes can be added to project-level files (CLAUDE.md) or user-level files (~/.claude/CLAUDE.md).

## When to Use

Invoke this skill when:
- Important configuration or deployment details are discovered
- Troubleshooting reveals critical information that should be remembered
- User explicitly asks to "remember this" or "make a note"
- Session is ending and context should be preserved
- Lessons learned from debugging should be documented

## Instructions

### Adding Notes

1. **Determine the scope:**
   - **Project-specific** notes go in `./CLAUDE.md` or `./.claude/CLAUDE.md`
   - **Personal/global** notes go in `~/.claude/CLAUDE.md`
   - **Private project** notes go in `./CLAUDE.local.md` (auto-gitignored)

2. **Format notes clearly:**
   - Use descriptive headings
   - Include dates for time-sensitive info
   - Use tables for configuration values
   - Include code blocks for commands

3. **Categorize appropriately:**
   - Deployment/Infrastructure notes
   - Configuration values
   - Troubleshooting solutions
   - Important commands
   - Lessons learned

### Quick Note Syntax

For quick additions, use the `#` shortcut in Claude Code:
```
# Always use SPA type for Azure B2C redirect URIs with MSAL.js
```

### Note Structure Template

```markdown
## [Category] - [Brief Description]

**Added:** [Date]
**Context:** [Why this is important]

### Details
[Structured information here]

### Related
- Links to docs or files
```

## Examples

### Example 1: Recording Deployment Configuration
```markdown
## Azure Deployment Configuration (Dev Environment)

**Added:** 2025-12-07

| Resource | Value |
|----------|-------|
| Frontend URL | https://example-frontend.azurewebsites.net |
| Backend URL | https://example-backend.azurewebsites.net |
| ACR | example.azurecr.io |
```

### Example 2: Documenting a Gotcha
```markdown
## Important: Azure B2C Propagation Delay

**Added:** 2025-12-07

Azure AD B2C takes **45-60 minutes** to propagate redirect URI changes.
If authentication redirects fail after updating URIs, wait and retry.
```

### Example 3: Recording Troubleshooting Solution
```markdown
## Fix: Next.js NEXT_PUBLIC_* Variables in Docker

**Problem:** Environment variables not available at runtime
**Solution:** NEXT_PUBLIC_* vars must be set at Docker BUILD time using --build-arg

```bash
docker build --build-arg NEXT_PUBLIC_API_URL=https://api.example.com ...
```
```

## Best Practices

1. **Be specific:** "Use 2-space indentation" is better than "Format code properly"
2. **Include context:** Explain WHY something is important
3. **Keep notes lean:** Only essential information that's needed across sessions
4. **Update periodically:** Remove outdated information
5. **Use imports:** Reference external docs with `@path/to/file` syntax

## Files Modified

When this skill is invoked, it may read or modify:
- `./CLAUDE.md` - Project memory (shared with team)
- `./CLAUDE.local.md` - Project memory (personal, gitignored)
- `~/.claude/CLAUDE.md` - User memory (all projects)
