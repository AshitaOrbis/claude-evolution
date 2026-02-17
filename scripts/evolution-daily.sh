#!/bin/bash
# Daily capability discovery, evaluation, and integration heartbeat
# Run manually or via cron: 0 6 * * * /path/to/claude-evolution/scripts/evolution-daily.sh

set -euo pipefail

# Resolve paths relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVOLUTION_DIR="$(dirname "$SCRIPT_DIR")"

# Load config
if [[ -f "$EVOLUTION_DIR/.env" ]]; then
    set -a
    source "$EVOLUTION_DIR/.env"
    set +a
fi

# Ensure PATH includes user binaries for cron environment
export PATH="$HOME/.local/bin:$PATH"

LOG_DIR="$EVOLUTION_DIR/logs"
LOG_FILE="$LOG_DIR/daily-$(date +%Y%m%d).log"

mkdir -p "$LOG_DIR"

log() { echo "$(date -Iseconds) $1" | tee -a "$LOG_FILE"; }

log "Starting daily evolution heartbeat..."

# Pre-flight check
if ! command -v claude &>/dev/null; then
    log "ERROR: Claude CLI not found. Install from https://claude.ai/claude-code"
    exit 1
fi

# Lock to prevent parallel runs
LOCK_FILE="/tmp/evolution-daily.lock"
if [[ -f "$LOCK_FILE" ]]; then
    lock_age=$(($(date +%s) - $(stat -c %Y "$LOCK_FILE")))
    if [[ $lock_age -gt 3600 ]]; then
        rm -f "$LOCK_FILE"
    else
        log "Another run in progress, exiting"
        exit 0
    fi
fi
touch "$LOCK_FILE"
trap "rm -f '$LOCK_FILE'" EXIT

cd "$EVOLUTION_DIR"

# Phase 1: Discovery
log "Phase 1: Running capability discovery..."
claude -p \
    --model "${DISCOVERY_MODEL:-sonnet}" \
    --max-turns 30 \
    --allowed-tools Read Write Bash Glob Grep \
    -- "Execute the tasks in HEARTBEAT-DAILY.md. Current date: $(date -I). Save report to pipeline/discovery/daily/$(date +%Y%m%d).md" \
    >> "$LOG_FILE" 2>&1

# Phase 2: Evaluate pending items
log "Phase 2: Running evaluations..."
EVAL_OUTPUT=$(claude -p \
    --model "${EVAL_MODEL:-sonnet}" \
    --max-turns 30 \
    --allowed-tools Read Write Bash Glob Grep WebFetch WebSearch \
    -- "Execute the tasks in EVALUATE-PENDING.md. Current date: $(date -I)." \
    2>&1) || true
echo "$EVAL_OUTPUT" >> "$LOG_FILE"

# Extract evaluation summary
EVAL_COUNT=$(echo "$EVAL_OUTPUT" | python3 -c '
import sys, json
last = "{}"
for line in sys.stdin:
    line = line.strip()
    if "evaluated" in line:
        try:
            d = json.loads(line)
            if "evaluated" in d:
                last = line
        except (json.JSONDecodeError, ValueError):
            pass
d = json.loads(last)
print(d.get("evaluated", 0))
' 2>/dev/null || echo "0")

log "Evaluated: $EVAL_COUNT items"

# Phase 3: Integrate approved items
log "Phase 3: Running integrations..."
INTEG_OUTPUT=$(claude -p \
    --model "${EVAL_MODEL:-sonnet}" \
    --max-turns 35 \
    --allowed-tools Read Write Edit Bash Glob Grep \
    -- "Execute the tasks in INTEGRATE-APPROVED.md. Current date: $(date -I)." \
    2>&1) || true
echo "$INTEG_OUTPUT" >> "$LOG_FILE"

# Phase 4: Generate helpers
log "Phase 4: Generating helpers..."
claude -p \
    --model haiku \
    --max-turns 20 \
    --allowed-tools Read Write Glob Grep Bash \
    -- "Execute GENERATE-HELPERS.md. Date: $(date -I). Log: $LOG_FILE" \
    >> "$LOG_FILE" 2>&1 || true

# Optional: Discord notification
if [[ -n "${DISCORD_WEBHOOK_URL:-}" ]]; then
    REPORT_FILE="pipeline/discovery/daily/$(date +%Y%m%d).md"
    if [[ -f "$REPORT_FILE" ]]; then
        SUMMARY=$(head -20 "$REPORT_FILE")
        curl -s -H "Content-Type: application/json" \
            -d "$(jq -n --arg title "Daily Discovery - $(date +%Y-%m-%d)" --arg desc "$SUMMARY" \
            '{embeds: [{title: $title, description: $desc, color: 3447003}]}')" \
            "$DISCORD_WEBHOOK_URL" || log "WARNING: Discord webhook failed (non-fatal)"
    fi
fi

log "Daily heartbeat completed"
