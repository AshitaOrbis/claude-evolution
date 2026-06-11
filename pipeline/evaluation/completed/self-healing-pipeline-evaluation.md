# Self-Healing Pipeline Skill Evaluation

**Date**: 2026-02-05
**Evaluator**: Claude Sonnet 4.5
**Source**: Claude Code /insights report "On the Horizon" section
**Discovery Type**: CLAUDE.md instruction pattern + skill (not a tool)

---

## Discovery Summary

**What it is**: A formalized skill/workflow pattern where Claude autonomously:
1. Reads scripts that handle a specific concern (e.g., JSON parsing, data transformation)
2. Writes comprehensive test suite (using bats or simple bash test functions)
3. Runs tests
4. For every failure: diagnoses root cause, fixes script, re-runs
5. Loops until ALL tests pass
6. Writes summary of bugs found and fixed

**Evidence from usage data**:
- 64 friction events from buggy code
- High ratio of Bash invocations (53K) to Edit operations (9.5K) suggests run-hit-error-rerun pattern
- Quote: "Exactly the kind of problem an autonomous agent can solve by iterating against tests until green"
- The iterative-improve skill already exists but is oriented toward persona testing, not bash debugging

---

## Redundancy Check

### Existing Capabilities Analysis

| Existing Capability | Overlap | Gap |
|---------------------|---------|-----|
| **test-driven-development skill** | TDD workflow enforcement (write test, watch fail, implement, watch pass) | **LACKS autonomous fix loop** - requires human intervention between cycles |
| **debugger subagent** | Root cause analysis, hypothesis formation, minimal fixes | **LACKS test generation** and autonomous iteration |
| **test-writer subagent** | Comprehensive test suite creation | **LACKS execution loop** and fix automation |
| **iterative-improve skill** | Autonomous iteration loops with Codex review + deployment + persona testing | **WRONG SCOPE** - full application deployment cycle, not script debugging |

### Classification

**IMPROVEMENT** (not novel, not duplicate)

This discovery synthesizes existing capabilities into a **new automation pattern** that doesn't currently exist as a cohesive workflow:
- Test-writer generates tests → debugger fixes → TDD enforces cycle → **BUT no autonomous loop connecting them**
- Iterative-improve has loop structure → **BUT wrong scope (app deployment, not script testing)**

---

## Scoring Analysis

### 1. Integration Complexity (20% weight)

**Score: 85/100**

| Factor | Assessment |
|--------|------------|
| New code required | ~100-150 lines for skill file + ~50 lines for loop orchestration |
| Dependencies | Existing tools only (Read, Write, Edit, Bash, test-writer, debugger) |
| File locations | `~/.claude/skills/self-healing-pipeline/SKILL.md` + state file (optional) |
| Breaking changes | None - additive pattern |
| Testing burden | Dogfood on itself (meta-recursive validation) |

**Justification**:
- Reuses all existing subagents and tools
- Pattern is well-defined (similar to iterative-improve structure)
- Minimal new infrastructure (state tracking optional since this is synchronous)
- Main complexity: orchestrating test-writer → Bash → debugger → Edit loop logic

**Deductions**:
- -10 for needing careful orchestration logic (avoid infinite loops)
- -5 for state management if asynchronous retry needed

---

### 2. Token Efficiency Impact (25% weight)

**Score: 88/100**

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Human debugging cycles | 3-5 iterations | 0 (autonomous) | ~300-500 tokens per cycle saved |
| Context pollution from failed runs | High (error logs accumulate) | Low (cleaned between cycles) | ~200 tokens per attempt |
| Explicit debugging instructions | ~150 tokens per request | 0 (implicit in skill) | 150 tokens saved |

**Analysis**:
- **Reduces human-in-the-loop debugging**: Each manual "try this fix" → re-run → report back = ~400-600 tokens
- **Evidence from data**: 64 friction events suggest frequent debugging cycles
- **High Bash:Edit ratio** (53K:9.5K = 5.6:1) indicates repetitive run-fail-fix patterns

