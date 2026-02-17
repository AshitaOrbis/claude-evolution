#!/bin/bash
# Clean shutdown of Better Playwright MCP server

PID_FILE="/tmp/better-playwright.pid"
PORT=${1:-3102}

# Function to kill process on port
kill_port_process() {
    local pid=$(lsof -ti:$PORT 2>/dev/null)
    if [ -n "$pid" ]; then
        echo "Stopping process on port $PORT (PID: $pid)..."
        kill "$pid" 2>/dev/null
        sleep 1
        # Force kill if still running
        pid=$(lsof -ti:$PORT 2>/dev/null)
        if [ -n "$pid" ]; then
            kill -9 "$pid" 2>/dev/null
        fi
        return 0
    fi
    return 1
}

# Try to kill by PID file first
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Stopping Better Playwright (PID: $PID)..."
        kill "$PID" 2>/dev/null
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
