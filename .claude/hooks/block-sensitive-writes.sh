#!/usr/bin/env bash
#
# PreToolUse write-confinement hook for the Claude Evolution pipeline.
#
# WHY THIS EXISTS
#   The discovery and evaluation agents (the `claude -p` runs driven by
#   HEARTBEAT-DAILY.md / EVALUATE-PENDING.md in scripts/evolution-daily.sh)
#   are granted Write + WebFetch/WebSearch. They read attacker-controllable
#   internet content (READMEs, forum posts, newsletters). A prompt-injection
#   payload in that fetched content could steer a Write/Edit/NotebookEdit to a
#   sensitive target (~/.claude.json, ~/.claude/agents/*.md, .env, .git/hooks/,
#   ~/.ssh, ~/.config, or anywhere outside this repo) and thereby achieve code
#   execution on the next `claude`/cron run.
#
#   An investigation confirmed Claude Code does NOT path-confine subagent /
#   `claude -p` writes (path-scoped --allowed-tools and permissions.deny were
#   tested and fail open for `claude -p` file writes). This PreToolUse hook is
#   the chosen INTERIM mitigation: it inspects the resolved target path before
#   the tool runs and blocks (exit 2) anything on the denylist or outside the
#   pipeline's own directory tree.
#
# CONTRACT (Claude Code PreToolUse hook)
#   - Hook JSON is delivered on stdin: {tool_name, tool_input{...}, cwd, ...}.
#   - exit 0  -> allow the tool call.
#   - exit 2  -> BLOCK the tool call; stderr is fed back to the agent as the
#                reason. (We also emit the structured JSON deny form on stdout
#                for forward-compatibility.)
#   - ANY OTHER exit code is a *non-blocking* error in Claude Code: the tool
#     runs anyway. So this hook must never merely crash — see FAIL CLOSED.
#
# FAIL CLOSED (claude.write_hook_parse_failopen_01, 2026-08-12)
#   Every path that ends without a decision is a decision to allow. This hook
#   therefore:
#     - installs an EXIT trap that converts any unexpected non-zero exit into a
#       deny (exit 2) before Claude Code can read it as "non-blocking error";
#     - uses ONLY bash builtins until its two required dependencies (jq,
#       realpath) are confirmed present, so a stripped PATH denies rather than
#       dying at line 1 with 127;
#     - denies on unreadable/absent/non-object payloads, on a tool_name this
#       hook does not recognise, and on a matched event carrying no target path.
#   REQUIRED DEPENDENCIES: `jq` and GNU `realpath` (coreutils, `-m` support).
#   Both are declared in README.md / SECURITY.md. Missing either one is a deny.
#
# LIMITATION (read SECURITY.md)
#   A path denylist is strictly weaker than removing the Write tool. It cannot
#   catch every indirect write: e.g. a TOCTOU swap between this check and the
#   write itself, or a write funneled through an allowed tool we don't gate
#   (Bash). Symlinks ARE handled: a symlinked leaf is denied outright and every
#   existing intermediate component is resolved before the containment test.
#   The robust fix remains: strip Write from the web-fetching phases and have
#   the wrapper persist agent stdout. That is deferred (BACKLOG.md / SECURITY.md).

set -euo pipefail

deny() {
  # $1 = human-readable reason
  local reason="$1"
  # Structured deny (forward-compatible PreToolUse stdout protocol). Best-effort:
  # the dependable channel is stderr + exit 2 below, which needs no dependency.
  if command -v jq >/dev/null 2>&1; then
    jq -cn --arg r "$reason" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
      }
    }' 2>/dev/null || true
  fi
  # Stderr reason (exit-2 block protocol). This is the dependable path.
  echo "BLOCKED by block-sensitive-writes.sh: $reason" >&2
  exit 2
}

# Any exit that is neither an explicit allow (0) nor an explicit deny (2) is an
# unexpected failure — an unset variable, a dead dependency, a syntax error in a
# future edit. Claude Code would treat it as a non-blocking error and run the
# tool, so convert it into a block here.
hook_fail_closed() {
  local rc=$?
  if [[ $rc -ne 0 && $rc -ne 2 ]]; then
    echo "BLOCKED by block-sensitive-writes.sh: hook aborted (exit $rc) -- failing closed" >&2
    exit 2
  fi
}
trap hook_fail_closed EXIT
# A signal death would otherwise bypass the EXIT trap and surface as a non-2 exit,
# i.e. an allow. SIGKILL cannot be caught by anything (see SECURITY.md, "residual
# fail-open surface"), but a catchable termination denies.
trap 'deny "hook terminated before it could check the write target"' TERM INT HUP

