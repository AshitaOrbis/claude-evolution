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

# Empty MCP set for every headless phase below. Written per run into the private
# runtime dir so a clone needs no file from outside its own checkout: every
# `claude -p` call here pins `--strict-mcp-config --mcp-config "$MCP_EMPTY"`,
# which suppresses whatever ambient .mcp.json the parent directory carries.
MCP_EMPTY="$RUNTIME_DIR/mcp-empty.json"
printf '{"mcpServers":{}}\n' > "$MCP_EMPTY"

cd "$EVOLUTION_DIR"

# ---------------------------------------------------------------------------
# Preflight: refuse to evaluate without the deterministic controls this run
# claims to apply (claude.owner_interest_gate_absent_03).
#
# Both the pre-screen and the post-evaluation backstop call the owner-interest
# lens. When the lens or its config was absent, both calls soft-failed and the
# run still ended "Daily heartbeat completed" — a heartbeat reporting health for
# a run whose only deterministic control never executed, while rejects closed
# terminally. Missing or unreadable now refuses the run BEFORE evaluation.
# ---------------------------------------------------------------------------
OWNER_LENS="lib/owner_interest_lens.py"
OWNER_LENS_CONFIG="config/owner-interests.yaml"
preflight_missing=()
[[ -r "$OWNER_LENS" ]]        || preflight_missing+=("$OWNER_LENS")
[[ -r "$OWNER_LENS_CONFIG" ]] || preflight_missing+=("$OWNER_LENS_CONFIG")
command -v python3 &>/dev/null || preflight_missing+=("python3 (interpreter)")
if [[ ${#preflight_missing[@]} -gt 0 ]]; then
    log "ERROR: the owner-interest gate is unavailable — missing or unreadable: ${preflight_missing[*]}"
    log "       Refusing the WHOLE run, discovery included — not just the evaluation phase."
    log "       Evaluation would close rejects unscreened, which is the exact failure this gate"
    log "       exists to prevent (see EVALUATE-PENDING.md, 'Owner-Interest Override'); running"
    log "       discovery first and aborting after it would spend a full model run to reach the"
    log "       same refusal. No pipeline state was touched (only this log and the run lock)."
    log "       Restore the file(s), or remove the gate from this wrapper AND from EVALUATE-PENDING.md."
    exit 1
fi

# Tool allowlists.
# Review-gated default: agents get no Bash, and integration is skipped.
# EVOLUTION_AUTONOMOUS=1 restores fully autonomous behavior (see SECURITY.md).
AUTONOMOUS="${EVOLUTION_AUTONOMOUS:-0}"
if [[ "$AUTONOMOUS" == "1" ]]; then
    # Autonomous mode is the only mode that lets an agent write to your live Claude
    # Code config, and the empirical safety test is what stands between a changelog
    # claim and a 12-day permission outage. Refuse the mode outright when that
    # component is absent rather than letting the integration prompt call a program
    # that is not there (claude.approval_gate_not_published_04).
    autonomous_missing=()
    [[ -r scripts/sandbox-test-integration.sh ]] || autonomous_missing+=("scripts/sandbox-test-integration.sh")
    if [[ ${#autonomous_missing[@]} -gt 0 ]]; then
        log "ERROR: EVOLUTION_AUTONOMOUS=1 but the integration safety components are unavailable: ${autonomous_missing[*]}"
        log "       Refusing to run autonomously. INTEGRATE-APPROVED.md requires the sandbox test before"
        log "       any env-var or config change is proposed; without it the safeguard is a claim, not a control."
        log "       Re-run in the default review-gated mode (unset EVOLUTION_AUTONOMOUS), or restore the file."
        exit 1
    fi
    # Proposals wait here for a human; create it rather than failing on missing output state.
    mkdir -p pipeline/pending-approval
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
    --strict-mcp-config --mcp-config "$MCP_EMPTY" \
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
GATE_FAILED=0
if [[ ${#PENDING_FILES[@]} -gt 0 ]]; then
    log "Pre-screening ${#PENDING_FILES[@]} pending item(s) through the owner-interest lens..."
    if ! python3 "$OWNER_LENS" stamp --apply "${PENDING_FILES[@]}" >> "$LOG_FILE" 2>&1; then
        log "ERROR: owner-interest pre-screen FAILED — the ${#PENDING_FILES[@]} pending item(s) reach the evaluator UNSCREENED."
        GATE_FAILED=1
    fi
fi

log "Phase 2: Running evaluations..."
EVAL_RC=0
EVAL_OUTPUT=$(claude -p \
    --strict-mcp-config --mcp-config "$MCP_EMPTY" \
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
GATE_RC=0
GATE_OUTPUT=$(python3 "$OWNER_LENS" sweep --apply --since-days 7 2>&1) || GATE_RC=$?
echo "$GATE_OUTPUT" >> "$LOG_FILE"
if [[ $GATE_RC -ne 0 ]]; then
    log "ERROR: owner-interest gate FAILED (exit $GATE_RC) — rejects from this run are UNSCREENED."
    GATE_FAILED=1
else
    log "Owner-interest gate: ${GATE_OUTPUT%%$'\n'*}"
fi

# Phase 3: Integrate approved items (autonomous mode only)
if [[ "$AUTONOMOUS" == "1" && $EVAL_RC -eq 0 ]]; then
    log "Phase 3: Running integrations..."
    INTEG_RC=0
    INTEG_OUTPUT=$(claude -p \
        --strict-mcp-config --mcp-config "$MCP_EMPTY" \
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
    --strict-mcp-config --mcp-config "$MCP_EMPTY" \
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

# A heartbeat that says "completed" after its deterministic control was bypassed is
# the defect this gate was built to catch, one level up. Report what actually ran.
if [[ $GATE_FAILED -ne 0 ]]; then
    log "Daily heartbeat FAILED: the owner-interest gate did not run to completion; this run's rejects are UNSCREENED."
    log "         Re-run the gate manually once fixed: python3 $OWNER_LENS sweep --apply --since-days 7"
    exit 1
fi

log "Daily heartbeat completed"
