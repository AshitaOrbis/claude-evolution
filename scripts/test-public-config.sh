#!/usr/bin/env bash
set -euo pipefail

REFERENCE_DIR="$(dirname "$0")/../reference-config"
ERRORS=0

echo "=== Portability Test: reference-config/ ==="
echo ""

# Test 1: No private path references
echo "--- Test 1: No hardcoded private paths ---"
for f in $(find "$REFERENCE_DIR" -name "*.md" -type f); do
    matches=$(grep -nE '(/home/ashita|~/claudeworkspace|/home/[a-z]+/)' "$f" || true)
    if [ -n "$matches" ]; then
        echo "FAIL: $f contains private paths:"
        echo "$matches"
        ERRORS=$((ERRORS + 1))
    fi
done

# Test 2: No private project references
echo "--- Test 2: No private project references ---"
PRIVATE_PATTERNS_FILE="$(dirname "$0")/.private-patterns"
if [[ ! -f "$PRIVATE_PATTERNS_FILE" ]]; then
    echo "SKIP: .private-patterns file not found (gitignored)"
    echo "Create scripts/.private-patterns with project patterns (line 1) and agent patterns (line 2)"
    exit 0
fi
PRIVATE_PROJECTS=$(sed -n '1p' "$PRIVATE_PATTERNS_FILE")
for f in $(find "$REFERENCE_DIR" -name "*.md" -type f); do
    matches=$(grep -niE "$PRIVATE_PROJECTS" "$f" || true)
    if [ -n "$matches" ]; then
        echo "FAIL: $f references private project:"
        echo "$matches"
        ERRORS=$((ERRORS + 1))
    fi
done

# Test 3: No references to private agents/skills
echo "--- Test 3: No references to private agents/skills ---"
PRIVATE_AGENTS=$(sed -n '2p' "$PRIVATE_PATTERNS_FILE")
for f in $(find "$REFERENCE_DIR" -name "*.md" -type f); do
    matches=$(grep -niE "$PRIVATE_AGENTS" "$f" || true)
    if [ -n "$matches" ]; then
        echo "FAIL: $f references private agent:"
        echo "$matches"
        ERRORS=$((ERRORS + 1))
    fi
done

# Test 4: No secrets or credentials (skip security-related agent docs)
echo "--- Test 4: No secrets/credentials ---"
SECURITY_DOCS="security-auditor|code-reviewer|api-designer|webmcp-integration"
for f in $(find "$REFERENCE_DIR" -type f -name "*.md"); do
    basename_f=$(basename "$f")
    if echo "$basename_f" | grep -qiE "$SECURITY_DOCS"; then
        continue  # Skip security/auth docs (false positives)
    fi
    matches=$(grep -niE '(api[_-]?key|secret|password|bearer|token\s*[:=])' "$f" || true)
    if [ -n "$matches" ]; then
        echo "FAIL: $f may contain credentials:"
        echo "$matches"
        ERRORS=$((ERRORS + 1))
    fi
done

# Test 5: SKILL.md frontmatter validation
echo "--- Test 5: SKILL.md frontmatter ---"
for f in $(find "$REFERENCE_DIR/skills" -name "SKILL.md" -type f 2>/dev/null); do
    if ! head -1 "$f" | grep -q "^---"; then
        echo "WARN: $f missing frontmatter (---)"
    fi
done

# Test 6: Agent .md files have required structure
echo "--- Test 6: Agent definition structure ---"
for f in $(find "$REFERENCE_DIR/agents" -name "*.md" -type f 2>/dev/null); do
    if ! grep -q "^#" "$f"; then
        echo "WARN: $f has no markdown headers"
    fi
done

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "FAILED: $ERRORS error(s) found"
    exit 1
fi
