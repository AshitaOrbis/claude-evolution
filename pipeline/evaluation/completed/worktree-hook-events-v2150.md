# Discovery: WorktreeCreate and WorktreeRemove Hook Events

**Source**: Claude Code v2.1.50 official release (2026-02-20)
**Discovered**: 2026-02-21
**Type**: IMPROVEMENT (extends existing Hook Lifecycle Architecture)
**Category**: Hook Development Patterns

---

## What It Is

Two new Claude Code lifecycle hook events added in v2.1.50:

- **`WorktreeCreate`**: Fires when agent worktree isolation creates a new git worktree
- **`WorktreeRemove`**: Fires when agent worktree isolation removes a git worktree

These hooks fire specifically around the `isolation: worktree` feature (available since v2.1.49), enabling custom setup and teardown when agents operate in isolated git worktrees.

---

## Why It Matters

### Current State

The Hook Lifecycle skill (`~/.claude/skills/hook-lifecycle/SKILL.md`) documents 13 Claude Code lifecycle hooks. It does NOT currently include WorktreeCreate/WorktreeRemove.

### New Capability

These hooks enable **reproducible agent isolation** with custom environment setup:

```bash
# .claude/settings.json
{
  "hooks": {
    "WorktreeCreate": {
      "shell": "~/.claude/hooks/worktree-setup.sh"
    },
    "WorktreeRemove": {
      "shell": "~/.claude/hooks/worktree-cleanup.sh"
    }
  }
}
```

**Example worktree-setup.sh**:
```bash
#!/bin/bash
# Called after worktree is created
cd "$CLAUDE_WORKTREE_PATH"
npm install          # install dependencies in isolated copy
cp .env.example .env  # setup environment
```

**Example worktree-cleanup.sh**:
```bash
#!/bin/bash
# Called before worktree is removed
cd "$CLAUDE_WORKTREE_PATH"
# cleanup temp artifacts, log results, etc.
```

---

## Use Cases for Evolution Pipeline

1. **Isolated capability testing**: When evaluating MCPs/skills in worktree isolation, hooks can install test fixtures
2. **Agent worktree safety**: WorktreeRemove hook can verify agent made no unintended changes before cleanup
3. **Dependency isolation**: Agents working on different projects get properly isolated environments

---

## Registry Check

- **Hook Lifecycle Architecture**: IMPLEMENTED (`~/.claude/skills/hook-lifecycle/SKILL.md`)
- **WorktreeCreate/WorktreeRemove**: NOT in current documentation (13 hooks listed, these are 2 new ones)
- **Verdict**: IMPROVEMENT — extends documented capability

---

## Evaluation Notes

- **Integration complexity**: LOW — just adding 2 entries to existing hook skill documentation
- **Token efficiency**: Zero (hooks run outside conversation context)
- **Capability expansion**: MODERATE — extends hook system to cover worktree lifecycle
- **Maintenance burden**: LOW — official Anthropic feature, stable API
- **Community validation**: HIGH — official release, well-documented

**Estimated score**: 75-85/100 (IMPROVEMENT to existing high-value skill)

---

## Integration Path

If approved:
1. Open `~/.claude/skills/hook-lifecycle/SKILL.md`
2. Add WorktreeCreate and WorktreeRemove to the hooks table
3. Add example configurations for worktree setup/teardown patterns
4. Update the "13 hooks" count to "15 hooks" in documentation
5. Update registry redundancy triggers with "WorktreeCreate", "WorktreeRemove", "worktree hooks", "worktree lifecycle hooks"
