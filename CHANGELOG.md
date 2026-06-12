# Changelog

## 2026-06-11 — Security hardening release

Driven by an external security review (GPT-5.5 Pro, archived at
`reviews/gptpro-2026-06-11.md`) plus an independent adversarial follow-up
review (`reviews/fable-followup-2026-06-11.md`).

### Changed

- **Review-gated mode is now the default** for `evolution-daily.sh`: agents
  run without Bash, and the integration phase is skipped, leaving approved
  items in `pipeline/integration/` for human review. Fully autonomous
  behavior is opt-in via `EVOLUTION_AUTONOMOUS=1`.
- `.env` loading hardened: scripts refuse to source a `.env` not owned by the
  user or writable by group/others, with documented warnings (sourcing
  semantics intentionally retained — see SECURITY.md).
- Locks moved from predictable `/tmp` paths to a private
  `${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution` dir (mode 700) and made
  atomic via `flock`.
- Better Playwright PID/log files moved out of `/tmp` to the same runtime
  dir; PID file contents validated as positive integers before any `kill`.
- `npx better-playwright-mcp3@latest` replaced with a pinned version
  (override via `BETTER_PLAYWRIGHT_VERSION`).
- Chrome DevTools guidance changed from `--remote-debugging-address=0.0.0.0`
  to loopback-only binding, with mirrored-networking / scoped-portproxy
  instructions for WSL2.
- Port arguments validated as numeric TCP ports; `lsof` invocations quoted
  and structured (`-tiTCP:"$PORT" -sTCP:LISTEN`), multiple PIDs handled.
- `test-public-config.sh`: NUL-delimited `find` loops (whitespace-safe),
  `grep --` separators, non-empty pattern validation, generic private-path
  patterns instead of hardcoded personal identifiers, and Test 1 failures are
  no longer discarded when `.private-patterns` is absent.
- Discord notification summary now redacts webhook URLs and
  credential-shaped strings before posting (best-effort; documented).
- Terminal output sanitization (control-character stripping) for browser tab
  titles and plan-state JSON fields.
- Prompt files (`HEARTBEAT-DAILY.md`, `EVALUATE-PENDING.md`,
  `INTEGRATE-APPROVED.md`) gained explicit untrusted-content rules and write
  scoping.

### Added

- `SECURITY.md`: threat model, operating modes, sandboxing recommendations.
- `reviews/`: archived external security reviews.
- `EVOLUTION_AUTONOMOUS` configuration flag (`.env.example`, README).

## 2026-02 — Initial release

- Self-improving pipeline: discovery → evaluation → integration →
  verification, with daily/weekly cron heartbeats and reference-config
  (21 public agents, 12 public skills).
