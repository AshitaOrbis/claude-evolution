#!/usr/bin/env bash
set -euo pipefail

REFERENCE_DIR="$(dirname "$0")/../reference-config"
ERRORS=0

echo "=== Portability Test: reference-config/ ==="
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

# Tests 2-3 need the gitignored private-patterns file
PRIVATE_PATTERNS_FILE="$(dirname "$0")/.private-patterns"
if [[ -f "$PRIVATE_PATTERNS_FILE" ]]; then
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
else
    echo "--- Tests 2-3: SKIPPED ---"
    echo "SKIP: .private-patterns file not found (gitignored)"
    echo "Create scripts/.private-patterns with project patterns (line 1) and agent patterns (line 2)"
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
if [ $ERRORS -eq 0 ]; then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "FAILED: $ERRORS error(s) found"
    exit 1
fi
