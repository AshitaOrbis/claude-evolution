#!/usr/bin/env bash
#
# Regression suite for scripts/evolution-daily.sh's owner-interest gate sequencing
# (claude.owner_lens_precheck_continues_04, bq-1399) and the deterministic
# config-item safety backstop before autonomous integration
# (claude.review_gate_tool_mismatch_03 / claude.eval_mandatory_test_unavailable_05 /
# claude.review_mode_safety_check_unavailable_07).
#
# Runs a COPY of the real script end to end, but against a `claude` STUB (logs its
# arguments and exits 0 -- never a real agent call, never real network/model use)
# in an isolated fixture directory, per the "test with fixtures and stubs" rule for
# this file. Nothing here spawns a real discovery/evaluation/integration run.
#
# Usage:  bash tests/scripts/test-evolution-daily-gates.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SCRIPT_SRC="$REPO_ROOT/scripts/evolution-daily.sh"
[[ -f "$SCRIPT_SRC" ]] || { echo "FATAL: $SCRIPT_SRC not found" >&2; exit 1; }

PASS=0
FAIL=0
want() {
  if [[ "$2" -eq 0 ]]; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; fi
}

WORK="$(mktemp -d "${TMPDIR:-/tmp}/evo-daily-gates-test.XXXXXX")"
cleanup() { chmod -R u+rwX "$WORK" 2>/dev/null; rm -rf "$WORK"; }
trap cleanup EXIT

FIX="$WORK/repo"
BIN="$WORK/bin"
mkdir -p "$FIX/scripts" "$FIX/lib" "$FIX/config" "$FIX/logs" \
         "$FIX/pipeline/evaluation/pending" "$FIX/pipeline/evaluation/completed" \
         "$FIX/pipeline/integration" "$BIN" "$WORK/home" "$WORK/xdg"

cp "$SCRIPT_SRC" "$FIX/scripts/evolution-daily.sh"
cp "$REPO_ROOT/lib/owner_interest_lens.py" "$FIX/lib/owner_interest_lens.py"
cp "$REPO_ROOT/config/owner-interests.yaml" "$FIX/config/owner-interests.yaml"
chmod +x "$FIX/scripts/evolution-daily.sh"
# EVOLUTION_AUTONOMOUS=1 refuses outright unless this is present+readable (bq-1065's own fix).
printf '#!/bin/sh\necho {"passed": true}\n' > "$FIX/scripts/sandbox-test-integration.sh"
chmod +x "$FIX/scripts/sandbox-test-integration.sh"

