#!/bin/bash
# Plan Tracker - Session Start Hook
# Checks for incomplete plans and notifies

STATE_FILE="$HOME/.claude/plan-state.json"

if [ -f "$STATE_FILE" ]; then
  ACTIVE=$(jq -r '.active_plan.name // empty' "$STATE_FILE" 2>/dev/null)
  if [ -n "$ACTIVE" ]; then
    PENDING=$(jq '[.active_plan.steps[] | select(.status != "completed")] | length' "$STATE_FILE" 2>/dev/null)
    if [ "$PENDING" -gt 0 ]; then
      LAST=$(jq -r '.active_plan.last_activity // "unknown"' "$STATE_FILE")
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
