# Browser MCP Setup Skill

Autonomous management of browser automation MCPs for Claude Code, with non-admin WSL support.

## Quick Status Check

```bash
~/.claude/skills/browser-mcp-setup/scripts/check-browser-status.sh
```

## Decision Tree: Which Browser MCP?

```
What are you testing?
  │
  ├─ Your own app
  │     │
  │     └─ Does the app expose test helpers via WebMCP?
  │           ├─ YES → Use WebMCP endpoints
  │           └─ NO  → Use Better Playwright (primary) ─────────┐
  │                                                              │
  ├─ Third-party website                                        │
  │     │                                                        │
  │     └─ Need to persist login/cookies across sessions?       │
  │           ├─ YES → Use Chrome DevTools (WSL)                │
  │           └─ NO  → Use Better Playwright ───────────────────┤
  │                                                              │
  └─ Scraping/automation at scale                               │
        └─ Use Better Playwright with --headless ───────────────┘
```

**Current Recommendation**: Better Playwright for all cases until WebMCP is integrated.

---

## Better Playwright (Primary)

### Start Server (Idempotent)

Safe to call repeatedly - will report status if already running.

```bash
~/.claude/skills/browser-mcp-setup/scripts/ensure-better-playwright.sh
```

### Stop Server

```bash
~/.claude/skills/browser-mcp-setup/scripts/stop-better-playwright.sh
```

### Architecture

Better Playwright uses a custom MCP wrapper that talks to an HTTP server:

```
Claude Code <-> MCP Wrapper (stdio) <-> HTTP Server (port 3102) <-> Chromium Browser
```

The HTTP server provides 91% DOM compression via `_snapshotForAI()` for token efficiency.

### MCP Configuration

Already configured in `~/.claude.json`:

```json
{
  "mcpServers": {
    "better-playwright": {
      "type": "stdio",
      "command": "node",
      "args": ["~/.claude-mcp-servers/better-playwright-mcp-wrapper/mcp-server.mjs"],
      "env": {
        "BETTER_PLAYWRIGHT_URL": "http://localhost:3102"
      }
    }
  }
}
```

### Available Tools (mcp__better-playwright__*)

| Tool | Purpose |
|------|---------|
| `createPage` | Create page and navigate to URL |
| `closePage` | Close the current page |
| `listPages` | List all open pages |
| `browserNavigate` | Navigate to URL |
| `getOutline` | Get compressed DOM with ref IDs (token-efficient) |
| `searchSnapshot` | Regex search in page content |
| `browserClick` | Click element by ref ID |
| `browserType` | Type text into element |
| `browserHover` | Hover over element |
| `browserSelectOption` | Select from dropdown |
| `browserPressKey` | Press keyboard key |
| `screenshot` | Take visual screenshot (use sparingly) |
| `waitForSelector` | Wait for CSS selector |
| `scrollToBottom` | Scroll to page/element bottom |
| `scrollToTop` | Scroll to page/element top |
| `browserNavigateBack` | Browser back button |
| `browserNavigateForward` | Browser forward button |
| `browserFileUpload` | Upload files to input |
| `browserHandleDialog` | Handle alert/confirm/prompt |
| `waitForTimeout` | Wait for milliseconds |

### Token Efficiency

`getOutline` returns compressed DOM with ref-based elements:

```
nav "Main Navigation"
  link "Home" [ref=e1]
  link "Products" [ref=e2]
main
  heading "Welcome" level=1
  listitem "Feature 1" [ref=e3]
  listitem (... and 47 more similar)  ← DOM folding
```

Use ref IDs with `browserClick`, `browserType`, etc.

---

## Chrome DevTools (WSL)

Use when you need persistent browser state (logins, cookies) across sessions.

### Setup (NO ADMIN REQUIRED)

> **SECURITY: never bind the DevTools port to `0.0.0.0`.** The Chrome DevTools
> Protocol grants full browser control: reading page content and cookies,
> executing JavaScript in logged-in sessions, and navigating tabs. Binding it
> to all interfaces exposes that authority to every machine that can reach
> your host on the network. Always bind to `127.0.0.1`.

#### On Windows (regular PowerShell, NOT admin)

