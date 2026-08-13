#!/usr/bin/env bash
set -euo pipefail

# test-public-config.sh — portability + privacy scan over reference-config/.
#
# TWO MODES (claude.privacy_scan_missing_patterns_green_05)
#   publication (default)  every check runs, including the estate-specific
#                          private-name scans. A missing, unreadable, or empty
#                          scripts/.private-patterns is a FAILURE, not a skip:
#                          the file is the only thing that makes Tests 2-3 mean
#                          anything, and its absence is exactly the state a
#                          clean clone is in. Returns 0 only on a full pass.
#   --generic-only         portability checks only, for a clone that has no
#                          private pattern file by design. Ends with
#                          "PARTIAL CHECKS ONLY" and never claims a pass.
#
# The defect this replaces: the pattern file being absent printed SKIPPED,
# incremented nothing, and the run ended "ALL TESTS PASSED" — a green
# publication clearance from a scanner whose leak detection was switched off.

usage() {
    cat <<'USAGE'
Usage: test-public-config.sh [--generic-only]

  (no flags)       Publication mode. Requires scripts/.private-patterns.
                   Exits nonzero if it is missing, unreadable, or empty.
  --generic-only   Portability checks only. Reports "PARTIAL CHECKS ONLY".
                   Never a publication clearance.
  -h, --help       This message.
USAGE
}

GENERIC_ONLY=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --generic-only) GENERIC_ONLY=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "ERROR: unknown argument: $1" >&2; usage >&2; exit 2 ;;
    esac
done

REFERENCE_DIR="$(dirname "$0")/../reference-config"
ERRORS=0

if [ "$GENERIC_ONLY" -eq 1 ]; then
    echo "=== Portability Test: reference-config/  [--generic-only: PARTIAL] ==="
else
    echo "=== Portability Test: reference-config/  [publication mode] ==="
fi
echo ""

# Test 1: No private path references.
# Generic patterns only -- truly private identifiers belong in the gitignored
# scripts/.private-patterns file, not hardcoded in this public script.
# Any absolute /home/<user> path is both a privacy leak and non-portable.
# Tilde paths are flagged unless they start with a dot-directory (~/.claude/...
# is the intended portable form) or are the documented ~/your-project placeholder.
echo "--- Test 1: No hardcoded private paths ---"
while IFS= read -r -d '' f; do
    # shellcheck disable=SC2088  # literal tilde pattern intended, not expansion
    matches=$(grep -nE -- '(/home/[^/[:space:]]+|~/[A-Za-z0-9_-][^/[:space:]]*)' "$f" | grep -v -- '~/your-project' || true)
    if [ -n "$matches" ]; then
        echo "FAIL: $f contains private paths:"
        echo "$matches"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find "$REFERENCE_DIR" -name "*.md" -type f -print0)

# Tests 2-3 need the gitignored private-patterns file. In publication mode its
# absence is a hard failure: a scanner that cannot read its own input has not
# found nothing, it has looked at nothing (RELIABILITY-STANDARDS R2).
PRIVATE_PATTERNS_FILE="$(dirname "$0")/.private-patterns"
if [ "$GENERIC_ONLY" -eq 1 ]; then
    echo "--- Tests 2-3: NOT RUN (--generic-only) ---"
    echo "SKIP: private project and agent name scanning is disabled by flag."
elif [ ! -e "$PRIVATE_PATTERNS_FILE" ]; then
    echo "--- Tests 2-3: FAILED ---"
    echo "FAIL: required input missing: $PRIVATE_PATTERNS_FILE"
    echo "      Private project and agent names were NOT scanned, so this run cannot clear a publication."
    echo "      Create it with project patterns (line 1) and agent patterns (line 2), or re-run with --generic-only"
    echo "      if you only need the portability checks."
    ERRORS=$((ERRORS + 1))
elif [ ! -r "$PRIVATE_PATTERNS_FILE" ]; then
    echo "--- Tests 2-3: FAILED ---"
    echo "FAIL: required input unreadable: $PRIVATE_PATTERNS_FILE"
    ERRORS=$((ERRORS + 1))
