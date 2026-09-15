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

# jq builds the stale-quarantine metadata below; a missing binary must not turn
# the cleanup into an untracked file move.
if ! command -v jq &>/dev/null; then
    log "ERROR: jq not found — required to record stale-item metadata. Install jq."
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

# Empty MCP set for the headless phase below, written per run into the private
# runtime dir so a clone needs no file from outside its own checkout.
MCP_EMPTY="$RUNTIME_DIR/mcp-empty-weekly.json"
printf '{"mcpServers":{}}\n' > "$MCP_EMPTY"

cd "$EVOLUTION_DIR"

# ---------------------------------------------------------------------------
# Preflight: every configured PreToolUse guard must resolve to an executable
# file BEFORE the agent starts (claude.read_hook_missing_public_01). The weekly
# agent holds Write, so the write guard is the one that matters here, but the
# failure mode is the same for either: a hook command that does not exist makes
# the shell return 127, and Claude Code treats every PreToolUse failure other
# than exit 2 as NON-BLOCKING, so the tool runs unguarded and silently. The
# guard cannot fail closed from inside itself, because it never starts.
# ---------------------------------------------------------------------------
HOOK_CHECK="scripts/check-hook-commands.py"
if [[ ! -r "$HOOK_CHECK" ]]; then
    log "ERROR: $HOOK_CHECK is missing or unreadable — the configured PreToolUse guards cannot be resolved."
    log "       Refusing the run: an unverifiable guard is not a guard."
    exit 1
fi
if ! hook_preflight_out="$(CLAUDE_PROJECT_DIR="$PWD" python3 "$HOOK_CHECK" 2>&1)"; then
    log "ERROR: a configured PreToolUse guard does not resolve to an executable file:"
    while IFS= read -r hook_preflight_line; do
        [[ -n "$hook_preflight_line" ]] && log "       $hook_preflight_line"
    done <<< "$hook_preflight_out"
    log "       Refusing the run: the weekly agent holds Write with the advertised filter absent."
    exit 1
fi

# Weekly analysis: review the week's discoveries and integrations.
# Read/Write/Glob/Grep only -- the weekly report needs no Bash or web access.
log "Running weekly analysis..."
claude -p \
    --strict-mcp-config --mcp-config "$MCP_EMPTY" \
    --model "${EVAL_MODEL:-sonnet}" \
    --max-turns 40 \
    --allowed-tools Read Write Glob Grep \
    -- "Execute HEARTBEAT-WEEKLY.md. Current date: $(date -I). Generate weekly report." \
    >> "$LOG_FILE" 2>&1 || log "WARNING: weekly analysis phase exited nonzero (see log)."

# ---------------------------------------------------------------------------
# Quarantine stale evaluations (claude.stale_pending_marked_completed_06).
#
# Age is not evaluation. The previous version moved anything older than 14 days
# straight into pipeline/evaluation/completed/, where it became indistinguishable
# from a genuine verdict -- and a basename collision let `mv` overwrite a real
# completed evaluation with an unevaluated source record. Stale items now go to
# their own quarantine directory, keep their original name unless it is taken,
# and every move is recorded before the run can call itself healthy.
# ---------------------------------------------------------------------------
STALE_DIR="pipeline/evaluation/stale"
STALE_LOG="$STALE_DIR/stale-log.jsonl"
CLEANUP_ERRORS=0
STALE_COUNT=0

# The daily run mutates the same directory (the owner-interest pre-screen stamps every
# pending record in place), and the two scripts hold different locks -- so a long daily
# run overlapping this one could have its stamp write race this quarantine's `mv`. Take
# the DAILY lock for the duration of the move; if the daily run holds it, skip the
# quarantine entirely. Skipping is safe and self-healing: the items stay in the queue and
# next week's run picks them up. What is NOT safe is claiming they were quarantined.
log "Quarantining stale pipeline items (>14 days in evaluation/pending)..."
DAILY_LOCK="$RUNTIME_DIR/evolution-daily.lock"
exec 8>"$DAILY_LOCK"
if ! flock -n 8; then
    log "WARNING: the daily run is in progress and mutates pipeline/evaluation/pending/ — stale-item"
    log "         quarantine SKIPPED this run to avoid racing it. Items remain queued; re-run later."
    exec 8>&-
    log "Weekly heartbeat completed (0 stale item(s) quarantined; quarantine skipped — daily run active)"
    exit 0
