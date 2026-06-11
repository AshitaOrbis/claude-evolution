# Discovery: Cursor Composer Multi-File Editing Patterns

**Source**: Multiple sources - Cursor 2.0 documentation, user reviews, tutorials
**Category**: Technique/Pattern
**Stars/Validation**: Cursor: 1M+ users, 360k paying customers, NVIDIA 100% adoption

## Summary

Cursor Composer is a proprietary mixture-of-experts (MoE) model and multi-agent system designed specifically for multi-file editing in large codebases. Key innovations: (1) AI agents work independently in parallel with separate context windows, (2) Dependency-aware refactoring across hundreds of files, (3) Plan Mode with visible task breakdown, (4) Background agents for autonomous work, (5) Browser control integration for full-stack development.

## Potential Value

- **Token impact**: N/A - This is a competitor product pattern, not an integration
- **Capability**: Inspirational - Multi-file orchestration patterns we can learn from
- **Integration effort**: N/A - Cannot integrate proprietary Cursor features

## Key Innovations We Can Learn From

### 1. Multi-Agent Parallel Execution

**Cursor's Approach**:
- Run up to 8 AI agents simultaneously
- Each agent has independent context window (no cross-contamination)
- Agents coordinate via shared dependency graph
- "Composer" model acts as orchestrator

**Claude Code Equivalent**:
We already have:
- ✅ Task tool for spawning subagents (code-reviewer, debugger, etc.)
- ✅ Independent contexts for each subagent
- ✅ Agent Teams (experimental) for parallel coordination

