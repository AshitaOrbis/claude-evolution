#!/bin/bash
# Weekly deeper analysis, cleanup, and insights generation
# Run manually or via cron: 0 8 * * 0 /path/to/claude-evolution/scripts/evolution-weekly.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVOLUTION_DIR="$(dirname "$SCRIPT_DIR")"

# Load config.
# SECURITY WARNING: .env is sourced as shell code -- anything in it executes
# with your privileges. Keep it user-owned and non-writable by group/others,
# and never let automation write to it. See SECURITY.md ("Configuration loading").
if [[ -f "$EVOLUTION_DIR/.env" ]]; then
    if [[ ! -O "$EVOLUTION_DIR/.env" ]]; then
        echo "ERROR: $EVOLUTION_DIR/.env is not owned by the current user; refusing to source it" >&2
        exit 1
    fi
    env_mode="$(stat -c %a "$EVOLUTION_DIR/.env")"
    if (( (8#$env_mode & 8#022) != 0 )); then
        echo "ERROR: $EVOLUTION_DIR/.env is writable by group/others (mode $env_mode); refusing to source it. Fix with: chmod 600 '$EVOLUTION_DIR/.env'" >&2
        exit 1
    fi
    set -a
    # shellcheck source=/dev/null
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

# Lock to prevent parallel runs (atomic flock in a private runtime dir, not /tmp)
RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution"
install -d -m 700 "$RUNTIME_DIR"
LOCK_FILE="$RUNTIME_DIR/evolution-weekly.lock"
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
    log "Another run in progress, exiting"
    exit 0
fi

cd "$EVOLUTION_DIR"

# Weekly analysis: review the week's discoveries and integrations.
# Read/Write/Glob/Grep only -- the weekly report needs no Bash or web access.
log "Running weekly analysis..."
claude -p \
    --model "${EVAL_MODEL:-sonnet}" \
    --max-turns 40 \
    --allowed-tools Read Write Glob Grep \
    -- "Execute HEARTBEAT-WEEKLY.md. Current date: $(date -I). Generate weekly report." \
    >> "$LOG_FILE" 2>&1

# Cleanup stale evaluations
log "Cleaning up stale pipeline items..."
find pipeline/evaluation/pending -name "*.json" -mtime +14 -exec mv -t pipeline/evaluation/completed/ {} + 2>/dev/null || true

log "Weekly heartbeat completed"
