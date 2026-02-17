# Plan Tracker Skill

Track and enforce completion of implementation plans.

## Problem

When Claude creates a plan and the user approves it, sometimes:
- The plan is not executed after approval
- The plan is partially completed and abandoned
- It's unclear what remains from a previous session

## Solution

This skill provides plan state tracking via a state file and hook integration.

## Usage

### Check for Incomplete Plans

```bash
/plan-tracker check
```

Reads `~/.claude/plan-state.json` and reports:
- Active plan name and steps
- Completed vs remaining steps
- Last activity timestamp

### Mark Plan Complete

```bash
/plan-tracker complete
```

Clears the active plan state after all steps are done.

### Register a New Plan

When a plan is approved, register it:

```bash
/plan-tracker register "Plan Name" --steps "Step 1,Step 2,Step 3"
```

Or automatically via the ExitPlanMode hook.

---

## State File Format

Location: `~/.claude/plan-state.json`

```json
{
  "active_plan": {
    "name": "Phase 3 Optimization",
    "created": "2026-01-25T10:30:00Z",
    "steps": [
      {"name": "Step 1: Haiku Baseline", "status": "completed"},
      {"name": "Step 2: Sonnet COPRO", "status": "in_progress"},
      {"name": "Step 3: Skills Optimization", "status": "pending"},
      {"name": "Step 4: Opus Polish", "status": "pending"},
      {"name": "Step 5: Verification", "status": "pending"}
    ],
    "last_activity": "2026-01-25T11:45:00Z"
  }
}
```

---

## Hook Integration

### SessionStart Hook (Recommended)

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/skills/plan-tracker/check-plan.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

This will notify you at session start if there's an incomplete plan.

### Hook Script: check-plan.sh

```bash
#!/bin/bash
STATE_FILE="$HOME/.claude/plan-state.json"

if [ -f "$STATE_FILE" ]; then
  ACTIVE=$(jq -r '.active_plan.name // empty' "$STATE_FILE" 2>/dev/null)
  if [ -n "$ACTIVE" ]; then
    PENDING=$(jq '[.active_plan.steps[] | select(.status != "completed")] | length' "$STATE_FILE")
    if [ "$PENDING" -gt 0 ]; then
      echo "⚠️ INCOMPLETE PLAN: '$ACTIVE' has $PENDING remaining steps"
      echo "Run: /plan-tracker check for details"
    fi
  fi
fi
```

Make executable: `chmod +x ~/.claude/skills/plan-tracker/check-plan.sh`

---

## Commands

| Command | Description |
|---------|-------------|
| `/plan-tracker check` | Show active plan status |
| `/plan-tracker complete` | Mark active plan as complete |
| `/plan-tracker register` | Register a new plan from ExitPlanMode |
| `/plan-tracker step <n>` | Mark step N as completed |
| `/plan-tracker cancel` | Cancel active plan (with reason) |

---

## Best Practices

1. **Always register plans** - When a plan is approved, register it immediately
2. **Update step status** - Mark steps as you complete them
3. **Check at session start** - The hook will remind you of incomplete work
4. **Complete or handoff** - Never leave plans in limbo

## Integration with TaskList

This skill complements the built-in TaskList:
- TaskList: Fine-grained task tracking within a session
- plan-tracker: Cross-session plan state persistence
