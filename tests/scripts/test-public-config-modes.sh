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
# It also pins claude.public_scan_abnormal_exit_green_02: grep_or_fail rejected
# only exit 2, so exit 127 (grep not installed) and a signal death such as 137
# fell through to "no matches". A complete publication-mode run over a corpus
# carrying a dummy private name and a password-shaped line exited 0 and printed
# ALL TESTS PASSED with no grep on PATH. Only exit 0 and exit 1 are results —
# for the scans AND for the exception filters, which sit in the same fail-open
# position.
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

# ---------------------------------------------------------------------------
echo ""
echo "--- Enumeration failures are scan failures, not zero matches (claude.privacy_scan_walk_failopen_08) ---"
rm -rf "$FIX/reference-config"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "missing reference-config/ exits nonzero" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "missing reference-config/ never prints ALL TESTS PASSED" $?
mkdir -p "$FIX/reference-config"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "empty (zero-file) reference-config/ exits nonzero" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "empty reference-config/ never prints ALL TESTS PASSED" $?
cat > "$FIX/reference-config/clean.md" <<'MD'
# Reference config

Put skills in ~/.claude/skills/ and clone into ~/your-project.
MD

# ---------------------------------------------------------------------------
echo ""
echo "--- Non-Markdown leaks are now caught (claude.publication_scan_partial_green_05) ---"
mkdir -p "$FIX/reference-config/skills/browser-mcp-setup/scripts"
cat > "$FIX/reference-config/skills/browser-mcp-setup/scripts/leaky.sh" <<'SH'
#!/bin/sh
echo "home is /home/someuser/notes"
SH
OUT="$(run --generic-only)"; RC=$?
[[ $RC -ne 0 ]]; want "a private path inside a .sh reference script now fails the scan" $?
grep -q 'leaky.sh' <<< "$OUT"; want "the failure names the offending .sh file" $?
rm -rf "$FIX/reference-config/skills/browser-mcp-setup"