# The configured PreToolUse guards and the resolver the wrapper preflights with
# (claude.read_hook_missing_public_01). The wrapper refuses to launch an agent
# whose advertised guard is not there to run, so a fixture checkout that omits
# them is refused before Phase 1 -- which is the point, but it is not the state
# these gate-sequencing cases are about.
mkdir -p "$FIX/.claude/hooks"
cp "$REPO_ROOT/.claude/settings.json" "$FIX/.claude/settings.json"
cp "$REPO_ROOT/scripts/check-hook-commands.py" "$FIX/scripts/check-hook-commands.py"
for hook_src in "$REPO_ROOT"/.claude/hooks/*.sh; do
  cp "$hook_src" "$FIX/.claude/hooks/"
  chmod +x "$FIX/.claude/hooks/$(basename "$hook_src")"
done

# Fake `claude`: records every invocation (joined args) as one line, does nothing else.
CALL_LOG="$WORK/claude-calls.log"
cat > "$BIN/claude" <<STUB
#!/bin/sh
: > /dev/null
printf '%s\n' "\$*" >> "$CALL_LOG"
exit 0
STUB
chmod +x "$BIN/claude"

run() {
  : > "$CALL_LOG"
  ( cd "$FIX" && env -i PATH="$BIN:/usr/bin:/bin" HOME="$WORK/home" XDG_RUNTIME_DIR="$WORK/xdg" \
      bash scripts/evolution-daily.sh 2>&1 )
}

echo "=== evolution-daily.sh gate-sequencing regression suite ==="
echo ""

# ---------------------------------------------------------------------------
echo "--- Baseline: empty queue, no pre-screen failure -> Phase 2 runs ---"
OUT="$(run)"; RC=$?
[[ $RC -eq 0 ]]; want "clean run exits 0" $?
grep -q 'EVALUATE-PENDING.md' "$CALL_LOG"; want "clean run: Phase 2 (evaluation) was actually invoked" $?
grep -q 'Daily heartbeat completed' <<< "$OUT"; want "clean run: reports completed" $?

# ---------------------------------------------------------------------------
echo ""
echo "--- A pre-screen failure aborts BEFORE Phase 2 (claude.owner_lens_precheck_continues_04) ---"
printf '{"title": "x"}\n' > "$FIX/pipeline/evaluation/pending/broken.json"
chmod 000 "$FIX/pipeline/evaluation/pending/broken.json"
if [[ "$(id -u)" -eq 0 ]]; then
  echo "  skip (running as root: the unreadable-pending-file case cannot be simulated)"
else
  OUT="$(run)"; RC=$?
  [[ $RC -ne 0 ]]; want "pre-screen failure: whole run exits nonzero" $?
  ! grep -q 'EVALUATE-PENDING.md' "$CALL_LOG"; want "pre-screen failure: Phase 2 was NEVER invoked" $?
  grep -qi 'refusing to run' <<< "$OUT"; want "pre-screen failure: says it refused, not just 'failed at the end'" $?
fi
chmod 644 "$FIX/pipeline/evaluation/pending/broken.json"
rm -f "$FIX/pipeline/evaluation/pending/broken.json"

# ---------------------------------------------------------------------------
echo ""
echo "--- Config-item safety backstop (autonomous mode only) ---"
mkdir -p "$FIX/pipeline/pending-approval"
UNVERIFIED='{"title": "raise CLAUDE_CODE_SUBPROCESS_ENV_SCRUB", "evaluation": {"decision": "APPROVED", "reasoning": "looks fine from the changelog"}}'
VERIFIED='{"title": "raise CLAUDE_CODE_SUBPROCESS_ENV_SCRUB, tested", "evaluation": {"decision": "APPROVED", "reasoning": "Passed empirical safety test"}}'
NON_CONFIG='{"title": "a normal MCP server", "evaluation": {"decision": "APPROVED", "reasoning": "adds a new tool"}}'
printf '%s' "$UNVERIFIED" > "$FIX/pipeline/integration/unverified-env-change.json"
printf '%s' "$VERIFIED"   > "$FIX/pipeline/integration/verified-env-change.json"
printf '%s' "$NON_CONFIG" > "$FIX/pipeline/integration/normal-item.json"

run_autonomous() {
  ( cd "$FIX" && env -i PATH="$BIN:/usr/bin:/bin" HOME="$WORK/home" XDG_RUNTIME_DIR="$WORK/xdg" \
      EVOLUTION_AUTONOMOUS=1 bash scripts/evolution-daily.sh 2>&1 )
}
OUT="$(run_autonomous)"
RC=$?

[[ ! -e "$FIX/pipeline/integration/unverified-env-change.json" ]]
want "unverified env/config item removed from pipeline/integration/" $?
[[ -e "$FIX/pipeline/evaluation/review/UNVERIFIED-unverified-env-change.json" ]]
want "unverified env/config item moved to review/ for a human, not silently dropped" $?
[[ -e "$FIX/pipeline/integration/verified-env-change.json" ]]
want "env/config item WITH recorded pass evidence is left for integration" $?
[[ -e "$FIX/pipeline/integration/normal-item.json" ]]
want "an ordinary (non env/config) approved item is untouched by the backstop" $?
grep -qi 'refusing autonomous integration' <<< "$OUT"
want "autonomous run: the refusal is logged" $?

# ---------------------------------------------------------------------------
echo ""
echo "--- Backstop: negated or failed evidence is not a pass (review 2026-09-14) ---"
rm -rf -- "${FIX:?}/pipeline/evaluation/review"
rm -f -- "${FIX:?}/pipeline/integration/"*.json
printf '%s' '{"title": "raise CLAUDE_CODE_X", "evaluation": {"decision": "APPROVED", "reasoning": "Not passed empirical safety test"}}' > "$FIX/pipeline/integration/negated.json"
printf '%s' '{"title": "raise CLAUDE_CODE_Y", "evaluation": {"decision": "APPROVED", "reasoning": "Passed empirical safety test. FAILED empirical safety test: exit 7"}}' > "$FIX/pipeline/integration/failed-record.json"
printf '%s' '{"title": "raise CLAUDE_CODE_Z", "evaluation": {"decision": "APPROVED", "reasoning": "Scored normally. Passed empirical safety test."}}' > "$FIX/pipeline/integration/sentence-pass.json"
printf '%s' '{"title": "add a server block to .mcp.json", "evaluation": {"decision": "APPROVED", "reasoning": "adds a tool"}}' > "$FIX/pipeline/integration/mcp-config.json"
: > "$CALL_LOG"
OUT="$(run_autonomous)"
[[ -e "$FIX/pipeline/evaluation/review/UNVERIFIED-negated.json" ]]
want "'Not passed empirical safety test' is quarantined, not read as a pass" $?
[[ -e "$FIX/pipeline/evaluation/review/UNVERIFIED-failed-record.json" ]]
want "a record that also records a FAILED test is quarantined" $?
[[ -e "$FIX/pipeline/integration/sentence-pass.json" ]]
want "a pass recorded as its own sentence inside longer reasoning is still accepted" $?
[[ -e "$FIX/pipeline/evaluation/review/UNVERIFIED-mcp-config.json" ]]
want "an explicit .mcp.json change without evidence is quarantined" $?
grep -q 'INTEGRATE-APPROVED.md' "$CALL_LOG"
want "with every unverified item quarantined, Phase 3 still runs" $?

# ---------------------------------------------------------------------------
echo ""
echo "--- Backstop: JSON and Markdown records get the same verdict (verification 2026-09-14) ---"
rm -rf -- "${FIX:?}/pipeline/evaluation/review"
rm -f -- "${FIX:?}/pipeline/integration/"*.json "${FIX:?}/pipeline/integration/"*.md
cat > "$FIX/pipeline/integration/md-fenced-pass.md" <<'REC'
# raise CLAUDE_CODE_SUBPROCESS_ENV_SCRUB

```json
{"evaluation": {"decision": "APPROVED", "reasoning": "Passed empirical safety test. Scores well otherwise."}}
```
REC
cat > "$FIX/pipeline/integration/md-fielded-pass.md" <<'REC'
# enable a settings.json flag

**Decision**: APPROVED
**Reasoning**: Passed empirical safety test. Official feature.
REC
cat > "$FIX/pipeline/integration/md-fielded-negated.md" <<'REC'
# enable another settings.json flag

**Decision**: APPROVED
**Reasoning**: Not passed empirical safety test.
REC
: > "$CALL_LOG"
OUT="$(run_autonomous)"
[[ -e "$FIX/pipeline/integration/md-fenced-pass.md" ]]
want "a Markdown record with a fenced JSON pass stays eligible (JSON/Markdown parity)" $?
[[ -e "$FIX/pipeline/integration/md-fielded-pass.md" ]]
want "a Markdown record with a fielded '**Reasoning**: Passed ...' stays eligible" $?
[[ -e "$FIX/pipeline/evaluation/review/UNVERIFIED-md-fielded-negated.md" ]]
want "a Markdown record with a negated pass is still quarantined" $?

# ---------------------------------------------------------------------------
echo ""
echo "--- Backstop: a quarantine name collision, and a quarantine that cannot happen ---"
rm -rf -- "${FIX:?}/pipeline/evaluation/review"
rm -f -- "${FIX:?}/pipeline/integration/"*.json
mkdir -p "$FIX/pipeline/evaluation/review"
printf 'an earlier quarantine' > "$FIX/pipeline/evaluation/review/UNVERIFIED-collide.json"
printf '%s' "$UNVERIFIED" > "$FIX/pipeline/integration/collide.json"
OUT="$(run_autonomous)"
[[ ! -e "$FIX/pipeline/integration/collide.json" ]]
want "a name collision with an earlier quarantine still moves the item out" $?
[[ "$(cat "$FIX/pipeline/evaluation/review/UNVERIFIED-collide.json")" == "an earlier quarantine" ]]
want "the earlier quarantine record is not overwritten" $?
if [[ "$(id -u)" -eq 0 ]]; then
  echo "  skip (running as root: an unwritable review directory cannot be simulated)"
else
  rm -rf -- "${FIX:?}/pipeline/evaluation/review"
  mkdir -p "$FIX/pipeline/evaluation/review"
  chmod 555 "$FIX/pipeline/evaluation/review"
  printf '%s' "$UNVERIFIED" > "$FIX/pipeline/integration/stuck.json"
  : > "$CALL_LOG"
  OUT="$(run_autonomous)"; RC=$?
  chmod 755 "$FIX/pipeline/evaluation/review"
  [[ -e "$FIX/pipeline/integration/stuck.json" ]]
  want "(setup) the item that could not be moved is still in integration/" $?
  ! grep -q 'INTEGRATE-APPROVED.md' "$CALL_LOG"
  want "an item that could not be quarantined means Phase 3 is NEVER invoked" $?
  [[ $RC -ne 0 ]]
  want "and the heartbeat exits nonzero instead of reporting completed" $?
fi

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
