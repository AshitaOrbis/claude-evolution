# Discovery: 13-Hook Lifecycle Patterns (Complete Hook Architecture)

**Source**: https://github.com/disler/claude-code-hooks-mastery (2.3k stars)
**Date**: 2026-02-06 (repo updated Feb 2026)
**Category**: Hooks / Automation
**Community**: David Disler (established Claude Code educator)

## Description

Comprehensive hook architecture demonstrating all 13 lifecycle events with production patterns: blocking controls, intelligent TTS, transcript management, security gates, and builder/validator agent patterns.

### Complete Hook Lifecycle

```
Session Lifecycle → Main Loop → Tool Execution → Subagent Management

SessionStart → UserPromptSubmit → PreToolUse → [Tool Execution] →
PostToolUse/PostToolUseFailure → [Loop] → PreCompact →
[Compaction] → Stop → SessionEnd
```

Plus: PermissionRequest, SubagentStart, SubagentStop, SuggestCompact, EvaluateSession

### Key Patterns

**1. Blocking Control (Exit Code 2)**
```python
# PreToolUse: Block dangerous operations
if is_dangerous_rm_command(command):
    sys.exit(2)  # Exit code 2 = blocks execution
```

**2. UV Single-File Scripts**
```python
# /// script
# dependencies = ["anthropic>=0.28", "pydantic>=2.0"]
# ///
```
Each hook carries its own dependencies, isolated from project.

**3. Intelligent TTS System**
- Priority chain: ElevenLabs → OpenAI → pyttsx3
- Used in: PermissionRequest announcements, Stop completion messages
- Async queue prevents overlapping audio

**4. Transcript Management**
- PreCompact: Backup before compaction
- PostToolUse: JSONL → readable JSON conversion
- SessionEnd: Cleanup with reason codes

**5. Context Injection**
- UserPromptSubmit: Enriches prompts with git status, recent issues, security filters
- SuggestCompact: Strategic compaction recommendations

**6. Code Quality Integration**
- PostToolUse validators: ruff_validator.py, ty_validator.py
- Configured via ruff.toml, ty.toml in project root

**7. Builder/Validator Pattern**
- Builder agent: Full tool access for implementation
- Validator agent: Read-only for quality checks
- Orchestrated via `/plan_w_team` slash command

**8. Custom Status Lines (9 versions)**
- `.claude/status_lines/` for terminal displays
- v8: Token usage with cache stats
- v9: Minimal powerline style

**9. Structured Logging**
All 13 hooks log to JSON:
```
logs/user_prompt_submit.json
logs/pre_tool_use.json
logs/post_tool_use.json
... (13 total, chat.json overwrites per session)
```

## Redundancy Check

**Keywords searched**: "hooks", "lifecycle", "PreToolUse", "PostToolUse", "blocking hooks", "UV scripts", "hook patterns", "transcript management"

**Match in registry**: YES - Hooks documented but not comprehensively:
- Hook Development Patterns section (UV Single-File Script Hooks)
- TDD Guard hooks (tdd-guard enforcement)
- Various hook implementations scattered across skills

**Classification**: **IMPROVEMENT** - Much more comprehensive than existing documentation

### Comparison

| Feature | Existing (Registry) | New (13-Hook Architecture) |
|---------|---------------------|----------------------------|
| Hook count documented | Partial (SessionStart, Stop, PreToolUse) | All 13 lifecycle hooks |
| UV script pattern | Documented (2026-02-06) | Full examples with dependencies |
| Blocking pattern | Not documented | Exit code 2 semantics |
| TTS integration | Not documented | ElevenLabs→OpenAI→pyttsx3 priority chain |
| Transcript management | Not documented | PreCompact backup, JSONL→JSON conversion |
| Context injection | Not documented | UserPromptSubmit enrichment pattern |
| Quality validation | TDD guard only | PostToolUse ruff/ty validators |
| Status lines | Not documented | 9 versions with token/cache stats |
| Builder/Validator | Not documented | Agent pattern for code quality |

### Why Better

1. **Complete lifecycle coverage**: All 13 hooks with real examples
2. **Production patterns**: TTS, transcript backup, quality validation
3. **Blocking semantics**: Exit code 2 vs other codes clearly documented
4. **Agent orchestration**: Builder/Validator pattern for quality gates
5. **Status line customization**: 9 versions showing progression
6. **Structured logging**: JSON logs for all hook events

**This is the most comprehensive hook documentation available** (2.3k stars validates community value)

## Integration Path

**Option 1: Full Integration** (Recommended)
1. Create `~/.claude/skills/hooks-mastery/SKILL.md` with all 13 patterns
2. Include blocking semantics, UV scripts, TTS, transcript management
3. Add Builder/Validator agent definitions to `~/.claude/agents/`
4. Include example hooks in skill with modification instructions

**Option 2: Cherry-Pick High-Value Patterns**
1. Add to existing Hook Development Patterns section
2. Include: Blocking exit codes, TTS priority chain, transcript backup
3. Reference repo for full examples

## Evaluation Criteria

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 70/100 | Multiple hooks + agents, but modular |
| Token efficiency | 75/100 | Hooks run outside context (zero token) |
| Capability expansion | 90/100 | Comprehensive lifecycle coverage, novel patterns |
| Maintenance burden | 65/100 | 13 hooks + TTS + validators = some overhead |
| Community validation | 85/100 | 2.3k stars, active Feb 2026 updates |

**Estimated Total**: ~77/100 (APPROVED for integration)

## Decision

**APPROVE** for integration as comprehensive hook skill.

**Integration Plan**:
1. Create `~/.claude/skills/hooks-mastery/SKILL.md` documenting all 13 hooks
2. Include production patterns: blocking, TTS, transcripts, quality validation
3. Add Builder/Validator agent pattern to agent library
4. Extract and document status line customization patterns
5. Update registry with complete hook lifecycle

**Priority**: HIGH - Hooks are critical automation layer with poor documentation

## Notes

- Requires UV for single-file scripts (already in ecosystem)
- TTS optional (ElevenLabs/OpenAI API keys for voice)
- Cross-platform (Node.js implementations)
- Builds on existing Hook Development Patterns (UV scripts) from registry
- Repository includes 8 output styles in `.claude/output-styles/` (bonus content)

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Redundancy Classification

**Match**: YES - Hooks documented in registry but NOT comprehensively
**Classification**: IMPROVEMENT

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 70/100 | 20% | 14.0 | Multiple hooks + agents + TTS optional, modular |
| Token efficiency | 75/100 | 25% | 18.75 | Hooks run outside context (zero token) |
| Capability expansion | 90/100 | 25% | 22.5 | All 13 hooks with production patterns |
| Maintenance burden | 65/100 | 15% | 9.75 | 13 hooks + TTS + validators = moderate overhead |
| Community validation | 85/100 | 15% | 12.75 | 2.3k stars, active Feb 2026, established educator |

**TOTAL**: **77.75/100** ✅ APPROVED

### Decision

**APPROVE** - Comprehensive hook architecture with production patterns. This is the most complete hook documentation available.

**Integration Path**:
1. Create `~/.claude/skills/hooks-mastery/SKILL.md` documenting all 13 hooks
2. Include production patterns: blocking, TTS, transcripts, quality validation
3. Add Builder/Validator agent pattern to agent library
4. Document status line customization patterns
5. Update registry with complete hook lifecycle

**Priority**: HIGH - Hooks are critical automation layer with poor documentation
