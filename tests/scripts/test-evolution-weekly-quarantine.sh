#!/usr/bin/env bash
#
# Regression suite for the stale-item quarantine in scripts/evolution-weekly.sh
# (claude.weekly_quarantine_partial_scan_09).
#
# Runs a COPY of the real script against a `claude` STUB (logs and exits 0, no
# real agent call) in an isolated fixture directory -- "test with fixtures and
# stubs" per this file's own handling rules. mtimes are backdated with `touch`,
# not by waiting 14 real days.
#
# Usage:  bash tests/scripts/test-evolution-weekly-quarantine.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SCRIPT_SRC="$REPO_ROOT/scripts/evolution-weekly.sh"
[[ -f "$SCRIPT_SRC" ]] || { echo "FATAL: $SCRIPT_SRC not found" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "FATAL: jq required" >&2; exit 1; }

PASS=0
FAIL=0
want() {
  if [[ "$2" -eq 0 ]]; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/evo-weekly-test.XXXXXX")"
cleanup() { chmod -R u+rwX "$WORK" 2>/dev/null; rm -rf "$WORK"; }
trap cleanup EXIT

FIX="$WORK/repo"
BIN="$WORK/bin"
mkdir -p "$FIX/scripts" "$FIX/logs" "$FIX/pipeline/evaluation/pending" "$BIN" "$WORK/home" "$WORK/xdg"
# The configured PreToolUse guards and the resolver the wrapper preflights with
# (claude.read_hook_missing_public_01): the wrapper refuses to launch an agent
# whose advertised guard is not there to run, so a fixture checkout needs a
# complete, executable guard set before the cases below mean anything.
install_guard_fixture() { # install_guard_fixture <repo-root>
  local repo="$1" hook_src
  mkdir -p "$repo/.claude/hooks" "$repo/scripts"
  cp "$REPO_ROOT/.claude/settings.json" "$repo/.claude/settings.json"
  cp "$REPO_ROOT/scripts/check-hook-commands.py" "$repo/scripts/check-hook-commands.py"
  for hook_src in "$REPO_ROOT"/.claude/hooks/*.sh; do
    cp "$hook_src" "$repo/.claude/hooks/"
    chmod +x "$repo/.claude/hooks/$(basename "$hook_src")"
  done
}

cp "$SCRIPT_SRC" "$FIX/scripts/evolution-weekly.sh"
chmod +x "$FIX/scripts/evolution-weekly.sh"
install_guard_fixture "$FIX"

cat > "$BIN/claude" <<'STUB'
#!/bin/sh
exit 0
STUB
chmod +x "$BIN/claude"
# Real jq: quarantine metadata needs the actual JSON builder, not a stub.
ln -s "$(command -v jq)" "$BIN/jq"
for c in mkdir basename date flock mv cat rm chmod stat find touch tee env cd sh bash true false wc; do
  p="$(command -v "$c" 2>/dev/null || true)"
  [[ -n "$p" ]] && ln -sf "$p" "$BIN/$c" 2>/dev/null
done

run() {
  ( cd "$FIX" && env -i PATH="$BIN:/usr/bin:/bin" HOME="$WORK/home" XDG_RUNTIME_DIR="$WORK/xdg" \
      bash scripts/evolution-weekly.sh 2>&1 )
}

echo "=== evolution-weekly.sh quarantine regression suite ==="
echo ""

echo "--- Stale .md records are now quarantined too (previously *.json only) ---"
printf '{"title": "stale json"}\n' > "$FIX/pipeline/evaluation/pending/old.json"
printf '# stale markdown\n'        > "$FIX/pipeline/evaluation/pending/old.md"
touch -d '20 days ago' "$FIX/pipeline/evaluation/pending/old.json" "$FIX/pipeline/evaluation/pending/old.md" 2>/dev/null \
  || touch -t "$(date -d '20 days ago' +%Y%m%d0000 2>/dev/null || date -v-20d +%Y%m%d0000)" \
       "$FIX/pipeline/evaluation/pending/old.json" "$FIX/pipeline/evaluation/pending/old.md"
printf '{"title": "fresh"}\n' > "$FIX/pipeline/evaluation/pending/fresh.json"

OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "quarantine run exits 0" $?
[[ -e "$FIX/pipeline/evaluation/stale/old.json" ]]; want "stale .json quarantined" $?
[[ -e "$FIX/pipeline/evaluation/stale/old.md" ]];   want "stale .md quarantined (was invisible before this fix)" $?
[[ -e "$FIX/pipeline/evaluation/pending/fresh.json" ]]; want "fresh .json left in the queue" $?
[[ -e "$FIX/pipeline/evaluation/stale/stale-log.jsonl" ]]; want "quarantine metadata log written" $?
grep -q '"source"' "$FIX/pipeline/evaluation/stale/stale-log.jsonl"; want "metadata log is valid-looking JSON" $?

echo ""
echo "--- A missing/unreadable pending/ directory is a scan FAILURE, not zero stale items ---"
rm -rf "$FIX/pipeline/evaluation/pending"
rm -f "$FIX"/.cache-*/*.lock 2>/dev/null
# Fresh runtime dir so the flock from the previous run doesn't linger stale.
rm -rf "$WORK/xdg"; mkdir -p "$WORK/xdg"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "missing pending/ directory: heartbeat exits nonzero" $?
grep -qi 'could not enumerate' <<< "$OUT"; want "missing pending/ directory: names it as an enumeration failure" $?

echo ""
echo "--- A configured guard that is not present refuses BEFORE the agent runs ---"
mkdir -p "$FIX/pipeline/evaluation/pending"
rm -rf "$WORK/xdg"; mkdir -p "$WORK/xdg"
OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "complete guard set: weekly run proceeds (control)" $?

mv "$FIX/.claude/hooks/block-sensitive-writes.sh" "$WORK/writes.sh.held"
rm -rf "$WORK/xdg"; mkdir -p "$WORK/xdg"
OUT="$(run)"; RC=$?
[[ $RC -ne 0 ]]; want "missing write guard: weekly run refuses" $?
grep -q 'block-sensitive-writes.sh' <<< "$OUT"; want "missing write guard: names the script it could not resolve" $?
mv "$WORK/writes.sh.held" "$FIX/.claude/hooks/block-sensitive-writes.sh"

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
