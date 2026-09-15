#!/usr/bin/env bash
#
# Regression suite for the port-cleanup logic in
# reference-config/skills/browser-mcp-setup/scripts/{ensure,stop}-better-playwright.sh
# (claude.browser_port_kill_05 / claude.browser_stop_port_kill_06 /
#  claude.browser_stop_stale_pid_kill_04).
#
# Spawns DECOY listener processes on a throwaway high port (never the real
# 3102) and verifies the scripts never kill one that does not carry the
# pinned package name in its own /proc/<pid>/cmdline, while still cleaning up
# one that does. This test spawns and kills only its own decoy fixtures --
# it never touches an unrelated real process, which is exactly the property
# under test.
#
# Usage:  bash tests/scripts/test-better-playwright-port-safety.sh
# Exit:   0 = all cases pass, 1 = at least one case failed, 2 = environment
#         cannot run this suite (no lsof/python3).

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
ENSURE_SRC="$REPO_ROOT/reference-config/skills/browser-mcp-setup/scripts/ensure-better-playwright.sh"
STOP_SRC="$REPO_ROOT/reference-config/skills/browser-mcp-setup/scripts/stop-better-playwright.sh"
[[ -f "$ENSURE_SRC" && -f "$STOP_SRC" ]] || { echo "FATAL: scripts not found" >&2; exit 1; }
command -v lsof >/dev/null 2>&1 || { echo "SKIP: lsof not available" >&2; exit 0; }
command -v python3 >/dev/null 2>&1 || { echo "SKIP: python3 not available" >&2; exit 0; }

