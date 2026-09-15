#!/usr/bin/env bash
#
# PreToolUse read-confinement hook for the Claude Evolution pipeline.
#
# WHY THIS EXISTS (claude.read_web_exfil_01)
#   The discovery and evaluation agents (scripts/evolution-daily.sh) hold
#   Read + Glob + Grep in the SAME session as WebFetch + WebSearch, with no
#   technical control over what local content enters the model context or a
#   network-tool argument. A prompt injection in fetched web content could
#   direct the agent to Read a sensitive local path (~/.ssh, ~/.claude.json,
#   .env, browser profiles, ...) and then place the contents in a WebFetch
#   URL, a WebSearch query, or the discovery report -- exfiltrating it to
#   whatever those tools reach, with no Bash and no Write outside the repo
#   required. This hook closes the first step of that chain: it inspects
#   every matched Read/Glob/Grep target before the tool runs and blocks
#   (exit 2) anything on the sensitive-path denylist or outside this
#   project's own directory tree.
#
# CONTRACT (Claude Code PreToolUse hook) -- identical to block-sensitive-writes.sh:
#   exit 0 = allow, exit 2 = block, any other exit = non-blocking (tool runs
#   anyway), so this hook must never merely crash. See FAIL CLOSED below.
#
# SCOPE, DELIBERATELY NARROWER THAN THE WRITE HOOK
#   Reading a file is not itself code execution, so this hook does NOT deny
#   in-repo control-plane paths (.claude/, scripts/, lib/, config/, ...) --
#   agents legitimately read CLAUDE.md, SECURITY.md, and the registry as part
#   of normal operation. It denies the same HOME dotfile/credential surface
#   the write hook denies, plus anything outside the project tree, which is
#   the surface a discovery/evaluation run has no legitimate reason to read.
#
# LIMITATION (read SECURITY.md)
#   This is a path denylist, not tool removal: it cannot stop a read of a
#   secret that already lives inside the repo tree, and it does nothing about
#   the outbound side (WebFetch/WebSearch can still exfiltrate whatever the
#   model already has in context from a prior turn). The robust fix remains
#   splitting networked discovery from repo-local evaluation (BACKLOG.md).

set -euo pipefail

deny() {
  local reason="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -cn --arg r "$reason" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
      }
    }' 2>/dev/null || true
  fi
  echo "BLOCKED by block-sensitive-reads.sh: $reason" >&2
  exit 2
}

hook_fail_closed() {
  local rc=$?
  if [[ $rc -ne 0 && $rc -ne 2 ]]; then
    echo "BLOCKED by block-sensitive-reads.sh: hook aborted (exit $rc) -- failing closed" >&2
    exit 2
  fi
}
trap hook_fail_closed EXIT
trap 'deny "hook terminated before it could check the read target"' TERM INT HUP

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

command -v jq >/dev/null 2>&1 \
  || deny "required dependency 'jq' is not installed -- cannot parse the hook payload, so no read can be approved (install jq)"
command -v realpath >/dev/null 2>&1 \
  || deny "required dependency 'realpath' (GNU coreutils) is not installed -- cannot canonicalize the target path (install coreutils)"
realpath -m -- / >/dev/null 2>&1 \
  || deny "'realpath' does not support -m (GNU coreutils required) -- cannot canonicalize a not-yet-existing target path"

[[ -n "${HOME:-}" ]] || deny "HOME is unset -- cannot evaluate the sensitive-path denylist"

PAYLOAD=""
read_rc=0
IFS= read -r -t 5 -d '' PAYLOAD || read_rc=$?
[[ $read_rc -le 128 ]] \
  || deny "timed out reading the hook payload from stdin -- refusing a read whose target was never delivered"

[[ -n "$PAYLOAD" ]] \
  || deny "empty hook payload on stdin -- cannot determine the read target"
printf '%s' "$PAYLOAD" | jq -e 'type == "object"' >/dev/null 2>&1 \
  || deny "hook payload is not a JSON object -- cannot determine the read target"

TOOL_NAME="$(printf '%s' "$PAYLOAD" | jq -er '.tool_name | select(type == "string" and length > 0)' 2>/dev/null)" || TOOL_NAME=""

