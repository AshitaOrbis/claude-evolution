# Self-Healing Pipeline

Autonomous test-fix loop for hardening Bash scripts. Use when scripts have known fragility (JSON parsing, exit codes, quoting) or after writing new shell automation.

## When to Use

- After writing or modifying Bash scripts that handle JSON, exit codes, or piped commands
- When a script fails intermittently or with edge cases
- To harden hook scripts, orchestration scripts, or data pipelines
- When the insights report flags "buggy code" friction in shell scripts

## When NOT to Use

- For TypeScript/Python code (use `test-writer` + `debugger` instead)
- For simple scripts (<20 lines) where manual review is faster
- When the script should be rewritten in a typed language instead of patched

## Workflow

```
1. SCAN: Read the target script(s). Identify:
   - JSON operations (jq, sed on JSON, inline string building)
   - Exit code handling (pipefail, subshell returns, trap usage)
   - Quoting patterns (unquoted variables, word splitting risks)
   - Error handling (missing set -euo pipefail, unchecked commands)

2. TEST: Write a test suite covering:
   - Happy path with valid input
   - Empty/missing input
   - Malformed JSON (trailing commas, missing keys, null values)
   - Exit code propagation through pipes
   - Special characters in values (spaces, quotes, newlines)
   Use bats-core if available, otherwise simple bash test functions.

3. RUN: Execute the test suite. Capture failures.

4. FIX: For each failure:
   - Read the error output
   - Diagnose root cause (not symptoms)
   - Apply the minimal fix
   - Re-run tests

5. LOOP: Repeat steps 3-4 until all tests pass.
   MAX ITERATIONS: 10 (if not green after 10, stop and report)

6. REPORT: Write summary:
   - Bugs found (with before/after)
   - Tests added
   - Remaining risks (if any)
```

## Safeguards

| Guard | Value | Purpose |
|-------|-------|---------|
| Max iterations | 10 | Prevent infinite loops |
| Per-test timeout | 30s | Catch hangs |
| Same-failure limit | 3 | Stop if same test fails 3x consecutively |
| Scope limit | Target scripts only | Don't modify unrelated files |

## Example Invocation

```
Run the self-healing pipeline skill on ./scripts/heartbeat.sh:
1. Write tests for its JSON parsing and exit code behavior
2. Run tests, fix failures, loop until green
3. Report what you fixed
```

## Integration Points

- Complements `test-driven-development` (TDD writes tests first for new code; this hardens existing code)
- Complements `debugger` subagent (debugger diagnoses one issue; this iterates to full green)
- Can be triggered by `session-end verification` when bash scripts were modified
