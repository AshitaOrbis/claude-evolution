# Evaluation Report: Task Master MCP (claude-task-master)

**Evaluated**: 2026-01-26
**Evaluator**: capability-evaluator (Claude Opus 4.5)
**Cross-Validation**: Codex GPT-5.2 (Session: 019bfa44-0240-7562-9082-a13033dab814)

---

## Basic Information
- **Source**: https://github.com/eyaltoledano/claude-task-master
- **Category**: MCP Server (Task Management)
- **License**: MIT with Commons Clause (proprietary use restrictions)
- **Last Updated**: Active (Main branch commit 7a52bd41, created March 2025)
- **Stars/Validation**: 25.1k stars, 2.4k forks

---

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| **Integration Complexity** | 60/100 | Standard MCP setup + requires external API key management (Anthropic/OpenAI/Google/Perplexity). API dependency adds operational overhead (quotas, outages, key rotation). More complex than built-in TodoWrite + Plan Mode (zero external services). |
| **Token Efficiency Impact** | 20/100 | **CRITICAL FAILURE**: External AI API calls for every operation (PRD parsing, task decomposition, complexity analysis). Zero-cost TodoWrite provides 80-90% feature parity. Ongoing costs scale with usage—unbounded expense model. |
| **Capability Expansion** | 55/100 | **Incremental, not novel**: Automated PRD→task graph + dependency tracking are new. But Plan Mode handles planning, TodoWrite tracks progress, subagents decompose work. Gap = persistent task graphs with formal dependencies. Marginal value unless PRD automation is daily requirement. |
| **Maintenance Burden** | 50/100 | Medium: MCP server runtime, API key rotation, provider outages, version updates. Process overlap risk: maintaining Task Master's task model AND Claude Code's todos/plans creates dual-system friction. |
| **Community Validation** | 100/100 | 25.1k stars, active development, comprehensive docs (docs.task-master.dev), editor-agnostic (Cursor, Windsurf, VS Code, Claude Code). Well-validated in community. |
| **WEIGHTED TOTAL** | **48.75/100** | REJECTED |

### Score Calculation
```
Total = (IC × 0.20) + (TE × 0.25) + (CE × 0.25) + (MB × 0.15) + (CV × 0.15)
      = (60 × 0.20) + (20 × 0.25) + (55 × 0.25) + (50 × 0.15) + (100 × 0.15)
      = 12 + 5 + 13.75 + 7.5 + 15
      = 48.75 / 100
```

---

## Cross-Validation

| Source | Score | Key Points |
|--------|-------|------------|
| **Claude Assessment** | 48.75/100 | API cost model unacceptable; TodoWrite + Plan Mode provide 80-90% feature parity at zero cost |
| **Codex Assessment** | 38/100 | "High API cost risk, unbounded expense, process overlap friction. Skip unless PRD-to-task automation is core daily need." |
| **Variance** | 10.75 points | Consensus: REJECT |
| **Consensus** | ✅ Achieved | Both models agree: API cost risk outweighs incremental value |

**Codex Quote**:
> "If your team needs formal dependency graphs and automated PRD ingestion on a regular cadence—and you're willing to pay per operation—then it can be worth it. But for most Claude Code workflows, TodoWrite + Plan Mode + subagents already cover 80–90% of the value with zero ongoing cost and less operational overhead."

---

## Security Assessment

- [x] No sensitive permissions required (MCP server runs locally)
- [x] No excessive data access (reads local project files)
- [ ] License compatible (MIT/Apache/BSD) — **MIT with Commons Clause restricts commercial use**
- [x] No known vulnerabilities
- [ ] API keys manageable — **CONCERN**: Requires ongoing management of external AI provider keys

**License Risk**: Commons Clause prohibits selling the software or providing it as a service. Fine for personal use, but limits commercial deployment.

**API Key Risk**: External API dependency creates attack surface (key leakage, quota exhaustion, provider outages).

---

## Existing Alternatives

### Claude Code Built-In Task Management (Zero Cost)

| Feature | Task Master MCP | TodoWrite + Plan Mode + Subagents |
|---------|----------------|-----------------------------------|
| Task tracking | ✅ Status tracking | ✅ TodoWrite (pending/in_progress/completed) |
| Task decomposition | ✅ AI-powered via external API | ✅ Plan Mode + subagents (native) |
| Dependency tracking | ✅ Explicit dependency graph | ⚠️ Manual (todo order + notes) |
| PRD parsing | ✅ Automated PRD→task | ⚠️ Manual (read PRD, create plan) |
| Progress monitoring | ✅ Automated metrics | ✅ TodoWrite status updates |
| Persistent state | ✅ Stored task model | ⚠️ Session-based (can export) |
| Cost | ❌ API calls per operation | ✅ Zero (built-in tools) |
| Token overhead | ❌ MCP schema ~2-3k tokens | ✅ Zero (native tools) |
| Complexity analysis | ✅ AI-powered | ✅ Via subagents (e.g., `feature-implementer`) |
| Subtask management | ✅ Hierarchical | ✅ Nested todos with activeForm |