PASS=0
FAIL=0
want() {
  if [[ "$2" -eq 0 ]]; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/bpw-port-safety-test.XXXXXX")"
DECOY_PIDS=()
cleanup() {
  for p in "${DECOY_PIDS[@]:-}"; do kill -9 "$p" 2>/dev/null || true; done
  rm -rf "$WORK"
}
trap cleanup EXIT

PORT=$(( (RANDOM % 5000) + 20000 ))

# The stop script derives its PID file from XDG_RUNTIME_DIR. Pin it into the
# fixture: a regression suite must not read, signal from, or delete the
# caller's real ~/.cache/claude-evolution/better-playwright.pid.
XDG_FIX="$WORK/xdg"
mkdir -p "$XDG_FIX/claude-evolution"
PID_FILE_FIX="$XDG_FIX/claude-evolution/better-playwright.pid"
run_stop() { env XDG_RUNTIME_DIR="$XDG_FIX" bash "$STOP_SRC" "$@" 2>&1; }

listen_on_port() { # listen_on_port <argv0-name>  -- prints the PID once bound
  local name="$1"
  ( exec -a "$name" python3 -c "
import socket, time
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(('127.0.0.1', $PORT))
s.listen(1)
time.sleep(120)
" ) >/dev/null 2>&1 &
  local pid=$!
  DECOY_PIDS+=("$pid")
  # Wait for the bind to actually take effect before returning.
  for _ in $(seq 1 50); do
    lsof -nP -tiTCP:"$PORT" -sTCP:LISTEN 2>/dev/null | grep -q "^$pid\$" && break
    sleep 0.1
  done
  echo "$pid"
}

alive() { kill -0 "$1" 2>/dev/null; }

spawn_offport() { # spawn_offport <argv0-name>  -- a live process nowhere near our port
  ( exec -a "$1" sleep 120 ) >/dev/null 2>&1 &
  local pid=$!
  DECOY_PIDS+=("$pid")
  echo "$pid"
}

echo "=== better-playwright port-safety regression suite (port $PORT) ==="
echo ""

# ---------------------------------------------------------------------------
echo "--- stop-better-playwright.sh must NOT kill an unverified occupant ---"
DECOY_PID="$(listen_on_port "unrelated-dev-server")"
alive "$DECOY_PID"; want "decoy is listening before the stop script runs" $?
OUT="$(run_stop "$PORT")"
alive "$DECOY_PID"; want "unrelated decoy SURVIVES stop-better-playwright.sh" $?
grep -qi 'unidentified' <<< "$OUT"; want "stop script reports it as unidentified" $?
kill -9 "$DECOY_PID" 2>/dev/null || true

echo ""
echo "--- stop-better-playwright.sh DOES stop a verified orphan (no PID file) ---"
DECOY_PID="$(listen_on_port "better-playwright-mcp3-orphan")"
alive "$DECOY_PID"; want "verified decoy is listening before the stop script runs" $?
OUT="$(run_stop "$PORT")"
sleep 0.3
! alive "$DECOY_PID"; want "verified orphan is stopped" $?
grep -qi 'stopped' <<< "$OUT"; want "stop script reports success" $?

echo ""
echo "--- ensure-better-playwright.sh refuses to start over an unverified occupant ---"
DECOY_PID="$(listen_on_port "someones-database-proxy")"
alive "$DECOY_PID"; want "decoy is listening before the ensure script runs" $?
OUT="$(BETTER_PLAYWRIGHT_VERSION=0.0.0-test bash "$ENSURE_SRC" "$PORT" 2>&1)"; RC=$?
[[ $RC -ne 0 ]]; want "ensure script exits nonzero rather than clobbering it" $?
alive "$DECOY_PID"; want "unrelated decoy SURVIVES ensure-better-playwright.sh" $?
grep -qi 'do not look like a Better Playwright' <<< "$OUT"; want "ensure script explains the refusal" $?
kill -9 "$DECOY_PID" 2>/dev/null || true

# ---------------------------------------------------------------------------
# The PID-FILE branch runs before the verified port sweep, so its own
# verification is what decides whether an unrelated process survives
# (claude.browser_stop_stale_pid_kill_04). These decoys deliberately do NOT
# listen on the port: only the PID-file branch can reach them.
echo ""
echo "--- A stale PID file naming an unrelated live process must not kill it ---"
STALE_PID="$(spawn_offport "unrelated-dev-server")"
alive "$STALE_PID"; want "unrelated process is running before the stop script" $?
printf '%s\n' "$STALE_PID" > "$PID_FILE_FIX"
OUT="$(run_stop "$PORT")"
sleep 0.3
alive "$STALE_PID"; want "stale PID file naming an unrelated live process: left running" $?
[[ ! -e "$PID_FILE_FIX" ]]; want "the stale PID file is removed even though nothing was signalled" $?
grep -qi 'does not look like a Better Playwright' <<< "$OUT"; want "the stop script says why it refused to signal that pid" $?
kill -9 "$STALE_PID" 2>/dev/null || true

echo ""
echo "--- A PID file naming a VERIFIED server is still honoured ---"
OWN_PID="$(spawn_offport "better-playwright-mcp3-from-pidfile")"
alive "$OWN_PID"; want "verified process is running before the stop script" $?
printf '%s\n' "$OWN_PID" > "$PID_FILE_FIX"
OUT="$(run_stop "$PORT")"
sleep 0.3
! alive "$OWN_PID"; want "PID file naming a verified server: the server IS stopped" $?
grep -qi 'verified via /proc' <<< "$OUT"; want "the stop script records that it verified the pid first" $?
[[ ! -e "$PID_FILE_FIX" ]]; want "the PID file is removed after a verified stop" $?

echo ""
echo "--- A PID file that is garbage, empty, or names a dead pid is just removed ---"
for junk in "not-a-pid" "" "0" "999999999"; do
  printf '%s\n' "$junk" > "$PID_FILE_FIX"
  OUT="$(run_stop "$PORT")"; RC=$?
  [[ $RC -eq 0 || $RC -eq 1 ]]; want "PID file content '${junk:-<empty>}': the script does not crash" $?
  [[ ! -e "$PID_FILE_FIX" ]]; want "PID file content '${junk:-<empty>}': the file is removed" $?
done

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
