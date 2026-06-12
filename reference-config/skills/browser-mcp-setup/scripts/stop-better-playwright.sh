#!/bin/bash
# Clean shutdown of Better Playwright MCP server

set -euo pipefail

# Validate the port argument: must be a plain TCP port number
PORT="${1:-3102}"
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || (( PORT < 1 || PORT > 65535 )); then
    echo "ERROR: Invalid port: $PORT" >&2
    exit 2
fi

# Private runtime dir (matches ensure-better-playwright.sh)
RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution"
PID_FILE="$RUNTIME_DIR/better-playwright.pid"

# List validated PIDs listening on our port
list_port_pids() {
    lsof -nP -tiTCP:"$PORT" -sTCP:LISTEN 2>/dev/null || true
}

# Function to kill process(es) on port; returns 0 if anything was stopped
kill_port_process() {
    local pid found=1
    local -a pids
    mapfile -t pids < <(list_port_pids)
    for pid in "${pids[@]}"; do
        if [[ "$pid" =~ ^[1-9][0-9]*$ ]]; then
            echo "Stopping process on port $PORT (PID: $pid)..."
            kill "$pid" 2>/dev/null || true
            found=0
        fi
    done
    if (( found == 0 )); then
        sleep 1
        # Force kill anything still listening
        mapfile -t pids < <(list_port_pids)
        for pid in "${pids[@]}"; do
            if [[ "$pid" =~ ^[1-9][0-9]*$ ]]; then
                kill -9 "$pid" 2>/dev/null || true
            fi
        done
    fi
    return $found
}

# Try to kill by PID file first (validated content only)
if [[ -f "$PID_FILE" ]]; then
    PID=""
    read -r PID < "$PID_FILE" || true
    if [[ "$PID" =~ ^[1-9][0-9]*$ ]] && kill -0 "$PID" 2>/dev/null; then
        echo "Stopping Better Playwright (PID: $PID)..."
        kill "$PID" 2>/dev/null || true
        sleep 0.5
    fi
    rm -f "$PID_FILE"
fi

# Also kill any process on the port (handles orphaned servers)
if kill_port_process; then
    echo "Stopped"
else
    echo "Better Playwright not running"
fi
