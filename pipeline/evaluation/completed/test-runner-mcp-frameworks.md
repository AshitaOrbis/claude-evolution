## Discovery: Test Runner MCP (Multi-Framework Testing)

**Source**: https://github.com/privsim/mcp-test-runner
**Category**: MCP
**Stars/Validation**: LOW (new project), GitHub Actions integration

### Summary
MCP server providing unified interface for executing tests from multiple frameworks: Bats (Bash), Pytest (Python), Flutter, Jest (JavaScript), and Go. Allows AI assistants to run tests and parse results across different test suites. Includes GitHub Actions integration for CI/CD.

### Redundancy Check

**Existing capabilities checked**:
- test-writer subagent: Generates tests, doesn't run them
- TDD guard: Enforces test-first, but uses Bash tool to run tests
- Bash tool: Can run any test framework via CLI

**Classification**: **IMPROVEMENT** - Adds structured test execution vs raw Bash commands, but Bash already provides this capability.

### Potential Value

**Token impact**: Moderate - MCP overhead ~2-3k tokens, but provides structured test results

**Capability**:
- **Multi-framework support**: Bats, Pytest, Flutter, Jest, Go
- **Unified interface**: Single MCP tool for all test runners
- **Structured output**: Parsed test results (passed/failed/skipped counts)
- **Result artifacts**: Test output uploaded to GitHub Actions
- **Framework detection**: Auto-detects test framework from project

**Integration effort**: Medium
- Node.js MCP server
- Requires each test framework installed (pytest, jest, etc.)
- Config for framework-specific options

### Comparison to Existing

| Feature | Bash tool | TDD guard | Test Runner MCP |
|---------|-----------|-----------|-----------------|
| Run tests | ✅ Any framework | ✅ npm test | ✅ 5 frameworks |
| Parse output | Manual | Manual | ✅ Structured |
| Multi-framework | ✅ All frameworks | ❌ npm only | ✅ 5 frameworks |
| CI/CD | Manual | N/A | ✅ GitHub Actions |
| Token efficiency | High (no MCP) | High (no MCP) | Medium (MCP overhead) |
| Flexibility | Unlimited | Limited | 5 frameworks only |

**Key insight**: Bash tool can already run ANY test framework. Test Runner MCP adds structure but LIMITS flexibility to 5 frameworks.

### Quick Assessment Score

- **Integration complexity**: 70/100 (Need all test frameworks installed)
- **Token efficiency impact**: 50/100 (MCP overhead not justified by value)
- **Capability expansion**: 40/100 (Bash already does this, just less structured)
- **Maintenance burden**: 60/100 (Depends on 5 different test frameworks)
- **Community validation**: 30/100 (Very new, unproven)

**TOTAL**: **50/100** (REJECT - Bash tool is more flexible)

### Recommended Action

[ ] Evaluate further
[x] Reject (reason: Bash tool provides more flexibility with zero token overhead)
[ ] Fast-track integration

### Rejection Rationale

**Why Bash > Test Runner MCP**:

1. **Flexibility**: Bash can run ANY test framework, not just 5
2. **Token efficiency**: Bash has zero MCP overhead
3. **Simplicity**: `bash -c "pytest"` vs MCP tool call
4. **Coverage**: Test Runner supports 5 frameworks, Bash supports ∞
5. **Existing patterns**: TDD guard already uses Bash for test execution

**Example comparison**:
```javascript
// Test Runner MCP (MCP overhead + limited to 5 frameworks)
mcp_test_runner.run_tests({ framework: "pytest", path: "tests/" })

// Bash (zero overhead + works with ANY framework)
bash -c "pytest tests/"
```

**What would make this valuable**:
- Intelligent test failure analysis (root cause, similar failures)
- Test selection (only run affected tests)
- Cross-framework test result aggregation
- Test coverage analysis
- Performance regression detection

Current implementation just wraps CLI commands without adding value.

### Alternative Approach

Instead of Test Runner MCP, consider:
1. **Skill file**: Document test execution patterns with Bash
2. **test-runner subagent**: Specialized agent for test execution and analysis
3. **Enhanced TDD guard**: Add test result parsing to existing hooks

These provide the structure without MCP token overhead.

---

## Evaluation (2026-02-06)

### Redundancy Check

**Status**: DUPLICATE

Existing capabilities:
- Bash tool: Can run ANY test framework (`bash -c "pytest"`, `npm test`, etc.)
- test-writer subagent: Generates tests
- TDD guard: Enforces test-first workflow using Bash

**Classification**: DUPLICATE - Test Runner MCP just wraps CLI commands that Bash already executes, with LESS flexibility (limited to 5 frameworks).

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 60/100 | 20% | 12.0 | Requires all 5 test frameworks installed, Node.js MCP server |
| Token efficiency impact | 30/100 | 25% | 7.5 | MCP overhead (~2-3k tokens) NOT justified by value |
| Capability expansion | 20/100 | 25% | 5.0 | Bash already runs any framework; MCP limits to 5 |
| Maintenance burden | 60/100 | 15% | 9.0 | Depends on 5 different test framework updates |
| Community validation | 30/100 | 15% | 4.5 | Very new project, unproven |

**WEIGHTED TOTAL**: **38.0/100**

### Cross-Validation with Codex

Codex assessment: 35/100 ("Unnecessary wrapper around CLI commands; Bash provides more flexibility at zero cost")
Variance: 3 points (consensus achieved)

### Decision: REJECT ❌

**Rationale**: Scores 38/100 (well below 70 threshold). Test Runner MCP is a token-inefficient wrapper around CLI commands that Bash already executes. It REDUCES flexibility (5 frameworks only) while INCREASING token cost (MCP overhead).

**Why Bash > Test Runner MCP**:
1. **Flexibility**: Bash runs ANY test framework (pytest, jest, go test, cargo test, vitest, ava, tap, etc.) vs MCP's 5
2. **Token efficiency**: Bash = zero MCP overhead vs ~2-3k tokens for MCP tool schemas
3. **Simplicity**: `bash -c "pytest tests/"` vs MCP tool call with framework detection
4. **Existing integration**: TDD guard already uses Bash for test execution
5. **No added value**: MCP just wraps CLI without intelligent features

**What WOULD add value** (not claimed by this MCP):
- Intelligent test failure analysis (root cause, similar past failures)
- Test selection based on code changes (only run affected tests)
- Cross-framework result aggregation with insights
- Test coverage gap detection
- Performance regression detection across test runs

**Example comparison**:
```bash
# Test Runner MCP (token overhead + limited frameworks)
mcp_test_runner.run_tests({ framework: "pytest", path: "tests/" })
# Returns: { passed: 10, failed: 2, skipped: 1 }

# Bash tool (zero overhead + unlimited frameworks)
bash -c "pytest tests/ --json-report"
# Returns: Same data, any framework, zero MCP cost
```

**Recommendation**: Document test execution patterns in a skill file (`~/.claude/skills/test-execution-patterns/SKILL.md`) instead of adding MCP overhead.

**Kill signals triggered**:
- 100% functional overlap with Bash tool
- Token overhead not justified by value
- Reduces flexibility vs existing approach

**File disposition**: Move to `archive/` with rejection reason

**Registry update**: Add triggers: "test runner mcp", "multi-framework testing mcp", "test execution mcp", "test framework wrapper"
