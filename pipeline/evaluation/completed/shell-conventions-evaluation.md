# Evaluation: Shell/Bash Conventions CLAUDE.md Addition + Shellcheck Hook

**Date**: 2026-02-05
**Evaluator**: Claude Sonnet 4.5
**Source**: Claude Code /insights report (Anthropic usage analysis)
**Status**: PENDING REVIEW

---

## Discovery Summary

**What it is**: Two complementary improvements to prevent shell scripting bugs:

1. **CLAUDE.md Documentation Section**: Add `## Shell/Bash Conventions` with mandatory rules:
   - Always use `jq` with proper quoting for JSON manipulation (no inline string hacks)
   - Always use `set -euo pipefail` at top of scripts
   - Test JSON parsing in isolation before integration
   - Explicitly handle exit codes from subcommands

2. **Shellcheck Pre-commit Hook**: Automated linting to catch common shell bugs before execution

**Evidence from Usage Data**:
- **53,021 Bash tool invocations** (dominant tool by far - ~40% of all tool usage)
- **64 friction events** from buggy shell code (primarily JSON parsing/quoting errors)
- **4,442 Shell file interactions**, **3,907 JSON file interactions** (high overlap)
- **Pre-existing pipefail bug** blocked entire E2E test runs (cascading failure mode)
- **Pattern**: JSON manipulation in bash is a recurring pain point

---

## Scoring Analysis

### 1. Integration Complexity (20%)

**Score**: 95/100

**Justification**:
- CLAUDE.md addition: Trivial (single section append)
- Shellcheck hook: Well-established tool, simple Git hook
- Files to modify:
  - `~/claudeworkspace/claude-evolution/CLAUDE.md` (add section)
  - `~/.claude/settings.json` (add PreCommit hook if not exists)
  - OR `.git/hooks/pre-commit` (direct hook installation)
- No breaking changes to existing system
- Shellcheck already available via package managers

**Implementation Steps**:
1. Draft Shell/Bash Conventions section (15 minutes)
2. Install shellcheck: `apt-get install shellcheck` or `brew install shellcheck`
3. Create pre-commit hook script (10 minutes)
4. Test on existing shell scripts (10 minutes)

**Risk**: Minimal. Shellcheck is non-invasive (linter only).

---

### 2. Token Efficiency Impact (25%)

**Score**: 85/100

**Justification**:

**Direct savings**:
- Each friction event from shell bugs triggers:
  - Error message reading (200-500 tokens)
  - Debug cycle analysis (500-1000 tokens)
  - Fix implementation (300-800 tokens)
  - Re-test verification (200-400 tokens)
  - **Total per incident**: ~1,200-2,700 tokens

**Projected reduction**:
- **64 friction events** documented
- If this prevents **50% of shell bugs** (conservative):
  - 32 incidents avoided
  - **32 × 1,500 tokens (avg) = 48,000 tokens saved**
  - Over **53,021 Bash invocations** = **0.9 tokens per Bash call saved**

**Multiplier effect**:
- Shell bugs often cascade (e.g., pipefail blocking E2E tests)
- Prevents "rabbit hole" debugging sessions (multi-hour token drains)
- Reduces need for bash-to-Python rewrites (which costs implementation tokens)

**Why not 100**:
- Not all shell bugs are shellcheck-detectable (logic errors remain)
- Documentation alone doesn't enforce compliance (humans still make mistakes)

---

### 3. Capability Expansion (25%)

**Score**: 70/100

**Justification**:

**Type**: **DEFENSIVE CAPABILITY** (prevents problems vs. adding new features)

**What it enables**:
- **Reliability improvement**: Bash tool becomes more trustworthy
- **Faster iteration**: Fewer debug cycles means faster script development
- **Error prevention**: Shellcheck catches bugs Claude Code doesn't natively detect
- **Best practices enforcement**: Codifies tribal knowledge into system rules

**What it does NOT do**:
- Does not add new tool capabilities (still just Bash)
- Does not enable new workflows (same operations, fewer bugs)
- Does not expand integration surface (internal improvement only)

**Comparison to novel capabilities**:
- Novel MCP server = 100 (new external system access)
- New agent pattern = 90 (new workflow capability)
- Tool efficiency improvement = 70 (better use of existing tools)
- **This falls in "better use of existing tools"**

**Why 70 not higher**:
- Bash is already heavily used (53k invocations)
- This makes it **better**, not **new**
- High impact due to volume, but incremental improvement type

---

### 4. Maintenance Burden (15%)

**Score**: 90/100

**Justification**:

**Ongoing costs**:
- **CLAUDE.md section**: Zero maintenance (static documentation)
- **Shellcheck hook**: Minimal (stable tool, infrequent updates)
- **Rule updates**: Low (bash best practices change slowly)

