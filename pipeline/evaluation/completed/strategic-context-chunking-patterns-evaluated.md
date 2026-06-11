# Discovery: Strategic Context Chunking Patterns

**Source**: https://claudefa.st/blog/guide/mechanics/context-management
**Date**: 2026-02-06 (published Jan 2026)
**Category**: Context Management / Best Practice
**Community**: Claude Fast (established Claude Code resource)

## Description

Evidence-based context management patterns from production Claude Code usage that go beyond generic "restart when full" advice.

### Core Patterns

**80% Rule**: Exit sessions at 80% context usage before degradation becomes noticeable

**Component-Based Workflow**:
- Build complete components in isolated sessions before integration
- Finish research phases separately from implementation
- Create checkpoint documentation between sessions

**Task Categorization by Context Efficiency**:
- **Memory-intensive** (degrade first): Large refactors, multi-component features, complex debugging, architectural code reviews
- **Context-efficient**: Single-file edits, utility creation, documentation, localized fixes

**20% Reserve**: Avoid using final 20% of context for multi-section work to protect project awareness

**Natural Breakpoints**: Divide work into context-sized chunks with clear completion points

### Supporting Features
- `/compact` slash command for session memory summarization
- CLAUDE.md for "free context that survives restarts"
- Session Memory includes: title, completed work, key results, discussion points, work log

## Redundancy Check

**Keywords searched**: "context management", "session reset", "chunking", "context window", "memory optimization", "session strategy"

**Match in registry**: YES - Partial match:
- Context Management section exists (1M context, programmatic tool calling, subagent delegation)
- Auto-compacting (built-in conversation summarization)
- Compact with Instructions skill (preserves critical info during compaction)
- Fan-Out Scaling Workflow (three-phase pattern for scaling changes)

**Classification**: **IMPROVEMENT** - More tactical guidance than existing documentation

### Comparison

| Feature | Existing (Registry) | New (Strategic Chunking) |
|---------|---------------------|--------------------------|
| High-level strategy | 1M context window, subagent delegation | Component-based workflow, 80% rule |
| Compaction guidance | Compact with Instructions skill | `/compact` command + session memory details |
| Task categorization | Fan-Out Scaling (sample→tune→deploy) | Memory-intensive vs context-efficient |
| Practical thresholds | None specified | 80% exit, 20% reserve for multi-section work |
| Workflow integration | Auto-compacting, batch-orchestrator | Natural breakpoints, checkpoint documentation |

### Why Better (Marginal)

1. **Quantified thresholds**: 80% exit rule, 20% reserve (vs vague "approaching limit")
2. **Task categorization**: Helps predict when to chunk (large refactors vs single-file edits)
3. **Component isolation**: Specific pattern for multi-component projects
4. **Checkpoint documentation**: Explicit continuity strategy between sessions

**However**: Most of this is workflow advice, not new tooling. It complements existing patterns but doesn't replace them.

## Integration Path

**Option 1: Documentation Addition** (Recommended)
- Add to `~/.claude/skills/advanced-tool-use/SKILL.md` as "Context Management Patterns" section
- Include 80% rule, task categorization, component workflow
- Cross-reference Compact with Instructions and Fan-Out Scaling

**Option 2: Standalone Skill**
- Create `~/.claude/skills/strategic-context-chunking/SKILL.md`
- Full patterns documentation
- Decision tree: When to chunk vs continue

## Evaluation Criteria

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 95/100 | Documentation-only, no code |
| Token efficiency | 50/100 | Neutral - workflow advice, not optimization |
| Capability expansion | 60/100 | Incremental - clarifies existing features |
| Maintenance burden | 95/100 | Static documentation |
| Community validation | 70/100 | Claude Fast established resource |

**Estimated Total**: ~74/100 (APPROVED for documentation integration)

## Decision

**APPROVE** for integration as **documentation enhancement**, not standalone capability.

**Action**:
1. Add "Strategic Context Chunking Patterns" section to `advanced-tool-use` skill
2. Include 80% rule, task categorization, component workflow, 20% reserve
3. Cross-reference with Compact with Instructions and Fan-Out Scaling
4. Update existing capabilities registry with tactical context patterns

## Notes

- This discovery represents **best practices codification** rather than new tooling
- Complements existing context management features
- Low integration effort (documentation-only)
- Marginal improvement over existing guidance but worth documenting

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Redundancy Classification

**Match**: YES - Context Management section (1M context, auto-compacting, Fan-Out Scaling)
**Classification**: IMPROVEMENT (tactical guidance vs high-level strategy)

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 95/100 | 20% | 19.0 | Documentation-only, no code |
| Token efficiency | 50/100 | 25% | 12.5 | Neutral - workflow advice, not optimization |
| Capability expansion | 60/100 | 25% | 15.0 | Incremental - clarifies existing features |
| Maintenance burden | 95/100 | 15% | 14.25 | Static documentation |
| Community validation | 70/100 | 15% | 10.5 | Claude Fast established resource |

**TOTAL**: **71.25/100** ✅ APPROVED

### Decision

**APPROVE** for documentation enhancement. Provides quantified thresholds (80% exit, 20% reserve) and task categorization (memory-intensive vs context-efficient) that complement existing patterns.

**Integration Path**:
1. Add "Strategic Context Chunking Patterns" section to `~/.claude/skills/advanced-tool-use/SKILL.md`
2. Include: 80% rule, task categorization, component workflow, 20% reserve
3. Cross-reference with Compact with Instructions and Fan-Out Scaling
4. Update existing capabilities registry

**Priority**: LOW - Documentation enhancement, marginal improvement
