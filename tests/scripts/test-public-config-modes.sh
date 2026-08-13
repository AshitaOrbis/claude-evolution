#!/usr/bin/env bash
#
# Regression suite for scripts/test-public-config.sh
# (claude.privacy_scan_missing_patterns_green_05).
#
# The defect: with the gitignored scripts/.private-patterns absent — the default
# state of any clean clone — Tests 2 and 3 printed SKIPPED, incremented no error
# counter, and the run ended "ALL TESTS PASSED". A privacy scanner returned a
# green publication clearance with its estate-specific leak detection switched
# off. These cases pin: missing input fails, unreadable input fails, empty input
# fails, --generic-only is honest about what it did not check, and a real pass
# still passes.
#
# Usage:  bash tests/scripts/test-public-config-modes.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SCRIPT_SRC="$REPO_ROOT/scripts/test-public-config.sh"
[[ -f "$SCRIPT_SRC" ]] || { echo "FATAL: $SCRIPT_SRC not found" >&2; exit 1; }

PASS=0
FAIL=0
want() { # want <description> <rc-of-condition>
  if [[ "$2" -eq 0 ]]; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/pubcfg-test.XXXXXX")"
cleanup() { chmod -R u+rwX "$WORK" 2>/dev/null; rm -rf "$WORK"; }
trap cleanup EXIT

# A throwaway checkout: the script only ever reads scripts/ and reference-config/.
FIX="$WORK/repo"
mkdir -p "$FIX/scripts" "$FIX/reference-config/skills" "$FIX/reference-config/agents"
cp "$SCRIPT_SRC" "$FIX/scripts/test-public-config.sh"
# Clean reference content: portable paths, no credentials, no private names.
cat > "$FIX/reference-config/clean.md" <<'MD'
# Reference config

Put skills in ~/.claude/skills/ and clone into ~/your-project.
MD

run() { ( cd "$FIX" && bash scripts/test-public-config.sh "$@" 2>&1 ); }

echo "=== test-public-config.sh mode regression suite ==="
echo ""

# ---------------------------------------------------------------------------
echo "--- Publication mode requires its private-pattern input ---"
rm -f "$FIX/scripts/.private-patterns"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "missing .private-patterns exits nonzero" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "missing input never prints ALL TESTS PASSED" $?
grep -q 'required input missing' <<< "$OUT"; want "missing input says which input is missing" $?

printf '' > "$FIX/scripts/.private-patterns"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "empty .private-patterns exits nonzero" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "empty input never prints ALL TESTS PASSED" $?

printf 'privateproj\nprivateagent\n' > "$FIX/scripts/.private-patterns"
chmod 000 "$FIX/scripts/.private-patterns"
if [[ "$(id -u)" -eq 0 ]]; then
  echo "  skip (running as root: the unreadable-input case cannot be simulated)"
else
  OUT="$(run)"; RC=$?
  [[ $RC -ne 0 ]]; want "unreadable .private-patterns exits nonzero" $?
  ! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "unreadable input never prints ALL TESTS PASSED" $?
fi
chmod 600 "$FIX/scripts/.private-patterns"

# ---------------------------------------------------------------------------
echo ""
echo "--- --generic-only is honest about what it skipped ---"
rm -f "$FIX/scripts/.private-patterns"
OUT="$(run --generic-only)"; RC=$?
[[ $RC -eq 0 ]]; want "--generic-only exits 0 without the pattern file" $?
grep -q 'PARTIAL CHECKS ONLY' <<< "$OUT"; want "--generic-only reports PARTIAL CHECKS ONLY" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "--generic-only never prints ALL TESTS PASSED" $?
grep -q 'does NOT clear a publication' <<< "$OUT"; want "--generic-only says it is not a clearance" $?

# ---------------------------------------------------------------------------
echo ""
echo "--- A real publication pass still passes, and real leaks still fail ---"
printf 'privateproj\nprivateagent\n' > "$FIX/scripts/.private-patterns"
OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "clean tree with pattern file exits 0" $?
grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "clean publication run reports ALL TESTS PASSED" $?

printf 'The privateproj rollout notes.\n' > "$FIX/reference-config/leak.md"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "a private project name still fails the scan" $?
grep -q 'references private project' <<< "$OUT"; want "the failure names the offending check" $?
rm -f "$FIX/reference-config/leak.md"

printf 'Home path /home/someuser/notes is not portable.\n' > "$FIX/reference-config/leak.md"
OUT="$(run --generic-only)"; RC=$?
[[ $RC -ne 0 ]]; want "--generic-only still fails on a hardcoded home path" $?
! grep -q 'PARTIAL CHECKS ONLY' <<< "$OUT"; want "a failing --generic-only run does not print PARTIAL CHECKS ONLY" $?
rm -f "$FIX/reference-config/leak.md"

# ---------------------------------------------------------------------------
echo ""
echo "--- Argument handling ---"
OUT="$(run --nonsense)"; RC=$?
[[ $RC -ne 0 ]]; want "unknown flag exits nonzero" $?
OUT="$(run --help)"; RC=$?
[[ $RC -eq 0 ]]; want "--help exits 0" $?

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