# Which field carries the target path, per tool. Glob/Grep's `path` is OPTIONAL
# (defaults to cwd when absent) -- that default is the safe, expected case
# (searching the project itself), so an absent path is ALLOWED here, unlike
# the write hook where an absent path is always denied. Read has no such
# default: file_path is mandatory, so an absent one is denied.
case "$TOOL_NAME" in
  Read)       PATH_FILTER='.tool_input.file_path'; PATH_FIELD="file_path"; REQUIRED=1 ;;
  Glob|Grep)  PATH_FILTER='.tool_input.path';       PATH_FIELD="path";      REQUIRED=0 ;;
  "")  deny "hook payload carries no tool_name -- refusing an unidentified read" ;;
  *)   deny "unrecognized tool '$TOOL_NAME' routed to the read-confinement hook -- its payload shape is unknown, so its target cannot be checked" ;;
esac

RAW_PATH="$(printf '%s' "$PAYLOAD" | jq -er "($PATH_FILTER) | select(type == \"string\" and length > 0)" 2>/dev/null)" || RAW_PATH=""
if [[ -z "$RAW_PATH" ]]; then
  if [[ "$REQUIRED" -eq 1 ]]; then
    deny "$TOOL_NAME payload has no usable .tool_input.$PATH_FIELD -- refusing a read whose target cannot be inspected"
  fi
  # Glob/Grep with no path: defaults to cwd, which is inside the project. Allow.
  exit 0
fi

TOOL_CWD="$(printf '%s' "$PAYLOAD" | jq -er '.cwd | select(type == "string" and length > 0)' 2>/dev/null)" || TOOL_CWD=""

case "$RAW_PATH" in
  "~")    RAW_PATH="$HOME" ;;
  "~/"*)  RAW_PATH="$HOME/${RAW_PATH#\~/}" ;;
esac

case "$RAW_PATH" in
  /*) ABS_PATH="$RAW_PATH" ;;
  *)
    [[ -n "$TOOL_CWD" ]] \
      || deny "relative target '$RAW_PATH' and no cwd in the hook payload -- refusing to guess where it points"
    ABS_PATH="$TOOL_CWD/$RAW_PATH"
    ;;
esac

CANON_PATH="$(realpath -m -- "$ABS_PATH")" \
  || deny "could not canonicalize the target path ($ABS_PATH)"
CANON_HOME="$(realpath -m -- "$HOME")" || deny "could not canonicalize HOME ($HOME)"
CANON_PROJECT="$(realpath -m -- "$PROJECT_ROOT")" \
  || deny "could not canonicalize the project root ($PROJECT_ROOT)"

base="${CANON_PATH##*/}"

if [[ "$CANON_PATH" == "$CANON_HOME/.claude" || "$CANON_PATH" == "$CANON_HOME/.claude/"* ]]; then
  deny "read of Claude config directory (~/.claude/...) -- may carry credentials or other agents' state ($CANON_PATH)"
fi
if [[ "$CANON_PATH" == "$CANON_HOME/.claude.json" || "$base" == ".claude.json" ]]; then
  deny "read of ~/.claude.json -- may carry credentials/tokens ($CANON_PATH)"
fi
if [[ "$base" == ".env" || "$base" == ".env."* ]]; then
  deny "read of an environment file ($base) -- typically carries secrets ($CANON_PATH)"
fi
if [[ "$CANON_PATH" == *"/.git/"* || "$base" == ".git" ]]; then
  deny "read under a .git directory -- may carry embedded credentials in remote config ($CANON_PATH)"
fi
if [[ "$CANON_PATH" == "$CANON_HOME/.ssh" || "$CANON_PATH" == "$CANON_HOME/.ssh/"* ]]; then
  deny "read of ~/.ssh -- private key / credential material ($CANON_PATH)"
fi
if [[ "$CANON_PATH" == "$CANON_HOME/.config" || "$CANON_PATH" == "$CANON_HOME/.config/"* ]]; then
  deny "read of ~/.config -- may carry other applications' credentials/tokens ($CANON_PATH)"
fi
if [[ "$CANON_PATH" == "$CANON_HOME/.aws" || "$CANON_PATH" == "$CANON_HOME/.aws/"* \
   || "$CANON_PATH" == "$CANON_HOME/.gnupg" || "$CANON_PATH" == "$CANON_HOME/.gnupg/"* \
   || "$CANON_PATH" == "$CANON_HOME/.netrc" || "$base" == ".netrc" ]]; then
  deny "read of a credential store (~/.aws, ~/.gnupg, ~/.netrc) ($CANON_PATH)"
fi

if [[ "$CANON_PATH" == "$CANON_PROJECT" || "$CANON_PATH" == "$CANON_PROJECT/"* ]]; then
  exit 0
fi

deny "read outside the claude-evolution project tree -- reads are confined to $CANON_PROJECT (target: $CANON_PATH)"
