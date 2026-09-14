#!/usr/bin/env bash
set -euo pipefail

# sandbox-test-integration.sh — Test proposed env vars/config changes against Claude Code
# Returns JSON with pass/fail and specific failure reasons.
#
# Usage:
#   ./sandbox-test-integration.sh --env "CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1"
#   ./sandbox-test-integration.sh --env "CLAUDE_CODE_NO_FLICKER=1"
#
# Created 2026-04-13 after the ENV_SCRUB incident (12 days of broken permissions).
#
# PROOF-OF-EXECUTION, NOT TEXT MATCHING (claude.sandbox_gate_false_pass_05 /
# claude.sandbox_marker_false_pass_04 / claude.sandbox_marker_false_pass_05 /
# claude.sandbox_sentinel_falsepass_04)
#   The original version asked Claude to `echo SANDBOX_TEST_PASS` and set
#   passed=true whenever that literal string appeared anywhere in the combined
#   stdout/stderr, without requiring the Claude process to exit 0 or proving a
#   Bash tool call actually ran. A model that just REPEATED the requested
#   command in prose, or that emitted the marker and then failed for an
#   unrecognized reason, was scored as a passing empirical safety test -- the
#   exact "trust the claim, not the behavior" failure this harness exists to
#   replace. This version instead:
#     - generates a random per-run nonce
#     - asks Claude to use the Bash tool to write ONLY that nonce to a fresh,
#       script-owned file
#     - requires Claude's own exit code to be 0
#     - reads the file back itself (never trusts model-reported text) and
#       requires its content to match the nonce EXACTLY
#   `passed` is true only when all of: exit 0, no permission-override
#   signature, no sandbox-init-failure signature, and the nonce file exists
#   with exactly the expected content.
#
# LIMITATION, NOT FIXED HERE: this still only exercises an env var (--env).
# EVALUATE-PENDING.md / INTEGRATE-APPROVED.md also route settings.json, hook,
# and MCP config changes through "run the sandbox test", but this script has
# no adapter for those change types and will refuse them (see the argument
# handling below) rather than silently substituting an unrelated env-var test
# (claude.sandbox_gate_false_pass_05's second finding). Tracked in BACKLOG.md.

PROPOSED_ENV=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --env)
            PROPOSED_ENV="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 --env \"VAR=value\""
            echo "Tests whether a proposed env var breaks Claude Code functionality."
            echo "Only env-var changes are supported; settings/hook/MCP changes have no adapter yet."
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

if [[ -z "$PROPOSED_ENV" ]]; then
    echo '{"passed": false, "error": "No --env argument provided"}'
    exit 1
fi

VAR_NAME="${PROPOSED_ENV%%=*}"
VAR_VALUE="${PROPOSED_ENV#*=}"

