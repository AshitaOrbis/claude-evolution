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
#
# LIMITATION (read SECURITY.md)
#   A path denylist is strictly weaker than removing the Write tool. It cannot
#   catch every indirect write: e.g. a symlink inside the repo that points at a
#   sensitive target (we resolve symlinks on existing paths, but a write that
#   *creates* a new symlink, or a TOCTOU swap, can still slip an indirect write
#   through), or a write funneled through an allowed tool we don't gate (Bash).
#   The robust fix remains: strip Write from the web-fetching phases and have
#   the wrapper persist agent stdout. That is deferred (BACKLOG.md / SECURITY.md).

set -euo pipefail

# ---------------------------------------------------------------------------
# The project root this hook protects. Writes must stay within this tree.
# Resolved portably from the hook's own location (.claude/hooks/ -> project
# root), so the repo can be cloned anywhere with no hardcoded paths. Prefer
# $CLAUDE_PROJECT_DIR (exported by Claude Code) when present, since it is the
# authoritative project root for the run.
# ---------------------------------------------------------------------------
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${CLAUDE_PROJECT_DIR:-}" && -d "$CLAUDE_PROJECT_DIR" ]]; then
  PROJECT_ROOT="$(cd "$CLAUDE_PROJECT_DIR" && pwd)"
else
  PROJECT_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"
fi

deny() {
  # $1 = human-readable reason
  local reason="$1"
  # Structured deny (forward-compatible PreToolUse stdout protocol).
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

# ---------------------------------------------------------------------------
# Read the hook payload from stdin and extract the tool + target path.
# ---------------------------------------------------------------------------
PAYLOAD="$(cat 2>/dev/null || echo '{}')"

TOOL_NAME="$(printf '%s' "$PAYLOAD" | jq -r '.tool_name // empty' 2>/dev/null || true)"

# Extract the target path. Write/Edit/MultiEdit use .tool_input.file_path;
# NotebookEdit uses .tool_input.notebook_path. Fall back across both shapes.
RAW_PATH="$(printf '%s' "$PAYLOAD" | jq -r '
  .tool_input.file_path
  // .tool_input.notebook_path
  // empty
' 2>/dev/null || true)"

# If there is no path to inspect (e.g. a tool with no file target slipped past
# the matcher), allow it -- this hook only governs file writes.
if [[ -z "$RAW_PATH" ]]; then
  exit 0
fi

# ---------------------------------------------------------------------------
# Resolve the path: expand ~, make relative paths absolute against cwd, and
# canonicalize. We must NOT require the target to exist (writes create files),
# so resolve the deepest existing ancestor and re-append the missing tail. This
# also resolves symlinks on the existing portion (a symlinked *parent dir* that
# points outside the repo will be caught).
# ---------------------------------------------------------------------------

# Determine the cwd the tool will run in (hook payload carries it; default to
# the project root, which is where the evolution scripts cd before running).
TOOL_CWD="$(printf '%s' "$PAYLOAD" | jq -r '.cwd // empty' 2>/dev/null || true)"
[[ -z "$TOOL_CWD" ]] && TOOL_CWD="$PROJECT_ROOT"

# Expand a leading ~ (and ~/...) to $HOME.
case "$RAW_PATH" in
  "~")    RAW_PATH="$HOME" ;;
  "~/"*)  RAW_PATH="$HOME/${RAW_PATH#\~/}" ;;
esac

# Make relative paths absolute against the tool's cwd.
case "$RAW_PATH" in
  /*) ABS_PATH="$RAW_PATH" ;;
  *)  ABS_PATH="$TOOL_CWD/$RAW_PATH" ;;
esac

# Canonicalize: resolve symlinks/.. on the deepest existing ancestor, then
# re-append the non-existent tail. Avoids failing on not-yet-created files.
resolve_path() {
  local p="$1" existing tail=""
  existing="$p"
  while [[ ! -e "$existing" && "$existing" != "/" && -n "$existing" ]]; do
    tail="/$(basename "$existing")$tail"
    existing="$(dirname "$existing")"
  done
  local resolved
  if [[ -e "$existing" ]]; then
    resolved="$(cd "$existing" 2>/dev/null && pwd -P)" || resolved="$existing"
  else
    resolved="$existing"
  fi
  # Strip a trailing slash from resolved root to avoid '//'.
  [[ "$resolved" == "/" ]] && resolved=""
  printf '%s%s' "$resolved" "$tail"
}

CANON_PATH="$(resolve_path "$ABS_PATH")"

# Canonicalize HOME and PROJECT_ROOT the same way for reliable prefix tests.
CANON_HOME="$(cd "$HOME" 2>/dev/null && pwd -P || echo "$HOME")"
CANON_PROJECT="$(cd "$PROJECT_ROOT" 2>/dev/null && pwd -P || echo "$PROJECT_ROOT")"

# ---------------------------------------------------------------------------
# Denylist checks (run BEFORE the in-tree allow, so a sensitive path that
# happens to live inside the repo is still blocked).
# ---------------------------------------------------------------------------

base="$(basename "$CANON_PATH")"

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
