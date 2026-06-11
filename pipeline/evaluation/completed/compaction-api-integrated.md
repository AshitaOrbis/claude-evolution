## Discovery: Compaction API

**Source**: https://platform.claude.com/docs/en/build-with-claude/compaction
**Category**: API Feature
**Stars/Validation**: Official Anthropic, Beta (as of Feb 5, 2026), Opus 4.6 exclusive

### Summary
Server-side context compaction for managing long conversations that approach context window limits. Automatically summarizes older context when approaching the configured token threshold (default 150k), enabling effectively infinite conversations with automatic context management.

### Potential Value
- **Token impact**: Major savings - enables infinite conversations without manual summarization
- **Capability**: Novel - automatic server-side context management vs manual client-side summarization
- **Integration effort**: Easy - single API parameter, handles summarization automatically

### Technical Details

**How It Works**:
1. Detects when input tokens exceed trigger threshold (default 150k, min 50k)
2. Generates summary of current conversation
3. Creates `compaction` block containing summary
4. Continues response with compacted context
5. On subsequent requests, drops all message blocks prior to compaction block

**API Usage**:
```python
response = client.beta.messages.create(
    betas=["compact-2026-01-12"],
    model="claude-opus-4-6",
    max_tokens=4096,
    messages=messages,
    context_management={
        "edits": [
            {
                "type": "compact_20260112",
                "trigger": {"type": "input_tokens", "value": 150000},
                "pause_after_compaction": False,  # optional
                "instructions": "..."  # optional custom summarization prompt
            }
        ]
    }
)
```

**Parameters**:
- `type`: "compact_20260112" (required)
- `trigger`: Token threshold (default 150k, min 50k)
- `pause_after_compaction`: Pause after summary for manual message preservation
- `instructions`: Custom summarization prompt (completely replaces default)

**Default Summarization Prompt**:
```
You have written a partial transcript for the initial task above. Please write a
summary of the transcript. The purpose of this summary is to provide continuity so
you can continue to make progress towards solving the task in a future context, where
the raw history above may not be accessible and will be replaced with this summary.
Write down anything that would be helpful, including the state, next steps, learnings
etc. You must wrap your summary in a <summary></summary> block.
```

**Advanced Features**:
- **Streaming support**: Compaction block streams differently (single delta with complete summary)
- **Prompt caching**: Can add `cache_control` breakpoint on compaction blocks
- **Token budget enforcement**: Use `pause_after_compaction` + counter to limit total token consumption
- **Preserve recent messages**: Pause compaction, insert preserved messages, continue request
- **Multiple compactions**: Last compaction block reflects final state

**Usage Tracking**:
```json
{
  "usage": {
    "input_tokens": 45000,
    "output_tokens": 1234,
    "iterations": [
      {
        "type": "compaction",
        "input_tokens": 180000,
        "output_tokens": 3500
      },
      {
        "type": "message",
        "input_tokens": 23000,
        "output_tokens": 1000
      }
    ]
  }
}
```

**IMPORTANT**: Top-level `input_tokens`/`output_tokens` do NOT include compaction iteration. Must sum across `usage.iterations` array for total billing.

**Compatibility**:
- Server tools: Compaction trigger checked at start of each sampling iteration
- Token counting: `/v1/messages/count_tokens` applies existing compaction blocks but doesn't trigger new ones

### Quick Assessment Score

- **Integration complexity**: 90/100 (single API parameter, automatic handling)
- **Token efficiency impact**: 95/100 (enables infinite conversations, automatic summarization)
- **Capability expansion**: 85/100 (significantly improves vs manual client-side summarization)
- **Maintenance burden**: 95/100 (official API feature, server-side, no client maintenance)
- **Community validation**: 100/100 (official Anthropic, beta with production path)

**TOTAL**: **93/100** (Weighted average)

### Recommended Action
[ ] Evaluate further
[ ] Reject (reason: ...)
[X] Fast-track integration

### Integration Path

**Immediate Use Cases**:
1. **Evolution heartbeat conversations** - Long-running discovery/evaluation sessions
2. **Multi-iteration development** - Iterative improvement loops with persona testing
3. **Interactive debugging** - Long troubleshooting sessions
4. **Knowledge extraction** - Extended conversations with context librarian

**Implementation Steps**:
1. Update SDK to latest version (Python v0.78.0+, TypeScript latest)
2. Add beta header `compact-2026-01-12` to API requests
3. Update message handling to preserve compaction blocks
4. Update cost tracking to sum `usage.iterations` array
5. Test with long-running evolution sessions

**Compatibility**:
- Requires Claude Opus 4.6 (`claude-opus-4-6`)
- Beta status (as of Feb 5, 2026)
- Client libraries: Python SDK 0.78.0+, TypeScript SDK latest

**Configuration Recommendation**:
- Trigger: 100,000 tokens (allows multiple tool use iterations before compaction)
- Pause after compaction: False (default, automatic continuation)
- Custom instructions: None initially (use default summarization prompt)

### Relationship to Existing Capabilities

**vs Auto-Compacting** (already in registry):
- **Auto-compacting**: Client-side, lossy, within-session only
- **Compaction API**: Server-side, structured, preserves summaries across requests
- **Relationship**: IMPROVEMENT - server-side is more efficient than client-side
- **Action**: Update registry to note Compaction API as preferred for API users

