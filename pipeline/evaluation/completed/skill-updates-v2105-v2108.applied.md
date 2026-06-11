**Triage 2026-06-10**: needs user decision because this bundle is partially superseded — §19 (plugin `monitors`) documents top-level manifest syntax that v2.1.129 deprecated (`monitors` now belongs under `"experimental": { ... }`; top-level still works but `claude plugin validate` warns), so applying it verbatim would write stale docs into hook-lifecycle. Parts 1 (EnterWorktree `path`, verified live in the v2.1.172 tool schema + changelog v2.1.105) and §18 (PreCompact blocking, verified in changelog, no later reversal) are accurate and still unapplied — recommend splitting: apply 1 + §18, rewrite §19 for the experimental-key syntax, treat part 3 (agent description notes) as optional per its own wording.

# Skill/Agent Update Proposals (v2.1.105 + v2.1.108)

These updates were blocked by the system file guard (files outside ~/claudeworkspace/).
Apply manually to complete the integrations.

---

## 1. `~/.claude/skills/using-git-worktrees/SKILL.md`

**Why**: EnterWorktree `path` parameter (v2.1.105) enables entering existing worktrees.
The skill references this capability in the registry but the skill file lacks documentation.

**Add to end of file** (after the `isolation: worktree` comparison table):

```markdown
## EnterWorktree `path` Parameter (v2.1.105+)

The built-in `EnterWorktree` tool gained a `path` parameter in v2.1.105, enabling agents
to switch INTO an existing worktree rather than always creating a new one.

**Use cases:**
- **Cross-session resume**: Agent B enters a worktree created by Agent A in a prior session
- **Human-created worktrees**: CI or human creates the worktree; agent enters it cleanly via tool API
- **Multi-agent coordination**: Agent A creates worktree → passes path to Agent B → Agent B enters same isolated branch

```python
# Enter an existing worktree (v2.1.105+)
EnterWorktree(path="/absolute/path/to/existing-worktree")

# Create a new worktree (original behavior, unchanged)
EnterWorktree()  # auto-creates isolated worktree
```

**Before v2.1.105**: Agents used `Bash("cd <path>")` to enter existing worktrees, bypassing
the tool API and losing paired `ExitWorktree` cleanup.

**After v2.1.105**: `EnterWorktree(path: ...)` switches into the existing worktree cleanly,
with proper `ExitWorktree` symmetry.
```

---

## 2. `~/.claude/skills/hook-lifecycle/SKILL.md`

**Why**: The registry documents PreCompact blocking (v2.1.105) as "§18" and Plugin monitors
(v2.1.105) as "§19" but these sections don't exist in the skill file yet (last section is §17).

**Add after section 17 (PreToolUse defer)**:

### 18. PreCompact Hook Blocking (v2.1.105+)

```markdown
### 18. PreCompact Hook Blocking (v2.1.105+)

PreCompact hooks can now **block compaction** by returning exit code 2 or the structured
response `{"decision":"block"}`.

**Before v2.1.105**: PreCompact was notification-only — it could backup transcripts but
could not prevent compaction from occurring.

**After v2.1.105**: PreCompact becomes a control hook; exit code 2 = block compaction
(same semantic as PreToolUse blocking).

**Two return forms**:
```python
# Option A: Exit code 2 (idiomatic)
sys.exit(2)

# Option B: Structured JSON
print(json.dumps({"decision": "block"}))
sys.exit(0)
```

**Example: Block during active iterative-improve loop**:
```bash
#!/bin/bash
set -euo pipefail
# Block compaction when iterative-improve loop is active
STATE_FILE="$HOME/.claude/hooks/iterative-loop/state.json"
if [ -f "$STATE_FILE" ]; then
    ACTIVE=$(python3 -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('active','false'))" 2>/dev/null || echo "false")
    if [ "$ACTIVE" = "True" ] || [ "$ACTIVE" = "true" ]; then
        echo '{"decision":"block"}' >&1
        echo "[PreCompact] Blocked: iterative-improve loop is active" >&2
        exit 0
    fi
fi
exit 0
```

**Use cases**:
- Block during irreversible operation sequences (deployment, database migration)
- Block when active subagents depend on conversation context
- Block during evolution pipeline integration phase to preserve plan context
- Block if context contains unsaved discovery work
```

### 19. Plugin `monitors` Manifest Key (v2.1.105+)

```markdown
### 19. Plugin `monitors` Manifest Key (v2.1.105+)

A new top-level `monitors` key in the plugin manifest. Background monitors declared here
**auto-arm at session start** or when the skill is invoked.

**Key difference from Monitor Tool (v2.1.98)**:

| Aspect | Monitor Tool | `monitors` Manifest Key |
|--------|-------------|------------------------|
| Activation | Explicit agent tool call | Declarative — automatic |
| Lifecycle | Per-invocation | Session start or skill invoke |
| Config location | Runtime conversation | Plugin manifest (static) |

**Manifest example** (exact syntax — verify against official docs before implementing):
```yaml
---
name: my-plugin
monitors:
  - command: "tail -f /tmp/my-pipeline.log"
    label: "pipeline-monitor"
---
```

**Use cases for evolution pipeline**:
- `capability-discoverer` plugin: auto-monitor feed aggregator for new discoveries
- `evolution-orchestrator`: auto-monitor event bus without explicit Monitor tool calls
- Heartbeat scripts: monitor version-tracker output and pipe to evolution pipeline

**Open questions** (verify empirically):
1. Does "session start" mean all installed plugins' monitors start, or only invoked plugins?
2. What stops the monitor — session end? Explicit stop? Skill deinvoke?
3. Interaction with `CLAUDE_CODE_DISABLE_CRON` — does it suppress monitors too?
```

Also update the **Common Use Cases** table at the bottom, adding:
```
| Block compaction during critical ops | PreCompact (v2.1.105+) | Exit code 2 or `{"decision":"block"}` |
| Declarative background monitoring | plugin `monitors` key (v2.1.105+) | Auto-arms at session start |
```

And update the hook file list under `## Hook Configuration`:
```
├── PreCompact.py       # Now supports blocking via exit code 2 (v2.1.105+)
```

---

## 3. Agent Definitions (model-invokable built-ins, v2.1.108)

The registry notes "Updated agents: code-reviewer, security-auditor, feature-implementer"
but those updates haven't been applied. The capability is automatic (no config needed),
so this is documentation-only.

**Optional** — add to each agent's description or instructions a note like:
- `code-reviewer`: Can invoke the built-in `/review` skill autonomously via the Skill tool (v2.1.108+)
- `security-auditor`: Can invoke `/security-review` autonomously via the Skill tool (v2.1.108+)
- `feature-implementer`: Can invoke `/init` autonomously via the Skill tool (v2.1.108+)

---

**Status**: pending_approval (files outside ~/claudeworkspace/)
**Created**: 2026-04-16


**Approved by human via Discord reaction** (2026-06-11) — ready to apply.


**Applied 2026-06-11 (split per triage)**: Section 1 (EnterWorktree path) appended to using-git-worktrees skill; §18 (PreCompact blocking) and §19 (rewritten for the v2.1.129 experimental-key syntax) appended to hook-lifecycle skill, plus Common Use Cases rows. Part 3 (agent description notes) skipped — optional per its own wording and the capability is automatic.
