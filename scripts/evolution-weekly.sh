#!/bin/bash
# Weekly deeper analysis, cleanup, and insights generation
# Run manually or via cron: 0 8 * * 0 /path/to/claude-evolution/scripts/evolution-weekly.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVOLUTION_DIR="$(dirname "$SCRIPT_DIR")"

if [[ -f "$EVOLUTION_DIR/.env" ]]; then
    set -a
    source "$EVOLUTION_DIR/.env"
    set +a
fi

export PATH="$HOME/.local/bin:$PATH"

LOG_DIR="$EVOLUTION_DIR/logs"
LOG_FILE="$LOG_DIR/weekly-$(date +%Y%m%d).log"

mkdir -p "$LOG_DIR"

log() { echo "$(date -Iseconds) $1" | tee -a "$LOG_FILE"; }

log "Starting weekly evolution heartbeat..."

if ! command -v claude &>/dev/null; then
    log "ERROR: Claude CLI not found"
    exit 1
fi

LOCK_FILE="/tmp/evolution-weekly.lock"
if [[ -f "$LOCK_FILE" ]]; then
    lock_age=$(($(date +%s) - $(stat -c %Y "$LOCK_FILE")))
    if [[ $lock_age -gt 7200 ]]; then
        rm -f "$LOCK_FILE"
    else
        log "Another run in progress, exiting"
        exit 0
    fi
fi
touch "$LOCK_FILE"
trap "rm -f '$LOCK_FILE'" EXIT

cd "$EVOLUTION_DIR"

# Weekly analysis: review the week's discoveries and integrations
log "Running weekly analysis..."
claude -p \
    --model "${EVAL_MODEL:-sonnet}" \
    --max-turns 40 \
    -- "Execute HEARTBEAT-WEEKLY.md. Current date: $(date -I). Generate weekly report." \
    >> "$LOG_FILE" 2>&1

# Cleanup stale evaluations
log "Cleaning up stale pipeline items..."
find pipeline/evaluation/pending -name "*.json" -mtime +14 -exec mv {} pipeline/evaluation/completed/ \; 2>/dev/null || true

log "Weekly heartbeat completed"
