# Public Reference Configuration

Sanitized public agents and skills from the Claude Evolution system, suitable for sharing and reuse.

## Contents

### Agents (21)

General-purpose subagents for common development tasks:

**Code Quality & Review:**
- `code-reviewer.md` - Code quality, security, best practices
- `refactoring-advisor.md` - Code improvement strategies
- `performance-analyzer.md` - Bottleneck identification
- `security-auditor.md` - Vulnerability scanning

**Development:**
- `feature-implementer.md` - End-to-end feature implementation
- `test-writer.md` - Comprehensive test suite creator
- `debugger.md` - Root cause analysis, fixing errors
- `api-designer.md` - REST/GraphQL API design
- `docs-updater.md` - Keep documentation in sync
- `pr-preparer.md` - PR description and quality checks

**Testing & QA:**
- `browser-tester.md` - Browser automation testing
- `adversarial-explorer.md` - Edge case exploration

**Research & Search:**
- `web-researcher.md` - Multi-source web research
- `brave-mcp-researcher.md` - Brave search integration
- `exa-mcp-researcher.md` - Exa semantic search
- `parallel-search-mcp-researcher.md` - Parallel search across sources
- `codex-researcher.md` - GPT-5 alternative AI research
- `codex-coder.md` - GPT-5.2-Codex code generation

**Orchestration:**
- `batch-orchestrator.md` - Process many files without context pollution
- `model-router.md` - Route tasks to appropriate models
- `gemini-frontend.md` - Gemini 3 Pro integration

### Skills (12)

Reusable workflow patterns and tools:

**Tool Efficiency:**
- `advanced-tool-use/` - Anthropic's advanced tool use patterns
- `mcp-search-framework/` - Decision tree for Brave vs Exa vs Codex
- `mgrep-guide/` - Semantic search with mgrep

**Project Management:**
- `plan-tracker/` - Ensure plans are executed to completion
- `note-taker/` - Memory management and note-taking
- `fan-out-scaling/` - Three-phase pattern for scaling changes
- `self-healing-pipeline/` - Autonomous error recovery
- `skill-auditor/` - Skill validation and improvement

**Integration:**
- `browser-mcp-setup/` - Browser automation MCP management
- `source-aggregation/` - RSS feeds for capability discovery
- `youtube-transcriber/` - Transcribe YouTube videos with Gemini
- `genealogy-toolkit/` - Family history research tools

## Usage

### For New Projects

Copy the entire `reference-config/` directory to your project:

```bash
cp -r reference-config/ ~/.claude/
```

Then customize paths in sanitized files:
- Replace `~/your-project` with your actual project path
- Update MCP server paths if different
- Customize skill parameters for your workflow

### For Existing Projects

Copy individual agents or skills as needed:

```bash
# Add a specific agent
cp reference-config/agents/code-reviewer.md ~/.claude/agents/

# Add a specific skill
cp -r reference-config/skills/advanced-tool-use ~/.claude/skills/
```

## Sanitization

All files are sanitized: private user paths use `~`, project-specific
references are generalized, and private agent names are removed.

Customize `~/your-project` references to match your actual project path.

## Contributing Back

If you improve these agents or skills, consider contributing sanitized versions back to the community.

## License

These configurations are derived from the Claude Evolution system. Use freely, modify as needed.

---

**Created:** 2026-02-16
**Source:** claude-evolution private configuration
**Sanitized:** All private paths and references removed
