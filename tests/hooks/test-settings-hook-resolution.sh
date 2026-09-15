#!/usr/bin/env bash
#
# Post-publication clean-checkout suite for the PreToolUse guards configured in
# .claude/settings.json (claude.read_hook_missing_public_01).
#
# THE DEFECT THIS EXISTS FOR
#   The published artifact registered a Read|Glob|Grep guard in
#   .claude/settings.json whose script was not published with it. A fresh
#   checkout ran the configured command, the shell returned 127, and Claude
#   Code's PreToolUse contract treats every hook failure other than exit 2 as
#   NON-BLOCKING: Read, Glob and Grep ran unguarded in the same sessions that
#   hold WebFetch and WebSearch, and nothing in the transcript said so. The
#   guard could not fail closed from inside itself, because it never started.
#
#   Neither of the existing hook suites could see that. tests/hooks/test-
#   block-sensitive-reads.sh invokes the guard script directly, so it passes on
#   a tree that never publishes it; tests/hooks/test-settings-hook-quoting.sh
#   reads only the first configured hook entry.
#
# WHAT THIS SUITE PROVES, RUN FROM A CLEAN CHECKOUT AND NOTHING ELSE
#   1. every command configured in this checkout's settings.json resolves to an
#      executable file that is actually present in this checkout;
#   2. a checkout that is missing one, or carries it non-executable, is REFUSED
#      by scripts/check-hook-commands.py -- the check the daily wrapper runs
#      before any agent starts;
#   3. a sensitive read is DENIED (exit 2) when driven through the configured
#      command string itself, not through a directly-invoked script path.
#
# Usage:  bash tests/hooks/test-settings-hook-resolution.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SETTINGS="$REPO_ROOT/.claude/settings.json"
CHECKER="$REPO_ROOT/scripts/check-hook-commands.py"

[[ -f "$SETTINGS" ]] || { echo "FATAL: $SETTINGS not found" >&2; exit 1; }
[[ -f "$CHECKER" ]]  || { echo "FATAL: $CHECKER not found -- the hook-resolution preflight is not published" >&2; exit 1; }
command -v jq      >/dev/null 2>&1 || { echo "FATAL: jq required" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "FATAL: python3 required" >&2; exit 1; }