**What We're Missing**:
- ❌ No explicit limit on parallel agents (Task tool is sequential by default)
- ❌ No shared dependency graph for cross-file coordination
- ❌ No visual orchestration UI (like Cursor's agent manager)

### 2. Plan Mode with Visible Task Breakdown

**Cursor's Approach**:
- User approves plan before execution
- Task tree shows parent-child relationships
- Real-time status updates (in_progress, completed, failed)
- Human can intervene at any step

**Claude Code Equivalent**:
We already have:
- ✅ EnterPlanMode / ExitPlanMode tools
- ✅ TodoWrite for task tracking
- ✅ Task tool returns metrics (tokens, duration, tool uses)

**What We're Missing**:
- ❌ No visual task tree (CLI only)
- ❌ No real-time status UI
- ❌ No dependency visualization

**Note**: These are UX features, not fundamental capabilities. Claude Code's plan mode is functionally equivalent.

### 3. Rules System for Context Constraints

**Cursor's Approach**:
- `.cursorrules` file with project-specific constraints
- Natural language rules ("Follow Next.js patterns", "Use TypeScript strict mode")
- Rules automatically injected into every agent's context

**Claude Code Equivalent**:
We already have:
- ✅ CLAUDE.md for project instructions (always loaded)
- ✅ Skills in `.claude/skills/` (progressive disclosure)
- ✅ Agent frontmatter for tool restrictions

**What We're Missing**:
- ❌ No dedicated "rules" file (CLAUDE.md serves this purpose but less explicit)
- ❌ No rules inheritance hierarchy (global → project → agent)

**Opportunity**: Could create `.claude/RULES.md` convention for explicit constraints.

### 4. Background Agents

**Cursor's Approach**:
- Agents continue working after user logs off
- Asynchronous task execution
- Results available when user returns

**Claude Code Equivalent**:
We already have:
- ✅ Bash tool can run background processes (`command &`)
- ✅ Hooks system for automated tasks
- ✅ Session persistence (resume work later)

**What We're Missing**:
- ❌ No first-class "background agent" concept
- ❌ No async Task tool (agents block until completion)
- ❌ No agent state persistence across sessions (sessions are ephemeral)

**Note**: Could implement via Bash + hooks, but not native to Task tool.

### 5. Browser Control Integration

**Cursor's Approach**:
- AI agents can control browser for testing/validation
- Full-stack development in one tool
- Drag-and-drop images for UI implementation

**Claude Code Equivalent**:
We already have:
- ✅ Better Playwright MCP for browser automation
- ✅ Chrome DevTools MCP for WebMCP integration
- ✅ Read tool supports images (multimodal vision)

**What We're Missing**:
- ❌ No drag-and-drop image support (Read tool requires file paths)
- ❌ No seamless IDE ↔ browser connection (requires MCP setup)

**Note**: MCP integration provides equivalent functionality, just less polished UX.

## Redundancy Check

### Existing Capabilities

From registry:
- ✅ **Agent Teams**: Experimental parallel agent coordination (v2.1.32+)
- ✅ **Plan Mode**: EnterPlanMode / ExitPlanMode tools
- ✅ **Task Metrics**: Task tool returns token count, duration, tools used
- ✅ **Rules System**: CLAUDE.md + skills + agent frontmatter
- ✅ **Browser Automation**: Better Playwright MCP, Chrome DevTools MCP

### Is This DUPLICATE or IMPROVEMENT?

**DUPLICATE**: Most capabilities exist in Claude Code
- Multi-agent execution: Agent Teams (experimental)
- Plan mode: EnterPlanMode/ExitPlanMode
- Context constraints: CLAUDE.md + skills
- Browser control: Playwright/Chrome MCPs

**IMPROVEMENT**: Cursor's UX and orchestration polish
- Visual task tree (vs CLI)
- Up to 8 parallel agents (vs sequential Task tool)
- Dedicated rules file (vs CLAUDE.md)
- Drag-and-drop images (vs file paths)

**Key Insight**: Cursor's innovations are primarily UX/polish, not fundamental capabilities. Claude Code has the building blocks but less polished interfaces.

## Learnings for Claude Code

### 1. Make Agent Teams More Discoverable
- Document best practices for parallel agent workflows
- Create example workflows showing Agent Teams usage
- Consider `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` default

### 2. Enhance Plan Mode Visibility
- Add `TaskTree` tool for hierarchical task visualization
- Improve TodoWrite with parent-child relationships
- Consider visual plan mode in future IDE integrations

### 3. Formalize Rules System
- Create `.claude/RULES.md` convention (separate from CLAUDE.md)
- Document rules inheritance: global → project → agent
- Add `Rules` tool for runtime rule injection

### 4. Improve Background Execution
- Add `TaskAsync` tool for non-blocking agent execution
- Persist agent state across sessions
- Add progress callbacks for long-running agents

### 5. Polish Browser Integration
- Document Better Playwright setup more prominently
- Create examples showing seamless IDE → browser workflows
- Consider drag-and-drop image support in future

## Quick Assessment Score

**N/A - This is a pattern analysis, not an integration candidate**

However, if scoring the *inspirational value*:
- **Pattern quality**: 90/100 (proven at scale, 1M+ users)
- **Relevance to Claude Code**: 85/100 (most patterns applicable)
- **Implementation effort**: 50/100 (requires UX work, not just backend)
- **Novelty**: 60/100 (many capabilities exist, just less polished)
- **INSPIRATIONAL VALUE**: **71/100**

## Recommended Action

[X] Document patterns - No integration needed, but document learnings:
  - Add to `library/patterns/multi-file-orchestration.md`
  - Update Agent Teams documentation with Cursor-inspired examples
  - Create `.claude/RULES.md` convention document
  - Add background agent patterns to `library/patterns/`

## Research Questions

1. **Agent Teams Adoption**: Are users discovering the experimental Agent Teams feature?
2. **Visual Plan Mode**: Would visual task tree improve UX significantly?
3. **Rules vs CLAUDE.md**: Does dedicated rules file improve clarity?
4. **Background Agents**: Is async task execution a common need?

## Integration Blocker Classification

**N/A - Pattern Analysis Only**

No integration needed. These are design patterns to learn from, not features to integrate.

## Pros (Pattern Quality)

✅ Proven at massive scale (1M+ users)
✅ NVIDIA 100% adoption validates enterprise readiness
✅ Multi-agent orchestration patterns are battle-tested
✅ Plan mode UX shows clear task breakdown value
✅ Background agents enable async workflows

## Cons (Applicability to Claude Code)

❌ Most capabilities already exist in Claude Code
❌ Differences are primarily UX, not fundamental
❌ Cannot integrate proprietary Cursor features
❌ Agent Teams already provides parallel execution
❌ Visual UI would require IDE integration work

## Key Takeaway

Cursor's success comes from **polish and UX**, not novel capabilities. Claude Code has the building blocks (Agent Teams, Plan Mode, Task tool, MCPs) but could improve:
1. Discoverability (Agent Teams is experimental, poorly documented)
2. Visibility (Plan mode is CLI-only, no visual tree)
3. Formalization (Rules scattered across CLAUDE.md/skills/frontmatter)
4. Async execution (Task tool is blocking by default)

**Action**: Document Cursor's patterns, improve Claude Code's existing features, don't try to copy Cursor's UI.

---

## Evaluation

**Evaluator**: capability-evaluator
**Evaluation Date**: 2026-02-06

### Registry Redundancy Check

**Keywords**: multi-file editing, agent teams, plan mode, parallel agents, background agents, browser control

**Registry Check**: EXTENSIVE overlap found:
- Agent Teams: IMPLEMENTED (experimental, v2.1.32+)
- Plan Mode: BUILT-IN (EnterPlanMode/ExitPlanMode)
- Browser Automation: IMPLEMENTED (Better Playwright MCP, Chrome DevTools MCP)
- Multi-agent orchestration: IMPLEMENTED (Task tool + 15+ subagents)
- Rules system: IMPLEMENTED (CLAUDE.md + skills + agent frontmatter)

**Classification**: **DUPLICATE (Pattern Analysis)** - Most capabilities exist in Claude Code. Cursor's innovations are primarily UX/polish, not fundamental capabilities.

### Scoring (Inspirational Value, Not Integration Score)

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | N/A | Cannot integrate proprietary Cursor features |
| Token Efficiency Impact | N/A | This is pattern analysis, not a tool |
| Capability Expansion | 40/100 | Most capabilities exist (Agent Teams, Plan Mode, Browser MCPs). UX differences only. |
| Maintenance Burden | N/A | No integration = no maintenance |
| Community Validation | 100/100 | 1M+ users, NVIDIA 100% adoption, proven at scale |
| **PATTERN VALUE** | **40/100** | REJECT for integration, but document learnings |

**Calculation**: Only Capability Expansion is scorable (40/100) - other criteria N/A for pattern analysis.

### Cross-Validation (Codex)

**Codex Assessment**: N/A - Codex agrees this is pattern analysis, not integration candidate.
- Consensus: "Document learnings, don't attempt integration"
- Note: "Focus on improving discoverability of existing features (Agent Teams)"

### Decision: REJECT (Not an Integration Candidate)

**Rationale**: This is a competitive analysis of Cursor's UX patterns, not an integration opportunity:
1. **Proprietary features**: Cannot integrate Cursor's closed-source MoE model or UI
2. **Functional parity**: Claude Code has building blocks (Agent Teams, Plan Mode, Task tool)
3. **UX differences only**: Visual task tree, drag-and-drop images = polish, not capabilities
4. **Better approach**: Document learnings, improve existing feature discoverability

### Recommended Action

**Document Patterns** in `library/patterns/cursor-learnings.md`:

1. **Multi-Agent Orchestration**: Cursor runs up to 8 agents in parallel
   - Claude Code equivalent: Agent Teams (experimental)
   - Action: Improve Agent Teams documentation, create usage examples

2. **Plan Visibility**: Cursor shows visual task tree with real-time status
   - Claude Code equivalent: Plan Mode + TodoWrite
   - Action: Document hierarchical task tracking patterns

3. **Rules System**: `.cursorrules` file for project constraints
   - Claude Code equivalent: CLAUDE.md + skills
   - Action: Consider creating `.claude/RULES.md` convention

4. **Background Agents**: Async task execution
   - Claude Code equivalent: Bash background processes + hooks
   - Action: Document background agent patterns using hooks

5. **Browser Integration**: Seamless IDE → browser connection
   - Claude Code equivalent: Better Playwright MCP
   - Action: Improve MCP setup documentation, create examples

### Integration Blocker Classification

**N/A - Pattern Analysis Only**

No integration possible (proprietary competitor product). Value is in learning from their design patterns.

### Notes

- Cursor's success validates multi-agent orchestration (Agent Teams direction is correct)
- Visual UX improvements would require IDE integration work (future consideration)
- Most "missing" features are discoverability issues, not capability gaps
- Agent Teams (experimental) should be promoted more prominently if stable

### Registry Update Required

Add note to "Context Management" section under Agent Teams:

```markdown
**Pattern Validation**: Cursor Composer (1M+ users) validates multi-agent parallel execution approach. Their UX polish (visual task tree, 8 parallel agents) demonstrates market demand for this pattern. Claude Code's Agent Teams provides equivalent backend capability with less polished frontend.
```

---

**Evaluation Date**: 2026-02-06
**Evaluator**: capability-discoverer
**Discovery Loop**: #15
