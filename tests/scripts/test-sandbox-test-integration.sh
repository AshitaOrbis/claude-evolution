#!/usr/bin/env bash
#
# Regression suite for scripts/sandbox-test-integration.sh (claude.sandbox_gate_false_pass_05
# / claude.sandbox_marker_false_pass_04 / claude.sandbox_marker_false_pass_05 /
# claude.sandbox_sentinel_falsepass_04).
#
# Never invokes the real `claude` CLI (no model calls, no subscription usage). A stub
# `claude` on PATH parses the "printf '%s' '<nonce>' > <path>" instruction out of its
# own argv and behaves according to a mode smuggled through the --env value under
# test (the one channel `env -i` actually preserves into the child) -- so this
# exercises the REAL script's proof-of-execution logic end to end, not a reimplementation
# of it.
#
# Usage:  bash tests/scripts/test-sandbox-test-integration.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SCRIPT_SRC="$REPO_ROOT/scripts/sandbox-test-integration.sh"
[[ -f "$SCRIPT_SRC" ]] || { echo "FATAL: $SCRIPT_SRC not found" >&2; exit 1; }

PASS=0
FAIL=0
want() {
  if [[ "$2" -eq 0 ]]; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/sandbox-test-test.XXXXXX")"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

BIN="$WORK/bin"
mkdir -p "$BIN"
cp "$SCRIPT_SRC" "$WORK/sandbox-test-integration.sh"
chmod +x "$WORK/sandbox-test-integration.sh"

cat > "$BIN/claude" <<'STUB'
#!/bin/sh
# Fake `claude -p ... -- "<prompt>"`. Extract the nonce + target path this script
# asked to be written, then behave per $SANDBOX_STUB_MODE (an env var passed
# through by --env, the one channel `env -i` preserves into this process).
ARGS="$*"
NONCE=$(printf '%s\n' "$ARGS" | sed -n "s/.*printf '%s' '\([^']*\)' > .*/\1/p")
FILE=$(printf '%s\n' "$ARGS" | sed -n "s/.*> \([^\"]*\)\"\{0,1\}$/\1/p")
case "${SANDBOX_STUB_MODE:-}" in
  correct)
    printf '%s' "$NONCE" > "$FILE"
    exit 0
    ;;
  wrong_content)
    printf 'not-the-nonce' > "$FILE"
    exit 0
    ;;
  never_writes_but_narrates)
    # The old exploit: repeat the command / claim success in TEXT without
    # actually running Bash. No file is written.
    echo "I ran: printf '%s' '$NONCE' > $FILE"
    echo "SANDBOX_TEST_PASS"
    exit 0
    ;;
  correct_but_nonzero_exit)
    printf '%s' "$NONCE" > "$FILE"
    exit 7
    ;;
  permission_forced)
    printf '%s' "$NONCE" > "$FILE"
    echo "Permission mode forced to default"
    exit 0
    ;;
  empty_output)
    # Exits 0, writes nothing, says nothing.
    exit 0
    ;;
  sandbox_failed)
    printf '%s' "$NONCE" > "$FILE"
    echo "Sandbox failed to initialize"
    exit 0
    ;;
  *)
    exit 0
    ;;
esac
STUB
chmod +x "$BIN/claude"

run() { # run <stub-mode>
  ( PATH="$BIN:/usr/bin:/bin" HOME="$HOME" bash "$WORK/sandbox-test-integration.sh" --env "SANDBOX_STUB_MODE=$1" 2>&1 )
}

echo "=== sandbox-test-integration.sh regression suite ==="
echo ""

echo "--- The old exploit: marker/narration without a real Bash write must now FAIL ---"
OUT="$(run never_writes_but_narrates)"; RC=$?
[[ $RC -ne 0 ]]; want "text-only 'SANDBOX_TEST_PASS' with no file write: nonzero exit" $?
grep -q '"passed": false' <<< "$OUT"; want "text-only marker: JSON says passed:false" $?
grep -qi 'no proof of bash execution' <<< "$OUT"; want "text-only marker: warns about missing proof" $?

