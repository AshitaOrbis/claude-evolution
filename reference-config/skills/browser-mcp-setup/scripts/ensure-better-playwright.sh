#!/bin/bash
# Idempotent Better Playwright MCP server startup with PID tracking
# Safe to call repeatedly - will report status if already running

set -euo pipefail

# Validate the port argument: must be a plain TCP port number
PORT="${1:-3102}"
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || (( PORT < 1 || PORT > 65535 )); then
    echo "ERROR: Invalid port: $PORT" >&2
    exit 2
fi

# Pinned version: never run @latest from an executable script (mutable npm
# code is remote code execution on every cold start). Bump deliberately via
# BETTER_PLAYWRIGHT_VERSION after reviewing the release.
BPW_VERSION="${BETTER_PLAYWRIGHT_VERSION:-3.2.0}"

# Private runtime dir (mode 700) instead of predictable world-writable /tmp paths
RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution"
install -d -m 700 "$RUNTIME_DIR"
PID_FILE="$RUNTIME_DIR/better-playwright.pid"
LOG_FILE="$RUNTIME_DIR/better-playwright.log"

# Function to check if server is responding
check_health() {
    curl -s "http://localhost:$PORT/health" >/dev/null 2>&1
}

# Read PID file content only if it is a plausible positive integer
read_pid() {
    local pid=""
    if [[ -f "$PID_FILE" ]]; then
        read -r pid < "$PID_FILE" || true
    fi
    if [[ "$pid" =~ ^[1-9][0-9]*$ ]]; then
        echo "$pid"
    fi
}

# Check if already running with valid PID and responding
PID="$(read_pid)"
if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null && check_health; then
    echo "Better Playwright already running (PID: $PID, Port: $PORT)"
    exit 0
fi
# Stale or invalid PID file, or server not responding - clean up
rm -f "$PID_FILE"

# Verify a PID is actually a Better Playwright server before touching it: a
# positive-integer PID that is LISTENING on our port is not proof of identity
# (claude.browser_port_kill_05). Match the pinned package name in its own
# /proc/<pid>/cmdline -- an unrelated dev server, database proxy, or browser
# endpoint that merely happens to occupy this port must never be killed.
is_better_playwright_pid() {
    local pid="$1" cmdline
    [[ "$pid" =~ ^[1-9][0-9]*$ ]] || return 1
    cmdline="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)" || return 1
    [[ -n "$cmdline" ]] || return 1
    [[ "$cmdline" == *"better-playwright-mcp3"* ]]
}

# Kill only VERIFIED orphaned Better Playwright listeners on our port. An
# unverified occupant refuses startup with a diagnostic instead of being
# killed -- "is a positive integer and listening here" is not identity.
mapfile -t orphan_pids < <(lsof -nP -tiTCP:"$PORT" -sTCP:LISTEN 2>/dev/null || true)
killed_any=0
unverified_pids=()
for pid in "${orphan_pids[@]}"; do
    if is_better_playwright_pid "$pid"; then
        echo "Killing orphaned Better Playwright process on port $PORT (PID: $pid, verified via /proc/$pid/cmdline)"
        kill "$pid" 2>/dev/null || true
        killed_any=1
    elif [[ "$pid" =~ ^[1-9][0-9]*$ ]]; then
        unverified_pids+=("$pid")
    fi
done
if (( ${#unverified_pids[@]} > 0 )); then
    echo "ERROR: port $PORT is occupied by process(es) that do not look like a Better Playwright" >&2
    echo "       server (PID(s): ${unverified_pids[*]}). Refusing to kill an unidentified process." >&2
    echo "       Stop it yourself, or start Better Playwright on a different port." >&2
    exit 1
fi
if (( killed_any )); then
    sleep 1
fi

# Start in background with Chromium (Chrome not installed in WSL)
echo "Starting Better Playwright MCP server (better-playwright-mcp3@$BPW_VERSION) on port $PORT..."
USE_CHROMIUM=true nohup npx "better-playwright-mcp3@$BPW_VERSION" server -p "$PORT" > "$LOG_FILE" 2>&1 &
SERVER_PID=$!
echo "$SERVER_PID" > "$PID_FILE"

# Wait for startup (up to 10 seconds)
for _ in {1..20}; do
    if check_health; then
        echo "Better Playwright started successfully (PID: $SERVER_PID, Port: $PORT)"
        exit 0
    fi
    sleep 0.5
done

# Startup failed
echo "ERROR: Better Playwright failed to start within 10 seconds"
echo "Check log: $LOG_FILE"
tail -20 "$LOG_FILE" || true
rm -f "$PID_FILE"
exit 1