**Token cost of the skill itself**:
- Skill file: ~2k tokens (one-time load when relevant)
- Per-iteration overhead: ~50 tokens (loop coordination)
- Net savings: **Positive after 4-5 debugging cycles avoided**

**Deductions**:
- -7 for skill file token cost (amortized over many uses)
- -5 for potential infinite loop risk (requires max iteration limit)

---

### 3. Capability Expansion (25% weight)

**Score: 78/100**

| Dimension | Assessment |
|-----------|------------|
| **Novelty** | **Medium** - Combines existing tools in new autonomous pattern |
| **Scope** | **Focused** - Specifically bash/script debugging, not general development |
| **Uniqueness** | **High within domain** - No other skill provides test-fix loops for scripts |
| **Complementarity** | **Strong** - Fills gap between TDD (manual) and iterative-improve (app-level) |

**What this ENABLES that wasn't possible before**:
1. **Autonomous bash script hardening** - Write script → run skill → get battle-tested version
2. **Hook/utility script validation** - Apply to `.claude/hooks/*` scripts for reliability
3. **JSON/data pipeline debugging** - jq scripts, awk transforms, parsing pipelines
4. **Reduced friction from buggy automation** - Addresses the 64 friction events directly

**What this DOESN'T enable** (avoiding over-claiming):
- Application-level TDD (already covered by test-driven-development skill)
- Complex debugging across multiple files (debugger subagent handles this)
- Production deployment loops (iterative-improve owns this)

**Deductions**:
- -12 for limited scope (bash scripts only, not general development)
- -10 for being a synthesis rather than fundamentally novel capability

---

### 4. Maintenance Burden (15% weight)

**Score: 82/100**

| Maintenance Aspect | Assessment |
|--------------------|------------|
| **Complexity** | Low - No new tools, just orchestration |
| **Dependencies** | Stable - Bash, test-writer, debugger unlikely to change |
| **Failure modes** | Medium - Infinite loops possible without safeguards |
| **Documentation** | Low - Pattern is straightforward |
| **Updates needed** | Rare - Logic stable once working |

**Ongoing costs**:
- Add max iteration limit (e.g., 10 cycles) to prevent runaway loops
- Document when to use (script debugging) vs when NOT to use (app development)
- Potential need for test framework detection logic (bats vs jest vs custom)

**Benefits reducing burden**:
- Dogfoods on itself (meta-validation)
- Clear failure indicators (test pass/fail is boolean)
- Reuses existing agents (no duplication of debugging logic)

**Deductions**:
- -10 for infinite loop risk requiring safeguards
- -8 for needing framework detection logic

---

### 5. Community Validation (15% weight)

**Score: 65/100**

| Validation Source | Evidence |
|-------------------|----------|
| **Internal evidence** | Strong - 64 friction events, 5.6:1 Bash:Edit ratio |
| **External patterns** | Medium - TDD + auto-fix loops exist separately, but not bash-focused |
| **Precedent** | Some - Aider has "test-driven development mode" but requires human loop |
| **Adoption indicators** | Weak - No direct community equivalent found |

**Supporting evidence**:
- **TDD + auto-fix is proven**: Test-driven development (24.1k stars obra/superpowers)
- **Script testing is valued**: bats-core (4.9k stars), shellcheck (36k stars) prove demand
- **Autonomous loops validated**: iterative-improve demonstrates pattern viability

**Lack of direct evidence**:
- No "bash-tdd-loop" or "self-healing-scripts" skill found in ecosystem audit
- Aider's test mode stops at "run test → show error" (doesn't auto-fix)
- Most TDD tools assume human in the loop

**Why might it not exist yet?**
- Bash scripts historically considered "throwaway" (low testing culture)
- AI agents capable of autonomous debugging loops are recent capability
- Narrow scope (scripts only) may not have reached critical mass

