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

# Verify a PID is actually a Better Playwright server before touching it: a
# positive-integer PID listening on our port is not proof of identity
# (claude.browser_stop_port_kill_06). Match the pinned package name in its
# own /proc/<pid>/cmdline.
is_better_playwright_pid() {
    local pid="$1" cmdline
    [[ "$pid" =~ ^[1-9][0-9]*$ ]] || return 1
    cmdline="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)" || return 1
    [[ -n "$cmdline" ]] || return 1
    [[ "$cmdline" == *"better-playwright-mcp3"* ]]
}

# Function to kill VERIFIED Better Playwright process(es) on the port; returns
# 0 if anything was stopped. An unverified occupant is reported and left
# untouched rather than killed -- a stale/reused PID or a port collision must
# never let this script terminate an unrelated dev server or database proxy.
kill_port_process() {
    local pid found=1
    local -a pids
    local -a unverified=()
    mapfile -t pids < <(list_port_pids)
    for pid in "${pids[@]}"; do
        if is_better_playwright_pid "$pid"; then
            echo "Stopping process on port $PORT (PID: $pid, verified via /proc/$pid/cmdline)..."
            kill "$pid" 2>/dev/null || true
            found=0
        elif [[ "$pid" =~ ^[1-9][0-9]*$ ]]; then
            unverified+=("$pid")
        fi
    done
    if (( found == 0 )); then
        sleep 1
        # Force kill anything of OURS still listening -- re-verify, do not
        # broaden to "anything on the port" on the second pass either.
        mapfile -t pids < <(list_port_pids)
        for pid in "${pids[@]}"; do
            if is_better_playwright_pid "$pid"; then
                kill -9 "$pid" 2>/dev/null || true
            fi
        done
    fi
    if (( ${#unverified[@]} > 0 )); then
        echo "NOTE: port $PORT is also occupied by unidentified process(es) (PID: ${unverified[*]});" >&2
        echo "      left untouched -- they do not look like a Better Playwright server." >&2
    fi
    return $found
}

# Try to kill by PID file first -- but only after verifying the occupant, the
# same way the port sweep does (claude.browser_stop_stale_pid_kill_04). This
# branch used to require only a positive integer that `kill -0` answered for,
# which is proof that SOME process holds that pid, not that it is ours: after a
# crash or a reboot a stale better-playwright.pid routinely names a pid the
# kernel has since handed to something else, and this branch signalled it
# before the verified port sweep below ever ran. A stale file is removed; its
# occupant is left running and reported.
if [[ -f "$PID_FILE" ]]; then
    PID=""
    read -r PID < "$PID_FILE" || true
    if is_better_playwright_pid "$PID"; then
        echo "Stopping Better Playwright (PID: $PID, verified via /proc/$PID/cmdline)..."
        kill "$PID" 2>/dev/null || true
        sleep 0.5
    elif [[ "$PID" =~ ^[1-9][0-9]*$ ]] && kill -0 "$PID" 2>/dev/null; then
        echo "NOTE: $PID_FILE names live PID $PID, which does not look like a Better Playwright" >&2
        echo "      server -- its /proc/$PID/cmdline does not carry the pinned package name." >&2
        echo "      Left untouched; removing the stale PID file." >&2
    fi
    rm -f "$PID_FILE"
fi

# Also kill any process on the port (handles orphaned servers)
if kill_port_process; then
    echo "Stopped"
else
    echo "Better Playwright not running"
fi
