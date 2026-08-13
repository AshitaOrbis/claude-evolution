#!/usr/bin/env bash
#
# Regression suite for .claude/hooks/block-sensitive-writes.sh
#
# The hook is the only technical write barrier the pipeline ships in its default
# review-gated mode, and its failure mode is silent: Claude Code treats every
# exit code other than 2 as a NON-blocking error and runs the tool anyway. So the
# thing under test is not "does it block a bad path" — it is "is there any input
# for which it returns anything other than a decision".
#
# Covers claude.write_hook_parse_failopen_01 (missing jq, malformed payload,
# absent path, every matcher tool) and claude.write_hook_symlink_file_bypass_02
# (symlink to file / to directory / broken / chained), plus the pre-existing
# denylist and containment behaviour.
#
# Usage:  bash tests/hooks/test-block-sensitive-writes.sh
# Exit:   0 = all cases pass, 1 = at least one case failed.

set -uo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
HOOK_SRC="$REPO_ROOT/.claude/hooks/block-sensitive-writes.sh"

[[ -f "$HOOK_SRC" ]] || { echo "FATAL: hook not found at $HOOK_SRC" >&2; exit 1; }

PASS=0
FAIL=0

WORK="$(mktemp -d "${TMPDIR:-/tmp}/hook-test.XXXXXX")"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

# A throwaway project tree standing in for a clone, plus a throwaway HOME so the
# denylist cases never touch the real one.
PROJ="$WORK/project"
FAKE_HOME="$WORK/home"
OUTSIDE="$WORK/outside"
mkdir -p "$PROJ/.claude/hooks" "$PROJ/pipeline/evaluation/pending" \
         "$FAKE_HOME/.claude/agents" "$FAKE_HOME/.ssh" "$FAKE_HOME/.config" "$OUTSIDE"
cp "$HOOK_SRC" "$PROJ/.claude/hooks/block-sensitive-writes.sh"
chmod +x "$PROJ/.claude/hooks/block-sensitive-writes.sh"
HOOK="$PROJ/.claude/hooks/block-sensitive-writes.sh"

printf 'secret\n' > "$OUTSIDE/target.txt"
printf '{}\n'      > "$FAKE_HOME/.claude.json"

# --- symlink fixtures (claude.write_hook_symlink_file_bypass_02) --------------
ln -s "$OUTSIDE/target.txt" "$PROJ/link-to-outside-file"
ln -s "$OUTSIDE"            "$PROJ/link-to-outside-dir"
ln -s "$OUTSIDE/does-not-exist" "$PROJ/broken-link"
ln -s "$PROJ/link-to-outside-file" "$PROJ/chained-link"
ln -s "$FAKE_HOME/.claude.json" "$PROJ/link-to-claude-json"
# A symlinked *intermediate* component: the leaf itself is not a link.
mkdir -p "$OUTSIDE/subdir"
ln -s "$OUTSIDE/subdir" "$PROJ/linked-dir"

# A PATH with jq but no realpath, to exercise the missing-dependency deny.
JQ_ONLY_BIN="$WORK/jq-only-bin"
mkdir -p "$JQ_ONLY_BIN"
if command -v jq >/dev/null 2>&1; then ln -s "$(command -v jq)" "$JQ_ONLY_BIN/jq"; fi

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

# Absolute interpreter path: the dependency cases strip PATH, and `env bash` would
# then fail to find bash itself rather than exercising the hook.
BASH_BIN="$(command -v bash)"

