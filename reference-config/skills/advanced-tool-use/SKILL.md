# Advanced Tool Use Skill

Based on Anthropic's research paper on advanced tool use patterns for improved efficiency and accuracy.

## 0. MCP Server Deferred Loading (IMPLEMENTED)

Claude Code supports disabling MCP servers by default. Disabled servers don't load their tools at startup, saving context tokens.

### Current Configuration

In `~/.claude/settings.json`:
```json
{
  "disabledMcpjsonServers": []
}
```

**Currently**: All servers enabled (playwright in heavy use for webapp investigation)
**Ready to defer**: Add server names to the array when usage patterns change

### Enabling Disabled Servers On-Demand

When you need a disabled server:
1. **@-mention**: Type `@playwright` in your prompt to enable it for the session
2. **Use `/mcp`**: Open MCP menu to toggle servers

### Adding More Servers to Deferred List

Edit `~/.claude/settings.json`:
```json
{
  "disabledMcpjsonServers": ["playwright", "gemini"]
}
```

### Token Savings Estimate

| Server | Tools | Token Cost | Deferrable? |
|--------|-------|------------|-------------|
| brave-search | 6 tools | ~2.2k | Yes (if not searching) |
| exa | 7 tools | ~4.2k | Yes (if not researching) |
| playwright | 20+ tools | ~4k | Yes (if not automating) |
| gemini | 6 tools | ~4k | Yes (if not collaborating) |

**Current savings**: 0 (all enabled for active use)
**Max possible savings**: ~14k tokens (all MCP disabled)

---

## 0.5 Tool Search Tool (Anthropic Feature)

> **Status**: IMPLEMENTED - Available in Claude Code 2.1.7+ (as of Jan 2026)

### What Is Tool Search Tool?

Anthropic's Tool Search Tool is an official feature that dramatically reduces context usage by dynamically loading only relevant tools based on the current task. This feature is now automatically enabled in Claude Code 2.1.7 and later versions.

**Verified Metrics** (from Anthropic Engineering):
- **85% token reduction**: ~77K tokens → ~8.7K tokens with 50+ MCP tools
- **Accuracy improvement**: 49% → 74% and 79.5% → 88.1% on MCP evaluations
- **Enables 100+ tools** without context overflow

### How It Works

Instead of loading all tool schemas at startup:
1. Claude analyzes the current task
2. Searches tool catalog for semantically relevant tools
3. Loads only the needed tool schemas (~500 tokens for Tool Search itself)
4. Executes with minimal context overhead

**This happens automatically** - no configuration required.

### Relationship to Manual Workarounds

| Approach | Status | Mechanism | When to Use |
|----------|--------|-----------|-------------|
| **Tool Search Tool** | ✅ ACTIVE | Automatic semantic search | Default (always active) |
| **MCP defer_loading** | Available | Manual deferral in config | Fallback for older API versions |
| **disabledMcpjsonServers** | Available | Manual toggle via settings | Fallback for older API versions |
| **Tool Classification** | Pattern | Manual prioritization guidance | Understanding tool categories |

**Current recommendation**: Tool Search Tool is now the primary mechanism. Manual workarounds (`defer_loading` and `disabledMcpjsonServers`) remain available as fallbacks for environments without Tool Search support.

### Version Requirements

- **Minimum version**: Claude Code 2.1.7
- **Current version**: Check with `claude --version`
- **API requirement**: Beta header `anthropic-beta: tool-search-2025-03-05` (automatically added by Claude Code)

### Source

- [Anthropic Engineering: Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)
- Evaluated and approved: 2026-01-24 (Score: 89/100)
- Integrated: 2026-02-06

---

## 1. Tool Classification (Simulated Deferred Loading)

Beyond MCP deferral, this provides guidance on tool prioritization to reduce cognitive load and improve selection accuracy.

### Core Tools (High Frequency - Always Consider First)
These tools handle 80%+ of tasks. Consider them first:

| Tool | Purpose | Token Cost |
|------|---------|------------|
| Read | Read file contents | Low |
| Edit | Modify existing files | Low |
| Write | Create new files | Low |
| Bash | Execute shell commands | Low |
| Grep | Search file contents | Low |
| Glob | Find files by pattern | Low |

### Specialized Tools (Medium Frequency - Consider When Relevant)
Use for specific task types:

| Tool | When to Use |
|------|-------------|
| Task (subagents) | Multi-step exploration, code review, testing |
| WebFetch | Fetching URL content |
| WebSearch | Current information lookup |
| TodoWrite | Multi-step task tracking |