**Feature Parity**: 80-90% overlap. Task Master adds:
1. Persistent task database (beyond session)
2. Formal dependency graph structure
3. Automated PRD ingestion

**But at what cost?**
- External API calls = unbounded expense
- Dual-system maintenance (Task Master + TodoWrite)
- Operational overhead (API keys, quotas, outages)

---

## Kill Signals Triggered

- [ ] ~~Requires root/admin access to system~~
- [ ] ~~Accesses sensitive user data without clear need~~
- [ ] ~~License is incompatible (GPL without isolation, proprietary)~~ — Commons Clause restricts commercial use but allows personal use
- [ ] ~~No documentation or examples~~ — Excellent docs
- [ ] ~~Abandoned (no commits in 12+ months)~~
- [ ] ~~Known major security vulnerabilities~~
- [ ] ~~Conflicts with existing critical tools~~ — Process overlap, not conflict
- [x] **Requires API keys with unclear cost implications** — External AI calls per operation, unbounded costs

**PRIMARY KILL SIGNAL**: API cost model unacceptable when zero-cost alternatives exist.

---

## Recommendation

**DECISION**: ❌ **REJECT (48.75/100)**

**Rationale**:

Task Master MCP provides **incremental value** (persistent task graphs, automated PRD parsing) but fails on **token efficiency** (20/100) due to external API costs. The core issue:

1. **API Cost Model**: Every task operation (PRD parsing, decomposition, complexity analysis) hits paid external APIs. This creates unbounded expense that scales with usage—exactly opposite to Claude Code's philosophy of built-in, zero-cost tools.

2. **High Feature Overlap**: TodoWrite (built-in) + Plan Mode (built-in) + subagents (built-in) already provide:
   - Task tracking with status (TodoWrite)
   - Structured planning with approval workflow (Plan Mode)
   - Task decomposition via specialized agents (Task tool + subagents)
   - Progress monitoring (TodoWrite status updates)

   **80-90% feature parity at zero cost.**

3. **Dual-System Friction**: Integrating Task Master creates operational overhead:
   - Maintain both Task Master's task model AND Claude Code's todos/plans
   - Context drift between Task Master decomposition style vs subagent patterns
   - API key management, quota tracking, provider outages

4. **The 10-20% Gap**: What Task Master uniquely offers:
   - Persistent task database (cross-session)
   - Formal dependency graph structure
   - Automated PRD→task ingestion

   These are valuable **only if PRD automation is a core daily requirement**. For most Claude Code workflows, manual PRD review + Plan Mode is sufficient.

**Cross-Validation Consensus**: Both Claude (48.75/100) and Codex (38/100) agree this is a poor fit. Codex's frank take: "Skip integration unless PRD-to-task automation is core daily need."

**Alternative**: If persistent task graphs are needed, consider:
1. Extend TodoWrite with simple dependency tracking (e.g., `blockedBy: ["task-2", "task-3"]` field)
2. Export Plan Mode outputs to external tools (Jira, Linear) if formal tracking needed
3. Use Claude Code's session persistence for cross-session continuity

**Token Economy Principle**: Never integrate a tool that adds API costs when free alternatives provide 80%+ feature parity. Task Master violates this principle.

---

## Storage

**File**: `~/claudeworkspace/claude-evolution/pipeline/evaluation/completed/task-master-mcp-evaluation.md`
**Status**: REJECTED
**Reason**: API cost model unacceptable; high feature overlap with built-in tools

**Next Steps**:
1. Update `registry/existing-capabilities.md` with "task master" redundancy trigger
2. Archive this evaluation in `archive/rejected/task-master-mcp-api-cost-rejected.md`
3. No integration action required

---

## Future Reconsideration Triggers

Reconsider Task Master MCP if ANY of these change:

1. **API Cost Eliminated**: Task Master adds local-only decomposition mode (no external AI calls)
2. **Feature Gap Widens**: Built-in TodoWrite + Plan Mode cannot scale to formal dependency graphs needed daily
3. **Enterprise Requirement**: Compliance/audit requires persistent, versioned task models that TodoWrite cannot provide
4. **Commons Clause Lifted**: License becomes MIT/Apache for commercial use

Otherwise, **permanently rejected** due to API cost model.

---

## Lessons for Future Evaluations

**Pattern Detected**: "AI-powered task management" tools often require external API calls, creating ongoing costs. This is a **red flag** when evaluating against Claude Code's built-in, zero-cost task management (TodoWrite + Plan Mode + subagents).

**Evaluation Heuristic**:
```
IF (new_tool requires external_api_calls) AND (built_in_tools provide 80%+ feature_parity):
  Token Efficiency Score = 0-30 / 100
  Automatic rejection unless:
    - API costs are fixed/predictable
    - Feature gap is >50% and critical
    - No built-in alternative exists
```

**Added to Registry**: "task master mcp", "ai task management", "prd to task automation", "task dependency graph"
