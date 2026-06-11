# Evaluation: Shared JSON Helpers Library for Bash Scripts

**Date**: 2026-02-05
**Evaluator**: Claude Sonnet 4.5
**Discovery Source**: Claude Code /insights report (Anthropic built-in usage analysis)
**Discovery Type**: Infrastructure/Tooling

---

## Summary

Create a shared `lib/json_helpers.sh` library that bash scripts can source, providing standardized JSON manipulation functions using jq with proper error handling and quoting.

---

## Evidence

**From Claude Code insights report (2026-02-05):**
- 53,021 Bash invocations in recent usage
- 3,907 JSON file interactions
- Repeated friction with JSON parsing in Bash (quoting issues, string manipulation problems)
- Multiple debugging cycles per session for the same class of bugs
- Direct quote: "Standardizing on jq for all JSON operations and creating helper functions would prevent the class of bugs that blocked your end-to-end tests"

**Known pain points:**
- Improper quoting in jq queries causing failures
- Inconsistent error handling for missing keys
- Manual JSON construction prone to syntax errors
- No standardized approach across different scripts

---

## Scoring

| Criterion | Weight | Score | Justification |
|-----------|--------|-------|---------------|
| **Integration complexity** | 20% | 85 | **Easy integration**. Create single file in `~/.claude/lib/json_helpers.sh`, add `source ~/.claude/lib/json_helpers.sh` to scripts. Simple to retrofit existing scripts incrementally. No dependencies beyond jq (already installed). |
| **Token efficiency impact** | 25% | 65 | **Moderate savings**. Prevents repeated debugging cycles (current friction point), but doesn't fundamentally reduce token usage - just shifts JSON logic to helper calls. Saves tokens during error recovery, not during normal operation. |
| **Capability expansion** | 25% | 40 | **Limited expansion**. Prevents a known bug class but doesn't enable new capabilities. This is defensive/maintenance work, not new functionality. The capability to manipulate JSON in Bash already exists - this just makes it more reliable. |
| **Maintenance burden** | 15% | 70 | **Low-to-moderate burden**. Once created, helpers are stable (jq API is stable). May need occasional updates for edge cases discovered in production. Risk: if library has bugs, affects all dependent scripts. Need test suite for the helpers themselves. |
| **Community validation** | 15% | 90 | **Strong validation**. Using jq for JSON in Bash is industry best practice. Shell scripting guides universally recommend jq over string manipulation. Helper library pattern is common (similar to `bash-lib` projects on GitHub). |

### Weighted Score Calculation

```
(85 × 0.20) + (65 × 0.25) + (40 × 0.25) + (70 × 0.15) + (90 × 0.15)
= 17.0 + 16.25 + 10.0 + 10.5 + 13.5
= 67.25
```

**Final Score: 67/100** → **NEEDS RESEARCH**

---

## Critical Analysis: Root Cause vs Symptom

### The Deeper Issue

The insights report includes a crucial recommendation: **"Consider moving pipeline logic into TypeScript or Python"** rather than continuing to expand Bash infrastructure.

**This suggests:**
1. The JSON helpers are treating a **symptom** (Bash is bad at JSON)
2. The **root cause** is using Bash for complex data manipulation tasks
3. The right solution may be **rewriting** problematic scripts in TypeScript/Python

### When Bash is Wrong Tool

**Bash is appropriate for:**
- Simple file operations (cp, mv, mkdir)
- Command orchestration (git, npm, docker)
- Environment management (exports, PATH manipulation)

**Bash is problematic for:**
- Complex JSON manipulation (nested objects, arrays)
- Data validation and transformation
- Error handling with structured data
- Type safety (everything is a string)

### Evidence from Current System

Looking at the usage data:
- 53,021 Bash invocations suggests heavy reliance on shell scripts
- 3,907 JSON interactions in Bash is a code smell
- "Multiple debugging cycles per session" indicates fundamental tool mismatch

**Question**: What percentage of those 3,907 JSON interactions could be eliminated by using TypeScript/Python for pipeline logic?

---

## Alternative Approaches

### Option A: JSON Helpers (This Discovery)
- **Pros**: Quick fix, incremental adoption, low migration cost
- **Cons**: Perpetuates Bash for JSON tasks, doesn't solve root cause
- **Best for**: Short-term pain relief while planning migration

### Option B: Migrate to TypeScript/Python
- **Pros**: Proper type safety, native JSON support, better maintainability
- **Cons**: Higher upfront cost, requires rewriting existing scripts
- **Best for**: Long-term system health

### Option C: Hybrid Approach
- **Pros**: Use Bash for what it's good at (orchestration), TypeScript/Python for data manipulation
- **Cons**: More complex architecture, two languages to maintain
- **Best for**: Pragmatic balance

---

## Recommendation

### Status: NEEDS RESEARCH

**Research questions to answer before integration:**

1. **Audit current JSON usage in Bash**
   - Which scripts perform JSON operations?
   - How many could be rewritten in TypeScript/Python with reasonable effort?
   - Which are legitimate orchestration scripts that should stay in Bash?

2. **Cost-benefit analysis**
   - Time to create + test JSON helpers: ~2-4 hours
   - Time to migrate critical scripts to TypeScript: ~4-8 hours per script
   - How many scripts are there?

3. **Community research**
   - Search GitHub for popular Bash JSON helper libraries
   - Are there existing solutions we could adopt instead of building?
   - Examples: `bash-json`, `jq-helpers`, `shellspec-json`

4. **Technical validation**
   - Can jq handle all current use cases (deeply nested updates, array manipulation)?
   - What's the performance impact of shelling out to jq repeatedly vs native TS/Python?

### Conditional Integration Path

**IF research shows:**
- Most JSON operations are in orchestration scripts that should stay Bash
- Migration to TypeScript would take >20 hours
- No suitable existing library found

**THEN:** Create JSON helpers as interim solution with deprecation timeline

**OTHERWISE:** Prioritize migration to TypeScript/Python for data manipulation tasks

---

## Suggested Next Steps

1. **Run script audit**: `find ~/.claude -name "*.sh" -exec grep -l "jq\|JSON" {} \;`
2. **Categorize usage**: Which scripts are orchestration vs data manipulation?
3. **Research existing solutions**: Search GitHub for "bash json helpers jq"
4. **Estimate migration effort**: For top 5 problematic scripts, estimate rewrite time
5. **Decision**: Based on research, choose Option A, B, or C above

---

## References

- Claude Code insights report (2026-02-05)
- Bash best practices: Use jq for JSON, not string manipulation
- TypeScript/Python migration consideration from insights report
- Existing capabilities: `~/.claude/lib/` directory structure (if exists)

---

## Redundancy Check

**Checked against**: `registry/existing-capabilities.md`

**Result**: No existing JSON helper library found in current system. This would be a new capability.

**Related capabilities:**
- jq is already used ad-hoc in various scripts
- No standardized approach currently exists

---

## Evaluation Complete

**Score**: 67/100 (NEEDS RESEARCH)
**Decision**: Defer integration pending research on migration to TypeScript/Python
**Assigned**: capability-evaluator (this evaluation)
**Next Action**: Script audit + cost-benefit analysis