```powershell
& "C:\Program Files\Google\Chrome\Application\chrome.exe" `
    --user-data-dir="$env:USERPROFILE\ChromeProfiles\mcp" `
    --remote-debugging-port=9222 `
    --remote-debugging-address=127.0.0.1 `
    --no-first-run
```

Or use the helper script:
```powershell
pwsh -File ~/.claude/skills/browser-mcp-setup/scripts/launch-chrome-wsl.ps1
```

#### Reaching the loopback-bound port from WSL2

WSL2's default NAT networking cannot reach `127.0.0.1` on the Windows host.
Two safe options, in order of preference:

1. **Mirrored networking** (Windows 11 22H2+): add to `%USERPROFILE%\.wslconfig`:
   ```ini
   [wsl2]
   networkingMode=mirrored
   ```
   then `wsl --shutdown` and restart. `localhost` is now shared between
   Windows and WSL, so WSL can use `http://127.0.0.1:9222` directly.

2. **Scoped port proxy** (NAT mode): forward only the WSL-facing vEthernet
   address to loopback (run in admin PowerShell once):
   ```powershell
   # Use the "vEthernet (WSL)" adapter IP as listenaddress -- NOT 0.0.0.0
   netsh interface portproxy add v4tov4 listenaddress=<vEthernet-WSL-IP> listenport=9222 connectaddress=127.0.0.1 connectport=9222
   ```
   The vEthernet (WSL) address is internal to the Windows<->WSL virtual
   switch, so the port stays unreachable from the LAN.

#### In WSL - Connect

```bash
# Mirrored networking:
curl "http://127.0.0.1:9222/json"

# NAT mode with portproxy (Windows host IP):
WINDOWS_IP=$(grep nameserver /etc/resolv.conf | head -1 | awk '{print $2}')
curl "http://${WINDOWS_IP}:9222/json"
```

### DevTools MCP Configuration

To use Chrome DevTools as an MCP, add to `~/.claude.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-puppeteer"],
      "env": {
        "PUPPETEER_EXECUTABLE_PATH": "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe",
        "PUPPETEER_SKIP_CHROMIUM_DOWNLOAD": "true"
      }
    }
  }
}
```

---

## WebMCP (Future - For Own Apps)

WebMCP allows your app to expose test helpers that Claude can call directly. This is the cleanest approach for testing your own applications.

See: `~/.claude/skills/browser-mcp-setup/references/webmcp-integration.md`

Benefits over browser automation:
- Direct access to app internals
- No UI fragility (element selectors breaking)
- Faster execution
- Can seed test data programmatically

---

## Troubleshooting

### Better Playwright won't start

```bash
# Check what's on port 3102
lsof -i:3102

# Kill and restart
~/.claude/skills/browser-mcp-setup/scripts/stop-better-playwright.sh
~/.claude/skills/browser-mcp-setup/scripts/ensure-better-playwright.sh

# Check logs
cat "${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution/better-playwright.log"
```

### Chrome DevTools: Connection refused from WSL

1. **Verify Chrome is listening on loopback**:
   ```powershell
   # On Windows
   netstat -an | findstr 9222
   # Should show 127.0.0.1:9222 (never 0.0.0.0:9222 -- see security note above)
   ```

2. **Verify the path from WSL**: with mirrored networking, test
   `curl http://127.0.0.1:9222/json` directly. In NAT mode, verify the
   portproxy exists (`netsh interface portproxy show all` on Windows) and the
   Windows IP is correct:
   ```bash
   # In WSL
   grep nameserver /etc/resolv.conf
   ping -c 1 $(grep nameserver /etc/resolv.conf | head -1 | awk '{print $2}')
   ```

3. **Restart Chrome with correct flags** (must include `--remote-debugging-address=127.0.0.1`)

### Element not found errors

1. Use `getOutline` to see current compressed DOM with ref IDs
2. Check that ref values match exactly (e.g., `e1`, `e2`)
3. Use `waitForSelector` before interacting with dynamic content
4. Use `searchSnapshot` with regex to find specific text/elements

---

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `ensure-better-playwright.sh` | Idempotent server start |
| `stop-better-playwright.sh` | Clean shutdown |
| `check-browser-status.sh` | Status of all MCPs |
| `launch-chrome-wsl.ps1` | Windows helper (non-admin) |

All scripts located in: `~/.claude/skills/browser-mcp-setup/scripts/`