**vs Manual Summarization** (existing practice):
- **Manual**: Client writes summarization logic, manages context windows
- **Compaction API**: Automatic, server-side, zero maintenance
- **Relationship**: REPLACEMENT for API workflows

**vs Official Memory System** (2.1.32+):
- **Memory System**: Recalls facts from previous sessions, conversational
- **Compaction API**: Manages long conversations, task-oriented
- **Relationship**: COMPLEMENTARY - Memory for cross-session facts, Compaction for long tasks

### Notes
- **Beta status**: Include header `anthropic-beta: compact-2026-01-12`
- **Current limitation**: Same model for summarization (no option for cheaper model)
- **Opus 4.6 exclusive**: Not available on other models (yet)
- **Billing change**: Must update cost tracking logic to sum `usage.iterations`

---

## Evaluation

**Evaluator**: capability-evaluator
**Evaluation Date**: 2026-02-06

### Registry Redundancy Check

**Keywords**: compaction, context management, automatic summarization, infinite conversations

**Registry Check**: Found existing capability - "Auto-Compacting" in "Memory & Persistence" section:
- Status: BUILT-IN
- Mechanism: Automatic conversation summarization when context limit approached
- Scope: Within session only

**Classification**: **IMPROVEMENT** - Server-side automatic compaction with structured summaries vs client-side lossy summarization.

### Comparison: Compaction API vs Auto-Compacting

| Feature | Auto-Compacting (existing) | Compaction API (new) |
|---------|---------------------------|---------------------|
| Mechanism | Client-side | Server-side |
| Trigger | Automatic near limit | Configurable threshold (50k-200k) |
| Summary structure | Lossy compression | Structured `<summary>` blocks |
| Preservation | None (compressed away) | Summary persists in context |
| Control | None | Custom instructions, pause_after_compaction |
| Token tracking | Standard | Requires parsing `usage.iterations` array |
| Availability | All models | Opus 4.6 only (beta) |

**Winner**: Compaction API - More control, structured summaries, configurable, official feature path.

### Scoring

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 95/100 | Single API parameter (`context_management`), beta header. Requires updating cost tracking logic (parse `usage.iterations`). Near drop-in. |
| Token Efficiency Impact | 95/100 | Enables infinite conversations, automatic summarization at configurable threshold. Major token savings vs manual context management. |
| Capability Expansion | 90/100 | Significant improvement over auto-compacting - structured summaries, custom instructions, pause control, prompt caching on compaction blocks. |
| Maintenance Burden | 95/100 | Official Anthropic API feature, server-side (zero client maintenance), clear path from beta to GA. |
| Community Validation | 100/100 | Official Anthropic feature, beta with production path, documented in platform docs. |
| **WEIGHTED TOTAL** | **94.75/100** | APPROVE |

**Calculation**: (95×0.20) + (95×0.25) + (90×0.25) + (95×0.15) + (100×0.15) = 94.75

### Cross-Validation (Codex)

**Codex Assessment**: 91/100
- Agreement: "Major improvement over client-side auto-compacting"
- Agreement: "Official Anthropic feature = high confidence"
- Note: "Cost tracking update is critical - must parse iterations array"
- Variance: 3.75 points (consensus)

### Decision: APPROVE (70+ threshold)

**Rationale**: Official Anthropic feature that significantly improves context management:
1. **Server-side = zero maintenance**: No client-side summarization logic needed
2. **Structured summaries**: `<summary>` blocks preserve state/decisions vs lossy compression
3. **Configurable**: Trigger threshold, custom instructions, pause control
4. **Production-ready path**: Beta with clear GA trajectory
5. **Enables infinite conversations**: Major capability expansion for long-running sessions

### Integration Path

**Target Files**:
1. Update `registry/existing-capabilities.md` - Add Compaction API, mark as IMPROVEMENT over auto-compacting
2. Create skill: `~/.claude/skills/compaction-api/SKILL.md` with usage patterns
3. Document in evolution heartbeat setup (long discovery/evaluation sessions)
4. Update cost tracking: Parse `usage.iterations` array in any billing logic

**Configuration**:
```python
# For evolution heartbeat sessions
context_management={
    "edits": [{
        "type": "compact_20260112",
        "trigger": {"type": "input_tokens", "value": 100000},
        "pause_after_compaction": False
    }]
}
```

**Priority Use Cases**:
1. Evolution heartbeat (discovery/evaluation loops)
2. Iterative improvement sessions (multi-iteration dev + testing)
3. Extended debugging sessions
4. Knowledge extraction with context-librarian

### Migration Notes

- Auto-compacting remains available for non-Opus models
- Compaction API is Opus 4.6 exclusive (beta)
- For API users: prefer Compaction API (more control)
- For CLI users: auto-compacting still works transparently

### Registry Update Required

Add to "Memory & Persistence" section:

```markdown
| Capability | Status | Implementation |
|------------|--------|----------------|
| Compaction API | **IMPLEMENTED** | Opus 4.6 beta (`context_management` parameter, header `compact-2026-01-12`) |
| Auto-Compacting | **BUILT-IN** | Fallback for non-Opus models |
```

Update redundancy triggers:
```
"compaction api", "context_management parameter", "server-side compaction", "infinite conversation", "structured summarization", "compact_20260112"
```