# ---------------------------------------------------------------------------
echo ""
echo "--- An invalid regex in .private-patterns is a scan FAILURE, not a silent no-match ---"
printf 'privateproj
[unterminated
' > "$FIX/scripts/.private-patterns"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "invalid ERE in .private-patterns exits nonzero" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "invalid ERE never prints ALL TESTS PASSED" $?
grep -qi 'not a valid extended regex' <<< "$OUT"; want "the failure names it as an invalid pattern, not a clean scan" $?
printf 'privateproj
privateagent
' > "$FIX/scripts/.private-patterns"

# ---------------------------------------------------------------------------
echo ""
echo "--- A grep that cannot run is a scan FAILURE, not a clean publication (claude.public_scan_abnormal_exit_green_02) ---"

REAL_GREP="$(command -v grep)"
REAL_BASH="$(command -v bash)"

# PATH with every other required utility but no grep -- the Pro's reproduction.
NOGREP_BIN="$WORK/bin-nogrep"
mkdir -p "$NOGREP_BIN"
for c in find sed basename mktemp dirname cat rm head chmod ls; do
  cbin="$(command -v "$c" 2>/dev/null || true)"
  [[ -n "$cbin" ]] && ln -sf "$cbin" "$NOGREP_BIN/$c"
done
run_nogrep() { ( cd "$FIX" && env -i PATH="$NOGREP_BIN" "$REAL_BASH" scripts/test-public-config.sh "$@" 2>&1 ); }

# A grep that is present but dies the way an OOM kill or a broken build does.
STUB137_BIN="$WORK/bin-grep137"
mkdir -p "$STUB137_BIN"
printf '#!/bin/sh\nexit 137\n' > "$STUB137_BIN/grep"
chmod +x "$STUB137_BIN/grep"
run_grep137() { ( cd "$FIX" && env PATH="$STUB137_BIN:$PATH" bash scripts/test-public-config.sh "$@" 2>&1 ); }

# A grep that works for the scans and dies only in the exception-filter position.
FILTER137_BIN="$WORK/bin-filter137"
mkdir -p "$FILTER137_BIN"
{
  printf '#!/bin/sh\n'
  printf 'if [ "$1" = "-v" ]; then exit 137; fi\n'
  printf 'exec %s "$@"\n' "$REAL_GREP"
} > "$FILTER137_BIN/grep"
chmod +x "$FILTER137_BIN/grep"
run_filter137() { ( cd "$FIX" && env PATH="$FILTER137_BIN:$PATH" bash scripts/test-public-config.sh "$@" 2>&1 ); }

# A corpus a working scanner rejects: a dummy private name and a password-shaped
# line. Nothing here is a real credential.
printf 'privateproj\nprivateagent\n' > "$FIX/scripts/.private-patterns"
printf 'The privateproj rollout notes, password: not-a-real-secret.\n' > "$FIX/reference-config/leak.md"

OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "control: an ordinary grep rejects the leaking fixture" $?

OUT="$(run_nogrep)"; RC=$?
[[ $RC -ne 0 ]]; want "missing grep: the scan FAILS instead of clearing the publication" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "missing grep: never prints ALL TESTS PASSED" $?
grep -q 'required tool' <<< "$OUT"; want "missing grep: names the tool it could not find" $?

OUT="$(run_grep137)"; RC=$?
[[ $RC -ne 0 ]]; want "abnormal grep exit (137): the scan FAILS instead of clearing the publication" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "abnormal grep exit: never prints ALL TESTS PASSED" $?
grep -q 'exited 137' <<< "$OUT"; want "abnormal grep exit: names the status it saw" $?

# The exception filter on its own: a file whose private-path findings are a
# genuine leak AND an allowed `~/your-project` exception. A filter that cannot
# run used to drop BOTH, and with nothing else to report the run came back
# clean. --generic-only isolates it from the private-name scans, so this case
# can only be carried by the filter.
printf 'Clone into ~/your-project.\nThis line, though, says /home/someuser/notes.\n' > "$FIX/reference-config/mixed.md"
rm -f "$FIX/reference-config/leak.md"

OUT="$(run --generic-only)"; RC=$?
[[ $RC -ne 0 ]]; want "control: an ordinary grep keeps the leak and drops the exception" $?

OUT="$(run_filter137 --generic-only)"; RC=$?
[[ $RC -ne 0 ]]; want "path-exception filter failure: the scan FAILS instead of dropping the finding" $?
! grep -q 'PARTIAL CHECKS ONLY' <<< "$OUT"; want "filter failure: never reports even a partial clean run" $?
grep -qi 'could not be filtered\|exception filter could not run' <<< "$OUT"; want "filter failure: says the filter, not the file, is what failed" $?
rm -f "$FIX/reference-config/mixed.md"
printf 'The privateproj rollout notes, password: not-a-real-secret.\n' > "$FIX/reference-config/leak.md"

# The same three failure modes must not be cleared by --generic-only either:
# a partial run is still a run, and a broken detector is still broken.
OUT="$(run_grep137 --generic-only)"; RC=$?
[[ $RC -ne 0 ]]; want "--generic-only with an abnormal grep exit also FAILS" $?
! grep -q 'PARTIAL CHECKS ONLY' <<< "$OUT"; want "--generic-only with an abnormal grep exit does not print PARTIAL CHECKS ONLY" $?

rm -f "$FIX/reference-config/leak.md"

# ---------------------------------------------------------------------------
echo ""
echo "--- The dependency preflight covers every program the scanner runs, not just its detectors ---"
# With a complete corpus and only `head` missing, the frontmatter check misread
# valid SKILL.md files as lacking frontmatter and the run still ended in a zero
# exit (Astra fix-verification, 2026-09-15). An unavailable check is not a
# passed one, whichever program is unavailable.
mkdir -p "$FIX/reference-config/skills/demo"
printf -- '---\nname: demo\n---\n\n# Demo\n' > "$FIX/reference-config/skills/demo/SKILL.md"
for tool_missing in head dirname cat rm; do
  MISSING_BIN="$WORK/bin-missing-$tool_missing"
  mkdir -p "$MISSING_BIN"
  for c in grep find sed basename dirname head cat rm mktemp ls; do
    [[ "$c" == "$tool_missing" ]] && continue
    cbin="$(command -v "$c" 2>/dev/null || true)"
    [[ -n "$cbin" ]] && ln -sf "$cbin" "$MISSING_BIN/$c"
  done
  OUT="$( cd "$FIX" && env -i PATH="$MISSING_BIN" "$REAL_BASH" scripts/test-public-config.sh 2>&1 )"; RC=$?
  [[ $RC -eq 1 ]]; want "missing $tool_missing: the scan FAILS (exit 1) instead of reporting a completed run" $?
  # The diagnostic must name THIS tool: "required tool(s) not found" alone would
  # still pass if the preflight always printed the same name.
  grep -qE "required tool\(s\) not found on PATH:.*\b$tool_missing\b" <<< "$OUT"
  want "missing $tool_missing: the preflight names $tool_missing itself" $?
  ! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "missing $tool_missing: never prints ALL TESTS PASSED" $?
done
rm -rf "$FIX/reference-config/skills/demo"

# ---------------------------------------------------------------------------
echo ""
echo "--- A structural check whose READER fails is a scan failure, however it fails ---"
# Under `pipefail`, `head -1 "$f" | grep -q '^---'` with a head that dies WITHOUT
# writing anything leaves grep with empty input: grep exits 1, 1 is the rightmost
# nonzero status, and the pipeline reads as "this file has no frontmatter". A
# reader that never ran became a warning and a zero exit (Astra verification
# round 2, 2026-09-15).
mkdir -p "$FIX/reference-config/skills/demo"
printf -- '---\nname: demo\n---\n\n# Demo\n' > "$FIX/reference-config/skills/demo/SKILL.md"

OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "control: a valid SKILL.md passes with an ordinary head" $?

HEAD_SILENT_BIN="$WORK/bin-head-silent137"
mkdir -p "$HEAD_SILENT_BIN"
printf '#!/bin/sh\nexit 137\n' > "$HEAD_SILENT_BIN/head"
chmod +x "$HEAD_SILENT_BIN/head"
OUT="$( cd "$FIX" && env PATH="$HEAD_SILENT_BIN:$PATH" bash scripts/test-public-config.sh 2>&1 )"; RC=$?
[[ $RC -ne 0 ]]; want "frontmatter reader exits 137 with NO output: the scan FAILS" $?
! grep -q 'ALL TESTS PASSED' <<< "$OUT"; want "silent reader failure: never prints ALL TESTS PASSED" $?
! grep -q 'missing frontmatter' <<< "$OUT"; want "silent reader failure: not misreported as missing frontmatter" $?
grep -q 'head exited 137' <<< "$OUT"; want "silent reader failure: names the reader and its status" $?

HEAD_NOISY_BIN="$WORK/bin-head-noisy137"
mkdir -p "$HEAD_NOISY_BIN"
printf '#!/bin/sh\necho "---"\nexit 137\n' > "$HEAD_NOISY_BIN/head"
chmod +x "$HEAD_NOISY_BIN/head"
OUT="$( cd "$FIX" && env PATH="$HEAD_NOISY_BIN:$PATH" bash scripts/test-public-config.sh 2>&1 )"; RC=$?
[[ $RC -ne 0 ]]; want "frontmatter reader exits 137 AFTER emitting a line: the scan still FAILS" $?
grep -q 'head exited 137' <<< "$OUT"; want "noisy reader failure: named as the reader, not the file" $?

# A genuinely absent frontmatter is still only a warning, and still exits 0.
printf '# Demo with no frontmatter\n' > "$FIX/reference-config/skills/demo/SKILL.md"
OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "genuinely missing frontmatter: still a warning, still exit 0" $?
grep -q 'WARN: .*missing frontmatter' <<< "$OUT"; want "genuinely missing frontmatter: still reported at WARN level" $?
rm -rf "$FIX/reference-config/skills/demo"

# --help must not outrun the preflight either: it is the one path that reached an
# external program (cat, for the usage heredoc) before the dependency check.
NOCAT_BIN="$WORK/bin-nocat"
mkdir -p "$NOCAT_BIN"
for c in grep find sed basename dirname head rm mktemp ls; do
  cbin="$(command -v "$c" 2>/dev/null || true)"
  [[ -n "$cbin" ]] && ln -sf "$cbin" "$NOCAT_BIN/$c"
done
OUT="$( cd "$FIX" && env -i PATH="$NOCAT_BIN" "$REAL_BASH" scripts/test-public-config.sh --help 2>&1 )"; RC=$?
[[ $RC -eq 1 ]]; want "--help with cat missing: exits 1 from the preflight, not 127 from a missing cat" $?
grep -qE "required tool\(s\) not found on PATH:.*\bcat\b" <<< "$OUT"
want "--help with cat missing: the preflight names cat" $?

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
