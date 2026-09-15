#!/usr/bin/env bash
#
# Regression suite for .claude/hooks/block-sensitive-reads.sh
# (claude.read_web_exfil_01).
#
# Same fail-open contract as the write hook: Claude Code treats every hook
# exit code other than 2 as non-blocking, so a crash here is an allow. This
# suite proves every dependency failure and malformed payload denies, that
# the sensitive-path denylist and containment check work for Read/Glob/Grep,
# and that the ordinary in-repo case (including Glob/Grep with no explicit
# path, which defaults to cwd) still works.
#
# Usage:  bash tests/hooks/test-block-sensitive-reads.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
HOOK_SRC="$REPO_ROOT/.claude/hooks/block-sensitive-reads.sh"

[[ -f "$HOOK_SRC" ]] || { echo "FATAL: hook not found at $HOOK_SRC" >&2; exit 1; }

PASS=0
FAIL=0

WORK="$(mktemp -d "${TMPDIR:-/tmp}/read-hook-test.XXXXXX")"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

PROJ="$WORK/project"
FAKE_HOME="$WORK/home"
OUTSIDE="$WORK/outside"
mkdir -p "$PROJ/.claude/hooks" "$PROJ/pipeline" \
         "$FAKE_HOME/.claude/agents" "$FAKE_HOME/.ssh" "$FAKE_HOME/.config" "$FAKE_HOME/.aws" "$OUTSIDE"
cp "$HOOK_SRC" "$PROJ/.claude/hooks/block-sensitive-reads.sh"
chmod +x "$PROJ/.claude/hooks/block-sensitive-reads.sh"
HOOK="$PROJ/.claude/hooks/block-sensitive-reads.sh"

printf 'super secret\n' > "$OUTSIDE/secret.txt"
printf '{}\n'           > "$FAKE_HOME/.claude.json"
printf 'AKIA...\n'      > "$FAKE_HOME/.aws/credentials"

payload() {
  # payload <tool> <path-key> <path> [cwd]
  local tool="$1" key="$2" path="$3" cwd="${4-}"
  if [[ -n "$cwd" ]]; then
    jq -cn --arg t "$tool" --arg k "$key" --arg p "$path" --arg c "$cwd" \
      '{tool_name: $t, tool_input: {($k): $p}, cwd: $c}'
  else
    jq -cn --arg t "$tool" --arg k "$key" --arg p "$path" \
      '{tool_name: $t, tool_input: {($k): $p}}'
  fi
}
payload_no_path() {
  # payload_no_path <tool> [cwd]  -- Glob/Grep with no `path` field at all
  local tool="$1" cwd="${2-}"
  if [[ -n "$cwd" ]]; then
    jq -cn --arg t "$tool" --arg c "$cwd" '{tool_name: $t, tool_input: {pattern: "x"}, cwd: $c}'
  else
    jq -cn --arg t "$tool" '{tool_name: $t, tool_input: {pattern: "x"}}'
  fi
}

BASH_BIN="$(command -v bash)"

check() { # check <expected-rc> <description> <payload> [env assignments...]
  local want="$1" desc="$2" pay="$3"; shift 3
  local got out
  out="$(printf '%s' "$pay" | env HOME="$FAKE_HOME" "$@" "$BASH_BIN" "$HOOK" 2>&1)"
  got=$?
  if [[ "$got" == "$want" ]]; then
    PASS=$((PASS + 1))
    printf '  ok   %-58s (exit %s)\n' "$desc" "$got"
  else
    FAIL=$((FAIL + 1))
    printf '  FAIL %-58s (want exit %s, got %s)\n' "$desc" "$want" "$got"
    printf '       output: %s\n' "${out//$'\n'/ | }"
  fi
}

echo "=== block-sensitive-reads.sh regression suite ==="
echo "project root under test: $PROJ"
echo ""

echo "--- Dependency failures must DENY, not crash ---"
check 2 "no jq on PATH" "$(payload Read file_path "$PROJ/ok.md" "$PROJ")" PATH="$WORK/empty-bin"
check 2 "HOME unset"    "$(payload Read file_path "$PROJ/ok.md" "$PROJ")" HOME=

echo ""
echo "--- Malformed / incomplete payloads must DENY ---"
check 2 "empty stdin"                  ""
check 2 "not JSON"                     "this is not json"
check 2 "unrecognized tool routed here" '{"tool_name": "Bash", "tool_input": {"command": "id"}}'
check 2 "Read with no file_path"       '{"tool_name": "Read", "tool_input": {}}'
check 2 "Read with empty file_path"    '{"tool_name": "Read", "tool_input": {"file_path": ""}}'
check 2 "relative path and no cwd"     '{"tool_name": "Read", "tool_input": {"file_path": "notes.md"}}'

echo ""
echo "--- Ordinary in-repo usage still works ---"
check 0 "Read, in-tree"                "$(payload Read file_path "$PROJ/pipeline/x.json" "$PROJ")"
check 0 "Glob with explicit in-tree path" "$(payload Glob path "$PROJ/pipeline" "$PROJ")"
check 0 "Grep with explicit in-tree path" "$(payload Grep path "$PROJ/pipeline" "$PROJ")"
check 0 "Glob with NO path (defaults to cwd)" "$(payload_no_path Glob "$PROJ")"
check 0 "Grep with NO path (defaults to cwd)" "$(payload_no_path Grep "$PROJ")"
check 0 "relative path, cwd in-tree"   "$(payload Read file_path "pipeline/x.json" "$PROJ")"
check 0 "Read of the hook's own control-plane files (reading, not writing, is not the risk)" \
        "$(payload Read file_path "$PROJ/.claude/hooks/block-sensitive-reads.sh" "$PROJ")"

echo ""
echo "--- Sensitive-path denylist (the exfil trigger: read a secret, hand it to WebFetch/WebSearch) ---"
check 2 "~/.claude.json"            "$(payload Read file_path "$FAKE_HOME/.claude.json" "$PROJ")"
check 2 "~/.claude/agents/x.md"     "$(payload Read file_path "$FAKE_HOME/.claude/agents/x.md" "$PROJ")"
check 2 "~/.ssh (Glob path)"        "$(payload Glob path "$FAKE_HOME/.ssh" "$PROJ")"
check 2 "~/.aws/credentials"        "$(payload Read file_path "$FAKE_HOME/.aws/credentials" "$PROJ")"
check 2 ".env inside the repo"      "$(payload Read file_path "$PROJ/.env" "$PROJ")"
check 2 "~/.config (Grep path)"     "$(payload Grep path "$FAKE_HOME/.config" "$PROJ")"

echo ""
echo "--- Containment ---"
check 2 "absolute path outside the repo (Read)" "$(payload Read file_path "$OUTSIDE/secret.txt" "$PROJ")"
check 2 "absolute path outside the repo (Glob)" "$(payload Glob path "$OUTSIDE" "$PROJ")"
check 2 "relative path climbing out"            "$(payload Read file_path "../outside/secret.txt" "$PROJ")"

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