# ---------------------------------------------------------------------------
# The project root this hook protects. Writes must stay within this tree.
# Resolved portably from the hook's own location (.claude/hooks/ -> project
# root), so the repo can be cloned anywhere with no hardcoded paths. Prefer
# $CLAUDE_PROJECT_DIR (exported by Claude Code) when present, since it is the
# authoritative project root for the run.
#
# `cd` and `pwd` are bash builtins: this runs before the dependency check on
# purpose, so a stripped PATH cannot crash the hook into a fail-open exit.
# ---------------------------------------------------------------------------
HOOK_SELF="${BASH_SOURCE[0]}"
HOOK_PARENT="${HOOK_SELF%/*}"
[[ "$HOOK_PARENT" == "$HOOK_SELF" ]] && HOOK_PARENT="."
HOOK_DIR="$(cd -- "$HOOK_PARENT" 2>/dev/null && pwd -P)" \
  || deny "cannot resolve the hook's own directory -- refusing to guess the project root"

if [[ -n "${CLAUDE_PROJECT_DIR:-}" && -d "${CLAUDE_PROJECT_DIR}" ]]; then
  PROJECT_ROOT="$(cd -- "$CLAUDE_PROJECT_DIR" 2>/dev/null && pwd -P)" \
    || deny "CLAUDE_PROJECT_DIR is set but unreadable ($CLAUDE_PROJECT_DIR)"
else
  PROJECT_ROOT="$(cd -- "$HOOK_DIR/../.." 2>/dev/null && pwd -P)" \
    || deny "cannot resolve the project root from the hook location ($HOOK_DIR)"
fi

# ---------------------------------------------------------------------------
# Required dependencies. Both are used to make the ALLOW decision, so neither
# may be optional: a missing binary must block, never wave the write through.
# ---------------------------------------------------------------------------
command -v jq >/dev/null 2>&1 \
  || deny "required dependency 'jq' is not installed -- cannot parse the hook payload, so no write can be approved (install jq)"
command -v realpath >/dev/null 2>&1 \
  || deny "required dependency 'realpath' (GNU coreutils) is not installed -- cannot canonicalize the target path (install coreutils)"
realpath -m -- / >/dev/null 2>&1 \
  || deny "'realpath' does not support -m (GNU coreutils required) -- cannot canonicalize a not-yet-existing target path"

# HOME is load-bearing for every denylist rule below.
[[ -n "${HOME:-}" ]] || deny "HOME is unset -- cannot evaluate the sensitive-path denylist"

# ---------------------------------------------------------------------------
# Read the hook payload from stdin and extract the tool + target path.
# Read with a builtin (no `cat`): stdin has no NUL, so -d '' consumes it whole.
#
# The -t bound matters for fail-closed: an unbounded read on a stalled stdin would
# sit until the harness's own hook timeout killed us, and a killed hook is an
# ALLOW. Timing out here instead produces a deny.
# ---------------------------------------------------------------------------
PAYLOAD=""
read_rc=0
IFS= read -r -t 5 -d '' PAYLOAD || read_rc=$?
# rc 1: EOF reached without the (never-present) NUL delimiter — the normal path,
# PAYLOAD holds everything. rc >128: the timeout elapsed and we have nothing to check.
[[ $read_rc -le 128 ]] \
  || deny "timed out reading the hook payload from stdin -- refusing a write whose target was never delivered"

[[ -n "$PAYLOAD" ]] \
  || deny "empty hook payload on stdin -- cannot determine the write target"
printf '%s' "$PAYLOAD" | jq -e 'type == "object"' >/dev/null 2>&1 \
  || deny "hook payload is not a JSON object -- cannot determine the write target"

TOOL_NAME="$(printf '%s' "$PAYLOAD" | jq -er '.tool_name | select(type == "string" and length > 0)' 2>/dev/null)" || TOOL_NAME=""

# Which field carries the target path, per tool. NotebookEdit accepts either
# shape so a payload-key rename upstream degrades to "checked", not to "allowed".
# An unrecognized tool that the matcher routed here is denied: this hook cannot
# vouch for a payload shape it does not know.
case "$TOOL_NAME" in
  Write|Edit|MultiEdit) PATH_FILTER='.tool_input.file_path'; PATH_FIELD="file_path" ;;
  NotebookEdit)         PATH_FILTER='.tool_input.notebook_path // .tool_input.file_path'; PATH_FIELD="notebook_path/file_path" ;;
  "")  deny "hook payload carries no tool_name -- refusing an unidentified write" ;;
  *)   deny "unrecognized tool '$TOOL_NAME' routed to the write-confinement hook -- its payload shape is unknown, so its target cannot be checked" ;;
esac

RAW_PATH="$(printf '%s' "$PAYLOAD" | jq -er "($PATH_FILTER) | select(type == \"string\" and length > 0)" 2>/dev/null)" || RAW_PATH=""
[[ -n "$RAW_PATH" ]] \
  || deny "$TOOL_NAME payload has no usable .tool_input.$PATH_FIELD -- refusing a write whose target cannot be inspected"