**Failure modes**:
- Shellcheck false positives (can disable specific rules)
- Hook bypass risk (developers can skip pre-commit)
- Documentation drift (rules fall out of sync with practice)

**Mitigation**:
- Shellcheck has mature ignore syntax (`# shellcheck disable=SC2086`)
- Pre-commit hooks are opt-in by design (low friction)
- CLAUDE.md is regularly reviewed (already in workflow)

**Comparison**:
- MCP server maintenance = 50-70 (external dependencies, breaking changes)
- Custom agent = 60-80 (prompt tuning, model changes)
- **Static documentation + stable linter = 90** (near zero maintenance)

**Why not 100**:
- Shellcheck updates may require hook adjustments (rare)
- New bash patterns may require documentation updates (infrequent)

---

### 5. Community Validation (15%)

**Score**: 100/100

**Justification**:

**Shellcheck**:
- **GitHub**: 35,000+ stars (koalaman/shellcheck)
- **Industry standard**: Used by Google, GitHub, major open source projects
- **ShellCheck.net**: Online tool with millions of users
- **Package manager ubiquity**: Available in apt, brew, yum, pacman

**Bash best practices**:
- `set -euo pipefail`: **Universally recommended** (Bash FAQ, Google Shell Style Guide)
- `jq` for JSON: **De facto standard** (StackOverflow top answer for "bash JSON parsing")
- Exit code handling: **POSIX standard practice**

**Evidence from usage data**:
- **64 friction events** = empirical validation that THIS system needs this
- **Pre-existing pipefail bug** = proof that absence causes real failures

**Community consensus**:
- No credible alternative to shellcheck for shell linting
- No debate on `set -euo pipefail` value (universally endorsed)
- `jq` vs. inline parsing is settled (jq wins for correctness)

---

## Weighted Score Calculation

| Criterion | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Integration complexity | 20% | 95 | 19.0 |
| Token efficiency impact | 25% | 85 | 21.25 |
| Capability expansion | 25% | 70 | 17.5 |
| Maintenance burden | 15% | 90 | 13.5 |
| Community validation | 15% | 100 | 15.0 |
| **TOTAL** | **100%** | - | **86.25** |

---

## Decision: APPROVE FOR INTEGRATION

**Threshold**: 70+ = integrate
**Actual**: 86.25

**Rationale**:
- **High impact, low cost**: 86.25 score indicates strong value proposition
- **Empirical need**: 64 friction events + pipefail bug = proven pain point
- **Industry standard solution**: Shellcheck is not experimental (100/100 validation)
- **Token efficiency**: 48k tokens saved (conservative estimate) justifies effort
- **Trivial integration**: <1 hour implementation time

---

## Integration Plan

### Files to Modify

| File | Change Type | Specific Modification |
|------|-------------|----------------------|
| `~/claudeworkspace/claude-evolution/CLAUDE.md` | Append | Add `## Shell/Bash Conventions` section |
| `.git/hooks/pre-commit` | Create/Edit | Add shellcheck invocation for `*.sh` files |
| `~/.claude/settings.json` | Optional | Add PreCommit hook configuration (if using Claude Code hooks) |

### Shell/Bash Conventions Section Content

```markdown
## Shell/Bash Conventions

All shell scripts and Bash tool invocations MUST follow these rules:

### Mandatory Script Headers
```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### JSON Manipulation
- **ALWAYS use `jq`** for JSON parsing/manipulation
- **NEVER use inline string hacks** (sed/awk on JSON is fragile)
- **Test jq filters in isolation** before integration

**Good**:
```bash
value=$(echo "$json" | jq -r '.key')
jq '.items += [{"new": "item"}]' state.json > tmp.json && mv tmp.json state.json
```

**Bad**:
```bash
value=$(echo "$json" | grep -oP '"key":\s*"\K[^"]+')  # FRAGILE
echo "$json" | sed 's/}/,"new":"item"}/g'  # BREAKS ON NESTED JSON
```

### Exit Code Handling
- **Explicitly check subcommand results** in conditionals
- **Use `|| true`** when failures are expected and acceptable

**Good**:
```bash
if grep -q "pattern" file.txt; then
  echo "Found"
fi

command_that_may_fail || true  # Explicit failure tolerance
```

**Bad**:
```bash
grep "pattern" file.txt  # Fails script if not found (set -e)
```

### Shellcheck Compliance
- All `*.sh` files MUST pass `shellcheck` before commit
- Use `# shellcheck disable=SCXXXX` sparingly with justification

### Quick Reference
| Anti-Pattern | Correct Pattern |
|--------------|----------------|
| `sed 's/}/,"x":"y"}/g' file.json` | `jq '.x = "y"' file.json` |
| `value=$(cat file \| grep 'key')` | `value=$(jq -r '.key' file)` |
| `command` (in set -e script) | `command \|\| true` OR `if command; then` |
| No error handling | `set -euo pipefail` + explicit checks |
```

### Shellcheck Hook Script

```bash
#!/usr/bin/env bash
# .git/hooks/pre-commit

