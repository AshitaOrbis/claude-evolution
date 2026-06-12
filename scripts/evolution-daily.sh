#!/bin/bash
# Daily capability discovery, evaluation, and integration heartbeat
# Run manually or via cron: 0 6 * * * /path/to/claude-evolution/scripts/evolution-daily.sh
#
# SECURITY: By default this script runs in REVIEW-GATED mode: the discovery and
# evaluation agents run without Bash, and the integration phase (which writes
# into your live Claude Code config) is skipped, leaving approved items in
# pipeline/integration/ for human review. Set EVOLUTION_AUTONOMOUS=1 to enable
# fully autonomous integration -- read SECURITY.md first.

set -euo pipefail

# Resolve paths relative to this script
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

# Ensure PATH includes user binaries for cron environment
export PATH="$HOME/.local/bin:$PATH"

LOG_DIR="$EVOLUTION_DIR/logs"
RUN_DATE="$(date +%Y%m%d)"
LOG_FILE="$LOG_DIR/daily-$RUN_DATE.log"

mkdir -p "$LOG_DIR"

log() { echo "$(date -Iseconds) $1" | tee -a "$LOG_FILE"; }

log "Starting daily evolution heartbeat..."

# Pre-flight check
if ! command -v claude &>/dev/null; then
    log "ERROR: Claude CLI not found. Install from https://claude.ai/claude-code"
    exit 1
fi

# Lock to prevent parallel runs.
# Uses flock on a file in a private runtime dir (mode 700), not a predictable
# path in world-writable /tmp, and is atomic (no check-then-create race).
RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution"
install -d -m 700 "$RUNTIME_DIR"
LOCK_FILE="$RUNTIME_DIR/evolution-daily.lock"
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
    log "Another run in progress, exiting"
    exit 0
fi

cd "$EVOLUTION_DIR"

# Tool allowlists.
# Review-gated default: agents get no Bash, and integration is skipped.
# EVOLUTION_AUTONOMOUS=1 restores fully autonomous behavior (see SECURITY.md).
AUTONOMOUS="${EVOLUTION_AUTONOMOUS:-0}"
if [[ "$AUTONOMOUS" == "1" ]]; then
    log "WARNING: EVOLUTION_AUTONOMOUS=1 -- agents run with Bash and integration writes to your Claude Code config. See SECURITY.md."
    DISCOVERY_TOOLS=(Read Write Bash Glob Grep WebFetch WebSearch)
    EVAL_TOOLS=(Read Write Bash Glob Grep WebFetch WebSearch)
else
    DISCOVERY_TOOLS=(Read Write Glob Grep WebFetch WebSearch)
    EVAL_TOOLS=(Read Write Glob Grep WebFetch WebSearch)
fi

# Phase 1: Discovery
log "Phase 1: Running capability discovery..."
claude -p \
    --model "${DISCOVERY_MODEL:-sonnet}" \
    --max-turns 30 \
    --allowed-tools "${DISCOVERY_TOOLS[@]}" \
    -- "Execute the tasks in HEARTBEAT-DAILY.md. Current date: $(date -I). Save report to pipeline/discovery/daily/$RUN_DATE.md" \
    >> "$LOG_FILE" 2>&1

# Phase 2: Evaluate pending items
log "Phase 2: Running evaluations..."
EVAL_OUTPUT=$(claude -p \
    --model "${EVAL_MODEL:-sonnet}" \
    --max-turns 30 \
    --allowed-tools "${EVAL_TOOLS[@]}" \
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

# Phase 3: Integrate approved items (autonomous mode only)
if [[ "$AUTONOMOUS" == "1" ]]; then
    log "Phase 3: Running integrations..."
    INTEG_OUTPUT=$(claude -p \
        --model "${EVAL_MODEL:-sonnet}" \
        --max-turns 35 \
        --allowed-tools Read Write Edit Bash Glob Grep \
        -- "Execute the tasks in INTEGRATE-APPROVED.md. Current date: $(date -I)." \
        2>&1) || true
    echo "$INTEG_OUTPUT" >> "$LOG_FILE"
else
    PENDING_INTEGRATIONS=$(find pipeline/integration -name '*.json' -type f 2>/dev/null | wc -l)
    log "Phase 3: SKIPPED (review-gated mode). $PENDING_INTEGRATIONS approved item(s) await human review in pipeline/integration/."
    log "         Review them, then integrate manually or re-run with EVOLUTION_AUTONOMOUS=1 (see SECURITY.md)."
fi

# Phase 4: Generate helpers (log extraction only -- no Bash needed)
log "Phase 4: Generating helpers..."
claude -p \
    --model haiku \
    --max-turns 20 \
    --allowed-tools Read Write Glob Grep \
    -- "Execute GENERATE-HELPERS.md. Date: $(date -I). Log: $LOG_FILE" \
    >> "$LOG_FILE" 2>&1 || true

# Optional: Discord notification.
# NOTE: this sends the start of the daily report to a third party (Discord).
# Credential-shaped strings and webhook URLs are redacted defensively, but do
# not rely on this as a complete filter -- see SECURITY.md.
if [[ -n "${DISCORD_WEBHOOK_URL:-}" ]]; then
    REPORT_FILE="pipeline/discovery/daily/$RUN_DATE.md"
    if [[ -f "$REPORT_FILE" ]]; then
        SUMMARY=$(head -20 "$REPORT_FILE" \
            | sed -E 's#(https://discord(app)?\.com/api/webhooks/)[^[:space:]]+#\1[REDACTED]#g' \
            | sed -E 's#((api[_-]?key|secret|password|token|bearer)[[:space:]]*[:=][[:space:]]*)[^[:space:]]+#\1[REDACTED]#Ig')
        curl -s -H "Content-Type: application/json" \
            -d "$(jq -n --arg title "Daily Discovery - $(date +%Y-%m-%d)" --arg desc "$SUMMARY" \
            '{embeds: [{title: $title, description: $desc, color: 3447003}]}')" \
            "$DISCORD_WEBHOOK_URL" || log "WARNING: Discord webhook failed (non-fatal)"
    fi
fi

log "Daily heartbeat completed"