fi

if ! mkdir -p "$STALE_DIR"; then
    log "ERROR: could not create $STALE_DIR — stale items left in pending/ (they stay in the queue, which is the safe side)."
    CLEANUP_ERRORS=$((CLEANUP_ERRORS + 1))
else
    # Checked enumeration (claude.weekly_quarantine_partial_scan_09): the previous
    # version only ever matched *.json (the daily queue and owner-interest tooling
    # both support .md pending records too, so those aged out silently and forever),
    # and it discarded `find`'s own exit status into /dev/null inside a process
    # substitution, so a missing/unreadable pending/ directory looked identical to
    # "scanned it, found nothing stale". A real temp file makes the exit status
    # inspectable, and both suffixes are now enumerated.
    STALE_LIST_TMP="$(mktemp)"
    STALE_FIND_ERR_TMP="$(mktemp)"
    if find pipeline/evaluation/pending -maxdepth 1 -type f \
            \( -name '*.json' -o -name '*.md' \) -mtime +14 -print0 \
            > "$STALE_LIST_TMP" 2>"$STALE_FIND_ERR_TMP"; then
        while IFS= read -r -d '' stale; do
            stale_base="$(basename "$stale")"
            dest="$STALE_DIR/$stale_base"
            # Collision-safe: never let one quarantined record replace another.
            # Preserve the ORIGINAL suffix (.json or .md), not a hardcoded .json.
            if [[ -e "$dest" ]]; then
                stale_ext="${stale_base##*.}"
                stale_stem="${stale_base%.*}"
                dest="$STALE_DIR/${stale_stem}.$(date +%Y%m%dT%H%M%S).$$.${stale_ext}"
            fi
            # mv -n exits 0 when it declines to clobber, so confirm the move landed.
            if mv -n -- "$stale" "$dest" 2>>"$LOG_FILE" && [[ -e "$dest" && ! -e "$stale" ]]; then
                # Metadata is written only after the move is confirmed, never before.
                if jq -cn \
                    --arg at "$(date -Iseconds)" \
                    --arg src "$stale" \
                    --arg dst "$dest" \
                    '{quarantined_at: $at, source: $src, dest: $dst,
                      reason: "stale: >14 days in pipeline/evaluation/pending",
                      evaluated: false, decision: null}' >> "$STALE_LOG"; then
                    STALE_COUNT=$((STALE_COUNT + 1))
                else
                    log "ERROR: moved $stale -> $dest but could not record it in $STALE_LOG"
                    CLEANUP_ERRORS=$((CLEANUP_ERRORS + 1))
                fi
            else
                log "ERROR: could not quarantine stale item $stale (left in pending/)"
                CLEANUP_ERRORS=$((CLEANUP_ERRORS + 1))
            fi
        done < "$STALE_LIST_TMP"
    else
        log "ERROR: could not enumerate pipeline/evaluation/pending for stale items: $(cat "$STALE_FIND_ERR_TMP")"
        log "       An unreadable/missing pending directory is a scan failure, not zero stale items."
        CLEANUP_ERRORS=$((CLEANUP_ERRORS + 1))
    fi
    rm -f "$STALE_LIST_TMP" "$STALE_FIND_ERR_TMP"
fi

if [[ $STALE_COUNT -gt 0 ]]; then
    log "WARNING: $STALE_COUNT item(s) aged out of the evaluation queue UNEVALUATED and were quarantined in $STALE_DIR (see $STALE_LOG)."
fi

exec 8>&-   # release the daily lock

if [[ $CLEANUP_ERRORS -gt 0 ]]; then
    log "Weekly heartbeat FAILED: $CLEANUP_ERRORS stale item(s) could not be quarantined or recorded."
    exit 1
fi

log "Weekly heartbeat completed ($STALE_COUNT stale item(s) quarantined)"