# A bare env-var name check: this is handed to `env "$VAR_NAME=$VAR_VALUE"` below,
# so an unvalidated name is a shell-injection-shaped input even though `env`
# itself does not re-interpret it. Refuse anything that is not a plain identifier.
if ! [[ "$VAR_NAME" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo "{\"passed\": false, \"error\": \"invalid environment variable name: ${VAR_NAME}\"}"
    exit 1
fi

# The subprocess runs with a scrubbed environment (env -i), so the Claude CLI has
# to be locatable from this shell and handed over explicitly -- no hardcoded
# interpreter or install path, which would make this script run only on the
# machine it was written on.
CLAUDE_BIN="$(command -v claude || true)"
if [[ -z "$CLAUDE_BIN" ]]; then
    echo '{"passed": false, "error": "claude CLI not found on PATH"}'
    exit 1
fi
CLAUDE_DIR="$(cd "$(dirname "$CLAUDE_BIN")" && pwd)"

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT
TMPOUT="$WORKDIR/output"

# Empty MCP set, written here so the test needs no file from outside the repo.
MCP_EMPTY="$WORKDIR/mcp-empty.json"
printf '{"mcpServers":{}}\n' > "$MCP_EMPTY"

# A random, per-run, out-of-band nonce. Claude is asked to write ONLY this value
# (via the Bash tool) to a fresh file this script owns and will read back itself
# -- proof a Bash tool call actually executed, not proof the model said so.
NONCE="sbx-$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')"
NONCE_FILE="$WORKDIR/nonce-proof"

# Run Claude in a subprocess with the proposed env var set
EXIT_CODE=0
env -i \
    HOME="$HOME" \
    PATH="$CLAUDE_DIR:/usr/local/bin:/usr/bin:/bin" \
    TERM="${TERM:-xterm-256color}" \
    "$VAR_NAME=$VAR_VALUE" \
    claude -p \
        --strict-mcp-config --mcp-config "$MCP_EMPTY" \
        --max-turns 2 \
        --dangerously-skip-permissions \
        -- "Run this exact command with the Bash tool and nothing else: printf '%s' '$NONCE' > $NONCE_FILE" \
        > "$TMPOUT" 2>&1 || EXIT_CODE=$?

OUTPUT=$(cat "$TMPOUT")

# Check for failure signatures
PERMISSION_FORCED=false
SANDBOX_FAILED=false

if echo "$OUTPUT" | grep -qi "Permission mode forced\|permission.*forced.*default"; then
    PERMISSION_FORCED=true
fi

if echo "$OUTPUT" | grep -qi "Sandbox failed\|sandbox.*initialize"; then
    SANDBOX_FAILED=true
fi

# Proof of execution: read the file back OURSELVES and compare bytes exactly.
# Never trust the model's OWN report of what it wrote -- that is exactly the
# "text matches, nothing ran" gap this rewrite closes.
NONCE_PROVEN=false
if [[ -f "$NONCE_FILE" ]]; then
    NONCE_CONTENT="$(cat "$NONCE_FILE" 2>/dev/null || true)"
    if [[ "$NONCE_CONTENT" == "$NONCE" ]]; then
        NONCE_PROVEN=true
    fi
fi

# Determine pass/fail: exit 0 AND proven Bash execution AND no failure signature.
PASSED=false
if [[ "$EXIT_CODE" -eq 0 ]] && [[ "$NONCE_PROVEN" == "true" ]] \
   && [[ "$PERMISSION_FORCED" == "false" ]] && [[ "$SANDBOX_FAILED" == "false" ]]; then
    PASSED=true
fi

# Output structured JSON using python with proper argument passing
python3 -c "
import json, sys
passed = sys.argv[1] == 'true'
env_tested = sys.argv[2]
nonce_proven = sys.argv[3] == 'true'
perm_forced = sys.argv[4] == 'true'
sandbox_fail = sys.argv[5] == 'true'
exit_code = int(sys.argv[6])

warnings = []
if perm_forced:
    warnings.append('ENV_SCRUB-style permission override detected')
if sandbox_fail:
    warnings.append('Sandbox initialization failure')
if exit_code != 0:
    warnings.append(f'Claude exited with code {exit_code}')
if not nonce_proven:
    warnings.append('No proof of Bash execution: the expected nonce file was missing or did not match (text output is not evidence)')

print(json.dumps({
    'passed': passed,
    'env_tested': env_tested,
    'nonce_proven': nonce_proven,
    'permission_forced': perm_forced,
    'sandbox_failed': sandbox_fail,
    'exit_code': exit_code,
    'warnings': warnings
}, indent=2))
" "$PASSED" "$PROPOSED_ENV" "$NONCE_PROVEN" "$PERMISSION_FORCED" "$SANDBOX_FAILED" "$EXIT_CODE"

# The pass/fail JSON above is diagnostic; the exit status is what callers that
# only check `$?` (rather than parsing JSON) actually branch on. Exiting 0 on a
# printed "passed": false let a status-based caller mistake a structured
# failure for shell success.
if [[ "$PASSED" == "true" ]]; then
    exit 0
else
    exit 1
fi