**Deductions**:
- -20 for lack of direct community equivalent
- -15 for being niche (bash scripts, not general dev)

---

## Weighted Score Calculation

| Criterion | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Integration complexity | 20% | 85/100 | 17.0 |
| Token efficiency impact | 25% | 88/100 | 22.0 |
| Capability expansion | 25% | 78/100 | 19.5 |
| Maintenance burden | 15% | 82/100 | 12.3 |
| Community validation | 15% | 65/100 | 9.75 |
| **TOTAL** | **100%** | - | **80.55** |

---

## Decision: **APPROVE FOR INTEGRATION**

**Threshold**: 70+ → Move to `pipeline/integration/`

**Rationale**:
1. **Score 80.55** exceeds approval threshold (70)
2. **Fills genuine gap**: No existing workflow provides autonomous test-fix loops for scripts
3. **High token efficiency**: Addresses documented pain (64 friction events, high Bash:Edit ratio)
4. **Low integration risk**: Reuses existing stable components
5. **Narrow scope is a feature**: Focused on one thing (bash scripts) done well

---

## Comparison to Existing Overlapping Capabilities

### vs. test-driven-development skill

| Aspect | TDD Skill | Self-Healing Pipeline |
|--------|-----------|----------------------|
| **Scope** | General development | Bash scripts only |
| **Human involvement** | Required between cycles | Autonomous loop |
| **Test creation** | Manual (developer writes) | Automated (test-writer) |
| **Fix loop** | Manual (developer fixes) | Automated (debugger) |
| **When to use** | New features, refactoring | Script hardening, hook validation |

**Conclusion**: **Complementary, not redundant** - TDD for app development, self-healing for script debugging.

---

### vs. debugger subagent

| Aspect | Debugger | Self-Healing Pipeline |
|--------|----------|----------------------|
| **Scope** | Any code, any error | Scripts with testable behavior |
| **Test generation** | No | Yes (via test-writer) |
| **Iteration** | Single diagnosis | Loop until green |
| **Human involvement** | Reports findings, waits for next step | Autonomous until completion |

**Conclusion**: **Self-healing USES debugger** - It's an orchestration layer, not a replacement.

---

### vs. iterative-improve skill

| Aspect | Iterative-Improve | Self-Healing Pipeline |
|--------|-------------------|----------------------|
| **Scope** | Full app deployment cycle | Single script testing |
| **Phases** | Plan → Implement → Review → Deploy → Persona Test | Test → Fix → Re-test |
| **Loop trigger** | Persona feedback | Test failures |
| **External dependencies** | Git, Codex, deployment, personas | None (self-contained) |
| **When to use** | Application iteration | Utility script hardening |

**Conclusion**: **Different scopes** - App deployment loops vs script debugging loops. No overlap.

---

### vs. test-writer subagent

| Aspect | Test-Writer | Self-Healing Pipeline |
|--------|-------------|----------------------|
| **Scope** | Write tests for any code | Write + execute + fix for scripts |
| **Execution** | No (just writes) | Yes (runs and fixes) |
| **Iteration** | Single test suite creation | Loop until all tests pass |
| **Fix capability** | No | Yes (via debugger) |

**Conclusion**: **Self-healing USES test-writer** - Adds execution and fix loops on top.

---

## Recommended Implementation Plan

### Phase 1: Core Skill Creation

**File**: `~/.claude/skills/self-healing-pipeline/SKILL.md`

**Structure**:
```markdown
---
name: self-healing-pipeline
description: Autonomous test-fix loop for bash scripts until all tests pass
---

# Self-Healing Pipeline

## When to Use
- Hardening bash/shell scripts
- Validating jq/awk data pipelines
- Testing .claude/hooks/* automation scripts
- JSON parsing scripts with edge cases

## When NOT to Use
- Application development (use test-driven-development)
- Multi-file refactoring (use debugger + test-writer separately)
- Deployment loops (use iterative-improve)

## Workflow
1. Read target script
2. Call test-writer to generate comprehensive test suite
3. Run tests (Bash)
4. IF failures:
   a. Call debugger to diagnose and fix
   b. Re-run tests
   c. GOTO 4 (max 10 iterations)
5. IF all pass:
   a. Document bugs found and fixed
   b. Return hardened script + test suite

## Safeguards
- Max iterations: 10 (prevent infinite loops)
- Test timeout: 30s per run (prevent hangs)
- Require at least 1 test (prevent no-op loops)
```

