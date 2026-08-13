#!/usr/bin/env bash
#
# Regression suite for the stale-item cleanup in scripts/evolution-weekly.sh
# (claude.stale_pending_marked_completed_06).
#
# The defect: age-based cleanup moved unevaluated pending records into
# pipeline/evaluation/completed/, where nothing distinguishes them from a real
# verdict, and a basename collision let one silently replace a completed
# evaluation. These cases pin the corrected behaviour: quarantine directory,
# collision-safe naming, a metadata row per move, and a run that refuses to
# report "completed" when a move failed.
#
# The suite runs the SHIPPED script with a stub `claude` on PATH, so it exercises
# the real code path rather than a copy of it.
#
# Usage:  bash tests/scripts/test-evolution-weekly-cleanup.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SCRIPT_SRC="$REPO_ROOT/scripts/evolution-weekly.sh"
[[ -f "$SCRIPT_SRC" ]] || { echo "FATAL: $SCRIPT_SRC not found" >&2; exit 1; }

PASS=0
FAIL=0
ok()   { PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"; }
bad()  { FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; }
want() { # want <description> <condition-result-rc>
  if [[ "$2" -eq 0 ]]; then ok "$1"; else bad "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/weekly-test.XXXXXX")"
cleanup() { chmod -R u+rwX "$WORK" 2>/dev/null; rm -rf "$WORK"; }
trap cleanup EXIT

# --- a throwaway checkout: scripts/ + the pipeline dirs the cleanup touches ---
make_repo() {
  local repo="$1"
  mkdir -p "$repo/scripts" "$repo/pipeline/evaluation/pending" \
           "$repo/pipeline/evaluation/completed" "$repo/logs"
  cp "$SCRIPT_SRC" "$repo/scripts/evolution-weekly.sh"
}

# A `claude` that does nothing: the analysis phase is not under test here, and a
# test suite must never spend a real model call. It lives in $HOME/.local/bin of a
# THROWAWAY home because the script itself does `export PATH="$HOME/.local/bin:$PATH"`
# — anything placed further down the PATH would lose to the real CLI.
FAKE_HOME="$WORK/home"
STUB_BIN="$FAKE_HOME/.local/bin"
mkdir -p "$STUB_BIN"
cat > "$STUB_BIN/claude" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
chmod +x "$STUB_BIN/claude"

run_weekly() { # run_weekly <repo> -> prints combined output, returns script rc
  local repo="$1"
  ( cd "$repo" && env HOME="$FAKE_HOME" PATH="$STUB_BIN:$PATH" \
      XDG_RUNTIME_DIR="$repo/.runtime" \
      bash "$repo/scripts/evolution-weekly.sh" 2>&1 )
}

# Guard the guard: if the stub is not what runs, every case below is meaningless
# (and slow, and billable).
if ! diff -q <(env HOME="$FAKE_HOME" PATH="$STUB_BIN:$PATH" bash -c 'command -v claude') \
             <(printf '%s\n' "$STUB_BIN/claude") >/dev/null; then
  echo "FATAL: the stub claude is not first on PATH — refusing to run (would invoke the real CLI)" >&2
  exit 1
fi

aged() { # aged <file> : backdate past the 14-day threshold
  touch -d '30 days ago' "$1"
}

echo "=== evolution-weekly.sh stale-cleanup regression suite ==="
echo ""

# ---------------------------------------------------------------------------
echo "--- Stale items are quarantined, never relabelled as completed ---"
R1="$WORK/r1"; make_repo "$R1"
printf '{"title":"aged out"}\n' > "$R1/pipeline/evaluation/pending/old-item.json"
aged "$R1/pipeline/evaluation/pending/old-item.json"
printf '{"title":"fresh"}\n'    > "$R1/pipeline/evaluation/pending/new-item.json"
OUT1="$(run_weekly "$R1")"; RC1=$?

[[ $RC1 -eq 0 ]]; want "run exits 0 when every move succeeds" $?
[[ -f "$R1/pipeline/evaluation/stale/old-item.json" ]]; want "stale item lands in evaluation/stale/" $?
[[ ! -e "$R1/pipeline/evaluation/completed/old-item.json" ]]; want "stale item does NOT land in completed/" $?
[[ ! -e "$R1/pipeline/evaluation/pending/old-item.json" ]]; want "stale item leaves pending/" $?
[[ -f "$R1/pipeline/evaluation/pending/new-item.json" ]]; want "fresh item stays in pending/" $?
grep -q 'UNEVALUATED' <<< "$OUT1"; want "run warns that items aged out unevaluated" $?

echo "$OUT1" | grep -q 'Weekly heartbeat completed'; want "clean run reports completed" $?

# metadata row, written after the move
STALE_LOG="$R1/pipeline/evaluation/stale/stale-log.jsonl"
[[ -s "$STALE_LOG" ]]; want "a metadata row is recorded" $?
if [[ -s "$STALE_LOG" ]]; then
  jq -e 'select(.evaluated == false and .decision == null and (.reason | test("stale")))' \
     "$STALE_LOG" >/dev/null 2>&1
  want "metadata marks the record unevaluated with no decision" $?
  jq -e --arg d "pipeline/evaluation/stale/old-item.json" 'select(.dest == $d)' \
     "$STALE_LOG" >/dev/null 2>&1
  want "metadata records where the record went" $?
else
  bad "metadata marks the record unevaluated with no decision"
  bad "metadata records where the record went"
fi

# ---------------------------------------------------------------------------
echo ""
echo "--- Basename collisions never overwrite ---"
R2="$WORK/r2"; make_repo "$R2"
mkdir -p "$R2/pipeline/evaluation/stale"
printf '{"quarantined":"first"}\n' > "$R2/pipeline/evaluation/stale/dup.json"
printf '{"pending":"second"}\n'    > "$R2/pipeline/evaluation/pending/dup.json"
aged "$R2/pipeline/evaluation/pending/dup.json"
# a completed record with the same basename must be left strictly alone
printf '{"verdict":"real evaluation"}\n' > "$R2/pipeline/evaluation/completed/dup.json"
OUT2="$(run_weekly "$R2")"; RC2=$?

[[ $RC2 -eq 0 ]]; want "collision run exits 0" $?
grep -q 'first' "$R2/pipeline/evaluation/stale/dup.json"; want "existing quarantined record is untouched" $?
grep -q 'real evaluation' "$R2/pipeline/evaluation/completed/dup.json"; want "existing completed verdict is untouched" $?
[[ "$(find "$R2/pipeline/evaluation/stale" -name '*.json' -type f | wc -l)" -eq 2 ]]
want "both records survive under distinct names" $?

# ---------------------------------------------------------------------------
echo ""
echo "--- A failed move must fail the run, not report health ---"
R3="$WORK/r3"; make_repo "$R3"
printf '{"title":"cannot move"}\n' > "$R3/pipeline/evaluation/pending/stuck.json"
aged "$R3/pipeline/evaluation/pending/stuck.json"
mkdir -p "$R3/pipeline/evaluation/stale"
chmod 500 "$R3/pipeline/evaluation/stale"      # read+execute, no writes
OUT3="$(run_weekly "$R3")"; RC3=$?
chmod 700 "$R3/pipeline/evaluation/stale"

if [[ "$(id -u)" -eq 0 ]]; then
  echo "  skip (running as root: the unwritable-directory case cannot be simulated)"
else
  [[ $RC3 -ne 0 ]]; want "run exits nonzero when a stale item cannot be quarantined" $?
  ! grep -q 'Weekly heartbeat completed' <<< "$OUT3"; want "run does NOT report 'completed' after a failed move" $?
  grep -q 'Weekly heartbeat FAILED' <<< "$OUT3"; want "run says explicitly that it failed" $?
  [[ -f "$R3/pipeline/evaluation/pending/stuck.json" ]]; want "unmovable item stays in the queue (safe side)" $?
fi

# ---------------------------------------------------------------------------
echo ""
echo "--- A concurrent daily run defers the quarantine instead of racing it ---"
R4="$WORK/r4"; make_repo "$R4"
printf '{"title":"deferred"}\n' > "$R4/pipeline/evaluation/pending/held.json"
aged "$R4/pipeline/evaluation/pending/held.json"
mkdir -p "$R4/.runtime/claude-evolution"
DAILY_LOCK="$R4/.runtime/claude-evolution/evolution-daily.lock"
: > "$DAILY_LOCK"
flock "$DAILY_LOCK" -c 'sleep 30' &
LOCK_HOLDER=$!
sleep 1                                  # let the holder acquire before the run starts
OUT4="$(run_weekly "$R4")"; RC4=$?
kill "$LOCK_HOLDER" 2>/dev/null; wait "$LOCK_HOLDER" 2>/dev/null

[[ $RC4 -eq 0 ]]; want "deferred run exits 0" $?
grep -q 'quarantine SKIPPED' <<< "$OUT4"; want "run says the quarantine was skipped" $?
[[ -f "$R4/pipeline/evaluation/pending/held.json" ]]; want "the stale item stays queued for next week" $?
[[ ! -e "$R4/pipeline/evaluation/stale/held.json" ]]; want "nothing was moved while the daily run held the lock" $?
grep -q '0 stale item(s) quarantined' <<< "$OUT4"; want "run does not claim items it did not quarantine" $?

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