PASS=0
FAIL=0
want() { # want <description> <rc-of-condition>
  if [[ "$2" -eq 0 ]]; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/settings-hook-resolution.XXXXXX")"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

echo "=== configured PreToolUse guards resolve, and deny, from this checkout alone ==="
echo ""

# ---------------------------------------------------------------------------
echo "--- 1. This checkout: every configured hook command resolves ---"
OUT="$(CLAUDE_PROJECT_DIR="$REPO_ROOT" python3 "$CHECKER" --settings "$SETTINGS" --project-dir "$REPO_ROOT" 2>&1)"; RC=$?
[[ $RC -eq 0 ]]; want "this checkout: check-hook-commands.py exits 0" $?
grep -q 'block-sensitive-writes.sh' <<< "$OUT"; want "this checkout: the write guard resolves" $?
grep -q 'block-sensitive-reads.sh'  <<< "$OUT"; want "this checkout: the read guard resolves" $?
! grep -q 'UNRESOLVED' <<< "$OUT"; want "this checkout: nothing reported UNRESOLVED" $?

# Every command the settings register must be checked, not just the first entry.
CONFIGURED_N="$(jq '[.hooks | to_entries[] | .value[] | .hooks[] | select(.type == "command")] | length' "$SETTINGS")"
CHECKED_N="$(grep -c '^ok   \|^UNRESOLVED ' <<< "$OUT")"
[[ "$CHECKED_N" == "$CONFIGURED_N" ]]
want "every configured command is checked ($CHECKED_N of $CONFIGURED_N)" $?

# ---------------------------------------------------------------------------
# A fixture checkout we can break without touching the real one.
FIX="$WORK/checkout"
mkdir -p "$FIX/.claude/hooks" "$FIX/scripts"
cp "$SETTINGS" "$FIX/.claude/settings.json"
cp "$CHECKER" "$FIX/scripts/check-hook-commands.py"
for h in "$REPO_ROOT"/.claude/hooks/*.sh; do
  cp "$h" "$FIX/.claude/hooks/"
  chmod +x "$FIX/.claude/hooks/$(basename "$h")"
done
run_checker() { # run_checker  -- against the fixture checkout
  ( cd "$FIX" && CLAUDE_PROJECT_DIR="$FIX" python3 scripts/check-hook-commands.py 2>&1 )
}

echo ""
echo "--- 2. A checkout missing a configured guard is REFUSED ---"
OUT="$(run_checker)"; RC=$?
[[ $RC -eq 0 ]]; want "intact fixture: resolves (control)" $?

mv "$FIX/.claude/hooks/block-sensitive-reads.sh" "$WORK/reads.sh.held"
OUT="$(run_checker)"; RC=$?
[[ $RC -ne 0 ]]; want "read guard absent: refuses (this is the published defect)" $?
grep -q 'UNRESOLVED' <<< "$OUT"; want "read guard absent: reports it UNRESOLVED" $?
grep -q 'block-sensitive-reads.sh' <<< "$OUT"; want "read guard absent: names the missing script" $?
grep -qi 'non-blocking' <<< "$OUT"; want "read guard absent: says why that is not a refusal by Claude" $?
mv "$WORK/reads.sh.held" "$FIX/.claude/hooks/block-sensitive-reads.sh"

echo ""
echo "--- 3. A present-but-unexecutable guard is REFUSED (a mode loss is not a guard) ---"
chmod -x "$FIX/.claude/hooks/block-sensitive-reads.sh"
OUT="$(run_checker)"; RC=$?
[[ $RC -ne 0 ]]; want "read guard not executable: refuses" $?
grep -qi 'not executable' <<< "$OUT"; want "read guard not executable: names the mode, not absence" $?
chmod +x "$FIX/.claude/hooks/block-sensitive-reads.sh"

echo ""
echo "--- 4. A command this check cannot resolve is REFUSED, never assumed fine ---"
jq '.hooks.PreToolUse[1].hooks[0].command = "\"$SOME_OTHER_DIR/.claude/hooks/block-sensitive-reads.sh\""' \
   "$FIX/.claude/settings.json" > "$FIX/.claude/settings.json.tmp" && mv "$FIX/.claude/settings.json.tmp" "$FIX/.claude/settings.json"
OUT="$(run_checker)"; RC=$?
[[ $RC -ne 0 ]]; want "unexpanded variable in a command: refuses" $?
grep -q 'SOME_OTHER_DIR' <<< "$OUT"; want "unexpanded variable: names the variable it could not expand" $?
cp "$SETTINGS" "$FIX/.claude/settings.json"

echo ""
echo "--- 5. Unreadable settings are a check failure, not an empty pass ---"
mv "$FIX/.claude/settings.json" "$WORK/settings.json.held"
OUT="$(run_checker)"; RC=$?
[[ $RC -eq 2 ]]; want "settings.json missing: exits 2 (cannot check), not 0" $?
grep -q 'UNRESOLVABLE' <<< "$OUT"; want "settings.json missing: says it could not read them" $?
mv "$WORK/settings.json.held" "$FIX/.claude/settings.json"

# ---------------------------------------------------------------------------
# 6. Drive a sensitive read through the CONFIGURED command string, from a
#    checkout path that contains a space -- the shape a clone actually runs.
echo ""
echo "--- 6. A sensitive read is DENIED through the configured command ---"
PROJ="$WORK/AI Projects/claude-evolution"
FAKE_HOME="$WORK/home"
OUTSIDE="$WORK/outside"
mkdir -p "$PROJ/.claude/hooks" "$PROJ/pipeline" "$FAKE_HOME/.aws" "$OUTSIDE"
cp "$SETTINGS" "$PROJ/.claude/settings.json"
for h in "$REPO_ROOT"/.claude/hooks/*.sh; do
  cp "$h" "$PROJ/.claude/hooks/"
  chmod +x "$PROJ/.claude/hooks/$(basename "$h")"
done
printf 'super secret\n' > "$OUTSIDE/secret.txt"
printf 'AKIA-not-a-real-key\n' > "$FAKE_HOME/.aws/credentials"
printf 'in-tree content\n' > "$PROJ/pipeline/report.md"

# The Read|Glob|Grep entry, selected by its matcher rather than by index.
READ_CMD="$(jq -er '[.hooks.PreToolUse[] | select(.matcher | test("Read")) | .hooks[] | select(.type == "command") | .command][0]' "$SETTINGS")"
[[ -n "$READ_CMD" ]]; want "settings.json registers a command hook for Read" $?

run_configured() { # run_configured <payload-json>
  printf '%s' "$1" | env CLAUDE_PROJECT_DIR="$PROJ" HOME="$FAKE_HOME" sh -c "$READ_CMD" >/dev/null 2>&1
  echo $?
}
payload() { # payload <tool> <key> <path>
  jq -cn --arg t "$1" --arg k "$2" --arg p "$3" --arg c "$PROJ" \
    '{tool_name: $t, tool_input: {($k): $p}, cwd: $c}'
}

[[ "$(run_configured "$(payload Read file_path "$PROJ/pipeline/report.md")")" == 0 ]]
want "in-tree read still ALLOWED through the configured command" $?
[[ "$(run_configured "$(payload Read file_path "$OUTSIDE/secret.txt")")" == 2 ]]
want "read outside the project DENIED through the configured command" $?
[[ "$(run_configured "$(payload Read file_path "$FAKE_HOME/.aws/credentials")")" == 2 ]]
want "credential read in HOME DENIED through the configured command" $?
[[ "$(run_configured "$(payload Grep path "$FAKE_HOME/.aws")")" == 2 ]]
want "Grep over a HOME credential directory DENIED through the configured command" $?

# 7. The same fixture WITHOUT the read guard is the published state: the
#    configured command cannot start, and its exit is not a denial.
echo ""
echo "--- 7. Without the guard, the configured command does not deny -- it just fails ---"
mv "$PROJ/.claude/hooks/block-sensitive-reads.sh" "$WORK/reads.sh.held2"
DENIED_RC="$(run_configured "$(payload Read file_path "$OUTSIDE/secret.txt")")"
[[ "$DENIED_RC" != 2 ]]
want "guard absent: the configured command's exit is NOT 2 (exit $DENIED_RC = the tool runs)" $?
mv "$WORK/reads.sh.held2" "$PROJ/.claude/hooks/block-sensitive-reads.sh"

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