### Deferred Tools (Low Frequency - Only When Explicitly Needed)
Only invoke when the task specifically requires them:

| Category | Tools | Trigger |
|----------|-------|---------|
| MCP: brave-search | brave_web_search, brave_local_search, etc. | Explicit search requests |
| MCP: exa | web_search_exa, deep_researcher, etc. | Research tasks, code context |
| MCP: playwright | browser_* | Browser automation |
| MCP: gemini | gemini-query, gemini-analyze-* | AI collaboration |
| Notebook | NotebookEdit | Jupyter notebook editing |
| Skill | Skill | Document generation (pdf, docx, etc.) |

### Tool Selection Decision Tree

```
Is this a file operation?
  └─ Read/view file → Read
  └─ Modify existing → Edit
  └─ Create new → Write
  └─ Find files → Glob
  └─ Search content → Grep

Is this a command execution?
  └─ Yes → Bash

Is this exploration/research?
  └─ Codebase exploration → Task (Explore agent)
  └─ Web research → Exa or Brave (see MCP selection)
  └─ Complex multi-step → Task (appropriate agent)

Is this a specialized task?
  └─ Only then consider MCP tools
```

## 2. Programmatic Tool Calling Patterns

Simulate programmatic orchestration using subagents to avoid context pollution.

### Pattern: Batch File Processing
Instead of reading 10 files individually (flooding context), use:

```
Task (Explore agent):
  "Find all files matching X and summarize their structure.
   Return only: file paths, key exports, dependencies."
```

### Pattern: Search Aggregation
Instead of running multiple greps that return full content:

```
Task (general-purpose agent):
  "Search for pattern X across the codebase.
   Aggregate results and return:
   - Total occurrences
   - File distribution
   - Key examples (max 5)"
```

### Pattern: Data Transformation Pipeline
For tasks requiring multiple dependent operations:

```
Task (feature-implementer agent):
  "1. Read the config files
   2. Extract the database settings
   3. Generate migration based on changes
   Return: Only the final migration script"
```

### Anti-Pattern: Context Pollution
AVOID this pattern:
```
Read file1.ts → full content enters context
Read file2.ts → full content enters context
Read file3.ts → full content enters context
...
Grep for X → all matches enter context
```

PREFER this pattern:
```
Task agent: "Read files 1-10, extract function signatures only"
→ Returns compact summary
```

## 3. When to Use Each Pattern

### Use Core Tools Directly When:
- Single file read/edit
- Simple grep (expecting <20 results)
- Known file path operations
- Quick bash commands

### Use Subagent Orchestration When:
- Processing >5 files
- Aggregating search results
- Multi-step workflows
- Need only summary, not raw data
- Context is approaching limits

### Use MCP Tools When:
- Task explicitly requires web search
- Browser automation needed
- External API integration
- AI collaboration (Gemini)

## 4. Strategic Context Chunking Patterns

Evidence-based context management patterns from production Claude Code usage.

Based on: https://claudefa.st/blog/guide/mechanics/context-management (Claude Fast, Jan 2026)

### Core Rules

**80% Rule**: Exit sessions at 80% context usage before degradation becomes noticeable.

**20% Reserve**: Avoid using final 20% of context for multi-section work to protect project awareness.

**Component-Based Workflow**:
- Build complete components in isolated sessions before integration
- Finish research phases separately from implementation
- Create checkpoint documentation between sessions

### Task Categorization by Context Efficiency

**Memory-Intensive** (degrade first):
- Large refactors spanning many files
- Multi-component features
- Complex debugging with deep call stacks
- Architectural code reviews

**Context-Efficient**:
- Single-file edits
- Utility creation
- Documentation writing
- Localized bug fixes

### Natural Breakpoints

Divide work into context-sized chunks with clear completion points:

- After completing a feature component
- After successful test runs
- After architectural decisions documented
- Before switching between unrelated tasks

### Supporting Features

**`/compact` command**: Summarizes session memory while preserving critical info (see Compact with Instructions in `~/.claude/CLAUDE.md`)

**CLAUDE.md files**: "Free context that survives restarts" - use for project conventions, architecture notes, common patterns

**Session Memory** includes:
- Session title
- Completed work summary
- Key results and decisions
- Discussion points
- Work log

### Practical Guidelines

**When to start new session**:
- Context usage >80% (check status bar)
- Switching between memory-intensive tasks
- After completing natural breakpoints (tests pass, feature done)
- Before multi-section work that needs full context