# Run shellcheck on all staged .sh files
staged_shell_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$' || true)

if [ -n "$staged_shell_files" ]; then
  echo "Running shellcheck on staged shell files..."

  if ! command -v shellcheck &> /dev/null; then
    echo "WARNING: shellcheck not found. Install with 'apt-get install shellcheck' or 'brew install shellcheck'"
    exit 1
  fi

  # Run shellcheck
  if ! echo "$staged_shell_files" | xargs shellcheck; then
    echo "Shellcheck failed. Fix errors or disable specific rules with '# shellcheck disable=SCXXXX'"
    exit 1
  fi

  echo "Shellcheck passed."
fi

exit 0
```

### Implementation Steps

1. **Install shellcheck**:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install shellcheck

   # macOS
   brew install shellcheck
   ```

2. **Add CLAUDE.md section**:
   ```bash
   # Edit ~/claudeworkspace/claude-evolution/CLAUDE.md
   # Append Shell/Bash Conventions section
   ```

3. **Create pre-commit hook**:
   ```bash
   # Copy hook script to .git/hooks/pre-commit
   chmod +x .git/hooks/pre-commit
   ```

4. **Test on existing scripts**:
   ```bash
   # Run shellcheck on all shell files
   find ~/.claude -name '*.sh' -exec shellcheck {} \;
   ```

---

## Risk Assessment

### Low Risk Factors
- **Shellcheck is read-only** (no code modification)
- **Pre-commit hooks are bypassable** (`git commit --no-verify`)
- **Documentation has no runtime impact**

### Medium Risk Factors
- **False positive fatigue**: Developers may disable hook if too noisy
- **Learning curve**: Teams unfamiliar with shellcheck syntax

### Mitigation
- **Start with warnings, not errors** (adjust hook to warn-only initially)
- **Document common false positives** and how to suppress them
- **Gradual enforcement**: Apply to new scripts first, retrofit old scripts later

### Rollback Plan
If integration causes problems:
1. Remove pre-commit hook
2. Mark CLAUDE.md section as "RECOMMENDED" instead of "MANDATORY"
3. Keep shellcheck installed for manual use

---

## Redundancy Check

**Query**: Does the Claude Evolution system already have shell scripting guidelines or shellcheck integration?

**Check against**: `~/claudeworkspace/claude-evolution/registry/existing-capabilities.md`

**Finding**:
- No existing shell/bash conventions documented in CLAUDE.md files
- No shellcheck hook currently installed (verified: `.git/hooks/pre-commit` does not exist)
- Some shell scripts exist (e.g., `~/.claude/hooks/iterative-loop/*.sh`) but no automated linting

**Conclusion**: **NOVEL CAPABILITY** (not redundant)

---

## Alternative Approaches Considered

| Alternative | Pros | Cons | Verdict |
|-------------|------|------|---------|
| **ShellCheck only (no docs)** | Faster integration | No human-readable reference | Reject (docs add value) |
| **CLAUDE.md only (no hook)** | Zero tooling | Not enforced automatically | Reject (reactive, not proactive) |
| **Rewrite all bash in Python** | Eliminates class of bugs | Massive effort, loses bash ubiquity | Reject (overkill) |
| **Use bash strict mode library** | More comprehensive | Adds dependency, not standard | Consider for future |

**Selected approach** (docs + hook) balances:
- Human reference (CLAUDE.md)
- Automated enforcement (shellcheck)
- Low complexity (standard tools)

---

## Conclusion

**APPROVE FOR INTEGRATION** (Score: 86.25/100)

This is a **high-value, low-cost defensive improvement** that addresses a proven pain point (64 friction events). The combination of documentation and automated linting creates a self-reinforcing system:

1. **CLAUDE.md** educates Claude Code on best practices
2. **Shellcheck hook** catches violations before they cause failures
3. **Usage data** validates the need (53k Bash invocations)
4. **Community validation** (100/100) eliminates adoption risk

**Next step**: Move to `pipeline/integration/` for implementation.

---

## Appendix: Usage Data Context

From Claude Code /insights report (2026-02-05):

```
Top Tools by Invocation:
1. Bash: 53,021 (40% of all tool usage)
2. Edit: 15,234
3. Read: 12,456
...

Friction Events (Shell-related):
- JSON parsing errors: 37 events
- Exit code mishandling: 18 events
- Variable quoting issues: 9 events

File Type Distribution:
- Shell scripts (.sh): 4,442 interactions
- JSON files (.json): 3,907 interactions
```

**Key insight**: High overlap between shell and JSON usage = perfect target for `jq` standardization.
