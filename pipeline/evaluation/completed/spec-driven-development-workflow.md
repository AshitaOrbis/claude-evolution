# Spec-Driven Development (SDD) Workflow

**Source**: [Pimzino/claude-code-spec-workflow](https://github.com/Pimzino/claude-code-spec-workflow), [gotalab/cc-sdd](https://github.com/gotalab/cc-sdd)
**Category**: Workflow Pattern
**Stars**: Unknown (2026-02-06)
**Discovery Date**: 2026-02-06

## Summary

"Specifications as the primary artifact of software development, with code becoming a generated output derived from human-authored specifications." Introduces structured phase gates to shift review burden from implementation (hundreds of edits) to planning (three documents).

## Core Workflow

**For New Features**:
1. **Requirements**: Define what to build (human-authored)
2. **Design**: Define how to build it (human-reviewed)
3. **Tasks**: Break design into implementation steps (human-reviewed)
4. **Implementation**: Generate code (mostly autonomous)

**For Bug Fixes** (streamlined):
1. **Report**: Document the bug
2. **Analyze**: Root cause analysis
3. **Fix**: Generate patch
4. **Verify**: Test the fix

## Problem Addressed

**Traditional AI-assisted coding**:
- Interrupted constantly during implementation for approval
- Review burden is DURING generation (line-by-line)
- Important decisions made on-the-fly (context degradation)
- Approval fatigue (say yes to everything after 50th prompt)

**Example**: Migration took one afternoon but required dozens of interruptions

## Solution Pattern

**Phase Gate Review**:
1. Review THREE documents upfront (requirements, design, tasks)
2. Approve the PLAN before implementation
3. Let Implementation Agent work autonomously
4. Approval count during implementation drops dramatically

**Key Insight**: Review at strategic checkpoints (phase boundaries), not tactical edits (code changes). Correction upfront is cheaper than rework during implementation.

## Benefits (Empirical)

From source articles:
- **SQLite → IndexedDB migration**: One afternoon (vs days with traditional approach)
- **Approval count**: Dropped significantly (exact number not stated)
- **Code quality**: Better due to research phase uncovering patterns
- **Developer interruption**: Reduced from dozens to ~3 (requirements, design, tasks)

## Implementation

**Multiple implementations available**:
1. **claude-code-spec-workflow** (Pimzino): Automated workflows with slash commands
2. **cc-sdd** (gotalab): Kiro style commands, multi-tool support (Claude/Codex/Cursor/Copilot/Gemini/Windsurf)
3. **spec-kit**: CLI tool for spec generation and validation

**Enforcement mechanisms**:
- Commands that require phase completion before advancing
- Validation checks at phase boundaries
- Templates for each phase document

## Relationship to Existing Capabilities

**FORMALIZATION of existing pattern**:
- Plan Mode (built-in): Create plans with approval workflow
- SDD: Extends to multi-phase with explicit documents (requirements, design, tasks)

**Different from**:
- Plan Mode: Single plan document in conversation context
- SDD: Multiple phase documents with validation at boundaries
- Plan Mode: Lightweight approval ("looks good")
- SDD: Structured review of detailed specs

**Complements**:
- planning-with-files: SDD defines WHAT to put in files (requirements, design, tasks)
- markdown-then-code: SDD is the structured version of interview → doc → plan → code

## Potential Value

**Token Impact**: Highly positive
- Requirements doc replaces repeated explanations
- Design doc captures decisions once (not rediscovered each session)
- Tasks list prevents "what's next?" prompts
- Autonomous implementation phase has fewer interruptions (fewer tokens)

**Capability**: Structured development workflow with phase gates
- Addresses approval fatigue (review 3 docs, not 50 prompts)
- Improves code quality (research phase before implementation)
- Reduces rework (catch issues in design, not in code)

**Integration Effort**: Medium
- Adopt workflow philosophy in CLAUDE.md
- Create phase templates (requirements.md, design.md, tasks.md)
- Optional: Install automated workflow tool (Pimzino or gotalab)
- Train on phase transitions (when to move from requirements → design)

## Quick Assessment Score

- Integration complexity: **70/100** (philosophy + templates, or tool install)
- Token efficiency impact: **85/100** (major reduction via autonomous implementation)
- Capability expansion: **80/100** (structured development workflow)
- Maintenance burden: **80/100** (static templates OR tool updates)
- Community validation: **75/100** (multiple implementations, production-validated, standardizing in 2026)

**TOTAL**: **78/100**

## Recommended Action

[X] Evaluate further - High score, strong validation, check for overlap with Plan Mode
[ ] Reject
[ ] Fast-track integration

## Redundancy Check

**Triggers checked**: "spec-driven", "phase gates", "requirements design tasks", "structured development"

**Result**: PARTIAL MATCH with Plan Mode (built-in)

**Classification**: IMPROVEMENT - Plan Mode provides single-phase planning; SDD provides multi-phase structured workflow. Likely COMPLEMENTARY if we adopt templates but don't install external tool.

## Notes

- Multiple tool implementations suggest standardization is happening (2026 trend)
- Could be integrated as skill with templates: `~/.claude/skills/spec-driven-development/`
- Complements persistent planning (planning-with-files) by defining file structure
- May want to create lightweight version (templates only) vs full tool install
- Cross-validate with Addy Osmani's spec writing guide (search result reference)

---

## Evaluation

**Evaluator**: capability-evaluator
**Date**: 2026-02-06

### Scoring

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration Complexity | 70/100 | Templates + workflow guidance OR tool install (medium) |
| Token Efficiency | 85/100 | Major savings: autonomous implementation, fewer approvals |
| Capability Expansion | 65/100 | IMPROVEMENT of Plan Mode (multi-phase vs single-phase) |
| Maintenance Burden | 80/100 | Static templates OR tool updates |
| Community Validation | 75/100 | Multiple implementations, production-validated, 2026 standardization |
| **WEIGHTED TOTAL** | **75/100** | |

### Cross-Validation (Codex)
"Phase gates reduce rework. 75/100 - formalization of Plan Mode with structured reviews. Complementary, not duplicate."

### Security
- [x] Markdown templates only
- [x] No external dependencies
- [x] Optional tool install (evaluate separately)

### Decision: APPROVE (75/100)

**Classification**: IMPROVEMENT (of Plan Mode)

**Integration Path**:
1. Create `~/.claude/skills/spec-driven-development/SKILL.md`
2. Templates: `requirements.md`, `design.md`, `tasks.md`
3. Phase transition criteria
4. Document in CLAUDE.md as workflow pattern
5. Test on the statement parser feature

**Complementarity**: Works WITH planning-with-files (defines file structure) and Plan Mode (extends to multi-phase).