### Phase 2: Integration Targets

**Priority targets** (from usage data):
1. `.claude/hooks/*` scripts (reliability critical)
2. `jq` data transformation scripts (parsing edge cases)
3. Git automation scripts (safety critical)
4. Session state management scripts (state integrity)

### Phase 3: Validation

**Dogfooding approach**:
1. Apply skill to itself (meta-recursive validation)
2. Apply to 3 existing `.claude/hooks/*` scripts
3. Measure: iterations to green, bugs found, token usage

**Success criteria**:
- Hardens scripts in <10 iterations (avg)
- Finds at least 1 bug per non-trivial script
- Token usage < manual debugging equivalent

---

## Risks & Mitigations

### Risk 1: Infinite Loop (High Impact, Medium Probability)

**Mitigation**:
- Hard limit: 10 iterations max
- Timeout: 30s per test run
- Early exit if same failure 3x in a row (likely unfixable by debugger)

### Risk 2: Token Overhead for Simple Scripts (Low Impact, High Probability)

**Mitigation**:
- Skill triggers only when explicitly requested
- Don't auto-apply to every script (opt-in model)
- Document when manual testing is faster (< 5 line scripts)

### Risk 3: Debugger Fails to Fix (Medium Impact, Medium Probability)

**Mitigation**:
- Debugger returns "cannot fix" signal → skill aborts gracefully
- Document unfixable scenarios in output
- Human escalation after 3 failed fix attempts

---

## Migration Impact

**Existing workflows affected**: None (additive pattern)

**User-facing changes**:
- New skill available for script hardening
- Explicit invocation required (`/self-heal <script>` or similar)

**Backward compatibility**: N/A (new capability)

---

## Alternative Considered: Extend iterative-improve

**Why rejected**:
- Iterative-improve is coupled to app deployment (Git push, Codex review, persona tests)
- Adding script-only mode would bifurcate the skill (two personalities)
- Separate skill maintains single responsibility principle
- Self-healing is synchronous (no state file needed), iterative-improve is async

---

## Open Questions

1. **Test framework detection**: How to auto-detect bats vs jest vs custom?
   - **Answer**: Infer from file extension (`.bats`, `.test.sh`) or default to bash functions

2. **Multi-file scripts**: Should this support multiple related scripts?
   - **Answer**: Phase 2 feature - start with single script, expand if proven valuable

3. **Integration with tdd-guard hooks**: Should self-healing trigger automatically on hook failures?
   - **Answer**: No - hooks should already be tested. Self-healing is for hardening, not runtime recovery.

---

## Success Metrics

**After 1 month of use**:
- Scripts hardened: Target 10+
- Avg iterations to green: Target <7
- Bugs found per script: Target >1.5
- Token efficiency vs manual: Target 30%+ reduction
- User satisfaction: Qualitative feedback from usage

**Evaluation triggers**:
- If avg iterations >10 → debugger not effective enough, reconsider
- If bugs found <1 → scripts already robust, skill low ROI
- If token usage >manual → overhead too high, optimize or deprecate

---

## Conclusion

**APPROVE FOR INTEGRATION** with score **80.55/100**.

This discovery represents a **medium-high value addition** that:
- Fills genuine gap in autonomous script debugging
- Addresses documented pain points (64 friction events)
- Reuses existing stable components
- Maintains clear boundaries with existing skills
- Has low integration risk and maintenance burden

**Next step**: Move to `pipeline/integration/` and create skill file per implementation plan.
