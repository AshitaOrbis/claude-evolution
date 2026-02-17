#!/bin/bash
# Idempotent Better Playwright MCP server startup with PID tracking
# Safe to call repeatedly - will report status if already running

PORT=${1:-3102}
PID_FILE="/tmp/better-playwright.pid"
LOG_FILE="/tmp/better-playwright.log"

# Function to check if server is responding
check_health() {
    curl -s "http://localhost:$PORT/health" >/dev/null 2>&1
}

# Check if already running with valid PID and responding
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null && check_health; then
        echo "Better Playwright already running (PID: $PID, Port: $PORT)"
        exit 0
    else
        # Stale PID file or server not responding - clean up
        rm -f "$PID_FILE"
    fi
fi

# Kill any orphaned processes on our port
existing_pid=$(lsof -ti:$PORT 2>/dev/null)
if [ -n "$existing_pid" ]; then
    echo "Killing orphaned process on port $PORT (PID: $existing_pid)"
    kill "$existing_pid" 2>/dev/null
    sleep 1
fi

# Start in background with Chromium (Chrome not installed in WSL)
echo "Starting Better Playwright MCP server on port $PORT..."
USE_CHROMIUM=true nohup npx better-playwright-mcp3@latest server -p "$PORT" > "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"

# Wait for startup (up to 10 seconds)
for i in {1..20}; do
    if check_health; then
        echo "Better Playwright started successfully (PID: $(cat $PID_FILE), Port: $PORT)"
        exit 0
    fi
    sleep 0.5
done

# Startup failed
echo "ERROR: Better Playwright failed to start within 10 seconds"
echo "Check log: $LOG_FILE"
cat "$LOG_FILE" | tail -20
rm -f "$PID_FILE"
exit 1
