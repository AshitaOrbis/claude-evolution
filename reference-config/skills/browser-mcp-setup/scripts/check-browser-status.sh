#!/bin/bash
# Check status of all browser automation MCPs

echo "=== Browser MCP Status ==="
echo ""

# Better Playwright (primary)
echo "Better Playwright (port 3102):"
if curl -s http://localhost:3102/health >/dev/null 2>&1; then
    PID_FILE="/tmp/better-playwright.pid"
    if [ -f "$PID_FILE" ]; then
        echo "  Status: RUNNING (PID: $(cat $PID_FILE))"
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
WINDOWS_IP=$(grep nameserver /etc/resolv.conf 2>/dev/null | head -1 | awk '{print $2}')
if [ -n "$WINDOWS_IP" ]; then
    if curl -s "http://${WINDOWS_IP}:9222/json" >/dev/null 2>&1; then
        echo "  Status: CONNECTED (Windows IP: $WINDOWS_IP)"
        echo "  Tabs:"
        curl -s "http://${WINDOWS_IP}:9222/json" | jq -r '.[].title' 2>/dev/null | head -5 | sed 's/^/    - /'
    else
        echo "  Status: NOT CONNECTED"
        echo "  Windows IP: $WINDOWS_IP"
        echo "  Start Chrome on Windows with:"
        echo '    & "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0'
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