# check <expected-rc> <description> <payload> [env assignments...]
check() {
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

echo "=== block-sensitive-writes.sh regression suite ==="
echo "project root under test: $PROJ"
echo ""

# ---------------------------------------------------------------------------
echo "--- Dependency failures must DENY, not crash (fail-open) ---"
# PATH stripped entirely: the hook must reach its own deny before needing any
# external binary. A crash here exits 127, which Claude Code runs the tool on.
check 2 "no jq on PATH"        "$(payload Write file_path "$PROJ/ok.md" "$PROJ")" PATH="$WORK/empty-bin"
check 2 "jq present, no realpath" "$(payload Write file_path "$PROJ/ok.md" "$PROJ")" PATH="$JQ_ONLY_BIN"
check 2 "HOME unset"           "$(payload Write file_path "$PROJ/ok.md" "$PROJ")" HOME=

# ---------------------------------------------------------------------------
echo ""
echo "--- Malformed / incomplete payloads must DENY ---"
check 2 "empty stdin"                     ""
check 2 "not JSON"                        "this is not json"
check 2 "truncated JSON"                  '{"tool_name": "Write", "tool_input":'
check 2 "JSON array, not an object"       '[{"tool_name":"Write"}]'
check 2 "JSON string, not an object"      '"Write"'
check 2 "no tool_name"                    '{"tool_input": {"file_path": "/tmp/x"}}'
check 2 "tool_name is not a string"       '{"tool_name": 7, "tool_input": {"file_path": "/tmp/x"}}'
check 2 "unrecognized tool routed here"   '{"tool_name": "Bash", "tool_input": {"command": "id"}}'
check 2 "Write with no file_path"         '{"tool_name": "Write", "tool_input": {"content": "x"}}'
check 2 "Write with empty file_path"      '{"tool_name": "Write", "tool_input": {"file_path": ""}}'
check 2 "Write with non-string file_path" '{"tool_name": "Write", "tool_input": {"file_path": 42}}'
check 2 "Write with null tool_input"      '{"tool_name": "Write", "tool_input": null}'
check 2 "relative path and no cwd"        '{"tool_name": "Write", "tool_input": {"file_path": "notes.md"}}'

# A stdin that never closes must time out into a DENY. Left unbounded it would sit
# until the harness's own hook timeout killed the process, and a killed hook is an
# ALLOW — the same fail-open class as a missing dependency.
STALL_FIFO="$WORK/stall.fifo"
mkfifo "$STALL_FIFO"
sleep 20 > "$STALL_FIFO" &
STALL_WRITER=$!
stall_start=$SECONDS
stall_out="$(env HOME="$FAKE_HOME" "$BASH_BIN" "$HOOK" < "$STALL_FIFO" 2>&1)"
stall_rc=$?
stall_elapsed=$(( SECONDS - stall_start ))
kill "$STALL_WRITER" 2>/dev/null
wait "$STALL_WRITER" 2>/dev/null
if [[ $stall_rc -eq 2 && $stall_elapsed -lt 15 ]]; then
  PASS=$((PASS + 1))
  printf '  ok   %-58s (exit 2 after %ss)\n' "stdin that never closes" "$stall_elapsed"
else
  FAIL=$((FAIL + 1))
  printf '  FAIL %-58s (want exit 2 within 15s, got %s after %ss)\n' \
    "stdin that never closes" "$stall_rc" "$stall_elapsed"
  printf '       output: %s\n' "${stall_out//$'\n'/ | }"
fi

# ---------------------------------------------------------------------------
echo ""
echo "--- Every matcher tool is inspected (in-tree target -> ALLOW) ---"
check 0 "Write, in-tree"       "$(payload Write       file_path     "$PROJ/pipeline/x.json" "$PROJ")"
check 0 "Edit, in-tree"        "$(payload Edit        file_path     "$PROJ/pipeline/x.json" "$PROJ")"
check 0 "MultiEdit, in-tree"   "$(payload MultiEdit   file_path     "$PROJ/pipeline/x.json" "$PROJ")"
check 0 "NotebookEdit, in-tree" "$(payload NotebookEdit notebook_path "$PROJ/nb.ipynb"       "$PROJ")"
check 0 "NotebookEdit via file_path"  "$(payload NotebookEdit file_path "$PROJ/nb.ipynb"     "$PROJ")"
check 0 "relative path, cwd in-tree"  "$(payload Write file_path "pipeline/evaluation/pending/new.json" "$PROJ")"
check 0 "deep not-yet-existing target" "$(payload Write file_path "$PROJ/a/b/c/d/new.md" "$PROJ")"
check 2 "NotebookEdit with no path"   '{"tool_name": "NotebookEdit", "tool_input": {"new_source": "x"}}'

# ---------------------------------------------------------------------------
echo ""
echo "--- Sensitive-path denylist ---"
check 2 "~/.claude.json (absolute)"  "$(payload Write file_path "$FAKE_HOME/.claude.json" "$PROJ")"
check 2 "~/.claude.json (tilde)"     "$(payload Write file_path '~/.claude.json' "$PROJ")"
check 2 "~/.claude/agents/evil.md"   "$(payload Write file_path "$FAKE_HOME/.claude/agents/evil.md" "$PROJ")"
check 2 ".env inside the repo"       "$(payload Write file_path "$PROJ/.env" "$PROJ")"
check 2 ".env.local inside the repo" "$(payload Write file_path "$PROJ/.env.local" "$PROJ")"
check 2 ".git/hooks/pre-commit"      "$(payload Write file_path "$PROJ/.git/hooks/pre-commit" "$PROJ")"
check 2 "~/.ssh/authorized_keys"     "$(payload Write file_path "$FAKE_HOME/.ssh/authorized_keys" "$PROJ")"
check 2 "~/.config/systemd/x.service" "$(payload Write file_path "$FAKE_HOME/.config/systemd/x.service" "$PROJ")"

# ---------------------------------------------------------------------------
echo ""
echo "--- Containment ---"
check 2 "absolute path outside the repo" "$(payload Write file_path "$OUTSIDE/loot.md" "$PROJ")"
check 2 "relative path climbing out"     "$(payload Write file_path "../outside/loot.md" "$PROJ")"
check 2 "repo-prefix lookalike sibling"  "$(payload Write file_path "${PROJ}-evil/x.md" "$PROJ")"

# ---------------------------------------------------------------------------
echo ""
echo "--- Symlink handling (claude.write_hook_symlink_file_bypass_02) ---"
check 2 "symlink leaf -> file outside"      "$(payload Write file_path "$PROJ/link-to-outside-file" "$PROJ")"
check 2 "symlink leaf -> ~/.claude.json"    "$(payload Write file_path "$PROJ/link-to-claude-json" "$PROJ")"
check 2 "symlink leaf -> directory outside" "$(payload Write file_path "$PROJ/link-to-outside-dir" "$PROJ")"
check 2 "broken symlink leaf"               "$(payload Write file_path "$PROJ/broken-link" "$PROJ")"
check 2 "chained symlink leaf"              "$(payload Write file_path "$PROJ/chained-link" "$PROJ")"
check 2 "file under a symlinked directory"  "$(payload Write file_path "$PROJ/linked-dir/loot.md" "$PROJ")"
check 2 "relative symlink leaf"             "$(payload Write file_path "link-to-outside-file" "$PROJ")"

echo ""
echo "=== $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]]
