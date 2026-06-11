# Discovery: Two-Failure Reset Rule

- **Source**: https://smartscope.blog/en/generative-ai/claude/claude-code-best-practices-advanced-2026/
- **Date Found**: 2026-02-06
- **Category**: technique
- **Summary**: Pattern where Claude sessions are cleared after two consecutive failures on the same issue to prevent context pollution and reasoning loops. Addresses the problem of Claude repeatedly making the same mistake when context becomes poisoned.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

The Two-Failure Reset Rule is a systematic approach to handling repeated failures: when Claude fails on the same task twice, immediately clear the session context and restart rather than continuing to iterate. This prevents:

- **Context poisoning**: Errors compounding through contaminated reasoning chains
- **Reasoning loops**: Claude repeatedly trying the same failed approach
- **Token waste**: Continued iteration on poisoned context that won't succeed

The technique is particularly valuable for:
- Debugging sessions where the first approach was fundamentally wrong
- Implementation tasks where Claude locked onto an incorrect pattern
- Refactoring attempts that introduced cascading issues

**Implementation**: Can be manual (user initiates `/clear` after second failure) or automated via a Stop hook that tracks failure count per issue and forces session reset.

## Redundancy Check

**Status**: NOVEL

Checked against registry:
- **Context Management**: Lists "Context Isolation" via subagents, but no pattern for handling repeated failures in main session
- **Session-End Verification**: Addresses testing after implementation, not mid-session failure recovery
- **Self-Healing Pipeline**: For Bash scripts only, not general Claude reasoning failures
- **Auto-Compacting**: For context overflow, not failure recovery
- **Memory system**: For recall across sessions, not within-session failure handling

This is a distinct pattern for **failure recovery** that complements but doesn't overlap with existing context management capabilities.

## Evaluation Needs

1. **Effectiveness**: Does clearing after two failures measurably improve success rate vs continuing to iterate?
2. **False positives**: Are there cases where the third+ attempt would have succeeded with same context?
3. **Automation**: Should this be a hook pattern, CLAUDE.md guidance, or manual practice?
4. **Metrics**: How to reliably detect "same issue" failures (string matching, embeddings, LLM classification)?
5. **User experience**: Does forced reset feel helpful or disruptive?

## Integration Path

If approved:
- **Skill**: Document as `~/.claude/skills/failure-recovery-patterns/SKILL.md`
- **Hook**: Optional Stop hook implementation with failure tracking
- **CLAUDE.md**: Add guidance section on when to manually reset
- **Metrics**: Test on 20+ real failure scenarios to validate effectiveness
