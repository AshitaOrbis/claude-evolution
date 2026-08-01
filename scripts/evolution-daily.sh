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
    >> "$LOG_FILE" 2>&1 || log "WARNING: discovery phase exited nonzero (see log)."

# Phase 2: Evaluate pending items
# Pre-screen first: the evaluation agent here runs without Bash, so it cannot invoke
# the owner-interest lens itself. Stamping the pending records is how the override
# reaches it; the sweep after Phase 2 is what actually enforces the outcome.
mapfile -t PENDING_FILES < <(find pipeline/evaluation/pending -maxdepth 1 -type f \
    \( -name '*.md' -o -name '*.json' \) 2>/dev/null)
if [[ ${#PENDING_FILES[@]} -gt 0 ]]; then
    log "Pre-screening ${#PENDING_FILES[@]} pending item(s) through the owner-interest lens..."
    python3 lib/owner_interest_lens.py stamp --apply "${PENDING_FILES[@]}" >> "$LOG_FILE" 2>&1 \
        || log "WARNING: owner-interest pre-screen failed; continuing."
fi

log "Phase 2: Running evaluations..."
EVAL_RC=0
EVAL_OUTPUT=$(claude -p \
    --model "${EVAL_MODEL:-sonnet}" \
    --max-turns 30 \
    --allowed-tools "${EVAL_TOOLS[@]}" \
    -- "Execute the tasks in EVALUATE-PENDING.md. Current date: $(date -I)." \
    2>&1) || EVAL_RC=$?
echo "$EVAL_OUTPUT" >> "$LOG_FILE"
if [[ $EVAL_RC -ne 0 ]]; then
    log "WARNING: evaluation phase exited $EVAL_RC (see log). Integration phase will be skipped this run."
fi

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

# Owner-interest gate (backstop). The prompt override in EVALUATE-PENDING.md can be
# ignored; this cannot. Any reject just closed that lands in a domain the owner works
# in is reopened into pipeline/evaluation/review/ instead of staying closed. Registry
# row 145 — three owner-shared repos were closed as "irrelevant to Claude Code" and
# never resurfaced. Idempotent, no LLM, scoped to the last week of records.
log "Running owner-interest gate over recent rejects..."
GATE_OUTPUT=$(python3 lib/owner_interest_lens.py sweep --apply --since-days 7 2>&1) \
    || log "WARNING: owner-interest gate failed — rejects from this run are UNSCREENED."
echo "$GATE_OUTPUT" >> "$LOG_FILE"
log "Owner-interest gate: ${GATE_OUTPUT%%$'\n'*}"

# Phase 3: Integrate approved items (autonomous mode only)
if [[ "$AUTONOMOUS" == "1" && $EVAL_RC -eq 0 ]]; then
    log "Phase 3: Running integrations..."
    INTEG_RC=0
    INTEG_OUTPUT=$(claude -p \
        --model "${EVAL_MODEL:-sonnet}" \
        --max-turns 35 \
        --allowed-tools Read Write Edit Bash Glob Grep \
        -- "Execute the tasks in INTEGRATE-APPROVED.md. Current date: $(date -I)." \
        2>&1) || INTEG_RC=$?
    echo "$INTEG_OUTPUT" >> "$LOG_FILE"
    [[ $INTEG_RC -ne 0 ]] && log "WARNING: integration phase exited $INTEG_RC (see log)."
elif [[ "$AUTONOMOUS" == "1" ]]; then
    log "Phase 3: SKIPPED — evaluation phase failed (exit $EVAL_RC); not integrating on a failed eval."
else
    PENDING_INTEGRATIONS=$(find pipeline/integration -name '*.json' -type f 2>/dev/null | wc -l)
    log "Phase 3: SKIPPED (review-gated mode). $PENDING_INTEGRATIONS approved item(s) await human review in pipeline/integration/."
    log "         Review them, then integrate manually or re-run with EVOLUTION_AUTONOMOUS=1 (see SECURITY.md)."
fi

# Phase 4: Generate helpers (log extraction only -- no Bash needed).
# Soft-fail: helper generation is best-effort and must not fail the heartbeat,
# but a failure is logged rather than silently discarded.
log "Phase 4: Generating helpers..."
claude -p \
    --model haiku \
    --max-turns 20 \
    --allowed-tools Read Write Glob Grep \
    -- "Execute GENERATE-HELPERS.md. Date: $(date -I). Log: $LOG_FILE" \
    >> "$LOG_FILE" 2>&1 || log "WARNING: helper generation failed (non-fatal)."

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