# ---------------------------------------------------------------------------
# Resolve the path: expand ~, make relative paths absolute against cwd, and
# canonicalize with realpath -m (resolves symlinks and .. on the existing
# portion; does not require the target to exist, since writes create files).
# ---------------------------------------------------------------------------

# The cwd the tool will run in (hook payload carries it). A RELATIVE target with
# no cwd is unresolvable, so it is denied rather than guessed at.
TOOL_CWD="$(printf '%s' "$PAYLOAD" | jq -er '.cwd | select(type == "string" and length > 0)' 2>/dev/null)" || TOOL_CWD=""

# Expand a leading ~ (and ~/...) to $HOME.
case "$RAW_PATH" in
  "~")    RAW_PATH="$HOME" ;;
  "~/"*)  RAW_PATH="$HOME/${RAW_PATH#\~/}" ;;
esac

# Make relative paths absolute against the tool's cwd.
case "$RAW_PATH" in
  /*) ABS_PATH="$RAW_PATH" ;;
  *)
    [[ -n "$TOOL_CWD" ]] \
      || deny "relative target '$RAW_PATH' and no cwd in the hook payload -- refusing to guess where it lands"
    ABS_PATH="$TOOL_CWD/$RAW_PATH"
    ;;
esac

# A symlinked LEAF is denied outright (claude.write_hook_symlink_file_bypass_02).
# Writing through a link is never required by this pipeline, and allowing it
# would make containment depend on where the link happens to point right now.
if [[ -L "$ABS_PATH" ]]; then
  deny "target is a symlink ($ABS_PATH) -- writes through links are refused; write to the real path inside the repo instead"
fi

CANON_PATH="$(realpath -m -- "$ABS_PATH")" \
  || deny "could not canonicalize the target path ($ABS_PATH)"
CANON_HOME="$(realpath -m -- "$HOME")" || deny "could not canonicalize HOME ($HOME)"
CANON_PROJECT="$(realpath -m -- "$PROJECT_ROOT")" \
  || deny "could not canonicalize the project root ($PROJECT_ROOT)"

# ---------------------------------------------------------------------------
# Denylist checks (run BEFORE the in-tree allow, so a sensitive path that
# happens to live inside the repo is still blocked).
# ---------------------------------------------------------------------------

base="${CANON_PATH##*/}"

# 1. Anything under ~/.claude, or the ~/.claude.json file itself.
if [[ "$CANON_PATH" == "$CANON_HOME/.claude" || "$CANON_PATH" == "$CANON_HOME/.claude/"* ]]; then
  deny "write to Claude config directory (~/.claude/...) -- prompt-injection escalation path ($CANON_PATH)"
fi
if [[ "$CANON_PATH" == "$CANON_HOME/.claude.json" || "$base" == ".claude.json" ]]; then
  deny "write to ~/.claude.json -- executes code on next claude start ($CANON_PATH)"
fi

# 2. Any .env or .env.* file (sourced as shell code by the evolution scripts).
if [[ "$base" == ".env" || "$base" == ".env."* ]]; then
  deny "write to an environment file ($base) -- sourced as shell code on next run ($CANON_PATH)"
fi

# 3. Any path containing a .git/hooks/ segment.
if [[ "$CANON_PATH" == *"/.git/hooks/"* || "$CANON_PATH" == *"/.git/hooks" ]]; then
  deny "write to a git hooks directory (.git/hooks/) -- executes on next git operation ($CANON_PATH)"
fi

# 4. ~/.ssh (keys / authorized_keys / config).
if [[ "$CANON_PATH" == "$CANON_HOME/.ssh" || "$CANON_PATH" == "$CANON_HOME/.ssh/"* ]]; then
  deny "write to ~/.ssh -- credential / authorized_keys tampering ($CANON_PATH)"
fi

# 5. ~/.config (XDG configs incl. autostart, systemd user units, shell rc dirs).
if [[ "$CANON_PATH" == "$CANON_HOME/.config" || "$CANON_PATH" == "$CANON_HOME/.config/"* ]]; then
  deny "write to ~/.config -- user-config / autostart tampering ($CANON_PATH)"
fi

# ---------------------------------------------------------------------------
# Containment check: the write must land INSIDE the project tree. Anything else
# (absolute path elsewhere, or a relative path that climbed out via ..) is
# blocked. The project root itself is allowed.
# ---------------------------------------------------------------------------
if [[ "$CANON_PATH" == "$CANON_PROJECT" || "$CANON_PATH" == "$CANON_PROJECT/"* ]]; then
  # In-tree and not on the denylist -> allow.
  exit 0
fi

deny "write outside the claude-evolution project tree -- writes are confined to $CANON_PROJECT (target: $CANON_PATH)"