**When to continue current session**:
- Context-efficient tasks (single file, docs, utilities)
- Sequential work on same component
- Context usage <60%
- Simple fixes and tweaks

### Integration with Existing Patterns

This complements:
- **Compact with Instructions** (`~/.claude/CLAUDE.md`) - Preserves critical info during compaction
- **Fan-Out Scaling** - Three-phase pattern for scaling changes
- **batch-orchestrator** - Processes many files without context pollution

---

## 5. Evidence-Based File Organization for Agentic Systems

Research-backed principles for organizing context files (CLAUDE.md, skill files, documentation).

Based on: [Structured Context Engineering for File-Native Agentic Systems](https://arxiv.org/abs/2602.05447)

### Format Selection: Familiarity Over Performance

**Key Finding**: Format choice (YAML vs Markdown vs JSON) has NO statistically significant impact on model performance (p=0.484).

**Implication**: Choose formats based on:
- Team familiarity and readability
- Existing tooling and workflows
- Human maintenance burden

**Don't waste time** optimizing format selection—the model performs equally well with any structured format.

### Compact Formats Are Counterproductive at Scale

**Key Finding**: Compact formats (JSON, YAML) consume MORE tokens than verbose formats (Markdown) in large-scale systems due to search inefficiencies.

**Why**: Models must scan more compact entries to find relevant information, outweighing the per-file token savings.

**Best Practice**: Use Markdown for large knowledge bases and documentation systems. Verbosity improves search efficiency.

### Domain-Partitioned Organization Outperforms Size-Based Splitting

**Key Finding**: Organizing files by domain/topic outperforms organizing by size or arbitrary splits.

**Example**:
- ✅ GOOD: `skills/git-workflow/`, `skills/testing/`, `skills/deployment/`
- ❌ BAD: `skills/part1.md`, `skills/part2.md`, `skills/misc.md`

**Why**: Semantic clustering allows models to quickly identify relevant context without scanning unrelated domains.

**Best Practice**:
- Group related concepts together even if files become large
- Use domain boundaries (features, components, workflows) as natural splits
- Avoid arbitrary size-based chunking

### File-Based Retrieval: Model-Aware Architecture

**Key Finding**: File-based retrieval improves accuracy for frontier models (+2.7%) but degrades accuracy for open-source models (-7.7%).

**Implication**: If using Claude Code (frontier model), file-based organization is beneficial. Structure matters.

**Best Practice**:
- For Claude/GPT-4: Embrace file-based organization with semantic partitioning
- For smaller models: Consider consolidation strategies
- Don't assume universal best practices—architecture should match model capabilities

### Practical Recommendations

| Scenario | Recommendation | Evidence |
|----------|----------------|----------|
| Choosing file format | Use team's preferred format (Markdown, YAML, JSON) | No performance difference |
| Large documentation sets | Prefer verbose Markdown over compact JSON | Compact formats cost more at scale |
| Organizing skill files | Group by domain/feature, not by size | Domain-partitioning outperforms size-based |
| Multi-file knowledge bases | Leverage file boundaries for semantic clustering | +2.7% accuracy with frontier models |
| Optimizing existing docs | Don't reformat—focus on organization instead | Format is statistically neutral |

### What This Validates

This research provides empirical backing for existing Claude Code patterns:
- ✅ Markdown-based CLAUDE.md and skill files (format-agnostic principle)
- ✅ Domain-organized skill structure (`~/.claude/skills/[topic]/`)
- ✅ File-based organization over monolithic configs (model-aware architecture)

**Bottom line**: Trust your intuition on readability. The model will adapt to whatever format is most maintainable for humans.

---

## Efficiency Metrics

Applying these patterns can achieve:
- 37% reduction in token consumption on complex tasks (Anthropic)
- 85% context savings with deferred tool patterns (Anthropic)
- Improved accuracy: 79.5% → 88.1% on tool selection (Anthropic)
- +2.7% accuracy with domain-partitioned file organization (ArXiv 2602.05447)

---

## Quick Reference Card

```
FILE OPS     → Read, Edit, Write, Glob, Grep
EXPLORATION  → Task (Explore)
RESEARCH     → Task (general-purpose) or Exa
BATCH WORK   → Task (appropriate agent)
WEB CONTENT  → WebFetch (single URL) or brave/exa (search)
AUTOMATION   → playwright MCP
TRACKING     → TodoWrite

CONTEXT MGMT → Exit at 80%, reserve 20%, component isolation
```