elif [ ! -s "$PRIVATE_PATTERNS_FILE" ]; then
    echo "--- Tests 2-3: FAILED ---"
    echo "FAIL: required input is empty: $PRIVATE_PATTERNS_FILE"
    ERRORS=$((ERRORS + 1))
else
    # Test 2: No private project references
    echo "--- Test 2: No private project references ---"
    PRIVATE_PROJECTS=$(sed -n '1p' "$PRIVATE_PATTERNS_FILE")
    if [[ -z "$PRIVATE_PROJECTS" ]]; then
        echo "FAIL: .private-patterns line 1 (project patterns) is empty"
        ERRORS=$((ERRORS + 1))
    else
        while IFS= read -r -d '' f; do
            matches=$(grep -niE -- "$PRIVATE_PROJECTS" "$f" || true)
            if [ -n "$matches" ]; then
                echo "FAIL: $f references private project:"
                echo "$matches"
                ERRORS=$((ERRORS + 1))
            fi
        done < <(find "$REFERENCE_DIR" -name "*.md" -type f -print0)
    fi

    # Test 3: No references to private agents/skills
    echo "--- Test 3: No references to private agents/skills ---"
    PRIVATE_AGENTS=$(sed -n '2p' "$PRIVATE_PATTERNS_FILE")
    if [[ -z "$PRIVATE_AGENTS" ]]; then
        echo "FAIL: .private-patterns line 2 (agent patterns) is empty"
        ERRORS=$((ERRORS + 1))
    else
        while IFS= read -r -d '' f; do
            matches=$(grep -niE -- "$PRIVATE_AGENTS" "$f" || true)
            if [ -n "$matches" ]; then
                echo "FAIL: $f references private agent:"
                echo "$matches"
                ERRORS=$((ERRORS + 1))
            fi
        done < <(find "$REFERENCE_DIR" -name "*.md" -type f -print0)
    fi
fi

# Test 4: No secrets or credentials (skip security-related agent docs)
echo "--- Test 4: No secrets/credentials ---"
SECURITY_DOCS="security-auditor|code-reviewer|api-designer|webmcp-integration"
while IFS= read -r -d '' f; do
    basename_f=$(basename "$f")
    if echo "$basename_f" | grep -qiE -- "$SECURITY_DOCS"; then
        continue  # Skip security/auth docs (false positives)
    fi
    matches=$(grep -niE -- '(api[_-]?key|secret|password|bearer|token\s*[:=])' "$f" || true)
    if [ -n "$matches" ]; then
        echo "FAIL: $f may contain credentials:"
        echo "$matches"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find "$REFERENCE_DIR" -type f -name "*.md" -print0)

# Test 5: SKILL.md frontmatter validation
echo "--- Test 5: SKILL.md frontmatter ---"
while IFS= read -r -d '' f; do
    if ! head -1 "$f" | grep -q "^---"; then
        echo "WARN: $f missing frontmatter (---)"
    fi
done < <(find "$REFERENCE_DIR/skills" -name "SKILL.md" -type f -print0 2>/dev/null)

# Test 6: Agent .md files have required structure
echo "--- Test 6: Agent definition structure ---"
while IFS= read -r -d '' f; do
    if ! grep -q "^#" "$f"; then
        echo "WARN: $f has no markdown headers"
    fi
done < <(find "$REFERENCE_DIR/agents" -name "*.md" -type f -print0 2>/dev/null)

echo ""
if [ $ERRORS -ne 0 ]; then
    echo "FAILED: $ERRORS error(s) found"
    exit 1
fi

if [ "$GENERIC_ONLY" -eq 1 ]; then
    echo "PARTIAL CHECKS ONLY"
    echo "Private project and agent names were not scanned. This does NOT clear a publication;"
    echo "re-run without --generic-only, with scripts/.private-patterns present, before publishing."
    exit 0
fi

echo "ALL TESTS PASSED"
exit 0
