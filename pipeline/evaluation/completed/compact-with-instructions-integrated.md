# Discovery: Compact with Instructions

- **Source**: https://smartscope.blog/en/generative-ai/claude/claude-code-best-practices-advanced-2026/
- **Date Found**: 2026-02-06
- **Category**: technique
- **Summary**: Pattern for guiding Claude's auto-compaction behavior by specifying what information to preserve during context summarization, preventing loss of critical details when approaching context limits.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

When Claude Code's automatic context compaction triggers (approaching context window limits), it summarizes earlier conversation history to free up tokens. The "Compact with Instructions" pattern proactively specifies what information MUST be preserved during this summarization:

**Standard behavior**: Claude auto-compacts based on general relevance heuristics
**Enhanced behavior**: User/CLAUDE.md provides explicit preservation instructions

**Example instructions**:
```markdown
## Compaction Preservation Rules

When auto-compacting context, ALWAYS preserve:
- Database schema definitions from initial analysis
- API endpoint signatures and authentication patterns
- Error patterns and their root causes from debugging sessions
- Performance benchmarks and optimization constraints
- Security requirements and compliance constraints
```

This prevents the common failure mode where Claude compacts away critical context (schema details, API contracts, constraints) that were established early in the session but are needed later.

## Redundancy Check

**Status**: NOVEL

Checked against registry:
- **Auto-Compacting**: Listed as "BUILT-IN" with "Automatic conversation summarization when context limit approached"
- **Context Compaction (configurable)**: Listed for Opus 4.6 as "Configurable threshold"
- **Partial Summarization**: Listed as manual "Summarize from here" feature

**Key distinction**: Registry documents THAT compaction happens and threshold configuration, but NOT HOW to guide WHAT gets preserved during compaction. This is a procedural pattern for optimizing compaction behavior, not a replacement for the compaction feature itself.

Similar to how "prompt engineering" doesn't replace the model but improves its output, "compact with instructions" doesn't replace auto-compacting but improves its preservation decisions.

## Evaluation Needs

1. **Effectiveness**: Does Claude actually respect preservation instructions during auto-compaction?
2. **Token overhead**: How many tokens do preservation instructions consume vs benefit gained?
3. **Timing**: Should instructions be in CLAUDE.md (always present) or added mid-session when critical info emerges?
4. **Validation**: How to test if compaction preserved the right information?
5. **Best practices**: What types of information most commonly need preservation?

## Integration Path

If approved:
- **CLAUDE.md section**: Add "Context Compaction Guidance" template
- **Skill**: `~/.claude/skills/context-preservation-patterns/SKILL.md`
- **Best practices doc**: Guidelines on what to preserve for different project types
- **Testing**: Run 10+ long sessions with/without preservation instructions to measure impact
