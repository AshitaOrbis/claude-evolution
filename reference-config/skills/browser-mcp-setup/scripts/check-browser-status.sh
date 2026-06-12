#!/bin/bash
# Check status of all browser automation MCPs

set -euo pipefail

# Private runtime dir (matches ensure-better-playwright.sh)
RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution"
PID_FILE="$RUNTIME_DIR/better-playwright.pid"

# Strip terminal control characters from untrusted text (browser tab titles
# etc.) before printing -- prevents ANSI/OSC escape injection into the terminal
sanitize() {
    LC_ALL=C tr -d '\000-\010\013\014\016-\037\177'
}

echo "=== Browser MCP Status ==="
echo ""

# Better Playwright (primary)
echo "Better Playwright (port 3102):"
if curl -s http://localhost:3102/health >/dev/null 2>&1; then
    PID=""
    if [ -f "$PID_FILE" ]; then
        read -r PID < "$PID_FILE" || true
    fi
    if [[ "$PID" =~ ^[1-9][0-9]*$ ]]; then
        echo "  Status: RUNNING (PID: $PID)"
    else
        echo "  Status: RUNNING (PID unknown)"
    fi
else
    echo "  Status: STOPPED"
    echo "  Start:  ~/.claude/skills/browser-mcp-setup/scripts/ensure-better-playwright.sh"
fi
echo ""

# Chrome DevTools (WSL)
echo "Chrome DevTools (for WSL):"
WINDOWS_IP=$(grep nameserver /etc/resolv.conf 2>/dev/null | head -1 | awk '{print $2}' || true)
if [ -n "$WINDOWS_IP" ]; then
    # Try localhost first (WSL2 mirrored networking), then the NAT gateway IP
    DEVTOOLS_URL=""
    if curl -s --max-time 2 "http://127.0.0.1:9222/json" >/dev/null 2>&1; then
        DEVTOOLS_URL="http://127.0.0.1:9222"
    elif curl -s --max-time 2 "http://${WINDOWS_IP}:9222/json" >/dev/null 2>&1; then
        DEVTOOLS_URL="http://${WINDOWS_IP}:9222"
    fi
    if [ -n "$DEVTOOLS_URL" ]; then
        echo "  Status: CONNECTED ($DEVTOOLS_URL)"
        echo "  Tabs:"
        curl -s "$DEVTOOLS_URL/json" | jq -r '.[].title' 2>/dev/null | head -5 | sanitize | sed 's/^/    - /'
    else
        echo "  Status: NOT CONNECTED"
        echo "  Windows IP: $WINDOWS_IP"
        echo "  Start Chrome on Windows bound to loopback ONLY:"
        echo '    & "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --remote-debugging-address=127.0.0.1'
        echo "  SECURITY: never use --remote-debugging-address=0.0.0.0 -- it exposes full"
        echo "  browser control (cookies, sessions, JS execution) to your network."
        echo "  To reach it from WSL2, enable mirrored networking (networkingMode=mirrored"
        echo "  in .wslconfig) so localhost is shared. See SKILL.md for details."
    fi
else
    echo "  Status: N/A (not in WSL environment)"
fi
echo ""

# Standard Playwright MCP (if different port used)
echo "Standard Playwright MCP (via claude.json):"
if grep -q "playwright" ~/.claude.json 2>/dev/null; then
    echo "  Config: PRESENT in ~/.claude.json"
else
    echo "  Config: NOT FOUND in ~/.claude.json"
fi
echo ""

echo "=== Quick Commands ==="
echo "Start Better Playwright: ~/.claude/skills/browser-mcp-setup/scripts/ensure-better-playwright.sh"
echo "Stop Better Playwright:  ~/.claude/skills/browser-mcp-setup/scripts/stop-better-playwright.sh"