echo ""
echo "--- Wrong nonce content must FAIL (proves it checks content, not just file existence) ---"
OUT="$(run wrong_content)"; RC=$?
[[ $RC -ne 0 ]]; want "wrong nonce content: nonzero exit" $?
grep -q '"passed": false' <<< "$OUT"; want "wrong nonce content: JSON says passed:false" $?

echo ""
echo "--- A correct write but nonzero Claude exit must FAIL (claude.sandbox_sentinel_falsepass_04) ---"
OUT="$(run correct_but_nonzero_exit)"; RC=$?
[[ $RC -ne 0 ]]; want "correct write, nonzero exit: script exits nonzero" $?
grep -q '"passed": false' <<< "$OUT"; want "correct write, nonzero exit: JSON says passed:false" $?
grep -q '"exit_code": 7' <<< "$OUT"; want "correct write, nonzero exit: exit code is reported" $?
grep -q 'Claude exited with code 7' <<< "$OUT"; want "correct write, nonzero exit: a warning names the exit (bq-2017)" $?

echo ""
echo "--- A permission-override signature must FAIL even with a correct write ---"
OUT="$(run permission_forced)"; RC=$?
[[ $RC -ne 0 ]]; want "permission-forced signature: nonzero exit" $?
grep -q '"permission_forced": true' <<< "$OUT"; want "permission-forced signature: flagged in JSON" $?
grep -q '"passed": false' <<< "$OUT"; want "permission-forced signature: JSON says passed:false" $?

echo ""
echo "--- Empty output with no proof of execution must FAIL (bq-2017) ---"
OUT="$(run empty_output)"; RC=$?
[[ $RC -ne 0 ]]; want "empty output: nonzero exit" $?
grep -q '"passed": false' <<< "$OUT"; want "empty output: JSON says passed:false" $?
grep -q '"nonce_proven": false' <<< "$OUT"; want "empty output: nonce_proven is false" $?

echo ""
echo "--- A sandbox-initialization failure signature must FAIL even with a correct write (bq-2017) ---"
OUT="$(run sandbox_failed)"; RC=$?
[[ $RC -ne 0 ]]; want "sandbox-failed signature: nonzero exit" $?
grep -q '"passed": false' <<< "$OUT"; want "sandbox-failed signature: JSON says passed:false" $?
grep -q '"sandbox_failed": true' <<< "$OUT"; want "sandbox-failed signature: flagged in JSON" $?

echo ""
echo "--- A genuine correct run (exit 0, exact nonce written) must PASS ---"
OUT="$(run correct)"; RC=$?
[[ $RC -eq 0 ]]; want "genuine pass: exits 0" $?
grep -q '"passed": true' <<< "$OUT"; want "genuine pass: JSON says passed:true" $?
grep -q '"nonce_proven": true' <<< "$OUT"; want "genuine pass: nonce_proven is true" $?

echo ""
echo "--- Argument / input validation ---"
OUT="$(PATH="$BIN:/usr/bin:/bin" bash "$WORK/sandbox-test-integration.sh" 2>&1)"; RC=$?
[[ $RC -ne 0 ]]; want "no --env argument: exits nonzero" $?
OUT="$(PATH="$BIN:/usr/bin:/bin" bash "$WORK/sandbox-test-integration.sh" --env 'X=1;rm -rf /' 2>&1)"; RC=$?
# VAR_NAME would be "X" here (split on first '='), which IS a valid identifier -- use
# a genuinely invalid name to exercise the validation.
OUT="$(PATH="$BIN:/usr/bin:/bin" bash "$WORK/sandbox-test-integration.sh" --env 'not a valid name=1' 2>&1)"; RC=$?
[[ $RC -ne 0 ]]; want "invalid env-var name: exits nonzero" $?
grep -qi 'invalid environment variable name' <<< "$OUT"; want "invalid env-var name: says why" $?

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
