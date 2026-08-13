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
        -- "Run this exact command with the Bash tool: echo SANDBOX_TEST_PASS" \
        > "$TMPOUT" 2>&1 || EXIT_CODE=$?

OUTPUT=$(cat "$TMPOUT")

# Check for failure signatures
CONTAINS_PASS=false
PERMISSION_FORCED=false
SANDBOX_FAILED=false

if echo "$OUTPUT" | grep -q "SANDBOX_TEST_PASS"; then
    CONTAINS_PASS=true
fi

if echo "$OUTPUT" | grep -qi "Permission mode forced\|permission.*forced.*default"; then
    PERMISSION_FORCED=true
fi

if echo "$OUTPUT" | grep -qi "Sandbox failed\|sandbox.*initialize"; then
    SANDBOX_FAILED=true
fi

# Determine pass/fail
PASSED=false
if [[ "$CONTAINS_PASS" == "true" ]] && [[ "$PERMISSION_FORCED" == "false" ]] && [[ "$SANDBOX_FAILED" == "false" ]]; then
    PASSED=true
fi

# Output structured JSON using python with proper argument passing
python3 -c "
import json, sys
passed = sys.argv[1] == 'true'
env_tested = sys.argv[2]
contains_pass = sys.argv[3] == 'true'
perm_forced = sys.argv[4] == 'true'
sandbox_fail = sys.argv[5] == 'true'
exit_code = int(sys.argv[6])

warnings = []
if perm_forced:
    warnings.append('ENV_SCRUB-style permission override detected')
if sandbox_fail:
    warnings.append('Sandbox initialization failure')
if exit_code != 0 and not contains_pass:
    warnings.append(f'Claude exited with code {exit_code} without completing test')

print(json.dumps({
    'passed': passed,
    'env_tested': env_tested,
    'stdout_contains_pass': contains_pass,
    'permission_forced': perm_forced,
    'sandbox_failed': sandbox_fail,
    'exit_code': exit_code,
    'warnings': warnings
}, indent=2))
" "$PASSED" "$PROPOSED_ENV" "$CONTAINS_PASS" "$PERMISSION_FORCED" "$SANDBOX_FAILED" "$EXIT_CODE"
