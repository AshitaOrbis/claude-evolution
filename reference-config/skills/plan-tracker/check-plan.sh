#!/bin/bash
# Plan Tracker - Session Start Hook
# Checks for incomplete plans and notifies

set -euo pipefail

STATE_FILE="$HOME/.claude/plan-state.json"

# Strip terminal control characters from untrusted JSON-derived text before
# printing -- prevents ANSI/OSC escape injection into the terminal
sanitize() {
  LC_ALL=C tr -d '\000-\010\013\014\016-\037\177'
}

if [ -f "$STATE_FILE" ]; then
  ACTIVE=$(jq -r '.active_plan.name // empty' "$STATE_FILE" 2>/dev/null | sanitize || true)
  if [ -n "$ACTIVE" ]; then
    PENDING=$(jq '[.active_plan.steps[] | select(.status != "completed")] | length' "$STATE_FILE" 2>/dev/null || true)
    if [[ "$PENDING" =~ ^[0-9]+$ ]] && [ "$PENDING" -gt 0 ]; then
      LAST=$(jq -r '.active_plan.last_activity // "unknown"' "$STATE_FILE" 2>/dev/null | sanitize || true)
      echo ""
      echo "⚠️  INCOMPLETE PLAN DETECTED"
      echo "   Plan: $ACTIVE"
      echo "   Remaining steps: $PENDING"
      echo "   Last activity: $LAST"
      echo ""
      echo "   Run '/plan-tracker check' for details or continue execution."
      echo ""
    fi
  fi
fi
