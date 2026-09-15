#!/usr/bin/env bash
#
# Regression suite for the owner-interest preflight in scripts/evolution-daily.sh
# (claude.owner_interest_gate_absent_03 / claude.owner_interest_config_preflight_02).
#
# Does NOT run the real evolution-daily.sh (which spawns `claude -p` agents and
# mutates the discoveries/pipeline queue -- see the file's own module docstring).
# Instead it truncates a COPY of the script right after the preflight block
# (before "# Tool allowlists", i.e. before Phase 1 could ever run) and exercises
# that truncated copy against fixture lib/config states: missing, unreadable,
# present-but-unimportable, present-but-malformed-yaml, and a real pass. A fake
# `claude` stub satisfies the script's own earlier "is claude installed" check
# without ever being invoked -- the truncation happens before Phase 1 calls it.
#
# Usage:  bash tests/scripts/test-evolution-daily-preflight.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SCRIPT_SRC="$REPO_ROOT/scripts/evolution-daily.sh"
[[ -f "$SCRIPT_SRC" ]] || { echo "FATAL: $SCRIPT_SRC not found" >&2; exit 1; }

PASS=0
FAIL=0
want() { # want <description> <rc-of-condition>
  if [[ "$2" -eq 0 ]]; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/evo-daily-preflight-test.XXXXXX")"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

FIX="$WORK/repo"
mkdir -p "$FIX/scripts" "$FIX/lib" "$FIX/config" "$FIX/logs"

# Truncate right after the preflight `if [[ ${#preflight_missing[@]} -gt 0 ]]; then ... fi`
# block, before Phase 1 (the `# Tool allowlists.` comment marks the boundary),
# and append a marker so a pass through the whole preflight is observable.
ANCHOR_LINE="$(grep -n '^# Tool allowlists\.' "$SCRIPT_SRC" | head -1 | cut -d: -f1)"
[[ -n "$ANCHOR_LINE" ]] || { echo "FATAL: could not find the Phase-1 boundary in $SCRIPT_SRC" >&2; exit 1; }
{
  head -n "$((ANCHOR_LINE - 1))" "$SCRIPT_SRC"
  echo 'echo "PREFLIGHT_PASSED"'
  echo 'exit 0'
} > "$FIX/scripts/evolution-daily.sh"
chmod +x "$FIX/scripts/evolution-daily.sh"

# Fake `claude` binary: satisfies the script's own earlier availability check.
# Never invoked -- the truncation happens before any `claude -p` call.
BIN="$WORK/bin"
mkdir -p "$BIN"
printf '#!/bin/sh\nexit 0\n' > "$BIN/claude"
chmod +x "$BIN/claude"

# A valid lens + config, for the "everything works" baseline.
cp "$REPO_ROOT/lib/owner_interest_lens.py" "$FIX/lib/owner_interest_lens.py"
cp "$REPO_ROOT/config/owner-interests.yaml" "$FIX/config/owner-interests.yaml"

# The configured PreToolUse guards and the check that resolves them
# (claude.read_hook_missing_public_01). The wrapper refuses to start an agent
# whose advertised guard is not there to run, so the baseline fixture needs a
# complete, executable guard set.
mkdir -p "$FIX/.claude/hooks"
cp "$REPO_ROOT/.claude/settings.json" "$FIX/.claude/settings.json"
cp "$REPO_ROOT/scripts/check-hook-commands.py" "$FIX/scripts/check-hook-commands.py"
for hook_src in "$REPO_ROOT"/.claude/hooks/*.sh; do
  cp "$hook_src" "$FIX/.claude/hooks/"
  chmod +x "$FIX/.claude/hooks/$(basename "$hook_src")"
done

run() { ( cd "$FIX" && env PATH="$BIN:$PATH" HOME="$WORK/home" XDG_RUNTIME_DIR="$WORK/xdg" bash scripts/evolution-daily.sh 2>&1 ); }
mkdir -p "$WORK/home" "$WORK/xdg"

echo "=== evolution-daily.sh owner-interest preflight regression suite ==="
echo ""

# ---------------------------------------------------------------------------
echo "--- A genuinely usable lens + config passes the preflight ---"
OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "valid lib+config: preflight exits 0" $?
grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "valid lib+config: reaches Phase 1" $?

# ---------------------------------------------------------------------------
echo ""
echo "--- Missing files still refuse (pre-existing behaviour, must not regress) ---"
mv "$FIX/lib/owner_interest_lens.py" "$WORK/lens.py.bak"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "missing lib/owner_interest_lens.py: refuses" $?
! grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "missing lib: never reaches Phase 1" $?
grep -qi 'owner-interest gate is unavailable' <<< "$OUT"; want "missing lib: names the reason" $?
mv "$WORK/lens.py.bak" "$FIX/lib/owner_interest_lens.py"

# ---------------------------------------------------------------------------
echo ""
echo "--- Present but malformed config must ALSO refuse (claude.owner_interest_config_preflight_02) ---"
cp "$FIX/config/owner-interests.yaml" "$WORK/config.yaml.bak"
printf 'version: 1\ndomains: []\n' > "$FIX/config/owner-interests.yaml"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "empty-domains config (readable, unusable): refuses" $?
! grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "empty-domains config: never reaches Phase 1" $?
cp "$WORK/config.yaml.bak" "$FIX/config/owner-interests.yaml"

# ---------------------------------------------------------------------------
echo ""
echo "--- Present but syntactically invalid YAML must ALSO refuse ---"
cp "$FIX/config/owner-interests.yaml" "$WORK/config.yaml.bak2"
printf 'domains: [\n  - id: broken\n' > "$FIX/config/owner-interests.yaml"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "invalid YAML config (readable, unusable): refuses" $?
! grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "invalid YAML config: never reaches Phase 1" $?
cp "$WORK/config.yaml.bak2" "$FIX/config/owner-interests.yaml"

# ---------------------------------------------------------------------------
echo ""
echo "--- Present but un-importable module (e.g. missing a dependency it needs) must ALSO refuse ---"
cp "$FIX/lib/owner_interest_lens.py" "$WORK/lens.py.bak2"
printf 'raise ImportError("simulated missing dependency, e.g. PyYAML")\n' > "$FIX/lib/owner_interest_lens.py"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "un-importable lens module: refuses" $?
! grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "un-importable lens module: never reaches Phase 1" $?
cp "$WORK/lens.py.bak2" "$FIX/lib/owner_interest_lens.py"

# ---------------------------------------------------------------------------
# The guard-resolution preflight (claude.read_hook_missing_public_01).
#
# A hook command that does not exist returns 127, and Claude Code treats any
# PreToolUse failure other than exit 2 as NON-BLOCKING -- the tool runs
# unguarded. The guard cannot fail closed from inside itself because it never
# starts, so the wrapper has to refuse before an agent holding Read, Glob,
# Grep, WebFetch and WebSearch is launched. These cases drive the real wrapper,
# truncated at the same Phase-1 boundary, so a refusal here IS a refusal before
# Phase 1.
# ---------------------------------------------------------------------------
echo ""
echo "--- A configured guard that is not present must refuse BEFORE Phase 1 ---"
mv "$FIX/.claude/hooks/block-sensitive-reads.sh" "$WORK/reads.sh.held"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "missing read guard: refuses" $?
! grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "missing read guard: never reaches Phase 1" $?
grep -q 'block-sensitive-reads.sh' <<< "$OUT"; want "missing read guard: names the script it could not resolve" $?
mv "$WORK/reads.sh.held" "$FIX/.claude/hooks/block-sensitive-reads.sh"

echo ""
echo "--- A configured guard present but not executable must ALSO refuse ---"
chmod -x "$FIX/.claude/hooks/block-sensitive-writes.sh"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "non-executable write guard: refuses" $?
! grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "non-executable write guard: never reaches Phase 1" $?
chmod +x "$FIX/.claude/hooks/block-sensitive-writes.sh"

echo ""
echo "--- The resolver itself going missing must refuse, not be skipped ---"
mv "$FIX/scripts/check-hook-commands.py" "$WORK/check-hook-commands.py.held"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "missing check-hook-commands.py: refuses" $?
! grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "missing check-hook-commands.py: never reaches Phase 1" $?
mv "$WORK/check-hook-commands.py.held" "$FIX/scripts/check-hook-commands.py"

echo ""
echo "--- With every guard present and executable, the preflight still passes ---"
OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "complete guard set: preflight exits 0" $?
grep -q 'PREFLIGHT_PASSED' <<< "$OUT"; want "complete guard set: reaches Phase 1" $?

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
