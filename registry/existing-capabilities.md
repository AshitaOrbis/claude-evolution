# Existing Capabilities Registry

> **Purpose**: Check against this BEFORE researching any discovery to catch redundancy early.
> **Last Updated**: 2026-08-02 (66 integrations: weekly /insights pass — 0 integrated directly (approval-gated); 1 skill improvement routed to pending-approval (binding-inputs ratification gate for fable-research-pipeline, 78.25); 1 deferred (commit-scope staged-file guard 64.0 — fold into the publish-guard hook if the allow-list ruling approves it); 14 duplicates. Cron /insights generation failed a 4th consecutive week on the unapproved variadic --mcp-config fix (proposal 20260719, pending since 07-20); recovered in-run again by equals-form generation of a fresh Account-B report (07-01→08-02; window overlaps last week's — window control is inside the pending fix). Prior: 1-proposal pass on 2026-07-26)

## How to Use This Document

### Step 1: Check for Match
Search this document for the discovery's keywords and redundancy triggers.

### Step 2: Classify the Match

| Match Type | Definition | Action |
|------------|------------|--------|
| **NOVEL** | No existing capability matches | Proceed to full evaluation |
| **DUPLICATE** | Same functionality, no advantage | SKIP immediately |
| **IMPROVEMENT** | Better than existing capability | Proceed to COMPARISON evaluation |

### Step 3: For IMPROVEMENTS - Compare Explicitly

If discovery appears to improve an existing capability:

```
┌─────────────────────────────────────────────────────────────────┐
│                    IMPROVEMENT COMPARISON                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Document BOTH options side-by-side:                         │
│     - Existing: [name, implementation, limitations]             │
│     - New: [name, source, claimed improvements]                 │
│                                                                  │
│  2. Score BOTH on same criteria:                                │
│     - Token efficiency                                          │
│     - Ease of use (manual vs automatic)                         │
│     - Maintenance burden                                        │
│     - Community support                                         │
│                                                                  │
│  3. Consider migration cost:                                    │
│     - Effort to switch                                          │
│     - Risk of breaking existing workflows                       │
│     - Backward compatibility                                    │
│                                                                  │
│  4. Decision:                                                   │
│     - New wins clearly → Replace existing, update registry      │
│     - Existing wins → Reject new, document why                  │
│     - Tie → Keep existing (avoid churn)                         │
│     - Complementary → Keep both if no conflict                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Improvement Indicators (proceed with comparison)

- **Automatic vs manual**: e.g., Tool Search Tool (automatic) vs defer_loading (manual)
- **Better metrics**: measurably better token efficiency, speed, accuracy
- **Official vs community**: Anthropic official replacing community workaround
- **More features**: same complexity but more capabilities
- **Better maintained**: more stars, recent updates, active development

### Duplicate Indicators (skip immediately)

- Same functionality with no measurable advantage
- Different name for what we already have
- Subset of existing capability
- Abandoned/unmaintained alternative to active tool

---

## Token Efficiency Features

### Tool Loading Optimization

| Capability | Status | Implementation |
|------------|--------|----------------|
| Tool Search Tool | **IMPLEMENTED** | Claude Code 2.1.7+ (client-side automatic), API beta with header |
| MCP defer_loading | **IMPLEMENTED** | `~/.claude.json` - `defer_loading: true` (fallback/manual control) |
| disabledMcpjsonServers | **IMPLEMENTED** | `~/.claude/settings.json` |
| Tool Classification | **DOCUMENTED** | `~/.claude/skills/advanced-tool-use/SKILL.md` |
| CLAUDE_CODE_SIMPLE | **IMPLEMENTED** | `export CLAUDE_CODE_SIMPLE=1` (env var, Claude Code 2.1.48+) — restricts session to Read/Edit/Glob/Grep+Bash AND disables MCP tools, attachments, hooks, and CLAUDE.md loading (Feb 2026 scope expansion) |
| Rules Directory (`paths:` frontmatter) | **IMPLEMENTED** | `.claude/rules/*.md` with optional `paths:` glob frontmatter for conditional loading (v2.1.69+ fixed). Rules load only when editing matching files. |
| Claude Code Auto Mode | **RESEARCH_PREVIEW** | `permissions.defaultMode: "auto"` in `~/.claude/settings.json` — Risk-based autonomous operation approval (v2.1.76+). **Now available to Max subscribers using Opus 4.7** (previously Teams/Enterprise only). Companion: `/less-permission-prompts` (v2.1.111) scans session transcripts and proposes full allowlist in one pass — automates the manual allow-rule-by-rule setup. **v2.1.104 behavior**: blocked tool calls now surface explicit approval UI rather than silently failing; in headless `-p` mode, blocked tools terminate the process (not stall). |
| `--bare` flag | **IMPLEMENTED (v2.1.81)** | `claude -p --bare "..."` — Skips hooks/LSP/skills/memory/auth overhead; retains full native + MCP tools. Requires `ANTHROPIC_API_KEY` (Max plan keychain bypassed). Complements `CLAUDE_CODE_SIMPLE` (which restricts tools; `--bare` keeps full tools). |
| MCP Tool Description Cap (2KB) | **ACTIVE (v2.1.84)** | Automatic protocol-layer cap: MCP tool descriptions and server-level instruction text truncated at 2KB per tool/server. No configuration needed. Prevents OpenAPI-generated MCPs from bloating context. |
| `CLAUDE_CODE_NO_FLICKER=1` | **ACTIVE (v2.1.88+)** | Flicker-free alt-screen rendering with virtualized scrollback. Addresses display artifacts in terminals with limited alt-screen support — particularly tmux panes. Add to `~/.bashrc`. No performance cost. **v2.1.97**: `Ctrl+O` toggled Focus View. **v2.1.110 change**: Focus View moved to `/focus`; `Ctrl+O` now toggles normal/verbose transcript verbosity instead. |
| `/tui` command + `tui` settings key | **ACTIVE (v2.1.110)** | In-session rendering mode switch — `/tui fullscreen` or `/tui normal` toggles alt-screen rendering live without restarting. Complements `CLAUDE_CODE_NO_FLICKER=1` (permanent default via bashrc); `/tui` covers Remote Control sessions and any session started without the env var. `tui` settings key in `~/.claude/settings.json` persists preference without env var. Companion: `autoScrollEnabled` config disables auto-scroll in fullscreen mode. |
| `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` | **ACTIVE (v2.1.88+)** | Strips Anthropic and cloud-provider credentials from subprocess environments (bash/hooks/MCP stdio). Prevents credential leakage into untrusted child processes. In `~/.bashrc`. Zero maintenance, zero performance cost. **v2.1.98 addition**: Also applies PID namespace isolation on Linux — subprocesses can't see or signal host processes. |
| `CLAUDE_CODE_SCRIPT_CAPS` | **ACTIVE (v2.1.98)** | Per-session script invocation cap. Set `export CLAUDE_CODE_SCRIPT_CAPS=50` to limit Bash tool calls per session. Third layer of subprocess sandboxing trilogy (env-scrub + PID namespace + invocation cap). Drop-in addition to `~/.bashrc` for cost-sensitive heartbeat/cron runs. |
| `--exclude-dynamic-system-prompt-sections` | **ACTIVE (v2.1.97)** | `claude -p` flag that excludes dynamic system prompt sections from the prompt cache key. Allows static CLAUDE.md prefix to cache across runs that differ only in dynamic sections (e.g., rotating `currentDate`). Add to heartbeat invocations — see `helpers/commands/heartbeat-commands.md`. |
| `ENABLE_PROMPT_CACHING_1H` | **ACTIVE (v2.1.108)** | Explicitly pins prompt cache TTL to 1 hour for all Claude Code sessions. Fixes silent bug where `DISABLE_TELEMETRY` users got 5-min TTL instead of 1hr. Companion debug var: `FORCE_PROMPT_CACHING_5M=1` forces 5-min TTL for testing cache expiry. Add to `~/.bashrc` — requires approval gate (proposal in `pipeline/pending-approval/enable-prompt-caching-1h.proposal.json`). |
| `MCP_CONNECTION_NONBLOCKING=true` | **ACTIVE (v2.1.89+)** | Skips waiting for MCP server connections in `-p` mode. Solves heartbeat stall when MCP servers are slow to respond. Option C: rely on automatic 5s cap (no env var). Add to `~/.bashrc` or cron env for explicit guarantee. |
| `disableSkillShellExecution` | **ACTIVE (v2.1.91+)** | Settings key that disables inline shell execution within skills, slash commands, and plugin commands. Narrower than `CLAUDE_CODE_SIMPLE` (which restricts all native tools) — targets only SKILL.md shell blocks. Use for CI/CD sandboxing or untrusted plugin containment. No current workflow change — skill shell execution is intentional. |
| MCP Tool Result Size Override (`maxResultSizeChars`) | **ACTIVE (v2.1.91+)** | MCP servers annotate individual tool results with `_meta["anthropic/maxResultSizeChars"]` (up to 500,000 chars) to raise the per-result payload limit. Prevents silent truncation of large MCP responses. Client-side is automatic. Server-side: add `_meta` field. Action item: PR against agent-event-bus for schema-returning tools. |

**Tool Search Tool Details**:
- **Announced**: Nov 24, 2025 (API beta), Jan 2026 (Claude Code 2.1.7)
- **Integrated**: Feb 6, 2026 (documentation finalized, score 89/100)
- **How it works**: Automatically detects when MCP tools would use >10% of context and switches to dynamic loading via search
- **Variants**: Regex (`tool_search_tool_regex_20251119`) and BM25 (`tool_search_tool_bm25_20251119`)
- **Scale**: Supports up to 10,000 tools in catalog
- **Token savings**: 85% reduction (77k → 8.7k tokens with 50+ tools, verified)
- **API access**: Requires beta header `anthropic-beta: tool-search-2025-03-05`
- **Client-side**: Automatic in Claude Code 2.1.7+ (no configuration needed)
- **Accuracy improvement**: 79.5% → 88.1% on tool selection benchmarks

**`CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` Details** (v2.1.88+, 2026-04-02; PID namespace added v2.1.98):
- **Purpose**: Strips Anthropic and cloud-provider credentials from subprocess environments before forking bash/hook/MCP stdio processes
- **Scope**: Prevents leakage of `ANTHROPIC_API_KEY`, AWS/GCP/Azure tokens, and similar secrets into child processes that may be less trusted
- **v2.1.98 addition**: When this env var is set on Linux, Claude Code now additionally isolates subprocesses in a PID namespace — forked processes cannot see or signal processes outside their sandbox. Automatic, no config change needed. Already active on requiem as of v2.1.98.
- **Implementation**: `export CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` in `~/.bashrc`; already active on requiem
- **Complementary to**: CLAUDE_CODE_NO_FLICKER (rendering), MCP_CONNECTION_NONBLOCKING (startup speed), CLAUDE_CODE_SCRIPT_CAPS (invocation cap)

**`MCP_CONNECTION_NONBLOCKING=true` Details** (v2.1.89+, 2026-04-02):
- **Purpose**: Prevents heartbeat stalls when MCP servers (event-bus, etc.) are slow to start or connect
- **Behavior**: In `-p` mode, skips waiting for MCP server connections; automatic 5s cap also active
- **Options**: A) `export MCP_CONNECTION_NONBLOCKING=true` globally, B) set per cron run, C) rely on auto 5s cap
- **Current setup**: Add to `~/.bashrc` — `export MCP_CONNECTION_NONBLOCKING=true   # v2.1.89 - prevents heartbeat stalls`
- **Note**: Verify interaction with event-bus MCP before relying on it for publish operations

**`disableSkillShellExecution` Details** (v2.1.91+, 2026-04-03):
- **Purpose**: Disables inline shell execution within skills, slash commands, and plugin commands only
- **Scope**: Narrower than `CLAUDE_CODE_SIMPLE` — targets SKILL.md shell blocks, not all native tools
- **Config**: `disableSkillShellExecution: true` in `~/.claude/settings.json` (exact namespace TBD — verify root vs permissions namespace empirically)
- **No current action**: Skill shell execution is intentional; document for CI/CD adoption trigger
- **Use cases**: CI/CD where SKILL.md shell blocks shouldn't run, untrusted marketplace plugin containment, read-only agent contexts

**MCP Tool Result Size Override (`maxResultSizeChars`) Details** (v2.1.91+, 2026-04-03):
- **Purpose**: Raises per-result payload limit from default to up to 500,000 characters for large MCP responses
- **Problem**: Without annotation, DB schema queries, deep research payloads, and event-bus stats are silently truncated
- **Client-side**: Claude Code automatically honors `_meta["anthropic/maxResultSizeChars"]` — no Claude Code config needed
- **Server-side**: MCP server must add `_meta["anthropic/maxResultSizeChars"] = 500000` to the tool result object
- **Action item**: File issue/PR against `agent-event-bus` to add annotation to schema-returning tools (`get_bus_stats`, `query_events`, `query_knowledge`)
- **Caution**: Raises per-call context usage — use only for schema-heavy tools, not routine small queries
- **Exa/Codex**: Third-party MCPs; monitor upstream adoption

**`CLAUDE_CODE_NO_FLICKER=1` Details** (v2.1.88, 2026-03-31; Ctrl+O Focus View added v2.1.97):
- **Purpose**: Flicker-free alt-screen rendering with virtualized scrollback
- **Scope**: Fixes display artifacts in terminals with limited alt-screen support (tmux panes, multiplexers)
- **Implementation**: `export CLAUDE_CODE_NO_FLICKER=1` in `~/.bashrc`; also add to workspace startup script if applicable
- **Performance**: No cost — pure rendering path change
- **Relevant setup**: Desktop (requiem) uses tmux-heavy session management; directly addresses display artifacts in `workspace` tmux script
- **v2.1.97 addition — Focus View**: Press `Ctrl+O` to toggle a distraction-free Focus View that shows only: current prompt, one-line tool summary with edit diffstats, and the final response. Intermediate tool output is hidden. Zero config — keybinding active whenever NO_FLICKER mode is on.

**Redundancy triggers**: "CLAUDE_CODE_NO_FLICKER", "flicker-free rendering", "tmux display artifacts", "alt-screen rendering", "virtualized scrollback", "terminal flicker", "tmux pane flicker", "display artifacts claude", "Focus View", "Ctrl+O focus", "distraction-free view", "tool summary view", "hide tool output", "/tui", "tui command", "tui settings key", "in-session rendering switch", "live rendering mode", "tui fullscreen", "tui normal"

**`CLAUDE_CODE_SCRIPT_CAPS` Details** (v2.1.98, 2026-04-09):
- **Purpose**: Caps the number of Bash tool script invocations per session to prevent runaway loops
- **Usage**: `export CLAUDE_CODE_SCRIPT_CAPS=50` — set in `~/.bashrc` or per-cron-job env
- **Trilogy**: Completes the subprocess sandboxing set: (1) `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` (credential scrub), (2) PID namespace isolation (v2.1.98 on Linux), (3) this invocation cap
- **Relevance**: Heartbeat/cron sessions where Bash loops could exhaust resources undetected. Does NOT restrict tool types (unlike CLAUDE_CODE_SIMPLE) — narrower, targeted cap.
- **Complementary distinction**: CLAUDE_CODE_SIMPLE restricts which tools are available; CLAUDE_CODE_SCRIPT_CAPS limits how many times Bash can fire regardless of other tool availability

**Redundancy triggers**: "CLAUDE_CODE_SCRIPT_CAPS", "script caps", "invocation limit", "bash invocation cap", "script invocation limit", "per-session script limit", "bash call limit", "runaway bash limit"

**`--exclude-dynamic-system-prompt-sections` Details** (v2.1.97, 2026-04-08):
- **Purpose**: Prevents rotating/dynamic system prompt sections (e.g., `currentDate` in CLAUDE.md) from invalidating the prompt cache key on every run
- **Usage**: `claude -p --exclude-dynamic-system-prompt-sections "your prompt"`
- **Problem it solves**: `currentDate` in CLAUDE.md changes daily → cache miss every heartbeat run → static prefix re-tokenized on every invocation. This flag separates dynamic sections from the cache key so the large static CLAUDE.md prefix stays cached.
- **Distinct from `--bare`**: `--bare` skips CLAUDE.md loading entirely; this flag keeps it but excludes dynamic parts from the cache hash
- **Action**: Added to heartbeat invocation templates in `helpers/commands/heartbeat-commands.md`. Validate empirically — compare cache hit rates before/after.

**Redundancy triggers**: "exclude dynamic system prompt", "exclude-dynamic-system-prompt-sections", "prompt cache miss daily", "CLAUDE.md cache key", "currentDate cache", "dynamic prompt caching", "static prefix cache", "prompt hash dynamic sections"

**Migration Note**: defer_loading remains useful as:
- Fallback for Claude Code <2.1.7
- Explicit control when Tool Search Tool not desired
- API users without beta header access

**Redundancy triggers**: "ENABLE_PROMPT_CACHING_1H", "prompt cache TTL control", "1 hour prompt cache", "FORCE_PROMPT_CACHING_5M", "cache TTL pin", "explicit cache TTL", "prompt cache guarantee", "OTEL_LOG_USER_PROMPTS", "OTEL_LOG_TOOL_DETAILS", "OTEL_LOG_TOOL_CONTENT", "OTEL_LOG_RAW_API_BODIES", "OTEL debugging", "api body logging", "opentelemetry claude", "debug prompt caching", "tool routing debug", "less-permission-prompts", "/less-permission-prompts", "allowlist builder", "permission allowlist automation", "transcript allowlist scan", "auto mode allowlist", "blocked tool calls explicit", "v2.1.104 permission", "blocked tool behavior", "headless blocked tool", "dynamic tool loading", "tool search", "semantic tool selection", "reduce tool context", "tool deferral", "lazy loading MCP", "on-demand tool loading", "--bare flag", "bare mode claude", "headless bare", "skip hooks scripted", "hook-free automation", "skip skill loading", "minimal startup claude -p", "claude -p bare", "CLAUDE_CODE_SUBPROCESS_ENV_SCRUB", "subprocess env scrub", "credential leakage subprocess", "strip credentials child process", "credential stripping flag", "MCP_CONNECTION_NONBLOCKING", "nonblocking MCP connection", "skip MCP wait", "MCP startup stall", "heartbeat MCP stall", "claude -p MCP timeout", "disableSkillShellExecution", "skill shell disable", "skill sandbox", "inline shell block", "SKILL.md shell execution", "plugin shell execution", "skill command sandbox", "maxResultSizeChars", "MCP result size", "tool result truncation", "large MCP response", "_meta annotation", "MCP payload limit override", "500K result", "MCP truncation"

**CLAUDE_CODE_SIMPLE Details**:
- **Introduced**: Claude Code v2.1.48 (Bash-only), expanded in v2.1.49 (Bash + file edit), v2.1.50+ (Read/Edit/Glob/Grep + Bash)
- **Feb 2026 scope expansion**: Mode now ALSO disables MCP tools, attachments, hooks, and CLAUDE.md loading — not just native tool restriction
- **Integrated**: 2026-02-25 (Score: 80/100)
- **Scope**: Session-wide tool restriction + MCP + hooks + CLAUDE.md loading disabled — maximum sandboxing via single env var
- **Use cases**: Cost-sensitive heartbeat runs, CI/CD pipelines, sandboxed agent testing, training data generation
- **Complementary control**: `disableSkillShellExecution` (v2.1.91) is narrower — only disables SKILL.md shell blocks, keeps full toolset
- **Documentation**: `~/.claude/skills/advanced-tool-use/SKILL.md` Section 0.25

**Redundancy triggers**: "CLAUDE_CODE_SIMPLE", "simple mode", "restrict tools", "minimal tool set", "bash only mode", "limited tools", "tool restriction env var", "sandboxed tool set"

**Rules Directory Details**:
- `.claude/rules/` directory for modular instruction files
- Rules with `paths:` frontmatter load only when editing matching files (glob patterns)
- Rules without `paths:` always load (like CLAUDE.md)
- v2.1.69 fixed conditional loading in `claude -p` print mode
- Token efficiency: reduces per-session context for irrelevant domain-specific rules
- Documentation: `~/.claude/skills/advanced-tool-use/SKILL.md` Section 0.75, `library/techniques/rules-directory-conditional-loading-2026-03-06.md`

**Redundancy triggers**: "rules directory", "conditional loading", "paths frontmatter", "modular instructions", "CLAUDE.md splitting", "file-pattern rules", "path-scoped rules", ".claude/rules"

**Claude Code Auto Mode Details**:
- **Introduced**: Claude Code v2.1.76+ (research preview)
- **Integrated**: 2026-03-15 (Score: 80.25/100)
- **Config**: `permissions.defaultMode: "auto"` in `~/.claude/settings.json`; also `skipAutoPermissionPrompt: true` to suppress opt-in dialog
- **Behavior**: Risk-based autonomous approval — low-risk operations auto-approve, high-risk surface for confirmation. Shift+Tab cycles mode per session.
- **Max plan expansion (v2.1.111/Opus 4.7)**: Auto Mode now available to Max subscribers using Opus 4.7. Previously restricted to Teams/Enterprise/API plans only.
- **`"$defaults"` sentinel (v2.1.118+)**: When customizing `autoMode.allow`, `autoMode.soft_deny`, or `autoMode.environment`, including the literal string `"$defaults"` as one entry merges your custom rules WITH Anthropic's built-in defaults. Without `"$defaults"`, custom entries REPLACE the built-in list — silent footgun. Always include `"$defaults"` at the top of any custom auto-mode list. Example: `"autoMode": { "allow": ["$defaults", "mcp__event-bus__publish_event"] }`. Score: 79.3/100 (registry-only, 2026-04-30).
- **Use case**: Long iterative loops (heartbeat, iterative-improve Phases 3-5) to prevent permission interruptions; complements hook allowlists
- **Security**: Prompt injection safeguards active per Anthropic docs; admin can lock to "normal" via `disableAutoMode: "disable"`
- **Re-evaluate when**: Stable release announced, `permissions.defaultMode` field name changes, or security issue reported

**`/less-permission-prompts` Skill (v2.1.111)**:
- **What it does**: Scans session transcripts and proposes a complete permission allowlist in one pass. Eliminates the friction of adding allow-rules one-by-one after encountering prompts.
- **Companion to**: Auto Mode — addresses the last adoption friction: knowing what rules to add
- **Built-in status**: Officially maintained by Anthropic; supersedes any manual process
- **Usage**: Run `/less-permission-prompts` during or after any session that had permission prompts
- **Score**: 75.0/100 (Integrated 2026-04-18)
- **Local skill check**: Check `~/.claude/skills/less-permission-prompts/` — if present, verify if built-in supersedes it (built-in has transcript analysis; local may have custom rule patterns)

**Blocked Tool Calls — Explicit Approval (v2.1.104)**:
- **Change**: Tool calls blocked by permission mode now surface an explicit approval UI instead of silently failing or bypassing
- **Headless mode behavior**: In `claude -p` (no UI), blocked tools **terminate the process** — not stall indefinitely. Safe for unattended cron runs.
- **Companion to**: Auto Mode — improves safety in auto-mode sessions by surfacing blocked calls rather than silently skipping
- **Source**: @ClaudeCodeLog/X + GitHub issue #47114
- **Score**: 70.25/100 (registry-only, 2026-04-18)

**OTEL Debugging Quartet**:
- **Four env vars** introduced across v2.1.101 and v2.1.111 forming a layered API observability system:
  | Variable | Version | Observability Layer |
  |----------|---------|---------------------|
  | `OTEL_LOG_USER_PROMPTS` | v2.1.101 | User prompt content |
  | `OTEL_LOG_TOOL_DETAILS` | v2.1.101 | Tool call decisions |
  | `OTEL_LOG_TOOL_CONTENT` | v2.1.101 | Tool result content |
  | `OTEL_LOG_RAW_API_BODIES` | v2.1.111 | Raw API request/response bodies |
- **Usage**: Set env vars before starting Claude Code session to enable each layer
- **Use cases**: Debug prompt caching failures, unexpected model behavior, tool routing issues during heartbeat development
- **For this setup**: `OTEL_LOG_USER_PROMPTS` + `OTEL_LOG_TOOL_DETAILS` sufficient for most debugging; `OTEL_LOG_RAW_API_BODIES` for deep API-level issues only
- **Score**: 70.5/100 (registry-only, 2026-04-18)

**Redundancy triggers**: "auto mode", "defaultMode auto", "autonomous permissions", "permission automation", "auto-approve operations", "permission fatigue", "autonomous approval mode", "risk-based permissions", "auto permission mode"

**MCP Tool Description Cap (2KB) Details**:
- **Introduced**: Claude Code v2.1.84 (2026-03-26)
- **Integrated**: 2026-03-26 (Score: 85/100)
- **Behavior**: Protocol-layer automatic truncation — MCP tool descriptions and server-level instruction text capped at 2KB per tool/server after tool loading/selection. No configuration required.
- **Use case**: Prevents OpenAPI-generated MCP servers from bloating context with verbose auto-generated docs (parameter schemas, response examples, exhaustive descriptions)
- **Orthogonal to**: Tool Search Tool (deferred loading), disabledMcpjsonServers (full exclusion), CLAUDE_CODE_SIMPLE (native tool restriction)

**Redundancy triggers**: "tool description truncation", "MCP description cap", "openapi mcp context bloat", "2KB limit MCP", "server instruction cap", "verbose MCP docs truncation", "MCP tool description limit"

### Context Management

| Capability | Status | Implementation |
|------------|--------|----------------|
| Nested CLAUDE.md Re-injection Deduplication | **ACTIVE (v2.1.89+)** | Automatic — nested CLAUDE.md files (project, subdirectory) no longer re-injected repeatedly in long sessions. Fix is passive; no configuration needed. Explains past context exhaustion in file-intensive long sessions. |
| 1M Token Context Window | **IMPLEMENTED (DEFAULT)** | Opus 4.6 GA — automatic on Max/Team/Enterprise, standard pricing ($5/$25/M), no surcharge >200k |
| Automatic Stale Tool Output Cleanup | **ACTIVE (verify version)** | Claude Code automatically clears stale tool call outputs from conversation history. Targets verbose tool results (file reads, bash output) that are no longer active context. Distinct from /compact (manual full-session summarization) — this is automatic and granular. Source: dev.to + releasebot.io (secondary — verify exact version against official changelog). |
| Programmatic Tool Calling | **IMPLEMENTED** | `batch-orchestrator` subagent |
| Context Isolation | **IMPLEMENTED** | All subagents use separate contexts |
| Subagent Delegation | **IMPLEMENTED** | Task tool with specialized agents |
| Multi-Agent Orchestration | **IMPLEMENTED** | Task tool + 15+ specialized subagents + evolution-orchestrator |
| Auto-Continuation on Token Limit | **ACTIVE (v2.1.90+)** | Claude Code automatically continues when output hits the token limit — no manual follow-up needed. Verify if applies to `claude -p` mode (confirm empirically). |
| SendMessage Auto-Resume | **ACTIVE** | v2.1.77+: `SendMessage({to: agentId})` automatically resumes a stopped agent in background (no longer errors on stopped agents) |
| Agent `resume` Parameter | **REMOVED** | v2.1.77 BREAKING CHANGE: `Agent(resume: sessionId)` is invalid — use `SendMessage({to: agentId})` instead |
| Autonomous Subagent Resume | **IMPLEMENTED (v2.1.81)** | Model-initiated: Claude autonomously decides to resume a previously spawned subagent vs spawn fresh. Subagents accumulate context across multiple orchestrator turns. No developer action required — model uses judgment. Worktree interaction: resumed agents in worktrees may have stale state if files changed between turns. |
| Background Agent Partial Result Preservation | **ACTIVE (v2.1.81+)** | When a background agent is killed/interrupted, completed work is preserved in conversation context. Distinct from Autonomous Subagent Resume (which resumes stopped agents) — this salvages partial output from forcibly killed agents. No configuration required, automatic behavior. |
| Agent Spawn Restrictions | **IMPLEMENTED** | `Task(agent_type)` frontmatter syntax (v2.1.33+), documented in `~/.claude/agents/INDEX.md` |
| Agent Teammate Hooks | **IMPLEMENTED (ACTIVATED 2026-05-01)** | TeammateIdle & TaskCompleted hook events (v2.1.33+). Now reachable since Agent Teams flag is on workspace-wide. |
| Agent Teams | **ACTIVATED FOR EVALUATION (2026-05-01)** | Research preview, flag set workspace-wide via `~/claudeworkspace/.envrc` (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`). Parallel autonomous agents with shared context. Token-intensive per Anthropic. Evaluation period: monitor token cost vs `dispatching-parallel-agents` baseline; revisit by 2026-06-01 to decide on permanent activation. Candidate skills: `iterative-improve`, `site-review`, `dispatching-parallel-agents`. Cross-model skills (`publication-review`, `methodology-review`, `codebase-review`) get partial benefit only — GPT/Gemini reviewers stay outside the team. |
| Agent Worktree Isolation | **IMPLEMENTED** | `isolation: worktree` frontmatter field (v2.1.68+). Declarative per-agent worktree isolation — auto-created at spawn, auto-cleaned on finish. Enables safe parallel agents without manual worktree management. Active in: `capability-discoverer`, `capability-evaluator`. |
| Recursive Agent Patterns | **REJECTED** | claude-code-mcp (23.5/100) - MCP wrapper designed for external clients, not internal use |
| Swarm Orchestration Platforms | **REJECTED** | Claude Flow (51.75/100) - External orchestration platform, 75% overlap with existing stack |

**1M Token Context Note**: As of 2026-03-13, 1M context is GA and automatic for Max/Team/Enterprise plans (no `[1m]` suffix needed). Standard pricing throughout — no long-context surcharge. Opus 4.6: $5/$25/M tokens at all context lengths. Media capacity expanded to 600 images/PDF pages. Disable with `CLAUDE_CODE_DISABLE_1M_CONTEXT=1` if needed. Subagent delegation remains valuable for cost management but is less critical for context isolation.

**Recursive MCP Patterns (claude-code-mcp)**: Evaluated and rejected 23.5/100 (2026-01-26). MCP wrapper of Claude Code CLI designed for EXTERNAL clients (Cursor, Windsurf, ChatGPT). Using FROM WITHIN Claude Code creates pointless recursive loop (Claude Code → MCP → Claude Code CLI spawn). Task tool provides agent-in-agent natively with zero overhead and no permission bypass risk.

**Swarm Orchestration Platforms (Claude Flow)**: Evaluated and rejected 51.75/100 (2026-01-26). Community platform (13k stars) with queen-led hierarchy, consensus algorithms, 87 MCP tools. Excellent for EXTERNAL orchestration (coordinating multiple Claude instances), but poor fit as internal MCP: 75% functional overlap with evolution-orchestrator + Task tool + batch-orchestrator, 10-15k token overhead incompatible with Tool Search Tool optimization (94% reduction). Novel features (consensus, HNSW memory) don't justify redundancy. Better deployed externally than as internal MCP. Full evaluation: `pipeline/evaluation/completed/claude-flow-evaluation.md`

**Agent Spawn Restrictions**: Control agent hierarchy security via frontmatter. Prevents privilege escalation, limits blast radius, enforces least-privilege. Use `tools: [Read, Task(code-reviewer)]` to allow only specific subagents. Official feature in v2.1.33+.

**Agent Teammate Hooks**: Hook events for multi-agent coordination (TeammateIdle, TaskCompleted). Enables load balancing, sequential workflows, monitoring. REQUIRES Agent Teams experimental feature. Use cases: detect idle teammates for work assignment, chain tasks on completion. Official v2.1.33+. Status: CONDITIONAL - only activate if Agent Teams proves valuable.

**Agent Teams**: Research preview feature enabling multiple Claude agents to work in parallel with autonomous coordination. Agents share context and self-organize. Best for read-heavy parallel work (codebase reviews, multi-file analysis). Token-intensive per Anthropic documentation. Trade-offs: autonomous coordination (pro) vs higher token cost + less control (cons). Use Task tool for explicit control and cost-sensitive workflows. Official v2.1.32+ with Opus 4.6. Status: CONDITIONAL - only activate with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` if workflow benefits from autonomous multi-agent coordination. Evaluation score: 78/100 (approved).

**Agent Worktree Isolation** (v2.1.68, 2026-03-06): Declarative per-agent worktree isolation via `isolation: worktree` frontmatter. When set, the agent always runs in its own git worktree — auto-created at spawn, auto-cleaned on completion without changes. Enables safe parallel agent runs without manual `git worktree` commands or explicit WorktreeCreate/Remove hook management. Distinct from: (1) `using-git-worktrees` skill (manual workflow), (2) WorktreeCreate/Remove hooks (lifecycle events). Add to any agent that benefits from isolation. Active in: `capability-discoverer`, `capability-evaluator`. Codex caveat: edge cases in shallow-clone CI environments — test before relying on cleanup guarantee in CI. Evaluation score: 87/100.

**Fan-Out Scaling Workflow** (2026-02-06): Three-phase pattern for scaling changes across many files - sample selection, prompt tuning on 2-3 representative files, then scaled deployment. Complementary to batch-orchestrator. Source: smartscope.blog best practices. Skill: `~/.claude/skills/fan-out-scaling/SKILL.md`

**Structured Context Engineering** (2026-02-10): Empirical research on file organization for agentic systems. Key findings: (1) Format choice (YAML/Markdown/JSON) has NO performance impact (p=0.484)—prioritize human readability. (2) Compact formats consume MORE tokens at scale due to search inefficiencies. (3) Domain-partitioned organization outperforms size-based splitting. (4) File-based retrieval improves accuracy +2.7% for frontier models but -7.7% for open-source models. Validates existing Claude Code patterns (Markdown skills, domain organization). Source: [ArXiv 2602.05447](https://arxiv.org/abs/2602.05447). Integrated: `~/.claude/skills/advanced-tool-use/SKILL.md` § Evidence-Based File Organization, `~/.claude/CLAUDE.md` CLAUDE.md Best Practices.

**Cloudflare Code Mode Pattern** (2026-02-24): Token-efficient API representation technique. Represents full API surface as structured operation schema (~1K tokens) instead of prose documentation (5K–20K tokens) — ~80% token reduction per API. Enables multiple APIs simultaneously without context overflow. Official Cloudflare engineering blog, package: `@cloudflare/mcp-server-cloudflare`. Portable pattern applicable to any API-backed MCP server (GitHub, AWS, Stripe). Documented: `library/techniques/cloudflare-code-mode-pattern.md`. Score: 78.9/100. MCP server deferred — add to workspace `.mcp.json` when active Cloudflare deployments exist.

**Nested CLAUDE.md Re-injection Deduplication** (v2.1.89+, 2026-04-05, Score: 77.5/100):
- **Change**: Nested CLAUDE.md files (subdirectory-level, project-level) no longer re-injected on each tool use in long sessions
- **Before**: Each CLAUDE.md re-injected "dozens of times" in file-intensive sessions — silent context bloat; explains past context exhaustion on long monorepo runs
- **This workspace**: 3 nested CLAUDE.md files (`~/.claude/`, `~/claudeworkspace/`, `~/claudeworkspace/claude-evolution/`) — all affected by the prior behavior
- **Implementation**: Passive, automatic in v2.1.89+. Already active (currently running v2.1.92). No config change needed.
- **Adjacent fix (v2.1.90)**: Separate issue — collapsed search/read summary badge appearing multiple times (UI artifact, different root cause)
- **Source**: Official Anthropic changelog, confirmed 2026-04-05

**Redundancy triggers**: "CLAUDE.md re-injection", "nested CLAUDE.md dedup", "CLAUDE.md context bloat", "re-injected CLAUDE.md", "CLAUDE.md repeated injection", "nested config re-inject", "CLAUDE.md long session bloat", "CLAUDE.md monorepo context"

**Redundancy triggers**: "batch processing", "context pollution", "multi-file aggregation", "summarize results", "avoid context overflow", "agent orchestration platform", "multi-agent swarm", "workflow orchestrator", "hive-mind swarm", "swarm intelligence", "claude-flow", "queen-led swarm", "consensus algorithms", "distributed agent coordination", "ruv swarms", "claude-code-mcp", "MCP claude code wrapper", "nested claude code", "recursive agent invocation", "claude code as tool", "agent security", "agent restrictions", "limit subagent spawning", "agent privilege control", "agent least-privilege", "prevent agent recursion", "teammate idle", "task completed hook", "multi-agent hooks", "agent coordination events", "teammate lifecycle", "agent teams", "parallel agents", "autonomous agent coordination", "shared context agents", "multi-agent collaboration", "parallel autonomous work", "fan-out scaling", "prompt tuning at scale", "sample then deploy", "batch file transformation", "file organization", "context file format", "YAML vs Markdown", "documentation structure", "semantic partitioning", "domain-based organization", "file-based retrieval", "structured context", "agentic file organization", "code mode", "cloudflare mcp", "API token compression", "token-efficient API surface", "API schema compression", "structured API schema", "MCP token efficiency", "compact API representation", "agent worktree isolation", "isolation: worktree", "declarative worktree", "agent isolation frontmatter", "per-agent worktree", "worktree agent field", "automatic worktree cleanup", "Agent resume parameter", "agent continuation", "resume stopped agent", "SendMessage resume", "agent restart", "auto-resume agent", "stopped agent continuation", "sendmessage auto-resume", "autonomous subagent resume", "model-initiated resume", "stateful subagent", "subagent context accumulation", "agent state persistence across turns", "background agent killed", "partial agent results", "interrupted agent", "checkpoint recovery", "agent work preserved", "salvage agent output", "killed agent output", "stale tool output", "automatic context cleanup", "tool output cleanup", "auto clear tool results", "stale tool results removed", "granular context pruning", "tool output expiry"

---

## Reasoning & Thinking

| Capability | Status | Implementation |
|------------|--------|----------------|
| Extended Thinking | **BUILT-IN** | "think" / "think harder" prompts |
| Adaptive Thinking | **BUILT-IN** | Opus 4.6 auto-calibrates thinking depth based on context clues |
| Effort Controls (API) | **AVAILABLE** | `effort` parameter: low/medium/high/xhigh/max — for programmatic/heartbeat invocations. **v2.1.94**: default raised Medium→High for API/Bedrock/Team/Enterprise users (Max plan unaffected at that time). **v2.1.117**: default raised to `high` for Pro/Max subscribers on Opus 4.6 and Sonnet 4.6 — add `--effort medium` to cost-sensitive heartbeat/cron invocations. |
| Effort Controls (/effort command) | **BUILT-IN (v2.1.76+)** | `/effort` in prompt box — cycles effort level for session; current level shown in spinner |
| ultrathink keyword | **BUILT-IN (v2.1.76+)** | Include `ultrathink` in prompt — bumps effort to Max for that turn only, then reverts to session default |
| Effort Controls (frontmatter) | **AVAILABLE (v2.1.78+)** | `effort:` field in agent/skill definitions — static per-agent default; extended to skills/commands in v2.1.80 |
| Plan Mode | **BUILT-IN** | EnterPlanMode tool |
| `/plan` inline description | **BUILT-IN (v2.1.87+)** | `/plan <description>` enters plan mode with context in one step — no separate description message needed |
| `/ultraplan` | **ACTIVE (v2.1.91+, research preview)** | Hands planning task to cloud session, freeing terminal. Browser review with inline section comments. Two paths: execute on web (→ PR) or teleport plan back to local terminal. Triggers: `/ultraplan` command, "ultraplan" keyword in prompt, or "Refine with Ultraplan" when declining local plan. Requires claude.ai account + GitHub repo. |
| Step-by-step Reasoning | **BUILT-IN** | Native Claude capability |
| `showThinkingSummaries` Setting | **DEFAULT-OFF (v2.1.88+)** | Thinking summaries disabled by default in `settings.json`. Previously auto-shown. Re-enable with `showThinkingSummaries: true` only if scripts parse thinking output. Reduces noise in headless runs. |

**Adaptive Thinking Note** (Opus 4.6): Model automatically decides how much extended thinking to use based on task complexity. Works alongside manual "think harder" prompts. No configuration needed.

**Default Effort Level Change** (v2.1.94, 2026-04-07):
- Default effort for API-key, Bedrock/Vertex/Foundry, Team, and Enterprise users raised from Medium to High
- **Max plan users unaffected at that time** — already had higher defaults; no workflow change needed here
- Documentation value: future sessions sharing agent configs with non-Max users should note this. A config that relies on "default effort" will now behave differently for API-key users.

**v2.1.117 Correction — Max/Pro Plan Default Raised** (2026-04-22):
- Default effort for Pro and Max subscribers raised from Medium to High for Opus 4.6 and Sonnet 4.6
- **Action**: Add `--effort medium` to heartbeat and cron `claude -p` invocations to maintain prior cost profile
- **Verify**: Run `claude -p --print-config | grep effort` to confirm current default
- **See**: `helpers/commands/heartbeat-commands.md` for updated heartbeat invocation patterns

**Effort Controls — Three Interfaces** (v2.1.76+):

1. **API parameter**: `effort: low/medium/high/max` — for programmatic invocations (heartbeat, `claude -p`)
2. **`/effort` slash command** (v2.1.76+): Interactive session-wide control; cycle with `/effort` in prompt; current level visible in spinner; works even while Claude is responding
3. **`ultrathink` keyword** (v2.1.76+): Per-turn Max effort override; include "ultrathink" in prompt for one high-effort response, then reverts to session default
4. **Frontmatter** (v2.1.78+, extended to skills in v2.1.80): Static `effort:` field in agent/skill definitions for consistent per-agent defaults

**Token efficiency note**: Use `low` effort for discovery/routing phases; save `high`/`max` for planning and evaluation. `ultrathink` avoids paying Max-effort cost for an entire session when one complex step needs it.

**`showThinkingSummaries` Details** (v2.1.88+, 2026-04-02):
- **Change**: Thinking summaries are now default-off; previously shown automatically
- **Impact**: Reduces noise in headless `-p` pipeline runs; less clutter in interactive sessions
- **Re-enable**: Set `showThinkingSummaries: true` in `~/.claude/settings.json` only if your scripts parse thinking summary output
- **Note**: This only affects thinking *summaries* shown to users — extended thinking itself is unaffected

**`/plan` Inline Description** (v2.1.87+, 2026-04-02):
- **Usage**: `/plan Build auth middleware` enters plan mode with that description already set
- **Before**: Required two steps: `/plan`, then write description
- **Now**: One step: `/plan <description>` 
- **Redundancy triggers**: "/plan inline", "plan with description", "/plan one step"

**`/ultraplan` — Cloud-Based Interactive Planning** (v2.1.91+, research preview, documented in v2.1.111 changelog):
- **Trigger methods**: (1) `/ultraplan` command, (2) include "ultraplan" in any prompt, (3) "Refine with Ultraplan" when declining a local plan
- **Cloud off-loading**: Drafts in cloud web session → terminal stays free during planning
- **Browser review features**: Inline section-level comments, emoji reactions, iterative refinement with Claude in browser
- **Two execution paths**: Path A → execute on web and open PR; Path B → "teleport" approved plan back to local terminal
- **Token efficiency benefit**: Off-loads planning work to cloud context, preserving local session budget for implementation
- **Requirements**: claude.ai account + GitHub repo. Not on Bedrock/Vertex/Foundry.
- **vs local plan mode**: Local = terminal-only single-pass; /ultraplan = cloud-hosted with browser annotation, section comments, and two-way sync
- **Pending**: CLAUDE.md Plan Mode Quality section update in `pipeline/pending-approval/ultraplan-claude-md-note.proposal.md`
- **Score**: 81.25/100 (Integrated 2026-04-18)

**Redundancy triggers**: "chain of thought", "sequential thinking", "structured reasoning", "step by step", "extended reasoning", "sequential thinking MCP", "thought logging", "reasoning audit trail", "adaptive thinking", "effort controls", "thinking calibration", "ultrathink", "effort slash command", "/effort command", "per-turn effort", "effort keyword", "interactive effort control", "effort level cycling", "session effort level", "max effort turn", "showThinkingSummaries", "thinking summaries off", "thinking summary default", "disable thinking summaries", "thinking output config", "/plan description", "plan inline description", "plan mode shortcut", "default effort level", "medium to high effort default", "effort level raised", "effort default change", "v2.1.94 effort", "ultraplan", "/ultraplan", "cloud planning", "cloud plan mode", "interactive plan review", "plan teleport", "browser plan editing", "inline plan comments", "cloud-based planning", "remote plan mode", "plan section comments"

### Failure Recovery

| Capability | Status | Implementation |
|------------|--------|----------------|
| Two-Failure Reset Rule | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Two-Failure Reset Rule section |

**Two-Failure Reset Rule** (2026-02-06): Clear session after two consecutive failures on the same issue. Prevents context poisoning, reasoning loops, and wasted tokens. Source: smartscope.blog best practices.

**Redundancy triggers**: "context poisoning", "reasoning loops", "failure recovery", "session reset", "clear after failure", "two failure rule"

### Context Preservation

| Capability | Status | Implementation |
|------------|--------|----------------|
| Compact with Instructions | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Context Compaction Preservation section |

**Compact with Instructions** (2026-02-06): Guide auto-compaction to preserve critical information (schemas, API contracts, decisions) during context summarization. Source: smartscope.blog best practices.

**Redundancy triggers**: "compaction preservation", "preserve during compact", "compact with instructions", "context preservation rules", "auto-compact guidance"

**Note on Sequential Thinking MCP** (evaluated 2026-01-24, rejected 30.5/100):
- Official Anthropic MCP server that wraps extended thinking with structured logging
- Adds ~200-500 token MCP overhead vs. native "think" prompts
- Use Plan Mode for visible structure, native prompts for reasoning
- Only relevant if compliance/audit requirements emerge (future reconsideration trigger)

---

## Multi-Model Orchestration

| Capability | Status | Implementation |
|------------|--------|----------------|
| Codex Integration | **IMPLEMENTED** | `mcp__codex__codex` MCP tool |
| Gemini Integration | **IMPLEMENTED** | `mcp__gemini-cli__ask-gemini` MCP tool |
| Model Routing | **IMPLEMENTED** | `model-router` subagent |
| Code Review (GPT) | **IMPLEMENTED** | Codex as primary reviewer in evolution-orchestrator |
| Dynamic Model Selection at Invocation | **IMPLEMENTED (v2.1.81)** | Agent tool `model` parameter overrides agent frontmatter at runtime: `Agent(subagent_type: "...", model: "haiku", prompt: "...")`. Values: `haiku`, `sonnet`, `opus`. Omit to use agent's definition model. Enables per-task model routing without separate agent definitions. |

**GPT-5.3-Codex-Spark** (2026-02-20, MONITOR):
- 1000+ tokens/sec on Cerebras WSE-3 (15x faster than GPT-5.3-Codex)
- Model ID: `gpt-5.3-codex-spark`
- API status: NOT generally available (select design partners only, Feb 12 2026)
- When available: test via Codex MCP wrapper, update `~/.codex/config.toml` if better
- Source: Simon Willison, OpenAI announcement

**GPT-5.4 mini / GPT-5.4 nano** (2026-03-17, ACTIVE):
- Released March 17, 2026 — smaller, cost-optimized members of the GPT-5.4 family
- Model IDs: `gpt-5.4-mini`, `gpt-5.4-nano` (verify via OpenAI docs before using in agent configs)
- Codex MCP support: verify `~/.claude-mcp-servers/codex-simple/server.js` accepts these IDs
- Use cases: mini → cost-optimized discovery/evaluation runs; nano → routing, lightweight classification (Haiku alternative for OpenAI tasks)
- Source: OpenAI release, March 2026. Score: 75/100.

**`modelOverrides` Setting** (v2.1.78, ACTIVE):
- Maps model picker entries to custom provider model IDs
- Use case: Bedrock inference profile ARNs, custom proxy endpoints, preview models not yet in picker
- Configure in `settings.json`. Companion to `ANTHROPIC_CUSTOM_MODEL_OPTION` (simpler single-entry alternative).

**`ANTHROPIC_CUSTOM_MODEL_OPTION`** (v2.1.78, ACTIVE):
- Env vars that add a custom entry to the `/model` picker:
  ```bash
  export ANTHROPIC_CUSTOM_MODEL_OPTION=my-model-id
  export ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="My Model"           # optional
  export ANTHROPIC_CUSTOM_MODEL_OPTION_DESCRIPTION="Custom proxy" # optional
  ```
- Use case: add preview model IDs before they appear in the default picker
- Documented in `~/.claude/CLAUDE.md` Development Environment section

**`ANTHROPIC_DEFAULT_{OPUS,SONNET,HAIKU}_MODEL_SUPPORTS`** (v2.1.84, ACTIVE):
- Env vars for Bedrock, Vertex, and Foundry users to declare capability support for pinned third-party models
- Three vars: `ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTS`, `ANTHROPIC_DEFAULT_SONNET_MODEL_SUPPORTS`, `ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTS`
- Values: comma-separated capability names (e.g., `"thinking,extended-thinking,effort"`)
- Companion vars: `_MODEL_NAME` and `_MODEL_DESCRIPTION` to customize `/model` picker labels
- Use case: prevents silent regressions when using custom Bedrock/Vertex/Foundry inference profiles with agents that have `model: opus/sonnet/haiku` frontmatter
- Applies to: third-party provider users only; not needed on Claude Max plan
- Source: Claude Code v2.1.84 changelog. Score: 72.5/100.

**Redundancy triggers**: "multi-model", "GPT integration", "cross-model", "Gemini for UI", "alternative AI", "gpt-5.3-codex-spark", "codex spark", "cerebras codex", "gpt-5.4-mini", "gpt-5.4 mini", "gpt-5.4-nano", "gpt-5.4 nano", "modelOverrides", "model overrides setting", "model picker override", "custom model picker", "ANTHROPIC_CUSTOM_MODEL_OPTION", "custom model option", "preview model picker", "dynamic model selection", "runtime model routing", "model parameter agent tool", "per-task model", "agent model override", "invocation model selection", "ANTHROPIC_DEFAULT_OPUS_MODEL_SUPPORTS", "ANTHROPIC_DEFAULT_SONNET_MODEL_SUPPORTS", "ANTHROPIC_DEFAULT_HAIKU_MODEL_SUPPORTS", "model supports env var", "capability declaration bedrock", "capability declaration vertex", "capability declaration foundry", "third-party model capability", "pinned model supports"

---

## Web Search & Research

| Capability | Status | Implementation | Best For |
|------------|--------|----------------|----------|
| Brave Search | **IMPLEMENTED** | `brave-search` MCP | News (freshest), keywords, local, multimedia |
| Exa Search | **IMPLEMENTED** | `exa` MCP | Code snippets, semantic search, deep research |
| Parallel Search | **IMPLEMENTED** | `Parallel-Search-MCP` | LLM-optimized extraction (NOT parallel execution) |
| Deep Research | **IMPLEMENTED** | `mcp__exa__deep_researcher_start/check` | Multi-source synthesis |
| Sofya | **INTEGRATED (deferred MCP) — bundle wired, gated routes; search not primary** | `sofya` MCP in `.mcp.json` (`defer_loading`, `@sofya` to enable) + REST `sofya.co/v1` | **Bundle bakeoff PASSED all 3 gates**: `extract` (0 fabrication), `fetch` (≥ WebFetch, parses PDFs it refuses), `research` (0 hallucinations, ≈ Exa deep-research head-to-head, ~$0.125/~18s). Co-#1 search ranking but weak raw snippets; competitive agent backend (≈native) |
| Web Fetch | **BUILT-IN** | WebFetch tool | Single URL content extraction |

### Search Tool Selection Guide (Evidence-Based)

> Based on comparative testing: `reports/search-mcp-comparison-2026-01-15.md`

| Use Case | Primary Tool | Evidence |
|----------|--------------|----------|
| Code/API docs | `mcp__exa__get_code_context_exa` | Returns actual code snippets (28 vs 0) |
| Semantic/exploratory | `mcp__exa__web_search_exa` | Neural search, moderate tokens |
| Breaking news | `mcp__brave-search__brave_news_search` | Explicit freshness metadata |
| Quick factual | `mcp__brave-search__brave_web_search` | Token-efficient (~1KB) |
| Deep content | `mcp__Parallel-Search-MCP__web_search_preview` | Full sections, but token-heavy (~15KB) |
| Images | `mcp__brave-search__brave_image_search` | Direct image results |
| Videos | `mcp__brave-search__brave_video_search` | Video metadata |
| Local businesses | `mcp__brave-search__brave_local_search` | Ratings, hours, addresses |

### Important: Parallel-Search-MCP Clarification

**WRONG assumption**: "Parallel execution of multiple queries"
**CORRECT**: "LLM-optimized output with objective-based section extraction"

- Returns MORE results (10 vs 5)
- Extracts full article sections based on "objective" parameter
- Token usage: VERY HIGH - use sparingly
- "Parallel" likely refers to Parallel.ai (company name)

**Redundancy triggers**: "web search MCP", "AI search", "research agent", "parallel search", "semantic search", "neural search", "LLM-friendly search", "sofya", "web intelligence API", "unified search/fetch/extract API", "Firecrawl alternative"

**Evaluation Note**: New search tools should demonstrate significant improvement over existing stack (better accuracy, speed, or unique data sources). Test comparatively before adopting.

### Sofya — Evaluated 2026-06-20 (full report: `reports/sofya-eval/REPORT.md`)

4-track independent benchmark vs Exa/Brave/Parallel, refined by a powered rerun on neutral OpenAI SimpleQA with a decomposed metric + bootstrap CIs (`reports/sofya-eval/REPORT-POWERED.md`).
- **Ranking (URL-recall@5, N=120):** Sofya **80% — co-#1, overlaps Exa (85%)**, clearly above Brave/Parallel (62%). Sofya is NOT a weak retriever.
- **Snippet content (snippet-findable@5, N=120):** Sofya **60% — last, CI-separated**. Its raw snippets often don't carry the answer; this was the real driver of the original "4th" (a confounded metric). Don't use Sofya as a raw *snippet* engine — Exa wins (great ranking AND snippets).
- **Agent backend (Opus drives each, n=48 SimpleQA):** Sofya **79.2%** ≈ native **83.3%** (CIs overlap) → **competitive as an agentic backend**; the weak snippets are bypassed when the agent reads the well-ranked pages. (Original Track 4 deep-research: Opus+Sofya was the best cell.)
- **Marketing check:** does NOT test Sofya's agentic-#2 SimpleQA claim under matched conditions; single-shot snippet result is consistent with its self-reported #4.
- **Differentiator:** one API for search+`fetch`(URL→markdown)+`extract`(structured JSON, ~1.8s)+`research`(25-cr deep synthesis), plus MCP + free tier. Framework score ≈ 71/100.
- **Bundle bakeoff — Evaluated 2026-06-22 (full report: `reports/sofya-eval/REPORT-BUNDLE.md`):** closes GPT-Pro's bundle gate. All 3 gates PASS.
  - `extract`: **100% parseable JSON, 0/12 fabrication** (all trap fields null), gold 24/24. No `schema` param — prompt-formatted JSON, so parse-and-validate downstream. Uses a stronger render path than `fetch` (got a GitHub install cmd `fetch` missed).
  - `fetch`: **≥ native WebFetch** — Sofya 10/10 usable vs WebFetch 8/10, 4.3× content, **parses PDFs WebFetch refuses**; blind GPT-5.5 judge 2/3 contested cases to Sofya. WebFetch wins only on already-markdown-native passthrough pages.
  - `research`: **0 hallucinations** across 6 reports, 88.9% claim accuracy, 4.2/5 citation-grounding (GPT-5.5-judged); ~$0.125 / ~18s per query. **Head-to-head vs Exa deep-research RESOLVED** (same rubric, 2026-06-22): competitive — both 0 hallucinations; Exa edges accuracy (94.4 vs 88.9), Sofya edges citation-grounding (4.2 vs 3.7) and cost ($0.125 vs $0.142).
  - **GPT-5.5 Pro implementation review** (`REPORT-BUNDLE.md` + `REVIEW-gpt-pro-implementation.md`): "wire it defensively." Promote `fetch` to preferred fidelity fetcher; wrap `extract` in a validator + evidence-per-field; treat `research` as a second opinion.
- **Disposition:** Exa remains the best single-call raw-search default. **Sofya's bundle (`extract`/`fetch`/`research`) is tested, recommended, and WIRED** (deferred `sofya` MCP in `.mcp.json`, `@sofya` to enable; gated routes in the `mcp-search-framework` skill). `extract` behind a validator, `fetch` as the preferred PDF/full-page fidelity fetcher, `research` as a fast cheap citation-grounded second opinion. NOT a search default. Reusable harness: `reports/sofya-eval/harness/bundle_*.py`.

---

## Browser Automation

| Capability | Status | Implementation | Token Efficiency |
|------------|--------|----------------|------------------|
| Better Playwright MCP | **IMPLEMENTED** | `better-playwright` MCP | 91% DOM compression |
| Chrome DevTools MCP | **IMPLEMENTED** | `chrome-devtools` MCP | 89% with WebMCP |
| Browser Testing | **IMPLEMENTED** | `browser-tester` subagent | Uses Better Playwright |

**Why These Over Standard Playwright?**
- Standard Playwright: Base64 screenshots in context = massive token bloat
- Better Playwright: DOM compression, list folding, ref-based elements
- Chrome DevTools + WebMCP: Structured tool calls, no screenshots needed

**Better Playwright MCP** (Primary for E2E):
- Package: `better-playwright-mcp3`
- Key tools: `getOutline` (91% compressed DOM), `searchSnapshot` (regex search)
- Requires HTTP server: `npx better-playwright-mcp3@latest server`
- Uses native Chrome on requiem (Chromium fallback removed after WSL → Linux migration)
- Works on ANY website

**Chrome DevTools MCP + WebMCP** (For YOUR Apps):
- Package: `@mcp-b/chrome-devtools-mcp`
- Key tools: `list_webmcp_tools`, `call_webmcp_tool`
- Native Linux (requiem): direct `localhost:9222` — no port forwarding needed
- WSL (orbis): requires `--remote-debugging-address=0.0.0.0` on Windows Chrome
- Best when you can expose test helpers via `navigator.modelContext.registerTool()`
- **2026-02-23 UPDATE**: Google Chrome now ships WebMCP natively (early preview, Chrome 146 Canary + flag)
  - Official W3C standard: https://github.com/webmachinelearning/webmcp (~1.6k stars)
  - Chrome DevTools blog: https://developer.chrome.com/blog/webmcp-epp (2026-02-10)
  - `@mcp-b/chrome-devtools-mcp` may become optional once stable (Chrome 148+?)
  - **Do NOT migrate away from package yet** — spec still unstable in preview; WSL port forwarding unchanged
  - Redundancy triggers: "Chrome WebMCP native", "webmachinelearning/webmcp", "browser standard MCP"
  - Re-evaluate when Chrome WebMCP ships to stable channel

**Setup Scripts**: `~/.claude-mcp-servers/browser-mcps/`

**Removed**: Standard `playwright` MCP (token-inefficient base64 screenshots)

**Persona Testing & UX Validation** (IMPLEMENTED):
- Subagents: `water-director-new-leader`, `water-director-rate-advocate`, `water-director-capital-planner`
- Framework: `~/claudeworkspace/applications/persona-probe/` (TypeScript)
- Orchestration: `/iterative-improve` skill — closed-loop fix → deploy → re-test cycle
- Output: Structured JSON with readiness %, per-criterion PASS/FAIL, fixable/tradeoff/false_positive classification
- Visual inspection: `visual-fidelity-inspector` subagent (Playwright + Gemini 3 Pro)
- Key differentiator: Personas navigate REAL browser via Playwright MCP, finding reproducible bugs in live DOM — not text-based imagination exercises

**Microsoft TinyTroupe** (2026-03-01, DOCUMENTED - ALTERNATIVE APPROACH, not adopted):
- Source: https://github.com/microsoft/TinyTroupe (~21k stars, Microsoft Research)
- What it is: Python library for LLM-powered persona simulation via text dialogue in fictional "TinyWorld" environments
- Personas defined as JSON specs with Big Five traits, biography, goals — richer psychological modeling than our task-focused agents
- Unique features we lack: TinyPersonFactory (population-scale sampling of 20+ persona variants), SimulationExperimentEmpiricalValidator (t-tests/KS-tests against real survey data), cross-persona dialogue (simulated focus groups)
- Why NOT adopted: No browser grounding (text-only, imagination exercises), no fix-and-re-test loop, unstructured prose output, OpenAI API lock-in, authors explicitly state "HAS NOT been shown to match real human behavior"
- Our setup is strictly superior for live web app UX validation; TinyTroupe is complementary only for text-based opinion sampling at population scale
- Revisit if: need for statistical calibration of persona feedback against real user data, or population-scale text opinion sampling for a different project

**Showboat & Rodney** (2026-02-20, Evaluated 71.75/100, Deferred):
- Agent verification CLI tools by Simon Willison (NOT MCP servers)
- Showboat: 320 stars, Apache-2.0, produces re-runnable Markdown proof-of-work docs
- Rodney: 371 stars, persistent Chrome CLI, agent-readable `--help`
- Install: `uvx showboat`, `uvx rodney` (zero MCP token overhead)
- Value: agents produce verifiable demo documents with embedded screenshots
- Status: APPROVED but integration deferred — existing pipeline (tests, persona reports, QA summaries) covers verification needs
- Adoption trigger: if pipeline needs agent-produced verification docs beyond existing reports

**Redundancy triggers**: "browser automation", "web scraping", "E2E testing", "puppeteer", "selenium", "browser testing token", "screenshot bloat", "showboat", "rodney", "agent demo", "agent verification document", "proof of work markdown", "re-runnable verification", "persona testing", "persona simulation", "LLM persona", "synthetic users", "simulated users", "TinyTroupe", "TinyPerson", "user simulation", "focus group simulation", "persona probe", "UX validation agents", "claude-code-templates", "aitmpl", "template marketplace"

---

## Task Management

| Capability | Status | Implementation |
|------------|--------|----------------|
| Todo Tracking | **BUILT-IN** | TodoWrite tool |
| Task Decomposition | **IMPLEMENTED** | Subagent patterns + Plan Mode |
| Progress Tracking | **BUILT-IN** | TodoWrite with status |
| Task Metrics | **BUILT-IN** | Task tool returns token count, tool uses, duration (2.1.30+) |
| Task Deletion | **BUILT-IN** | TaskUpdate tool can delete tasks (2.1.20+) |
| Structured Planning | **BUILT-IN** | Plan Mode (EnterPlanMode/ExitPlanMode) |
| Multi-step Delegation | **IMPLEMENTED** | Task tool + specialized subagents |

**Why No Task Management MCP?**
- Built-in TodoWrite provides zero-token task tracking with status (pending/in_progress/completed)
- Plan Mode creates structured implementation plans with user approval workflow
- Subagents handle task decomposition via specialized agents (feature-implementer, etc.)
- 80-90% feature parity with AI task management MCPs at zero cost

**Task Master MCP Evaluation** (2026-01-26):
- Scored 48.75/100 (rejected)
- Requires external AI API calls for every operation (PRD parsing, decomposition) = unbounded costs
- TodoWrite + Plan Mode + subagents provide 80-90% feature parity at zero cost
- Kill signal: API cost model unacceptable when free alternatives exist
- Full evaluation: `pipeline/evaluation/completed/task-master-mcp-evaluation.md`

**Redundancy triggers**: "task management", "todo list", "task tracking", "progress monitoring", "task master mcp", "ai task management", "prd to task automation", "task dependency graph", "automated task decomposition", "task complexity analysis", "task orchestration mcp"

---

## File Operations

| Capability | Status | Implementation |
|------------|--------|----------------|
| File Reading | **BUILT-IN** | Read tool (text, images, PDFs with page ranges `pages: "1-5"`, Jupyter notebooks) |
| File Writing | **BUILT-IN** | Write tool |
| File Editing | **BUILT-IN** | Edit tool (string replacement with context) |
| Content Search (Exact) | **BUILT-IN** | Grep tool (ripgrep-based, regex, globs, context lines) |
| Content Search (Semantic) | **IMPLEMENTED** | mgrep CLI tool (Mixedbread embeddings, natural language queries) |
| File Pattern Matching | **BUILT-IN** | Glob tool (pattern-based file discovery) |
| Filesystem Operations | **BUILT-IN** | Bash tool (mkdir, mv, ls, tree, stat, file, etc.) |
| Screenshot OCR / Image Text Extraction | **BUILT-IN** | Read tool + Claude multimodal vision (PNG/JPG/WebP/GIF/PDF, clipboard paste, drag-and-drop) |

**Why No Filesystem MCP?**
- Built-in tools provide zero-token, faster, more secure file operations
- Filesystem MCP would add 2-3k token overhead for exact same functionality
- All 14 MCP tools are covered by Read, Write, Edit, Bash, Grep, Glob
- MCP designed for AI assistants WITHOUT built-in file tools (not applicable to Claude Code)

**Filesystem MCP Evaluation** (2026-01-26):
- Scored 24/100 (rejected)
- 100% functional overlap with built-in tools
- Token efficiency: 0/100 (adds cost with zero benefit)
- Full evaluation: `archive/rejected/filesystem-mcp-rejected.md`

**File Context Server MCP Evaluation** (2026-01-26):
- Scored 45/100 (rejected)
- 90% functional overlap with Read + Glob + Grep + Bash
- Novel features (cyclomatic complexity, dependency extraction) are niche
- Token efficiency: negative (adds metadata overhead)
- Low community validation (34 stars)
- Codex cross-validation: 45/100 (consensus)
- Full evaluation: `pipeline/evaluation/completed/filecontext-mcp-evaluation.md`

**mgrep Semantic Search Evaluation** (2026-01-26, integrated 2026-01-17):
- Scored 83.0/100 (integrated)
- Novel capability: Natural language/semantic search using embeddings
- Empirically validated: 96.9% match for "rate calculation formula" (Grep missed primary file)
- Token efficiency: 2x reduction in 50-task benchmark
- Complementary to Grep: Use Grep for exact strings, mgrep for semantic exploration
- Installation: `npm i -g @mixedbread/mgrep`, one-time login
- Skill guide: `~/.claude/skills/mgrep-guide/SKILL.md`
- Integration report: `integrations/cli-tools/mgrep-integration.md`
- Full evaluation: `integrations/cli-tools/mgrep-semantic-search-evaluation.md`
- Full comparison: `reports/mgrep-vs-grep-comparison.md`

**contextplus MCP** (2026-03-01, NOT ADOPTED):
- Source: https://github.com/ForLoopCodes/contextplus (~1k stars)
- What it is: Local MCP server adding semantic code search, AST parsing, blast radius analysis, spectral file clustering, shadow restore points
- Requires Ollama running locally (hard dependency) with `nomic-embed-text` + `llama3.2`
- 60%+ overlap with mgrep (semantic search) which is already integrated and cloud-based (no GPU needed)
- One genuine gap: `get_blast_radius` (call-graph-level impact tracing before refactors) — no equivalent in our setup
- Also offers: `get_file_skeleton` (AST-based API surface, saves tokens on large files), `get_context_tree` (structural overview)
- `propose_commit` claims to be "the only way to write code" — conflicts with Claude Code's native write model
- Low maturity: 54 commits, "99% accuracy" claim has no published benchmarks
- See: `pipeline/future/contextplus-blast-radius-2026-03-01.md` for future tracking

**Redundancy triggers**: "filesystem MCP", "file operations MCP", "read/write MCP", "directory management MCP", "file search MCP", "@modelcontextprotocol/server-filesystem", "file context server", "file context MCP", "code analysis MCP", "cyclomatic complexity MCP", "dependency extraction MCP", "file watching MCP", "caching MCP", "semantic search", "natural language search", "embedding-based search", "mgrep", "semantic grep", "fuzzy code search", "screenshot OCR", "image text extraction", "OCR MCP", "tesseract integration", "vision OCR", "image to text", "image OCR MCP", "contextplus", "context+", "blast radius MCP", "AST MCP", "call graph MCP", "spectral clustering code", "Ollama code search"

---

## Database Operations

| Capability | Status | Implementation |
|------------|--------|----------------|
| Database CLI Access (OLTP) | **BUILT-IN** | Bash tool (psql, mysql, sqlite3, sqlcmd, mongosh) |
| OLAP Analytics (DuckDB) | **IMPLEMENTED** | `duckdb-motherduck` MCP (embedded, multi-format files) |
| Structured Output | **BUILT-IN** | CLI flags (--json, --batch, -At, etc.) |
| Connection Management | **BUILT-IN** | Environment variables, config files (.pgpass, .my.cnf) |
| Query Execution | **BUILT-IN** | Direct SQL via database CLIs |

**Why No Database MCP?**
- Bash provides zero-token database access via native CLIs
- All major databases supported: PostgreSQL, MySQL, MSSQL, SQLite, MongoDB
- Native CLIs offer full feature parity with vendor maintenance
- Environment integration (credentials, config files) already established
- Structured output available via CLI flags (JSON, tab-separated, etc.)

**MCP Database Server Evaluation** (2026-01-26):
- Hypothetical database MCP scored 24.5/100 (rejected)
- Bash database access is simpler, more transparent, lower risk
- MCP would add 2-3k tokens + credential security overhead for zero value-add
- Full evaluation: `pipeline/evaluation/completed/database-query-mcp-evaluation.md`

**When Database MCP WOULD Add Value** (not claimed by evaluated tool):
- Unified multi-DB abstraction with consistent API
- Schema introspection with semantic understanding
- Safe query builders with automatic parameterization
- Advanced pooling with health checks/failover
- LLM-optimized result formatting

**DuckDB/MotherDuck MCP** (2026-02-06):
- Embedded OLAP database (no server setup)
- Query CSV/Parquet/JSON/Excel directly without loading
- Fast analytics (<100ms for most operations)
- MotherDuck cloud for persistent storage
- Package: `@motherduckdb/mcp-server`
- Use cases: statement-parser data analysis, evolution pipeline metrics, ad-hoc analytics
- Complements PostgreSQL (OLTP) with OLAP capabilities
- Integration report: `integrations/mcps/duckdb-motherduck-integration.md`

**Redundancy triggers**: "database MCP", "SQL query server", "database operations MCP", "connection pooling MCP", "multi-database MCP", "schema management MCP", "DB query tool", "duckdb", "motherduck", "OLAP database", "embedded analytics", "columnar database", "file-based queries", "CSV query", "Parquet analytics"

---

## Version Control

| Capability | Status | Implementation |
|------------|--------|----------------|
| Git Operations | **BUILT-IN** | Bash tool (git commit, push, pull, branch, merge, status, diff, log, rebase, cherry-pick, stash, etc.) |
| Git Workflows | **DOCUMENTED** | CLAUDE.md files (commit messages, PR creation, co-authorship, safety protocols) |
| Git Worktrees | **IMPLEMENTED** | `~/.claude/skills/using-git-worktrees/SKILL.md` skill |
| GitHub CLI Integration | **BUILT-IN** | Bash tool (gh pr, gh issue, gh api, gh auth, etc.) |
| PR-linked Sessions | **BUILT-IN** | `--from-pr` flag to resume sessions linked to PR number/URL (2.1.27+) |
| PR Review Status | **BUILT-IN** | Prompt footer shows PR state as colored dot (2.1.20+) |

**Why No Git MCP?**
- Bash tool provides zero-token git access via native git CLI
- 100% feature parity: All git commands executable via `bash -c "git <command>"`
- Existing CLAUDE.md workflows document commit/PR best practices
- Git worktrees skill provides advanced parallel branch workflows
- MCP wrapper would add 2-3k token overhead for exact same functionality

**Git MCP Evaluation** (2026-01-26):
- Scored 20/100 (rejected)
- 100% functional overlap with Bash tool
- Token efficiency: 0/100 (adds 2-3k tokens for zero benefit)
- Codex cross-validation: 20/100 (consensus - "duplicates built-in Bash capabilities")
- Full evaluation: `archive/rejected/rejected-git-mcp-redundant.md`

**Redundancy triggers**: "git MCP", "version control MCP", "git operations server", "commit MCP", "push/pull MCP", "branch management MCP", "git wrapper MCP", "source control MCP"

---

## Code Quality

| Capability | Status | Implementation |
|------------|--------|----------------|
| Code Review | **IMPLEMENTED** | `code-reviewer` subagent |
| Structural Code Intelligence (Knowledge Graph) | **IMPLEMENTED** | `codebase-memory` MCP (`defer_loading: true` in `.mcp.json`) |
| Security Audit | **IMPLEMENTED** | `security-auditor` subagent |
| Security Review Command | **IMPLEMENTED** | `/security-review` slash command (`~/.claude/commands/security-review.md`) |
| `/ultrareview` | **ACTIVE (v2.1.111, research preview)** | Cloud multi-agent code review — fleet of reviewer agents independently verify bugs before merge. 5-10 min background run. Reports only verified findings (eliminates false positives). Works on local diffs or by PR number. 3 free runs, then $5-$20/review. Requires claude.ai account + GitHub. Not on Bedrock/Vertex/Foundry/ZDR. |
| Real-Time Security Scanning (Semgrep) | **IMPLEMENTED** | `semgrep` MCP (official Anthropic partner, SAST + SCA + Secrets) |
| MCP Security Scanner | **IMPLEMENTED** | `mcp-guard` CLI tool (scans MCP servers for vulnerabilities) |
| MCP Response Injection Defense | **IMPLEMENTED** | `helpers/playbooks/mcp-response-injection-defensive-pattern.md` — runtime adversarial content in MCP response payloads; distinct from mcp-guard (server code) and semgrep (generated code) |
| Performance Analysis | **IMPLEMENTED** | `performance-analyzer` subagent |
| Test Writing | **IMPLEMENTED** | `test-writer` subagent |
| Debugging | **IMPLEMENTED** | `debugger` subagent |
| Session Debugging | **BUILT-IN** | `/debug` command (v2.1.30+) |
| TDD Enforcement | **IMPLEMENTED** | `tdd-guard` hooks + `test-driven-development` skill |
| Self-Healing Pipeline | **IMPLEMENTED** | `~/.claude/skills/self-healing-pipeline/SKILL.md` |
| Shell/Bash Conventions | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Shell/Bash Conventions section |
| Session-End Verification | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Session-End Verification section |
| Execution Defaults | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Execution Defaults section |
| No Sudo Rule | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Development Environment section |
| Privacy in Generated Content | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Privacy in Generated Content section |
| Multi-Item Plan Verification | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Session-End Verification → Multi-Item Plan Verification subsection |
| Tool & Environment Failure Circuit Breaker | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Tool & Environment Failure Circuit Breaker section |
| Long-Running Job Provenance Validation | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Validate Before Irreversible Operations → Long-running jobs bullet |
| Session Spawning Defaults | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Execution Defaults → Session spawning defaults bullet |
| Prose Generation via `claude -p` | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Development Environment → Prose generation bullet |
| Detect Silent MCP Truncation | **IMPLEMENTED** | `~/.claude/CLAUDE.md` ## Tool & Environment Failure Circuit Breaker → truncation-detection paragraph |

**Self-Healing Pipeline Skill** (2026-02-05):
- Source: Claude Code /insights usage analysis (internal)
- Score: 80.55/100
- Autonomous test-fix loop for hardening Bash scripts
- Complements TDD (new code) and debugger (one-shot diagnosis) with iterative hardening of existing scripts
- Safeguards: 10 iteration limit, 30s timeout, same-failure detection

**Shell/Bash Conventions** (2026-02-05):
- Source: Claude Code /insights usage analysis (internal)
- Score: 86.25/100
- Mandates `set -euo pipefail`, `jq` for JSON, explicit exit code handling
- Addresses 64 friction events from buggy Bash code across 53k invocations

**Session-End Verification** (2026-02-05):
- Source: Claude Code /insights usage analysis (internal)
- Score: 85.45/100
- Run test suite after every implementation before marking task complete
- Addresses 23 unclear session outcomes and pipefail bugs caught too late

**Execution Defaults** (2026-02-22):
- Source: Claude Code /insights usage analysis (internal, week of 2026-02-18)
- Scores: Root cause identification 82.75, Priority preservation 79.5, Implementation over planning 85.25
- Three behavioral rules: (1) Identify root cause field before editing, (2) Preserve user-stated priority order, (3) Begin implementation immediately when user says "continue"/"implement"
- Addresses: wrong-field edits, dropped priorities, excessive re-planning in continuation sessions

**Approach-First Planning** (2026-03-15):
- Source: Claude Code /insights usage analysis (internal, 2026-02-18 to 2026-03-14)
- Score: 80.0/100
- Plan mode behavioral rule: Write brief approach outline first based on existing knowledge, get user buy-in on direction, then proceed with thorough file reads
- Addresses: 27 wrong-approach friction events, "excessive planning without execution" friction pattern, "read 30 files then told wrong direction" waste
- Promoted from validated memory insight (plan-for-a-plan pattern, 2026-03-04) to formal CLAUDE.md rule

**No Sudo Rule** (2026-03-22):
- Source: Claude Code /insights usage analysis (internal, 2026-02-18 to 2026-03-22)
- Score: 73.5/100
- System safety rule: Never run `sudo` commands directly — output the command for the user to run manually
- Addresses: Multiple sessions where Claude attempted sudo commands it cannot execute on native Linux (requiem), requiring user intervention
- Triggered by WSL → native Linux migration making sudo reachable for the first time

**Privacy in Generated Content** (2026-03-29):
- Source: Claude Code /insights usage analysis (internal, 2026-02-18 to 2026-03-26)
- Score: 74.5/100
- Behavioral rule: Never include real names in blog posts, pipeline outputs, gists, or public content. Use structural references. Never allowlist or pseudonymize — structurally remove.
- Addresses: Recurring privacy friction across 5 consecutive /insights reports (2026-02-05 through 2026-03-29). Claude repeatedly leaked real names into blog drafts and attempted to allowlist them. Previous "privacy pipeline" suggestions were deferred as project-specific; this broader behavioral rule addresses the root cause globally.
- Resolves recurring pattern: privacy-checker-mandate (5 occurrences), privacy-pipeline-mandate (4 occurrences)

**Multi-Item Plan Verification** (2026-04-26):
- Source: Claude Code /insights usage analysis (internal, 2026-02-18 to 2026-04-24)
- Score: 72.75/100
- Behavioral rule: For plans with 10+ items, use TodoWrite at start; mark each item completed with one-line evidence note (file:line, test result, or command output) — not summary; report final status as "X/Y complete" not "all done". Run verification subagent (code-reviewer/debugger/persona) before declaring completion on plans containing review steps.
- Addresses: Recurring premature-done claims on long plans (14, 24, 33-item) where user pushback ("seems quick, was every improvement implemented?") consistently surfaces P0 bugs that single-pass implementations miss. Distinct from Session-End Verification (test suite) — this enforces per-item evidence and structured X/Y reporting.
- Co-located with Session-End Verification rule rather than as separate section

**Tool & Environment Failure Circuit Breaker** (2026-04-26):
- Source: Claude Code /insights usage analysis (internal, 2026-02-18 to 2026-04-24)
- Score: 83.5/100
- Behavioral rule: When a TOOL or ENVIRONMENT fails (sandbox/bwrap, MCP server timeout/truncation, voice save bug, broken shell), attempt at most 2 fixes, then STOP and present: (1) what failed, (2) what was tried, (3) options for the user to choose. Do not burn the session on workarounds.
- Distinct from Two-Failure Reset Rule: Two-Failure Reset addresses *same-issue reasoning loops* by clearing the session; this rule addresses *external tool/environment failures* by stopping and asking the user (no session clear, just an explicit handoff).
- Addresses: Entire sessions lost to AppArmor/bwrap, ChatGPT MCP truncation, ElevenLabs voice save where Claude attempted heredoc workarounds and lost the original goal. Pivots from "burn session on workaround attempts" to "preserve session via early bailout".

**Long-Running Job Provenance Validation** (2026-05-03):
- Source: Claude Code /insights usage analysis (internal, 2026-02-18 to 2026-05-03)
- Score: 78.75/100
- Behavioral rule: Before launching any long-running job (>1 hour: training run, dataloader, multi-model batch, overnight pipeline), validate that provenance/cache files match runtime expectations — entry counts, schema versions, model names, config hashes. Never trust cached metadata silently.
- Integration target: appended as 5th bullet under existing `## Validate Before Irreversible Operations` section in `~/.claude/CLAUDE.md` (extends, doesn't duplicate)
- Addresses: A stale provenance entry-count caused a 45-hour nanochat training run to silently consume only 16.5% of cached data, requiring full relaunch. Single most expensive friction in 2026-02-18→2026-05-03 insights window. Distinct from Session-End Verification (post-implementation tests) and Tool & Environment Failure Circuit Breaker (reactive bail-out) — this is pre-launch sanity check on cached state.

**Redundancy triggers**: "multi-item plan verification", "per-item evidence", "X/Y complete reporting", "todowrite evidence note", "subagent verification large plan", "premature done claim", "10+ item plan", "verification before complete plan", "tool failure circuit breaker", "environment failure bailout", "sandbox failure bail out", "MCP failure stop", "tool failure 2 attempts", "broken sandbox bwrap", "MCP truncation handling", "stop burning session workarounds", "voice save mcp fail", "elevenlabs mcp fail", "session preservation early bailout", "external tool failure response", "heredoc workaround anti-pattern", "long-running job validation", "provenance validation", "cache provenance check", "training run sanity check", "stale cache metadata", "schema version validation", "config hash check", "pre-launch sanity check", "entry count validation", "cached metadata never trust", "45 hour training loss", "16.5% cache silent bug", "training run provenance bug", "dataloader provenance"

**Session Spawning Defaults** (2026-05-17):
- Source: Claude Code /insights weekly analysis (internal, 2026-02-18 to 2026-05-05)
- Score: 73.5/100
- Behavioral rule: When asked to "open"/"start"/"spin up" a session, default to interactive tmux Opus session, NOT `claude -p` headless. Headless `-p` only when request explicitly mentions scripting/cron/batch/one-shot. For vague project names matching multiple candidates (e.g., "voice fine-tuning" → Chatterbox TTS vs voice-clone LLM), confirm exact project before opening.
- Integration target: appended as 7th bullet under existing `## Execution Defaults` section in `~/.claude/CLAUDE.md`
- Addresses: Recurring 2+ wasted sessions in 2026-02-18→2026-05-05 window: (1) Claude started headless `claude -p` when user wanted interactive Opus tmux; (2) Claude opened voice-clone LLM project when user wanted Chatterbox TTS. Distinct from "Trust user certainty about existence claims" (which handles search-failure) — this handles the spawning step before search.
- **Redundancy triggers**: "session spawning defaults", "session type defaults", "interactive tmux default", "claude -p vs interactive", "headless vs interactive default", "open session opus default", "spin up session default", "start session interactive", "tmux opus default", "project name ambiguity spawn", "voice fine-tuning project pick", "chatterbox vs voice-clone", "confirm exact project before opening"

**Prose Generation via `claude -p`** (2026-05-31):
- Source: Claude Code /insights weekly analysis (internal, 2026-02-18 to 2026-05-05)
- Score: 71.25/100 (integration_complexity=85, token_efficiency=60, capability_expansion=70, maintenance=85, community_validation=60)
- Behavioral rule: When generating long-form/creative prose via `claude -p` (blog posts, fiction, translations), override or strip the default coding-agent system prompt — it leaks meta-commentary ("I'll write…", task framing) into the output — and set generous timeouts for Opus runs. Mechanism: `--bare` (skips CLAUDE.md/skills/memory) plus a custom system-prompt flag (verify exact flag name via `claude -p --help`, it has changed across versions).
- Integration target: appended as 2nd bullet under existing `## Development Environment` section in `~/.claude/CLAUDE.md` (extends the existing `claude -p` programmatic-call bullet)
- Addresses: Prose-generation pipelines (38-post blog campaigns, 84K-word novel from psyche profile, RTW translation) repeatedly failed on meta-responses and insufficient Opus timeouts, requiring iterative debugging. NOVEL — first surfaced in the report's `## Content Generation` CLAUDE.md suggestion (cmd-4); no prior digest entry across 11 weeks. Distinct from the `--bare` flag registry entry (which documents the *flag* for startup overhead) and the existing `claude -p` bullet (nested-session/auth) — this captures the *prose-specific guidance* (meta-response suppression + Opus timeout) that neither covered.
- **Redundancy triggers**: "prose generation claude -p", "meta-response prose", "suppress system prompt prose", "coding agent system prompt leak", "opus timeout prose", "creative writing claude -p", "novel generation pipeline", "blog prose generation flag", "strip system prompt generation", "content generation meta commentary", "claude -p prose timeout", "--bare prose", "custom system prompt prose"

**Detect Silent MCP Truncation** (2026-06-07):
- Source: Claude Code /insights weekly analysis (internal, 2026-02-18 to 2026-05-05)
- Score: 70.5/100 (integration_complexity=90, token_efficiency=55, capability_expansion=65, maintenance=90, community_validation=60)
- Behavioral rule: An MCP/tool response that looks abruptly cut off or implausibly short (e.g. a ~20-char answer to an analysis request) is a silent data-quality failure, not a valid result. Verify length/completeness before building on it; re-fetch once, then fall back to WebFetch or the underlying JSON API.
- Integration target: appended as a paragraph under existing `## Tool & Environment Failure Circuit Breaker` section in `~/.claude/CLAUDE.md` (the *detection* complement to the section's reactive 2-attempt bail-out)
- Addresses: Sessions derailed by the ChatGPT Pro MCP truncating to 20 chars and a browser-MCP serializer bug — both produced corrupt output that looked usable and was built upon before the failure was noticed. NOVEL — first surfaced as the report's `## Tooling Caveats` CLAUDE.md suggestion (cmd-3); no prior digest entry across 12 weeks (grep "distrust truncated"/"truncation detect" = 0). Distinct from `maxResultSizeChars` registry entry (server-side size-limit raise, not a detection heuristic) and `mcp-doctor-skill` (deferred diagnostic catalog) and the Circuit Breaker's reactive bail-out (assumes failure already noticed). Unlike sandbox/bwrap friction, MCP-level truncation was NOT resolved by the 2026-03-03 native-Linux migration — friction remains live.
- **Redundancy triggers**: "MCP truncation detection", "distrust truncated MCP response", "20-char MCP response", "silent truncation tool output", "verify response length before trusting", "MCP corrupt output detection", "truncated response fallback WebFetch", "implausibly short tool result", "abruptly cut off MCP", "tool output completeness check"

**`/ultrareview` — Cloud Multi-Agent Code Review** (v2.1.111, research preview, Score: 77.75/100):
- **How it works**: Launches a fleet of reviewer agents in a remote cloud sandbox. Agents run in parallel and independently verify each bug before reporting it — cross-verification eliminates false positives.
- **vs local `code-reviewer` subagent**: Local = single-pass analysis on local resources; /ultrareview = cloud multi-agent with independent cross-verification
- **Input modes**: (1) local diff (runs on current `git diff`), (2) PR number (GitHub required)
- **Output**: Verified findings only — noise-filtered; tracks progress via `/tasks`
- **Timing**: Background, 5-10 minutes — continue working while it runs
- **Cost**: 3 free runs, then $5-$20 per review (Max plan)
- **Requirements**: claude.ai account + GitHub (for PR mode). Not on Bedrock/Vertex/Foundry/ZDR.
- **Score**: 77.75/100 (Integrated 2026-04-18)

**Security Review Command**:
- From: `anthropics/claude-code-security-review` (2.8k stars)
- Purpose: 3-phase security analysis of pending git branch changes
- Phases: Vulnerability identification → False-positive filtering → Confidence thresholding (8+)
- Focus: HIGH/MEDIUM severity findings with >80% exploitability confidence
- Invocation: `/security-review` in any git repository

**Semgrep MCP** (2026-02-06):
- Real-time security scanning DURING code generation (preventative vs detective)
- SAST (600k+ rules), SCA (reachability analysis), Secrets (semantic detection + validation)
- Official Anthropic MCP partner
- Blocks insecure code before it's generated
- Single binary: `brew install semgrep` or `pip install semgrep`
- Auth: `semgrep login && semgrep install-semgrep-pro`
- Integration report: `integrations/mcps/semgrep-mcp-integration.md`

**MCP Guard** (2026-02-06):
- Scans MCP servers for vulnerabilities (supply chain security)
- Static analysis, dynamic testing, dependency scanning, fuzzing
- CVSS v4.0 + AIVSS scoring
- Rust CLI: `cargo install mcp-guard`
- Usage: `mcp-guard scan --repo <github-url>` or `--path <local-path>`
- Integration report: `integrations/cli-tools/mcp-guard-integration.md`
- **Scope clarification**: mcp-guard covers MCP SERVER CODE (supply-chain/SAST). It does NOT cover adversarial content in MCP RESPONSE PAYLOADS at runtime. See `helpers/playbooks/mcp-response-injection-defensive-pattern.md` for runtime defensive guidance.

**/debug Command** (2026-02-06):
- Built-in since v2.1.30 (we're on v2.1.34)
- Session-level troubleshooting (MCP servers, hooks, tools, config)
- Complements debugger subagent (code-level debugging)
- Usage: `/debug` when experiencing session issues

**codebase-memory MCP** (2026-04-13):
- Source: https://github.com/DeusData/codebase-memory-mcp — 1.3k stars, MIT, PulseMCP #152
- Score: 81.25/100
- Parses codebase into persistent knowledge graph (functions, classes, call chains, imports, HTTP routes)
- 14 structural query tools: blast radius analysis, call chain traversal, import graph, route mapping
- Persists across session restarts AND context compaction events (key differentiator)
- Benchmarked 120x token reduction (5 structural queries: ~3,400 vs ~412,000 via grep+read)
- 66-language support; auto-detects Claude Code; single static binary, zero dependencies
- Config: `npx -y codebase-memory-mcp` via `.mcp.json` (`defer_loading: true` — activate when doing code exploration)
- Distinct from: filesystem MCP (file I/O), contextplus (Ollama-required), Graphiti (Neo4j-required, in Future)
- Integration report: `integrations/mcps/codebase-memory-mcp-integration.md`

**Redundancy triggers**: "ultrareview", "/ultrareview", "cloud code review", "multi-agent code review", "pre-merge review", "verified findings code", "parallel reviewer agents", "cloud sandbox review", "false positive free review", "independent bug verification", "code review agent", "security scanner", "test generator", "debugging assistant", "security review", "vulnerability scanner", "TDD enforcement", "self-healing scripts", "autonomous fix loop", "bash hardening", "script testing automation", "shell conventions", "bash best practices", "jq standards", "pipefail conventions", "session-end testing", "post-implementation verification", "test before complete", "real-time security", "semgrep mcp", "SAST during generation", "secret validation", "MCP security scanner", "mcp-guard", "supply chain security for MCP", "scan MCP servers", "MCP vulnerability detection", "session debugging", "debug command", "troubleshooting tool", "session introspection", "root cause identification", "identify root cause before editing", "preserve user priorities", "priority ordering", "skip re-planning", "implementation over planning", "continue means implement", "execution defaults", "no sudo", "sudo restriction", "elevated privileges", "root command safety", "never run sudo", "sudo output only", "approach-first planning", "plan-for-a-plan", "outline before exploration", "privacy name rule", "real name leak", "allowlist real names", "name in content", "privacy generated content", "structural references", "remove real names", "pseudonymize names", "privacy blog pipeline", "name leak prevention", "codebase memory", "knowledge graph code", "call chain traversal", "blast radius analysis", "import graph", "structural code queries", "code knowledge graph", "persistent code index", "function graph", "HTTP route map", "DeusData MCP", "code intelligence MCP", "120x token reduction", "codebase-memory-mcp"

---

## UI Quality & Design

| Capability | Status | Implementation | Purpose |
|------------|--------|----------------|---------|
| Vercel Web Interface Guidelines | **IMPLEMENTED** | `/web-interface-guidelines` command | Comprehensive UI quality audit (7 domains) |
| UI-Skills | **IMPLEMENTED** | `/ui-skills` command + `~/.claude/skills/ui-skills/` | Opinionated Tailwind/Next.js constraints |

**Vercel Web Interface Guidelines**:
- Source: vercel-labs/web-interface-guidelines (475 stars, MIT)
- Covers: Interactions, Animations, Layout, Content, Forms, Performance, Design
- Framework-agnostic, works with any web project
- Usage: `/web-interface-guidelines <file>` or `/web-interface-guidelines` for full audit
- Recommends: Add `AGENTS.md` to projects for auto-application

**UI-Skills** (ibelick):
- Source: ibelick/ui-skills (384 stars, MIT)
- Stack-specific: Tailwind CSS, motion/react, accessible component primitives
- Opinionated constraints for component usage, animation, typography
- Usage: `/ui-skills <file>` for file audit, `/ui-skills` for conversation-wide

**Complementarity**:
- UI-Skills = Prescriptive constraints ("do this"), Tailwind-specific
- Vercel Guidelines = Comprehensive reference ("consider this"), framework-agnostic
- Use BOTH for complete coverage

**Rejected**:
- RAMS.ai (61/100) - Closed source, unknown license, security risk (no public repo)

**Redundancy triggers**: "UI audit", "accessibility checker", "WCAG compliance", "visual design review", "UI polish", "interface guidelines", "component constraints", "animation standards"

---

## Document Generation

| Capability | Status | Implementation |
|------------|--------|----------------|
| PDF Creation | **IMPLEMENTED** | `pdf` skill (reportlab) |
| Markdown → PDF | **IMPLEMENTED** | reportlab + markdown-it-py (Python) OR pandoc (CLI) |
| DOCX Creation | **IMPLEMENTED** | `docx` skill |
| PPTX Creation | **IMPLEMENTED** | `pptx` skill |
| XLSX Creation | **IMPLEMENTED** | `xlsx` skill |

**Markdown → PDF Details**:
- Python approach: reportlab + markdown-it-py (both installed)
- CLI approach: pandoc + weasyprint (installable via apt-get)
- Zero token cost via Bash tool
- Full styling, TOC, and template support via pandoc

**Redundancy triggers**: "document generation", "PDF creator", "Word documents", "spreadsheet automation", "markdown to pdf", "md to pdf", "markdown converter", "pdf from markdown"

---

## Memory & Persistence

| Capability | Status | Implementation |
|------------|--------|----------------|
| Official Memory System | **BUILT-IN** | Claude Code 2.1.32+ auto-records and recalls memories as it works |
| Agent Memory Frontmatter | **IMPLEMENTED** | Claude Code 2.1.33+ `memory:` field in agent definitions (user/project/local scope) |
| claude-mem Plugin | **DEPRECATED** | Superseded by official Memory System |
| Session Persistence | **BUILT-IN** | Claude Code sessions |
| CLAUDE.md Notes | **BUILT-IN** | Project/global instructions |
| Auto-Compacting | **BUILT-IN** | Automatic conversation summarization when context limit approached |
| Partial Summarization | **BUILT-IN** | Claude Code 2.1.32+ "Summarize from here" in message selector |

**Official Memory System** (Claude Code 2.1.32): Claude now automatically records and recalls memories as it works. This is a native, zero-token-overhead system that replaces the need for community memory MCPs. Cross-project isolation is handled natively.

**Agent Memory Frontmatter** (Claude Code 2.1.33): Enables individual agents to maintain persistent state across invocations with scoped memory (user/project/local). Distinct from Official Memory System which is conversational. Implemented in key agents: capability-discoverer (user scope), code-reviewer/debugger/evolution-orchestrator (project scope).

**Redundancy triggers**: "persistent memory", "remember across sessions", "knowledge base", "long-term memory", "context compression", "conversation summarization", "auto memory", "memory mcp", "agent state", "stateful agents", "agent memory", "agent persistence", "agentic context engineering", "ACE framework", "strategic learning", "execution feedback", "skillbook", "grow-and-refine", "instinct system", "confidence scoring", "pattern extraction", "team learning", "knowledge sharing", "continuous learning"

### Important: Auto-Compacting vs Claude-Mem

These are **complementary**, not redundant:

| Feature | Auto-Compacting | Claude-Mem |
|---------|-----------------|------------|
| Purpose | Prevent context overflow in long sessions | Retrieve info from previous sessions |
| Persistence | Within session only | Across sessions |
| Method | Automatic summarization (lossy) | Explicit search (structured storage) |
| When triggered | Approaching context limit | Manual search/recall |
| **Keep both**: Auto-compacting still needed even with claude-mem |

**Evaluation Note**: Discoveries claiming to "replace auto-compacting" should be compared carefully - claude-mem complements but doesn't replace it.

### Agentic Context Engineering (ACE)

| Capability | Status | Implementation |
|------------|--------|----------------|
| ACE Framework | **DOCUMENTED** | Stanford/SambaNova research framework for strategic learning from execution |

**ACE Framework** (2026-02-06):
- **Purpose**: Strategic learning from task execution feedback (distinct from conversational memory)
- **Architecture**: Three-role system (Generator, Reflector, Curator)
- **Innovation**: Grow-and-refine principle prevents brevity bias in context summarization
- **Empirical results**: 42-49% token reduction in browser automation, 29.8% step reduction
- **Integration options**: `ace-learn` CLI (reads Claude Code transcripts), SessionEnd hook, skillbook storage
- **Complementarity**: Works with Official Memory (factual), Agent Memory (state), ACE (strategy)
- **Status**: Documented for awareness, manual integration available via CLI
- **Source**: https://github.com/kayba-ai/agentic-context-engine

**Why ACE is Different**:
- **Official Memory**: "Remember that the API uses JWT tokens" (factual recall)
- **Agent Memory**: "capability-discoverer has checked these sources today" (agent state)
- **ACE**: "When evaluating MCPs, compare token overhead first, then features" (strategic patterns)

**Key Value**:
- Strategic lessons from execution outcomes (not just conversation content)
- Incremental growth with deterministic merging (avoids context collapse)
- Portable knowledge (JSON skillbooks transferable across agents)
- Proven token efficiency (40%+ reduction empirically validated)

**Integration Path** (if desired in future):
1. Install `ace-learn` CLI from kayba-ai/agentic-context-engine
2. Add SessionEnd hook to trigger reflection
3. Configure skillbook storage (CLAUDE.md or dedicated skill file)
4. Test on capability discovery workflow
5. Measure token reduction in evolution pipeline

### Instinct System (Continuous Learning v2)

| Capability | Status | Implementation |
|------------|--------|----------------|
| Instinct System | **DOCUMENTED** | Confidence-scored pattern extraction with team knowledge sharing |

**Instinct System** (2026-02-06):
- **Purpose**: Extract patterns from git history and Claude sessions with confidence scoring
- **Key features**: Confidence levels (0.0-1.0), import/export JSON, auto-clustering into skills
- **Commands**: `/instinct-status`, `/instinct-import/export`, `/evolve`, `/learn`, `/checkpoint`, `/verify`
- **Comparison to context-librarian**: More sophisticated with quantified reliability, team sharing, auto-skill generation
- **Integration**: Plugin install OR manual copy to `~/.claude/`, slash commands
- **Status**: Documented for awareness, complements existing context-librarian
- **Source**: https://github.com/affaan-m/everything-claude-code

**Why Instinct System is Different**:
- **Confidence scoring**: Tracks reliability (0.0-1.0) to prevent cargo-culting bad patterns
- **Team knowledge base**: Export/import JSON enables distributed learning across team
- **Auto-skill generation**: `/evolve` creates reusable skills from clustered patterns
- **Git-integrated**: Learns from actual code evolution, not just prompts
- **Lower barrier**: Slash commands vs subagent invocation

**Complementarity with Existing**:
- **context-librarian**: Manual conversation archival (triggered by subagent)
- **Instinct System**: Automatic git history + session pattern extraction with confidence scores
- Both serve different purposes and should coexist

**Integration Path** (if desired in future):
1. Install from plugin marketplace OR manual copy to `~/.claude/`
2. Add commands to `~/.claude/commands/`
3. Configure hooks for automatic pattern extraction
4. Test `/instinct-status` and `/learn` on existing project
5. Evaluate confidence scoring accuracy over 1-week trial

---

## Skills & Workflows

| Capability | Status | Implementation |
|------------|--------|----------------|
| Claude Skills Library | **AVAILABLE** | Community repos (41.8k+ official, 4,200+ community cataloged) |
| Skills Architecture | **IMPLEMENTED** | `~/.claude/skills/` with progressive disclosure |
| Custom Skills | **IMPLEMENTED** | Multiple domain-specific skills created |
| obra/superpowers TDD | **IMPLEMENTED** | `~/.claude/skills/test-driven-development/SKILL.md` |
| obra/superpowers Git Worktrees | **IMPLEMENTED** | `~/.claude/skills/using-git-worktrees/SKILL.md` |
| obra/superpowers Parallel Agents | **IMPLEMENTED** | `~/.claude/skills/dispatching-parallel-agents/SKILL.md` |
| Skill_Seekers | **IMPLEMENTED** | Installed via pipx (`skill-seekers` CLI) |
| tdd-guard | **IMPLEMENTED** | Hooks configured in `~/.claude/settings.json` |

**Claude Skills Ecosystem** (Audited 2026-01-15):

| Repository | Stars | Focus |
|------------|-------|-------|
| anthropics/skills | 41.8k | Official reference skills |
| obra/superpowers | 24.1k | TDD, debugging, subagents |
| ComposioHQ/awesome-claude-skills | 19.7k | Comprehensive collection |
| muratcankoylan/Agent-Skills-for-Context-Engineering | 7.1k | Context management |
| yusufkaraaslan/Skill_Seekers | 6.7k | Auto-skill generation |
| travisvn/awesome-claude-skills | 5.1k | Curated index |
| parcadei/Continuous-Claude-v3 | 3.2k | Context hooks/ledgers |
| anthropics/claude-code-security-review | 2.8k | Security GitHub Action |
| nizos/tdd-guard | 1.7k | TDD enforcement |
| trailofbits/skills | 768 | Security audit workflows |

**Full audit**: See `~/claudeworkspace/claude-evolution/docs/awesome-claude-skills-audit.md`

**Skills vs MCP Distinction**:
- **Skills**: Teach Claude procedural knowledge ("how to perform tasks")
- **MCP**: Provide tool access ("what external systems can I call")
- **Complementary**: Skills teach workflows, MCP provides tools

**High-Value Skills NOW Integrated** (from audit - 2026-01-15):
- ✅ TDD enforcement (obra/superpowers + tdd-guard) - skill + hooks
- ✅ Git worktrees workflow (obra/superpowers) - skill
- ✅ Parallel agent dispatching (obra/superpowers) - skill
- ✅ Auto-skill generation (Skill_Seekers) - CLI tool via pipx
- ✅ Security review (anthropics/claude-code-security-review) - slash command
- ✅ Rube MCP (500+ app integrations) - HTTP MCP server

**Skills NOT Yet Integrated** (from audit):
- Context engineering patterns (muratcankoylan) - requires further evaluation
- Security GitHub Action workflow (claude-code-security-review) - for CI/CD use

### Hook Development Patterns

| Capability | Status | Implementation |
|------------|--------|----------------|
| Hook Lifecycle Architecture | **IMPLEMENTED** | `~/.claude/skills/hook-lifecycle/SKILL.md` (all 21 hooks documented, incl. WorktreeCreate/WorktreeRemove v2.1.50+, ConfigChange v2.1.60+, InstructionsLoaded v2.1.69+, Elicitation/ElicitationResult v2.1.76+, TaskCreated v2.1.84+, conditional `if` field v2.1.85+, PreToolUse `updatedInput` v2.1.85+, PermissionDenied v2.1.88+) |
| PermissionDenied Hook | **ACTIVE (v2.1.88+)** | Fires after auto mode classifier denials — return `{retry: true}` to signal model should retry. Enables audit logging of denied commands, selective retry allowlisting, and Discord alerts on unexpected denials. The 21st Claude Code hook. Complements `permissions.defaultMode: "auto"` with observability. |
| PreToolUse `updatedInput` (AskUserQuestion) | **ACTIVE (v2.1.85+)** | PreToolUse hooks can return `{"permissionDecision": "allow", "updatedInput": {"question_id": "...", "answer": "..."}}` to satisfy AskUserQuestion dialogs programmatically. Enables headless pipeline runs. Hook script: `~/.claude/hooks/headless-question-handler.sh`. Registered with `if: "tool_name == 'AskUserQuestion'"` for zero overhead on non-question tools. |
| ConfigChange Hook | **IMPLEMENTED** | `~/.claude/settings.json` hooks.ConfigChange + `~/.claude/skills/hook-lifecycle/SKILL.md` § 10 (v2.1.60+) |
| InstructionsLoaded Hook | **IMPLEMENTED** | `~/.claude/skills/hook-lifecycle/SKILL.md` § 11 (v2.1.69+) — fires after CLAUDE.md/skills loaded; enables skill usage logging, agent-aware routing |
| Hook Agent Metadata Fields | **IMPLEMENTED** | All hook payloads now include `agent_id`, `agent_type`, `worktree` JSON fields (v2.1.69+) — documented in `helpers/navigation/hook-environment-variables.md` |
| MCP Elicitation Hook | **IMPLEMENTED** | `~/.claude/skills/hook-lifecycle/SKILL.md` § 12 (v2.1.76+) — fires when MCP server requests structured user input; enables credential pre-fill from local secret store |
| MCP ElicitationResult Hook | **IMPLEMENTED** | `~/.claude/skills/hook-lifecycle/SKILL.md` § 12 (v2.1.76+) — fires after user responds to elicitation dialog; enables validation, audit logging, value sanitization |
| StopFailure Hook | **ACTIVE** | v2.1.78+: fires when a turn ends due to API error (rate limit, auth failure, timeout). Enables auto-retry, backoff, or alerting. Documented in `helpers/playbooks/stopfailure-hook-error-recovery.md` |
| TaskCreated Hook | **ACTIVE (v2.1.84+)** | Fires when a Task (subagent) is spawned via the Task tool — at spawn time, before the agent runs. Enables cost tracking, spawn-time context injection, and rate-limiting expensive subagent spawns. Standard hook payload with agent_id, agent_type, worktree fields. The 20th Claude Code hook. |
| Conditional `if` Field for Hooks | **ACTIVE (v2.1.85+)** | Declarative `if` field using permission rule syntax (same as allow/deny rules). When condition is false, hook subprocess is never spawned — zero process overhead. Syntax: `{"if": "tool_name == 'Bash'", "hooks": [...]}`. Available fields include tool_name, file_path, command (verify empirically). |
| PreToolUse `defer` Decision | **ACTIVE (v2.1.89+)** | Fourth PreToolUse return value: `{"permissionDecision": "defer"}`. Pauses headless `-p` session at a tool call and saves state. Resume with `claude -p --resume <session-id>`. Use case: gate irreversible operations (force-push, `rm -rf`, `~/.claude.json` edits) without terminating session. Hook script: `~/.claude/hooks/defer-risky-operations.sh` (pattern in hook-lifecycle skill §17). |
| PreCompact Hook Blocking | **ACTIVE (v2.1.105)** | PreCompact hooks can now veto compaction entirely via exit code 2 OR returning JSON `{"decision": "block"}`. Previously only observational. Enables quality gates: block when iterative-improve loop state is active, active subagents are running, or mid-task context must be preserved. Documented in hook-lifecycle skill §18. |
| Background Plugin Monitors | **ACTIVE (v2.1.105)** | New `monitors` top-level key in plugin manifest. Scripts listed there auto-arm as background processes at session start or on skill invoke. Enables persistent background monitoring (test watchers, file change detectors, cost monitors) without manual hook setup. Documented in hook-lifecycle skill §19. |
| UV Single-File Script Hooks | **DOCUMENTED** | `~/.claude/CLAUDE.md` Shell/Bash Conventions section |

**Hook Lifecycle Architecture** (2026-02-06, updated 2026-03-31): Complete documentation of all 21 Claude Code lifecycle hooks with production patterns: blocking controls (exit code 2), intelligent TTS (ElevenLabs→OpenAI→pyttsx3), transcript management (PreCompact backup, JSONL→JSON), context injection (UserPromptSubmit), quality validation (PostToolUse ruff/ty), Builder/Validator agent pattern, custom status lines (9 versions), structured logging (JSON logs for all hooks). WorktreeCreate/WorktreeRemove added in v2.1.50+. ConfigChange added in v2.1.60+ (config audit trail, security auditing, drift detection). InstructionsLoaded added in v2.1.69+. Elicitation/ElicitationResult added in v2.1.76+ (MCP server-initiated structured input dialogs; credential pre-fill, OAuth audit logging). TaskCreated added in v2.1.84+ (spawn-time subagent monitoring). Conditional `if` field added in v2.1.85+ (declarative config-layer hook filtering). PreToolUse `updatedInput` added in v2.1.85+ (headless AskUserQuestion satisfaction). Source: disler/claude-code-hooks-mastery (2.3k stars) + Anthropic official releases.

**PreToolUse `updatedInput` — Headless AskUserQuestion** (v2.1.85+, 2026-03-28): PreToolUse hooks can now return `updatedInput` alongside `permissionDecision: "allow"` to programmatically answer AskUserQuestion dialogs without user interaction. Pattern-matching hook (`~/.claude/hooks/headless-question-handler.sh`) handles known pipeline questions (proceed/skip/yes patterns); unknown questions fall through to normal user interaction. Combined with conditional `if: "tool_name == 'AskUserQuestion'"` for zero overhead on all other tools. Direct use case: evolution pipeline heartbeat, iterative-improve headless phases. Score: 81.75/100.

**MCP Elicitation Hooks** (v2.1.76+, 2026-03-14): Two new hook types for the MCP Elicitation protocol. MCP servers can now request structured user input mid-task (form fields or browser URL). `Elicitation` fires before the dialog appears — useful for pre-filling credentials from local secret store. `ElicitationResult` fires after user responds — useful for audit logging OAuth flows, sanitizing values before server receives them. Open questions: which MCP servers support elicitation; exact event payload schema for ElicitationResult. Score: 78.25/100.

**ConfigChange Hook** (v2.1.60+, 2026-02-27): New hook event that fires when Claude Code's configuration is modified. Used for enterprise security auditing, config drift detection, and audit trails. Registered in `~/.claude/settings.json` hooks.ConfigChange. Logs to `~/.claude/logs/config-audit.log`. Env vars (unconfirmed — test before relying): `$CLAUDE_CONFIG_KEY`, `$CLAUDE_CONFIG_VALUE`, `$CLAUDE_CONFIG_PATH`. May fire frequently with auto-memory; consider debouncing if log grows large. Score: 85.5/100.

**TaskCreated Hook** (v2.1.84+, 2026-03-27): New hook event firing when a Task (subagent) is spawned via the Task tool. Fires at spawn time, before the agent consumes compute — distinct from SubagentStart (which fires when execution begins). This is the 20th Claude Code hook. Practical use: evolution pipeline can log task spawns to event bus for per-task cost tracking. Payload includes agent_id, agent_type, worktree fields. Score: 77.25/100.

**PermissionDenied Hook** (v2.1.88+, 2026-03-31): New hook event firing after the auto mode classifier denies a tool call or command. Return `{retry: true}` from the handler to signal the model should retry the denied operation; return `{}` to let the denial stand. The 21st Claude Code hook. Payload likely includes tool_name, command, file_path plus standard agent_id, agent_type, worktree fields (verify empirically). Complementary to `permissions.defaultMode: "auto"` — provides observability for denials that previously only showed a UI notification. Use cases: log denials to event bus for monitoring, Discord alert on unexpected denials during heartbeat runs, auto-approve known-safe patterns wrongly flagged. Also: `/permissions` → Recent tab (same v2.1.88 release) provides UI-side denial history. Score: 79.0/100.

**Conditional `if` Field for Hooks** (v2.1.85+, 2026-03-27): Declarative `if` field for hook entries using permission rule syntax. When the condition evaluates to false, the hook subprocess is never spawned — config-layer filtering with zero process overhead. Previously, every hook fired unconditionally and scripts had to exit early themselves. Available condition fields (verify empirically): tool_name, file_path, command, other event fields. Additive only — existing hooks are unaffected. Do NOT rewrite existing hooks until exact field names are confirmed. Score: 88.25/100.

**UV Single-File Script Hooks** (2026-02-06): Use Astral UV's inline dependency declarations (`#!/usr/bin/env uv run` + `# dependencies = [...]`) for Python hooks. Eliminates venv management, each hook carries its own dependencies. Integrated into Hook Lifecycle skill.

**Redundancy triggers**: "claude skills", "awesome skills", "skill library", "procedural knowledge", "workflow patterns", "TDD skill", "context engineering skill", "uv hooks", "hook dependencies", "python hook dependencies", "inline dependencies", "uv run hooks", "13 hooks", "15 hooks", "16 hooks", "17 hooks", "19 hooks", "20 hooks", "hook lifecycle", "PreToolUse", "PostToolUse", "SessionStart", "SessionEnd", "blocking hooks", "exit code 2", "TTS hooks", "transcript management", "Builder/Validator pattern", "WorktreeCreate", "WorktreeRemove", "worktree hooks", "worktree lifecycle hooks", "worktree setup teardown", "worktree isolation hooks", "ConfigChange", "config change hook", "config audit hook", "config drift detection", "configuration audit trail", "config security hook", "mcp elicitation", "mcp structured input", "mcp dialog", "mcp form fields", "server input request", "elicitation hook", "ElicitationResult hook", "mid-task user input", "mcp authentication dialog", "mcp browser url", "interactive mcp", "runtime mcp configuration", "credential pre-fill hook", "oauth audit hook", "StopFailure", "stop failure hook", "api error hook", "rate limit hook", "turn error hook", "turn failure hook", "api timeout hook", "TaskCreated", "task spawn hook", "subagent spawn event", "task created event", "spawn monitoring", "pre-execution task hook", "20 hooks", "21 hooks", "conditional hook", "if field hook", "hook condition", "declarative hook filter", "hook if field", "permission rule hook", "zero-cost hook filtering", "hook subprocess skip", "updatedInput", "satisfy AskUserQuestion", "headless question handler", "programmatic question answer", "pipeline question stall", "unattended AskUserQuestion", "headless hook answer", "updatedInput hook", "inject question answer", "bypass AskUserQuestion", "auto-answer pipeline question", "headless pipeline hook", "PermissionDenied", "permission denied hook", "denial hook", "auto mode denial", "denied command hook", "retry denied operation", "permission classifier hook", "denied tool hook", "auto mode observability", "21 hooks", "retry: true hook", "PreToolUse defer", "defer permission decision", "pause headless session", "session pause tool call", "defer tool call", "gate irreversible operation", "force-push gate hook", "rm -rf gate hook", "resume after defer", "fourth pretooluse decision", "pause and hold session", "defer headless pipeline"

---

## Plugin System

| Capability | Status | Implementation |
|------------|--------|----------------|
| `${CLAUDE_PLUGIN_DATA}` Persistent State | **ACTIVE** | v2.1.78+: per-plugin persistent directory that survives plugin updates. Path unknown (verify empirically: `echo ${CLAUDE_PLUGIN_DATA}` in a hook). `/plugin uninstall` now prompts before deletion. Documented in `helpers/navigation/hook-environment-variables.md`. |
| Plugin Agent Frontmatter (effort/maxTurns/disallowedTools) | **ACTIVE** | v2.1.78+: plugin-shipped agents can now set `effort`, `maxTurns`, and `disallowedTools` in frontmatter. Enables plugins to constrain agent behavior at definition time. Noted in `~/.claude/agents/INDEX.md` Agent Spawn Restrictions section. |
| Memory File Last-Modified Timestamps | **ACTIVE** | v2.1.78+: Claude can now reason about memory file freshness from last-modified timestamps. Automatic — no configuration required. Improves stale memory detection in the auto-memory system. |
| MCP Plugin Deduplication | **ACTIVE** | Plugin-provided MCP servers that match a manually-configured server (same command/URL) are automatically skipped. Manual config takes precedence. Prevents duplicate tool sets and tool disambiguation noise. |
| Inline Plugin Source (`source: "settings"`) | **ACTIVE (v2.1.85+)** | Declare plugins inline in `settings.json` without requiring a git-hosted repository. Previously, all plugins required a git repo. Enables rapid development of private or project-local plugins. Companion feature: CLI tool usage detection added to plugin tips (alongside file pattern matching). |
| Plugin `bin/` Executables | **ACTIVE (v2.1.91+)** | Plugins can ship executables under `bin/` within the plugin directory. These become invocable as bare commands from the Bash tool when the plugin is active — no global installation required. Enables self-contained plugins that bundle CLI helpers. Evolution use case: package heartbeat/version-tracker scripts as plugin bin/ entries. Deferred — revisit when packaging evolution scripts as a formal plugin. |

**Inline Plugin Source** (`source: "settings"`, v2.1.85+, 2026-03-27): New `source` field for plugin marketplace declarations that allows plugin entries to be declared inline in `settings.json` without requiring a git-hosted repository. Prior to this, every plugin required a git repo — creating overhead for project-local or personal tooling. Format: add `"source": "settings"` to the plugin entry in `settings.json`. Companion feature: CLI tool usage detection for plugin tips (in addition to file pattern matching) improves plugin discoverability. Score: 74.25/100.

**Plugin `bin/` Executables** (v2.1.91+, 2026-04-03):
- **Purpose**: Plugins can bundle their own CLI helpers in a `bin/` directory within the plugin package
- **Invocation**: Executables available as bare commands from the Bash tool when the plugin is active; no global PATH addition
- **Use case**: Self-contained plugins that don't require pre-installed dependencies — everything bundled in the plugin
- **Evolution pipeline**: heartbeat scripts, version-tracker, webhook-post could be packaged as plugin `bin/` entries for cleaner deployment
- **Open questions**: PATH injection scope (plugin-scoped vs global), permission model for executables, size/format restrictions
- **Action**: Deferred — revisit when packaging evolution heartbeat scripts as a formal plugin (v2.1.85 `source: "settings"` is the foundation)

**Redundancy triggers**: "plugin data", "CLAUDE_PLUGIN_DATA", "plugin persistent state", "plugin state directory", "plugin data variable", "plugin uninstall prompt", "plugin agent frontmatter", "plugin effort frontmatter", "plugin maxTurns", "plugin disallowedTools", "agent effort field", "memory file timestamps", "memory freshness", "memory last modified", "stale memory detection", "plugin mcp deduplication", "duplicate mcp server", "mcp plugin conflict", "manual config precedence", "plugin tool dedup", "plugin server dedup", "mcp dedup", "inline plugin", "plugin without git", "settings plugin source", "source settings plugin", "local plugin declaration", "private plugin", "project-local plugin", "plugin marketplace inline", "inline plugin source", "CLI tool detection plugin", "plugin tips cli", "plugin bin", "plugin executables", "plugin CLI helper", "plugin binary", "bin directory plugin", "self-contained plugin", "plugin tool packaging", "plugin bundled scripts"

---

## Sandboxed Code Execution

| Capability | Status | Implementation |
|------------|--------|----------------|
| Cloudflare Dynamic Workers | **DOCUMENTED (open beta)** | V8 isolate sandboxing at edge. <5ms startup vs ~500ms containers. $0.002/Worker/day (free in beta). Companion infrastructure primitive — no Claude Code config required. |
| Agent-Infra AIO Sandbox (Docker) | **PENDING EVALUATION** | Multi-runtime Docker sandbox (Browser + Shell + Filesystem + VSCode + Jupyter + MCP). 3.4k+ stars, ByteDance-affiliated. Shared filesystem across runtimes. Pre-configured MCP servers. Docker required. |

**Cloudflare Dynamic Workers** (2026-03-31, open beta): V8 isolate-based runtime where a parent Worker spawns child Workers with runtime-specified code. 100x faster than containers (<5ms startup). Deployed at the edge. No host infrastructure required beyond a Cloudflare account. Use cases: agent-generated code execution, evolution experiment sandboxing, games pipeline script execution. Distinct from Deno sandbox (local execution) and Docker sandboxes (container overhead). Score: 72/100. Technique doc: `library/techniques/cloudflare-dynamic-workers-agent-sandbox-2026-03-31.md`.

**Agent-Infra AIO Sandbox** (2026-03-31, pending evaluation): Open-source Docker container combining Browser, Shell, Filesystem, VSCode, Jupyter, and pre-configured MCP servers with a shared filesystem across runtimes. Key differentiator: file written in shell is immediately readable in browser context without coordination — solves multi-runtime state coherence. 3.4k+ stars, ByteDance-affiliated (UI-TARS-desktop production use). Docker available on requiem. Score: 74/100 (approved, pending full integration). Complementary to openclaw-sandbox pattern.

**Redundancy triggers**: "dynamic workers", "cloudflare sandbox", "V8 isolate sandbox", "edge code execution", "millisecond sandbox startup", "agent code sandbox", "cloudflare worker sandbox", "AIO sandbox", "agent-infra sandbox", "multi-runtime sandbox", "shared filesystem sandbox", "browser shell jupyter docker", "bytedance sandbox", "docker MCP runtime", "unified sandbox", "agent execution environment", "safe code execution agent"

---

## Unified Integration Platforms

| Capability | Status | Implementation |
|------------|--------|----------------|
| Rube MCP Server | **IMPLEMENTED** | HTTP MCP via `claude mcp add --transport http rube -s user "https://rube.app/mcp"` |

**Rube Details**:
- Built on Composio platform (SOC 2 compliant)
- Single MCP server replaces dozens of individual integrations
- OAuth 2.1 authentication, authenticate once per app
- Natural language → API translation
- Team support (shared/private connections)
- Requires Tool Search Tool for optimal token efficiency (500+ tools)

**Redundancy triggers**: "unified MCP", "multi-app integration", "500+ apps", "composio", "universal connector"

---

## Claude Code CLI & Built-in Commands (v2.1.85–v2.1.90)

| Capability | Status | Implementation |
|------------|--------|----------------|
| Monitor Tool (background streaming) | **ACTIVE (v2.1.98)** | Built-in tool that spawns a background process and streams each stdout line into the active session without blocking. Point at any long-running script (e.g., `kubectl logs -f \| grep ERROR`). Eliminates Bash polling loops for CI logs, test runners, build watchers. |
| `/cost` Per-Model & Cache Breakdown | **ACTIVE (v2.1.92)** | `/cost` now shows per-model cost breakdown and cache-hit breakdown for Max plan subscribers. Previously aggregate-only. Use to verify Opus/Sonnet/Haiku spend distribution and prompt cache effectiveness in multi-agent sessions. |
| Session Title via `hookSpecificOutput.sessionTitle` | **ACTIVE (v2.1.94)** | `UserPromptSubmit` hooks can return `{"hookSpecificOutput": {"sessionTitle": "..."}}` to programmatically set the session title. Heartbeat sessions auto-titled 'Heartbeat YYYY-MM-DD' for clean `/resume` picker navigation. Hook wired in `~/.claude/settings.json` UserPromptSubmit. |
| `refreshInterval` Statusline Setting | **ACTIVE (v2.1.97)** | `"refreshInterval": 30` in `settings.json` statusline config causes the status script to re-execute every N seconds for live indicators (rate limit countdown, heartbeat activity). Configured in `~/.claude/settings.json`. |
| Accept Edits Mode — Env-Var Prefix Auto-Approval | **ACTIVE (v2.1.97)** | In accept-edits mode, bash commands prefixed with `nvm`, `npx`, `python3 -c`, and similar process wrappers auto-approve without confirmation. Reduces friction for post-edit typecheck/lint runs. Auto Mode is primary; this helps specifically in accept-edits mode. |
| Skill Invocation Names from Frontmatter | **ACTIVE (v2.1.94)** | When using `skills: ['./']`, skills are now invoked using the `name:` field from their SKILL.md frontmatter rather than the directory basename. Existing skills unaffected — no config change needed; alignment between directory name and frontmatter name recommended. |
| `keep-coding-instructions` Plugin Frontmatter | **ACTIVE (v2.1.94)** | New frontmatter field for plugins/skills that controls post-task output behavior (whether to pause, summarize, or continue coding). Relevant for skills in automated loops (iterative-improve, heartbeat) where post-task summaries add noise. Check accepted values before applying to specific SKILL.md files. |
| `claude -n` Session Naming | **ACTIVE (v2.1.87+)** | `claude -p -n 'heartbeat-YYYYMMDD'` names the session for reliable `--resume` identification. Wired into daily heartbeat script. |
| `/teleport` + `/remote-env` | **ACTIVE (v2.1.87+)** | Cross-device session bridging between web and CLI. Requiem↔orbis-1 Tailscale topology makes this directly useful. Test from dashi (mobile). |
| `Ctrl+B` Agent Backgrounding | **ACTIVE (v2.1.88+)** | Backgrounds both bash commands AND agents simultaneously. Useful in tmux sessions for parallel agent management. |
| `ExitWorktree` Built-in Tool | **ACTIVE (v2.1.87+)** | Completes the `EnterWorktree`/`ExitWorktree` built-in tool pair. Agents using worktree isolation now have native exit capability. Updated in `using-git-worktrees` skill. |
| `EnterWorktree` `path` parameter | **ACTIVE (v2.1.105)** | New `path` parameter allows switching INTO an existing worktree without creating a new one. See v2.1.105 section below. |
| `CLAUDE_CODE_DISABLE_CRON` | **ACTIVE (v2.1.88+)** | Env var to abort all scheduled cron jobs mid-session. Critical for debugging: `export CLAUDE_CODE_DISABLE_CRON=1` before testing to prevent automation conflicts with 4+ active cron jobs. |
| Named Subagents `@` Typeahead | **ACTIVE (v2.1.88+)** | Named subagents now appear in `@` mention completion typeahead. Improved discoverability for 40+ custom subagents. |
| `/copy 'w'` Key | **ACTIVE (v2.1.88+)** | Write selection to file, bypassing clipboard. Useful over SSH (dashi→requiem, orbis-1). |
| `/powerup` Command | **ACTIVE (v2.1.90+)** | Interactive animated feature tutorial showing new capabilities. Run once per major release to check for registry gaps. Not scriptable — interactive only. |
| Auto-Continuation on Token Limit | **ACTIVE (v2.1.90+)** | Moved to Context Management section above. |
| `X-Claude-Code-Session-Id` Header | **ACTIVE (v2.1.86+)** | Session ID injected into all API requests as `X-Claude-Code-Session-Id`. Enables per-session cost tracking and audit logging at proxy layer. No action needed unless deploying a proxy. |
| `/team-onboarding` Command | **ACTIVE (v2.1.101)** | Generates a teammate ramp-up guide synthesized from local CLAUDE.md hierarchy, agent definitions, command patterns, and usage history. One-shot command replaces manual documentation of agent usage and workflow conventions. Run in the claude-evolution workspace to produce a guide for new contributors or returning users after long absences. |
| `/recap` Away Summary | **ACTIVE (v2.1.108)** | Returns contextual summary when returning to a long-running session. Manually invokable at any time. `CLAUDE_CODE_ENABLE_AWAY_SUMMARY=1` env var enables automatic away summary (needed for telemetry-disabled setups). Env var proposal: `pipeline/pending-approval/recap-session-context.proposal.json`. |
| Desktop App Redesign | **ACTIVE (v2.1.108)** | New desktop UX: session sidebar for managing multiple parallel sessions from one window, drag-and-drop workspace layout, integrated terminal pane, faster diff viewer. Auto-applied on app update. Limited impact on requiem (Linux/tmux workflow); relevant on Mac/Windows desktop app. |

**`/recap` Away Summary Details** (v2.1.108, 2026-04-18):
- **Purpose**: On-demand session context recap — "what were we doing?" without scrolling back through history
- **Manual use**: Type `/recap` at any point in any session
- **Automatic away summary**: Triggers when returning to session after absence (configurable via `/config`)
- **`CLAUDE_CODE_ENABLE_AWAY_SUMMARY=1`**: Forces away summary feature for telemetry-disabled setups where `/config` toggle isn't available
- **Complements**: `/compact` (model-facing context compression) and `/resume` picker (finds sessions, doesn't summarize content)
- **Best use**: Long iterative-improve loops and overnight heartbeat sessions where session state isn't obvious on return
- **Env var status**: Proposal in `pipeline/pending-approval/recap-session-context.proposal.json` (sandbox tested: PASSED)
- **Score**: 78.25/100

**Desktop App Redesign Details** (v2.1.108, 2026-04-18):
- **Features**: Multi-session sidebar, drag-drop workspace layout, integrated terminal pane, faster diff viewer, expanded preview area
- **Impact on requiem**: Limited — native Linux tmux session management provides equivalent parallel-session visibility
- **Impact on Mac/Windows**: Direct value — replaces cmd-tab between terminal tabs with sidebar view
- **Integration**: Automatic app update, zero config
- **Note**: Same release day as Routines (April 14, 2026)
- **Score**: 71.25/100 (registry-only)

**`claude -n` Session Naming Details** (v2.1.87+, 2026-04-02):
- **Usage**: `claude -p -n 'my-session-name' -- "prompt"`
- **Use case**: Heartbeat and pipeline scripts can now use stable, predictable names instead of opaque session IDs for `--resume` operations
- **Wired into heartbeat**: `evolution-daily-heartbeat.sh` now uses `claude -p -n 'heartbeat-YYYYMMDD'`

**`CLAUDE_CODE_DISABLE_CRON` Details** (v2.1.88+, 2026-04-02):
- **Usage**: `export CLAUDE_CODE_DISABLE_CRON=1` before starting Claude Code session
- **Effect**: Aborts all scheduled cron triggers mid-session — prevents automation from firing while debugging pipeline issues
- **Workspace relevance**: 4+ active cron jobs (heartbeat, orchestrator, openclaw-exchange, activity-monitor) — critical for debugging without side effects
- **Unset after debugging**: Remember to unset before returning to normal operation

**`ExitWorktree` Details** (v2.1.87+, 2026-04-02):
- **Completes**: EnterWorktree/ExitWorktree built-in tool pair for agents using `isolation: worktree` frontmatter
- **Distinction**: The built-in `ExitWorktree` tool is for AGENTS running in worktrees. The `using-git-worktrees` skill is for HUMANS doing interactive feature branch work.
- **Automatic cleanup**: Agents with `isolation: worktree` still auto-clean on finish; ExitWorktree is for explicit mid-session exit

**`X-Claude-Code-Session-Id` Details** (v2.1.86+, 2026-04-02):
- **Header**: `X-Claude-Code-Session-Id: <session-uuid>` injected into every API request
- **Use cases**: Proxy-layer cost tracking per session, audit logging for enterprise, debugging specific sessions
- **No action needed**: Useful only if deploying a proxy between Claude Code and Anthropic API
- **Future relevance**: If workspace ever needs per-session cost attribution (e.g., per-project billing)

**Monitor Tool — Background Script Streaming** (v2.1.98, 2026-04-09):
- **Purpose**: Spawns a background process and streams each stdout line into the active session without blocking it
- **Usage**: Point at any long-running script: `kubectl logs -f | grep ERROR`, test runner output, CI log streams, build watchers
- **Eliminates**: The Bash polling loop anti-pattern (running `sleep 5; check_status` repeatedly in a loop) and the "open second session for log tailing" pattern
- **Behavior**: Claude receives output as it arrives and can act on events in real-time — no additional tool calls needed
- **Use cases**: CI log monitoring, test runner progress, build watchers, deployment health checks, process output analysis

**Redundancy triggers**: "monitor tool", "background script streaming", "background process streaming", "log streaming tool", "long-running script tool", "stream process output", "background log tail", "async events tool", "stream stdout claude"

**`/cost` Per-Model and Cache Breakdown** (v2.1.92, 2026-04-04):
- **Purpose**: Extended `/cost` command showing per-model cost breakdown and cache-hit details for Max plan users
- **Before**: Showed aggregate session totals only
- **Now**: Breakdown by model tier (Opus/Sonnet/Haiku) + prompt cache hit/miss stats
- **Use case**: Verify spend distribution in multi-agent evolution/heartbeat sessions; check if cache is actually reducing costs
- **No config needed**: Built-in command enhancement; active automatically on Max plan

**Redundancy triggers**: "/cost breakdown", "/cost per model", "per-model cost", "cache hit breakdown", "cost by model", "token spend model", "cost visibility multi-agent", "opus sonnet haiku cost", "cache effectiveness cost"

**Session Title Hook** (`hookSpecificOutput.sessionTitle`, v2.1.94, 2026-04-07):
- **Purpose**: `UserPromptSubmit` hooks can return `{"hookSpecificOutput": {"sessionTitle": "..."}}` to programmatically set/override the session title
- **Wired**: Hook added to `~/.claude/settings.json` UserPromptSubmit — detects heartbeat prompts via keyword matching and returns `"Heartbeat YYYY-MM-DD"` title
- **Benefit**: `/resume` picker shows readable names instead of timestamp/UUID entries for automation sessions
- **Fallback**: Non-heartbeat sessions get no title override (hook returns `{}`)

**Redundancy triggers**: "session title hook", "hookSpecificOutput sessionTitle", "auto-title session", "UserPromptSubmit title", "session naming hook", "programmatic session title", "heartbeat session name", "resume picker title"

**`refreshInterval` Statusline** (v2.1.97, 2026-04-08):
- **Purpose**: Re-executes the statusline command on a timer (N seconds) for live indicators without user interaction
- **Config**: `"refreshInterval": 30` inside `statusLine` object in `~/.claude/settings.json`
- **Schema note**: Current `settings.json` schema has `additionalProperties: false` for `statusLine` — `refreshInterval` was not present as of integration check (2026-04-11). Prerequisite: add `statusLine: {type: "command", command: "~/.claude/statusline.sh"}` first, then test whether `refreshInterval` is accepted at runtime.
- **Use cases with existing statusline**: Live rate-limit countdown (`rate_limits` data), heartbeat last-run timestamp, git status refresh
- **Requirement**: Statusline script must be idempotent, fast (<2s), and side-effect-free. `~/.claude/statusline.sh` meets these criteria (read-only queries)

**Redundancy triggers**: "statusline refresh", "refreshInterval statusline", "live statusline", "auto-refresh status", "statusline timer", "dynamic status bar", "live rate limit status"

**Accept Edits Auto-Approval** (v2.1.97, 2026-04-08):
- **Purpose**: In accept-edits mode, recognized safe prefixes (`nvm run`, `npx`, `python3 -c`, etc.) auto-approve without confirmation
- **Scope**: Accept-edits mode only — distinct from Auto Mode (`permissions.defaultMode: "auto"`) which is the active default
- **For this setup**: `nvm` is the Node.js version manager; post-edit typecheck/lint via `npx tsc --noEmit` or `nvm run` no longer requires confirmation in accept-edits mode
- **No action needed**: Passive behavior, zero config. Auto Mode already covers this use case in normal operation.

**Redundancy triggers**: "accept edits auto-approve", "accept edits mode bash", "nvm auto-approve", "npx auto-approve", "env-var prefix approval", "process wrapper auto-approve", "accept-edits bash confirm"

**Skill Invocation Names from Frontmatter** (v2.1.94, 2026-04-07):
- **Change**: When referencing plugin-bundled skills via `skills: ['./']`, Claude Code now uses the `name:` frontmatter field as the invocation name instead of the directory basename
- **Impact**: Skills already have `name:` fields — invocation names now match declared names. Prevents drift between directory structure and skill invocation.
- **No migration needed**: Existing global skills are referenced directly (not via `skills: ['./']`) — behavior unchanged. Relevant for plugin development where directory naming may differ from logical skill name.

**Redundancy triggers**: "skill invocation name", "frontmatter name field", "plugin skill name", "skill directory basename", "skill naming frontmatter", "skills invocation"

**`keep-coding-instructions` Plugin Frontmatter** (v2.1.94, 2026-04-07):
- **Purpose**: New frontmatter field for plugins/skills that controls Claude's post-task behavior — whether to pause, summarize, or continue coding after skill completion
- **Relevant for**: Skills used in automated loops where post-task summary output adds noise (iterative-improve, deploy-staging, plan-tracker)
- **Integration note**: Before applying, confirm accepted values from v2.1.94 changelog (boolean? string enum?) and verify whether it applies to global `~/.claude/skills/` or only plugin-bundled skills
- **Priority candidates**: iterative-improve, deploy-staging, plan-tracker — all produce summary output during loops

**Redundancy triggers**: "keep-coding-instructions", "post-task behavior plugin", "skill completion behavior", "plugin output style", "agentic loop summary", "suppress task summary skill", "keep coding frontmatter", "plugin keep coding"

**Redundancy triggers**: "/recap", "recap command", "away summary", "session recap", "CLAUDE_CODE_ENABLE_AWAY_SUMMARY", "return session context", "session summary on return", "what were we doing", "session context refresh", "desktop app redesign", "multi-session sidebar", "parallel sessions UI", "integrated terminal claude", "drag-drop workspace", "diff viewer faster", "claude desktop v2.1.108", "session sidebar", "claude -n", "session naming", "name session", "named session resume", "/teleport", "/remote-env", "cross-device session", "session bridge web cli", "Ctrl+B", "background agent keyboard", "Ctrl+B backgrounding", "ExitWorktree", "exit worktree built-in", "worktree exit tool", "EnterWorktree ExitWorktree pair", "CLAUDE_CODE_DISABLE_CRON", "disable cron env var", "abort cron session", "stop cron jobs debug", "named subagents typeahead", "@ mention subagents", "agent completion", "/copy w key", "/copy write file", "copy write file key", "clipboard bypass", "/powerup", "powerup command", "feature tutorial command", "X-Claude-Code-Session-Id", "session id header", "api request session id", "proxy session tracking", "per-session cost tracking", "monitor tool", "background script streaming", "log streaming built-in", "/cost per model", "cost breakdown", "cache hit breakdown", "session title hook", "hookSpecificOutput sessionTitle", "auto-title session", "refreshInterval statusline", "live statusline", "accept edits auto-approve", "nvm auto-approve", "skill invocation name", "frontmatter name skill", "keep-coding-instructions", "post-task behavior plugin", "skill completion behavior", "plugin keep coding"

---

## Cloud Connections (claude.ai MCP Connectors)

| Capability | Status | Implementation |
|------------|--------|----------------|
| Gmail MCP | **ACTIVE (v2.1.89+)** | Authenticated via claude.ai web OAuth; appears automatically in CLI sessions. Tool: `mcp__claude_ai_Gmail__authenticate`. |
| Google Calendar MCP | **ACTIVE (v2.1.89+)** | Authenticated via claude.ai web OAuth; appears automatically in CLI sessions. Tool: `mcp__claude_ai_Google_Calendar__authenticate`. |
| Scholar Gateway MCP | **ACTIVE (v2.1.89+)** | Authenticated via claude.ai web OAuth. Tool: `mcp__claude_ai_Scholar_Gateway__authenticate`. |
| MCP `list_changed` Support | **ACTIVE (v2.1.89+)** | Claude Code handles `list_changed` notifications from MCP servers — dynamic tool registration after OAuth completes. Enables Gmail/Calendar tools to appear post-authentication mid-session. |

**claude.ai MCP Connectors** (v2.1.89, 2026-04-02):
- MCP servers authenticated via claude.ai web UI OAuth appear automatically in CLI sessions — no `~/.claude.json` config needed
- Connectors already showing in deferred tool list: Gmail, Google Calendar, Scholar Gateway, PubMed, Ashita Orbis blog
- **Authentication state**: Tools appear in deferred list = registered; full OAuth flow may still need verification
- **Direct relevance**: Scholar Gateway + PubMed enable research pipelines without manual API key setup

**MCP `list_changed` Notifications** (v2.1.89, 2026-04-02):
- Claude Code now handles `list_changed` notifications from MCP servers
- Effect: When an MCP server adds/removes tools after initial connection (e.g., after OAuth authentication), Claude Code refreshes its tool list dynamically
- **Enables**: Gmail/Calendar tools to become available mid-session after authentication without session restart
- **Relevant to**: Any MCP server that does conditional tool exposure based on auth state (Rube, Google connectors)

**Redundancy triggers**: "gmail mcp", "calendar mcp", "scholar gateway mcp", "pubmed mcp", "claude.ai oauth connectors", "web authenticated mcp", "claude.ai mcp cli", "mcp connectors cli", "list_changed", "list changed mcp", "dynamic tool registration", "mcp tool refresh", "post-auth tool list", "dynamic mcp tools", "mcp tools update notification", "mcp server notification"

---

## Session History Retrieval

| Capability | Status | Implementation |
|------------|--------|----------------|
| Context Librarian | **IMPLEMENTED** | `context-librarian` subagent — manual curation of knowledge from conversations |
| ccrider | **PENDING_GO_INSTALL** | TUI/CLI/MCP tool for cross-session history search. Score: 71.25/100. Requires Go installation (`sudo apt install golang-go`). Once installed: `go install github.com/neilberkman/ccrider@latest` + add MCP to `~/.claude.json`. |

**ccrider Details** (2026-04-01, PENDING_GO_INSTALL):
- **Three modes**: TUI browser, CLI scripting, MCP server (Claude queries history autonomously)
- **Unique capability**: Retrieves raw unstructured session transcripts — complementary to Context Librarian (curated extracts)
- **Blocked on**: Go installation (not present on requiem)
- **Install path**: `sudo apt install golang-go`, then `go install github.com/neilberkman/ccrider@latest`
- **MCP config**: Add `ccrider` to `~/.claude.json` mcpServers after binary install
- **Session archive**: ~4.2GB at `~/claudeworkspace/archived/session-transcripts/` — primary search target

**Redundancy triggers**: "ccrider", "session history search", "session transcript retrieval", "cross-session search", "context recovery history", "session archive search", "prior session retrieval", "session TUI", "session MCP", "session browser"

---

## Remote Machine Access

| Capability | Status | Implementation |
|------------|--------|----------------|
| Claw MCP (SSH) | **PENDING_GO_INSTALL** | Native Claude tools (bash/read/write/edit/grep/glob) over SSH. Score: 73.0/100. Requires Go. Once installed: `go install github.com/opsyhq/claw@latest`, then `claw init --from-ssh`. |

**Claw MCP Details** (2026-04-01, PENDING_GO_INSTALL):
- **Capability**: Deploy native Claude Code tools on any SSH-reachable machine — no open ports, no daemons, no root
- **Direct use case**: Operate on EC2/staging (the finance app at `<staging-host>`) without manual SSH + context transfer
- **Auto-imports**: `claw init --from-ssh` reads `~/.ssh/config` to discover all machines
- **Blocked on**: Go installation (not present on requiem)
- **Install path**: `sudo apt install golang-go`, then `go install github.com/opsyhq/claw@latest`
- **Technique doc**: `library/techniques/claw-mcp-ssh-remote-tools-2026-04-01.md`

**Redundancy triggers**: "claw mcp", "ssh mcp", "remote machine tools", "remote claude tools", "ssh remote execution mcp", "ec2 mcp", "staging server mcp", "remote file access mcp", "native tools over ssh", "opsyhq claw", "claw init ssh"

---

## Quick Redundancy Check Process

```
1. Extract keywords from discovery
2. Search this document for matching "Redundancy triggers"
3. If match found:
   - Check if capability is "IMPLEMENTED" or "BUILT-IN"
   - If yes → REDUNDANT, skip research
   - If "PLANNED" or "DOCUMENTED" → May still add value
4. If no match → Proceed with evaluation
```

---

## Adding New Capabilities

When a capability is integrated, add it here:
1. Find the appropriate category (or create new)
2. Add row with Status and Implementation location
3. Add relevant redundancy triggers
4. Update "Last Updated" date

---

## Cloud Compute

| Capability | Status | Implementation |
|------------|--------|----------------|
| Google Colab MCP | **PENDING_AUTH** | `googlecolab/colabtools` — Cloud GPU execution (T4/A100/TPU) via official Google MCP. Requires Google account OAuth setup. Config in `~/.claude/agent-workspace/.mcp.json` once auth verified. |

**Google Colab MCP** (2026-03-21, Score: 74.75/100):
- Official Google MCP server from `googlecolab/colabtools`
- Key tools: `execute_code` (run Python on cloud GPU), `connect` (attach to existing Colab session), notebook editing (create/modify .ipynb)
- Free tier: T4 GPU with idle timeout; Pro/Pro+ available ($10-50/month)
- Auth: Google account OAuth — one-time setup required before use
- Use cases: ML training runs, the gacha game asset generation, image-gen-mcp enhancement
- **Status**: Approved (74.75/100) but deferred to `PENDING_AUTH` — add to workspace `.mcp.json` after completing OAuth setup
- Integration target: add to `~/claudeworkspace/.mcp.json` after auth test

**Redundancy triggers**: "colab MCP", "google colab", "cloud GPU", "T4 GPU", "A100", "TPU", "notebook MCP", "cloud compute MCP", "jupyter GPU", "remote code execution MCP", "ML training MCP"

---

## Techniques & Patterns

| Capability | Status | Implementation |
|------------|--------|----------------|
| Thin Training Data Compensation | **IMPLEMENTED** | Three-component pattern: language spec + lazy-loaded docs + quirks database. `library/techniques/thin-training-data-compensation.md` + `~/.claude/skills/godot-development/SKILL.md` |
| Prune-Constraints Principle | **DOCUMENTED** | Anthropic-sourced architecture principle: continuously prune scaffolding as Claude's native capabilities advance. Add Section 6 to `~/.claude/skills/advanced-tool-use/SKILL.md`. Full technique: `library/techniques/anthropic-prune-constraints-principle-2026-04-04.md` |

**Thin Training Data Compensation** (2026-03-21, Score: 75.0/100):
- Source: `htdt/godogen` (Godot 4 game generation via Claude Code skills)
- Three-component architecture for niche/thin-training domains:
  1. **Language spec**: hand-written spec with domain quirks/idioms the model gets wrong
  2. **Lazy-loaded API docs**: on-demand documentation loaded only when needed (avoids context bloat)
  3. **Quirks database**: catalog of known model failure modes specific to the domain
- Portable beyond GDScript: Rust async lifetimes, Solidity, emerging MCPs, any thin-data domain
- Primary application: Godot 4 / GDScript for games pipeline (the gacha game, autonomous-gamedev)
- Full technique: `library/techniques/thin-training-data-compensation.md`
- Applied skill: `~/.claude/skills/godot-development/SKILL.md`

**Redundancy triggers**: "thin training data", "domain knowledge compensation", "quirks database", "lazy-loaded docs", "niche language skill", "LLM hallucination prevention", "domain-specific skill", "GDScript quirks", "Godot skill", "godogen", "language spec pattern", "model failure modes", "weak training domain"

**Prune-Constraints Principle** (2026-04-04, Score: 80.25/100):
- Source: Anthropic engineering blog (`claude.com/blog/harnessing-claudes-intelligence`)
- **Core principle**: As Claude's intelligence advances, continuously prune scaffolding that compensates for limitations Claude no longer has. Ask "what can I stop doing?" not "what can I add?"
- **Application**: Audit agents, skills, and hooks periodically — remove layers that Claude can now do natively. When a capability becomes built-in, retire the workaround.
- **Companion pattern — Progressive Context Loading**: Structure skill files with a compact overview section first; Claude loads full details only when the task requires them. Pattern already present in `mcp-search-framework` (decision tree first, details second).
- **Action item**: Add Section 6 (Maintenance Philosophy) to `~/.claude/skills/advanced-tool-use/SKILL.md`
- **Technique doc**: `library/techniques/anthropic-prune-constraints-principle-2026-04-04.md`

**Redundancy triggers**: "prune constraints", "prune-constraints principle", "remove scaffolding", "retire workaround", "capability regression check", "what to stop doing", "skill bloat audit", "agent obsolescence", "scaffolding reduction", "native capability migration", "progressive context loading", "overview section first", "compact skill structure", "skill overview pattern"

---

## DevOps & Infrastructure (Evaluated 2026-02-06)

No DevOps MCPs currently integrated. All evaluated items depend on platforms we don't use.

### Monitoring & Observability

| MCP | Score | Status | Reason |
|-----|-------|--------|--------|
| Grafana MCP (official, 2.2k stars) | 64.5 | **FUTURE** | Excellent but requires Grafana instance we don't have |
| Datadog MCP (community, 125 stars) | 46.0 | **REJECTED** | Don't use Datadog; community-maintained; Grafana MCP is stronger |

### Infrastructure as Code

| MCP | Score | Status | Reason |
|-----|-------|--------|--------|
| Terraform MCP (official, 1.2k stars) | 70.75 | **FUTURE** | Registry access useful but IaC adoption required for full value |
| Pulumi MCP (official, remote+local) | 64.0 | **FUTURE** | Loses to Terraform for AWS; interesting remote MCP pattern |

### CI/CD

| MCP | Score | Status | Reason |
|-----|-------|--------|--------|
| CircleCI MCP (official, 75 stars) | 51.25 | **REJECTED** | Don't use CircleCI; GitHub Actions is our CI/CD path |
| Buildkite MCP (official, 42 stars) | 50.0 | **REJECTED** | Don't use Buildkite; GitHub Actions is our CI/CD path |

### Version Control

| MCP | Score | Status | Reason |
|-----|-------|--------|--------|
| GitHub MCP (official, 26.7k stars) | 73.75 | **FUTURE** (deferred) | Token overhead concern substantially reduced by `--dynamic-toolsets` flag. Adoption triggers remain: GitHub Projects usage, gh CLI pain points, or enterprise OAuth need. |

**GitHub MCP Dynamic Toolsets** (v2.1.78 era, 2026-03-19):
- `--dynamic-toolsets` flag (or `GITHUB_DYNAMIC_TOOLSETS=1`) enables on-demand tool loading
- Token overhead reduced: only load tools for the operations being performed
- Updated score: 66/100 (Feb 2026) → 73.75/100 (Mar 2026) after this feature
- Install when trigger met: `docker run` with `--dynamic-toolsets` flag, add to `~/.claude.json` mcpServers
- **Adoption triggers** (unchanged): GitHub Projects heavy usage, gh CLI pain points, enterprise OAuth need

**GitHub MCP Secret Scanning** (March 17, 2026):
- New tool in GitHub MCP server: checks code changes for exposed credentials before commit/PR
- 160+ detectors (28 new in March 2026: Lark, Vercel, Snowflake, Supabase, and 11 others)
- 39 detectors with push protection enabled by default (Airtable, Databricks, Heroku, PostHog, Shopify)
- Complementary to Semgrep (which scans during code generation); this scans at commit/PR stage
- **No adoption action**: GitHub MCP remains FUTURE. This feature strengthens the security value proposition when triggers are met — enable from day one alongside `--dynamic-toolsets`

**Adoption Triggers**:
- If we adopt Grafana → promote Grafana MCP (strongest monitoring option)
- If we adopt Terraform → promote Terraform MCP (strongest IaC option)
- If we need CI/CD MCP → research GitHub Actions MCP first (matches our platform)
- If we adopt GitHub MCP → enable `--dynamic-toolsets` flag from day one

**Redundancy triggers**: "grafana mcp", "prometheus mcp", "loki mcp", "observability mcp", "monitoring mcp", "datadog mcp", "terraform mcp", "infrastructure as code mcp", "IaC mcp", "pulumi mcp", "circleci mcp", "buildkite mcp", "CI/CD mcp", "pipeline mcp", "devops mcp", "github mcp", "github mcp server", "github mcp dynamic toolsets", "dynamic-toolsets flag", "GITHUB_DYNAMIC_TOOLSETS", "github api mcp", "github projects mcp"

---

## Programmatic Agent Building

| Capability | Status | Implementation |
|------------|--------|----------------|
| claude-agent-sdk | **DOCUMENTED** | `@anthropic-ai/claude-agent-sdk` (TypeScript) / `claude-agent-sdk` (Python) — official Anthropic SDK for running agent loops programmatically |

**claude-agent-sdk** (2026-03-16, Score: 77/100):
- Official Anthropic rename from `@anthropic-ai/claude-code` SDK mode to `@anthropic-ai/claude-agent-sdk`
- Core API: `query()` async generator that runs the full Claude agent loop programmatically
- Key capabilities vs Claude Code CLI: in-process hooks (callbacks, not shell scripts), inline subagent definitions (not .md files), per-query MCP connections (not global config), session resume via `sessionId`
- Documentation: `~/.claude/skills/claude-api/SKILL.md` (includes both claude-agent-sdk and direct Anthropic SDK patterns)
- **Important**: Max plan has no `ANTHROPIC_API_KEY` — use `claude -p` CLI for in-script calls, not this SDK directly
- Adoption trigger: When building external apps that run agent loops, test harnesses with isolated sessions, or automation pipelines requiring in-process hook callbacks

**Migration**: `@anthropic-ai/claude-code` (SDK mode only) → `@anthropic-ai/claude-agent-sdk` (API-compatible rename)

**Redundancy triggers**: "claude-agent-sdk", "claude-code-sdk", "programmatic agent", "query() sdk", "agent loop sdk", "anthropic agent sdk", "programmatic claude loop", "in-process hooks", "sdk session resume", "anthropic/claude-agent-sdk"

---

## API Features (Anthropic Platform)

These features are available via Anthropic's API but not directly accessible in Claude Code CLI. Documented for awareness and future API-based tooling.

| Feature | Status | Model | Details |
|---------|--------|-------|---------|
| Compaction API | **AVAILABLE** | Opus 4.6 | Server-side context compaction at configurable thresholds (50k-200k tokens) |
| Data Residency Controls | **AVAILABLE** | Opus 4.6+ | `inference_geo` parameter for GDPR/compliance (eu, us, uk, auto) |

**Compaction API** (Beta: `compact-2026-01-12`):
- Automatic summarization when approaching context window limits
- Trigger threshold: min 50k, default 150k, max 200k tokens
- Custom instructions: Override default summarization prompt
- Streaming support: Compaction block streams differently
- Token tracking: Must sum `usage.iterations` array for billing
- Use case: Infinite conversations without manual summarization
- Evaluation: 94.75/100 (approved 2026-02-06)

**Data Residency Controls** (GA):
- API parameter: `inference_geo` (values: likely eu/us/uk/auto)
- Purpose: Specify inference location for GDPR/data sovereignty compliance
- Pricing: Unknown (likely no difference)
- Use case: EU projects (GDPR), financial services, healthcare
- Evaluation: 82.5/100 (approved 2026-02-06)

**Adoption Trigger**: If we build API-based automation (heartbeat scripts, custom integrations), revisit these features.

**Redundancy triggers**: "compaction api", "context_management parameter", "server-side compaction", "infinite conversation", "structured summarization", "compact_20260112", "data residency", "inference geo", "GDPR compliance", "data sovereignty", "region control", "geo control", "inference location"

---

## Future Capabilities (Requires Platform/Version Upgrades)

These capabilities are approved but cannot be integrated immediately due to missing prerequisites.

### MCP Apps Extension

| Feature | Status | Blocker | Adoption Trigger |
|---------|--------|---------|------------------|
| MCP Apps | **APPROVED** (80.25/100) | Requires UI development | When building evolution dashboard |

**Details**:
- Official Anthropic MCP extension (production-ready, Jan 2026)
- Interactive UI components in conversations (dashboards, forms, visualizations)
- Sandboxed iframes with bidirectional JSON-RPC
- Supported: Claude (web/desktop), ChatGPT, VSCode Insiders, Goose
- Use cases: Evolution dashboard, MCP config wizards, interactive registry browser
- Package: `@modelcontextprotocol/ext-apps`
- Evaluation: `pipeline/evaluation/completed/mcp-apps-extension-evaluation.md`

### Workflow Automation

| MCP | Status | Blocker | Adoption Trigger |
|-----|--------|---------|------------------|
| n8n-mcp | **APPROVED** (76.75/100) | Requires n8n instance | If we adopt n8n for workflow automation |

**Details**:
- 525+ n8n nodes with schema validation
- 45 min → 3 min workflow creation (author's testing)
- Complements Rube MCP (deep n8n expertise vs broad coverage)
- Official Vercel package, 13k stars
- Requires n8n instance (self-hosted or cloud)
- Token overhead: 10-15k without Tool Search, ~500-1k with Tool Search
- Evaluation: `pipeline/evaluation/completed/n8n-mcp-evaluation.md`

### Framework Integration

| MCP | Status | Blocker | Adoption Trigger |
|-----|--------|---------|------------------|
| next-devtools | **APPROVED** (87.25/100) | Requires Next.js 16+ | After upgrading the finance app to Next.js 16 |

**Details**:
- Official Vercel package for Next.js development tools
- Runtime diagnostics via `/_next/mcp` endpoint
- Automated Next.js 16 upgrades with codemods
- Cache Components setup automation
- Current blocker: the finance app uses Next.js 15.1.3
- Package: `next-devtools-mcp@latest`
- Evaluation: `pipeline/evaluation/completed/next-devtools-mcp-evaluation.md`

### Official Vendor Documentation

| MCP | Status | Blocker | Adoption Trigger |
|-----|--------|---------|------------------|
| Google Developer Knowledge API | **APPROVED** (84.25/100) | Public preview (awaiting GA) | GA announcement with installation details |

**Details**:
- Official Google MCP providing programmatic access to Firebase, Android, Google Cloud documentation
- Markdown-formatted responses with semantic search across Google's entire doc corpus
- First official vendor documentation integration
- 24-hour re-indexing during public preview
- Future plans: Structured content (code samples, API references), expanded coverage, reduced latency
- Use cases: Real-time documentation during Google Cloud work, API reference lookup, troubleshooting
- Source: https://developers.googleblog.com/introducing-the-developer-knowledge-api-and-mcp-server/ (2026-02-04)
- Evaluation: `pipeline/evaluation/completed/google-developer-knowledge-api-mcp-integrated.md`

**Why Important**:
- Authoritative source (first-party Google)
- Keeps AI tools current with API changes
- Broad coverage (Firebase, Android, Google Cloud)
- Complements existing search tools (Brave/Exa) with official structured access

### Cloud VM/GPU Provisioning

| Tool | Status | Blocker | Adoption Trigger |
|------|--------|---------|------------------|
| CloudRouter | **FUTURE** (65.25/100) | Opaque pricing, no GPU use case | If we need isolated cloud compute or GPU workloads |

**Details**:
- CLI + skill for agent VM/GPU provisioning (E2B/Modal backends)
- 851 stars, MIT license, active development (132 releases)
- GPU tiers: T4 through H100/B200
- Blocker: No public pricing, undocumented credential management
- Alternative: SSH to cloud VM (zero cost, full control)
- Evaluation: `pipeline/evaluation/completed/feb-15-17-batch-evaluation.md`

**Redundancy triggers**: "mcp apps", "interactive UI MCP", "dashboard MCP", "iframe extension", "rich UI conversations", "n8n mcp", "workflow automation mcp", "n8n integration", "next devtools", "next.js mcp", "next.js 16", "vercel devtools", "runtime diagnostics mcp", "google developer knowledge", "google documentation mcp", "firebase mcp", "android mcp", "google cloud documentation", "cloudrouter", "vm provisioning", "gpu provisioning", "cloud vm for agents", "agent sandbox", "e2b", "modal compute"

---

## Workflow Patterns

| Capability | Status | Implementation |
|------------|--------|----------------|
| Persistent File-Based Planning | **IMPLEMENTED** | `~/.claude/skills/planning-with-files/SKILL.md` |
| Spec-Driven Development | **DOCUMENTED** | `~/.claude/CLAUDE.md` ## Development Workflow section |
| Wrap-Up Ritual | **DOCUMENTED** | `~/.claude/CLAUDE.md` ## Wrap-Up Ritual section |
| 80/20 AI Coding Ratio | **DOCUMENTED** | `~/.claude/CLAUDE.md` ## AI Coding Philosophy section |

**Persistent File-Based Planning** (2026-02-06):
- Markdown files as persistent working memory (filesystem = disk, context = RAM)
- Files: `task_plan.md`, `findings.md`, `progress.md`
- Auto-recovery after `/clear` or session crashes
- Source: OthmanAdi/planning-with-files (Manus pattern, $2B Cursor acquisition)
- Score: 82/100

**Spec-Driven Development** (2026-02-06):
- Multi-phase workflow: Requirements → Design → Tasks → Implementation
- Phase gate reviews (3 documents vs 50 approval prompts)
- Autonomous implementation after plan approval
- Source: Pimzino/claude-code-spec-workflow, gotalab/cc-sdd
- Score: 75/100

**Wrap-Up Ritual** (2026-02-06):
- Session-end handoff protocol for multi-session continuity
- Document state, explicit next steps, trigger at 70-85% context
- Source: rohitg00/pro-workflow
- Score: 76/100

**80/20 AI Coding Ratio** (2026-02-06):
- Philosophy: Let AI write 80% of code, human reviews 20%
- Batch workflow: Generate → Review → Correct
- Trust calibration through repeated validation
- Source: rohitg00/pro-workflow
- Score: 76.5/100

**Redundancy triggers**: "persistent planning", "markdown files", "working memory", "Manus pattern", "filesystem storage", "spec-driven", "phase gates", "requirements design tasks", "structured development", "wrap-up ritual", "session handoff", "multi-session workflow", "80/20 ratio", "batch review", "autonomous generation"

---

## Knowledge Graph Systems

| Capability | Status | Implementation |
|------------|--------|----------------|
| Graphiti Knowledge Graph | **FUTURE** | Neo4j Docker + MCP integration pending |

**Graphiti Knowledge Graph** (2026-02-06):
- Real-time knowledge graphs with bi-temporal data model
- Tracks entity relationships + occurrence time + ingestion time
- Hybrid retrieval: semantic embeddings + BM25 + graph traversal
- Native MCP server ready
- Blocker: Requires Neo4j graph database setup
- Use case: Track capability dependencies, integration history, agent interaction patterns
- Source: https://github.com/getzep/graphiti (22.6k stars)
- Score: 81/100

**Why Future**: Requires Docker Neo4j + ontology design. Integration path documented but deferred pending infrastructure setup.

**Redundancy triggers**: "knowledge graph", "graphiti", "neo4j mcp", "temporal graph", "relationship tracking", "bi-temporal data"

---

## Behavioral Learning Systems

| Capability | Status | Implementation |
|------------|--------|----------------|
| Hindsight Agent Memory | **DOCUMENTED** | External Docker service pattern |

**Hindsight Agent Memory** (2026-02-06):
- Behavioral learning from execution failures via Reflect operation
- Three-layer architecture: World facts, personal experiences, mental models
- Four parallel recall strategies with reciprocal rank fusion
- Production deployments at Fortune 500
- Status: Documented for awareness, requires Docker + API wrapper integration
- Source: https://github.com/vectorize-io/hindsight (1.3k stars)
- Score: 75/100

**Complementarity**:
- Official Memory: "Remember API uses JWT" (factual recall)
- Agent Memory: "Last discovery run at 10:00" (state)
- ACE Framework: "Evaluate token overhead first" (strategy)
- Hindsight: "After 10 auth failures, learned to check credentials first" (behavioral learning)

**Redundancy triggers**: "hindsight", "behavioral learning", "reflect operation", "agent learning from failure", "execution feedback learning"

---

## Research Reports & Best Practices

| Resource | Status | Location |
|----------|--------|----------|
| 2026 Agentic Coding Trends (Anthropic) | **DOCUMENTED** | `library/techniques/agentic-coding-trends-2026.md` |
| Agentic Engineering Patterns (Simon Willison) | **IMPLEMENTED** | `library/techniques/agentic-engineering-patterns.md` |

**2026 Agentic Coding Trends Report** (2026-02-06):
- Anthropic research: developers integrate AI into 60% of work
- Strategic priorities: multi-agent coordination, oversight scaling, extending beyond engineering, security architecture
- Case studies: Rakuten (12.5M LOC, 7h autonomous, 99.9% accuracy), TELUS (13k+ solutions, 30% faster)
- Source: https://resources.anthropic.com/hubfs/2026%20Agentic%20Coding%20Trends%20Report.pdf
- Score: 76/100

**Use Case**: Validate evolution system aligns with Anthropic 2026 best practices.

**Redundancy triggers**: "agentic coding trends", "anthropic research 2026", "multi-agent coordination best practices", "human-agent oversight"

---

**Agentic Engineering Patterns Guide** (2026-02-24, updated 2026-03-12):
- Living guide by Simon Willison (Django co-creator, 1M+ followers, high-signal AI practitioner)
- Key framing: "Writing code is cheap" — inverts traditional developer intuitions
- Pattern areas: code-as-architecture prompt discipline, iterative refinement, validate-before-trust, human-in-the-loop at decision points
- **Linear Walkthroughs** (chapter added 2026-02-25): prompt for narrative code walkthrough before extending unfamiliar/AI-generated code; use "Provide a linear walkthrough of the code that explains how it all works in detail"
- **Anti-Patterns** (chapter added 2026-03-07): "Don't inflict unreviewed code on collaborators" — submitting large AI-generated PRs without testing/review is a liability. Extends validate-before-trust from the submission angle.
- **Annotated Prompts** (chapter added 2026-03-07): Real-world worked examples with exact prompts (first example: GIF compression web UI with WebAssembly/Gifsicle).
- **Behavioral Compatibility Rewrite** (chapter added 2026-03-12): Test-first workflow for rewriting libraries from scratch while preserving behavioral compatibility. Write tests against original → implement from scratch against those tests. Source: https://simonwillison.net/2026/Mar/5/chardet/. Score: 69.75/100 (conditional approve). Integration: added as §9 in `library/techniques/agentic-engineering-patterns.md`.
- Complements existing patterns: 80/20 AI Coding Philosophy, TDD skill, iterative-improve skill, spec-driven-dev skill
- Source: https://simonwillison.net/2026/Feb/23/agentic-engineering-patterns/
- Score: 77.5/100 (Claude 73.5 + Codex 81.5); Linear Walkthroughs extension: 80/100; Behavioral Compatibility Rewrite: 69.75/100
- **90-day re-check**: 2026-05-25 (living guide, new chapters published periodically)

**Redundancy triggers**: "agentic engineering patterns", "writing code is cheap", "Simon Willison patterns guide", "prompt as architecture", "validate before trust", "Willison agentic guide", "linear walkthrough", "codebase walkthrough", "code comprehension prompt", "linear walkthrough of the code", "anti-pattern", "unreviewed code", "inflicting code on collaborators", "annotated prompt example", "reviewed before PR", "clean-room rewrite", "behavioral compatibility rewrite", "test-first reimplementation", "library rewrite workflow", "license reimplementation"

---

**Piebald-AI/claude-code-system-prompts** (2026-03-30, ACTIVE):
- Repository tracking all of Claude Code's internal system prompts across 136+ versions since v2.0.14
- Updated to v2.1.87 (as of 2026-03-28) — includes: main system prompt, 18 tool descriptions, Plan/Explore/Task sub-agent prompts, compact/statusline/WebFetch/Bash utility prompts
- Use case: consult before writing new skills/agents to understand what Claude Code already knows by default — avoids duplicating or contradicting built-in context
- Zero maintenance (Piebald-AI maintains independently)
- URL: https://github.com/Piebald-AI/claude-code-system-prompts
- Score: 74/100.

**Redundancy triggers**: "piebald", "claude-code-system-prompts", "internal system prompt", "built-in prompt tracker", "system prompt changelog", "tool description tracking", "sub-agent prompt", "Claude Code internals tracking"

---

## Voice Input

**Status**: IMPLEMENTED (GA as of 2026-04-13 — upgraded from EARLY_PREVIEW)
**Source**: https://code.claude.com/docs/en/voice-dictation (official Anthropic docs)
**Evaluation score**: 75/100 (Claude 78 + Codex 72)
**Date evaluated**: 2026-03-04 | **Status upgraded**: 2026-04-13

| Capability | Implementation | Notes |
|------------|---------------|-------|
| Voice input for Claude Code | `/voice` built-in command | Fully available (no longer rollout) |
| Push-to-talk keybinding | `~/.claude/keybindings.json` `voice:pushToTalk` | Rebindable |
| Settings opt-in | `voiceEnabled` setting key | Enable/disable in settings.json |
| Language support | 20 languages via STT | Includes Russian, Polish, Turkish, Dutch, Ukrainian, Greek, Czech, Danish, Swedish, Norwegian (added v2.1.69) |

**What it does**: Allows spoken input to Claude Code via built-in `/voice` command. Push-to-talk mode, 20-language STT, configurable keybinding. Hands-free CLI workflows; accessibility improvement.

**Config** (optional):
```json
// ~/.claude/keybindings.json
{ "voice:pushToTalk": "ctrl+alt+v" }
```

**Redundancy triggers**: "Claude Code voice mode", "/voice command", "voice input CLI", "hands-free coding Claude", "speech input Claude Code", "voice dictation", "push-to-talk Claude"

---

## Categories Not Yet Covered

These are areas where we DON'T have strong capabilities yet:
- Video analysis
- Real-time collaboration
- Mobile app testing
- **DevOps/Infrastructure** (evaluated 2026-02-06 - no platform match, see section above)
- **Workspace/Productivity** — Google Workspace CLI MCP (`gws`) approved 74/100, deferred to the revenue pipeline's revival. See `pipeline/future/google-workspace-cli-mcp-2026-03-07.md`

**Database Operations are COVERED** (as of 2026-01-26):
- See "Database Operations" section below for full details

**Recently Addressed** (2026-01-15):
- ✅ Version control automation: `using-git-worktrees` skill NOW INTEGRATED
- ✅ TDD enforcement: `tdd-guard` hooks + `test-driven-development` skill NOW INTEGRATED
- ✅ Parallel agent patterns: `dispatching-parallel-agents` skill NOW INTEGRATED
- ✅ Auto-skill generation: `skill-seekers` CLI NOW INSTALLED

**Still Addressable via Skills Ecosystem** (see audit):
- Infrastructure as Code: `SecOpsAgentKit` has IaC security skills
- CI/CD automation: `claude-code-security-review` GitHub Action workflow (different from slash command)

---

## External Tools (Approved, Pending Integration)

| Tool | Status | Stars | Purpose | Installation |
|------|--------|-------|---------|--------------|
| Claude Squad | **APPROVED** | 5.6k | Multi-agent management with tmux + git worktrees | `brew install claude-squad` |

**Claude Squad Details**:
- Evaluated: 2026-01-15, Score: 71.5/100
- Complements `using-git-worktrees` and `dispatching-parallel-agents` skills
- External tool = no token cost
- Use case: Parallel capability discovery, multi-model workflows

**Redundancy triggers**: "multi-agent management", "tmux agents", "parallel claude instances", "agent supervisor"

### Google Workspace CLI MCP (`gws`)

| Tool | Status | Score | Purpose | Installation |
|------|--------|-------|---------|--------------|
| `@googleworkspace/cli` | **FUTURE** | 74/100 | Gmail, Drive, Calendar, Sheets, Docs via MCP | `npm install -g @googleworkspace/cli` |

- **GitHub**: https://github.com/googleworkspace/cli
- Personal Gmail works (needs Google Cloud OAuth project, ~45 min setup)
- Compact mode: ~26 tools (vs 200-400 full). Use `-s gmail,drive,sheets` to limit services
- **Caveat**: v0.8.0 removed `mcp` subcommand — pin to v0.7.x or wait for clarification
- **Deferred to**: revenue pipeline reactivation
- **Third-party alternative**: `taylorwilsdon/google_workspace_mcp` (Python, separate project)

**Redundancy triggers**: "google workspace mcp", "gmail mcp", "google drive mcp", "google calendar mcp", "google sheets mcp", "google docs mcp", "workspace cli", "gws cli", "gws mcp", "email mcp server", "taylorwilsdon google workspace"

---

## Opus 4.6 Model Capabilities (2026-02-05)

| Capability | Status | Detail |
|------------|--------|--------|
| 1M Token Context | **IMPLEMENTED (DEFAULT)** | GA 2026-03-13, automatic on Max/Team/Enterprise, standard pricing |
| 128k Output Tokens | **AVAILABLE** | Extended output generation |
| Adaptive Thinking | **BUILT-IN** | Auto-calibrates thinking depth |
| Effort Controls | **AVAILABLE** | API: low/medium/high/max |
| Agent Teams | **EVALUATING** | Research preview, experimental flag |
| Context Compaction (configurable) | **BUILT-IN** | Configurable threshold |
| Fast Mode | **IMPLEMENTED** | 2.5x faster inference, 6x cost (3x promo until Feb 16, 2026) |

**Fast Mode Details**:
- **Announced**: Feb 7, 2026
- **Integrated**: Feb 8, 2026 (documentation added to `~/.claude/CLAUDE.md`)
- **How to use**: Type `/fast` in CLI or use `model: "claude-opus-4-6-fast"` in API
- **Speed improvement**: 2.5x faster inference
- **Cost**: Standard 6x multiplier, promotional 3x until Feb 16, 2026
- **Use cases**: Interactive sessions, demos, time-sensitive debugging, user-facing apps
- **Avoid**: Batch jobs, cost-sensitive workflows, non-time-critical tasks, research
- **Usage guideline**: Reserve for specific high-priority tasks only

**Benchmark highlights**: GDPval-AA +144 Elo over GPT-5.2, Terminal-Bench 2.0 highest, BigLaw Bench 90.2%

**Redundancy triggers**: "opus 4.6", "1m context", "agent teams", "adaptive thinking", "effort controls", "context compaction", "fast mode", "faster inference", "speed optimization", "quick response"

---

## Rejected Discoveries (2026-01-24 - Final)

For reference, these were evaluated and rejected:

| Discovery | Score | Rejection Reason |
|-----------|-------|------------------|
| Claude Flow (ruvnet) | 56.25 | 100 MCP tools = 10-15k token overhead; 75% overlap with evolution-orchestrator + Task tool; Tool Search Tool 95% more efficient; better deployed externally |
| Taskmaster MCP | 50.5 | Makes API calls = ongoing cost; TodoWrite is free and sufficient |
| task-orchestrator | 60.5 | High overlap with TodoWrite + batch-orchestrator; low stars (144) |
| claude-code-mcp (steipete) | 23.5/100 | **RECURSIVE REDUNDANCY**: MCP wrapper of Claude Code run inside Claude Code = pointless; Task tool provides agent-in-agent natively with zero overhead; creates Claude Code → MCP → Claude Code loop; added token cost from serialization |
| claude-code-templates (davila7) | ~65/100 | 600+ generic starter templates; 90%+ redundant with existing custom agents/skills/hooks; agent definitions lack lifecycle, memory, spawn restrictions; worth extracting: `secret-scanner.py` (40+ credential regex patterns) and deep-research-team pattern |
| HCOM (aannoo) | 64.5 | Hook system fragility; low stars (41); Task tool returns results already |
| Datadog MCP (winor30) | 46.0 | Don't use Datadog; community-maintained; Grafana MCP stronger |
| CircleCI MCP | 51.25 | Don't use CircleCI; GitHub Actions is our CI/CD path |
| Buildkite MCP | 50.0 | Don't use Buildkite; GitHub Actions is our CI/CD path |

Full evaluations: `discoveries/rejected/`

---

## External Tools (Integrated)

| Tool | Status | Stars | Purpose | Command |
|------|--------|-------|---------|---------|
| Claude Squad | **INSTALLED** | 5.6k | Multi-agent management with tmux + git worktrees | `cs` |
| CodeBurn | **DOCUMENTED** | Show HN validated | Task-level token cost analytics TUI — 13 categories, one-shot success rate | `codeburn` |

**Claude Squad Details**:
- Version: 1.0.14
- Location: `~/.local/bin/cs`
- Prerequisites: tmux, gh (both installed)
- Usage: `cs` to launch TUI, `cs -p "claude"` to spawn Claude agents

**Use Cases**:
- Parallel capability discovery (multiple Claude instances searching different sources)
- Multi-model workflows (Claude + Codex + Aider in parallel)
- Supervised parallel development (human reviews work before shipping)

**Redundancy triggers**: "multi-agent management", "tmux agents", "parallel claude instances", "claude squad"

**CodeBurn Details** (2026-04-21, Score: 71.0/100):
- **Install**: `npm install -g codeburn` (zero configuration)
- **What it does**: Reads `~/.claude/projects/` JSONL session transcripts, classifies every interaction into 13 deterministic categories (no LLM calls — pure pattern matching on tool usage), shows token/cost breakdown by task type, tool, model, MCP server, project, and one-shot success rate per activity
- **Complementary to ccusage**: ccusage = cost-per-day. CodeBurn = cost-per-task-type. The 13 categories expose WHICH activities are expensive (e.g., discovery runs vs integration vs code review) — actionable for heartbeat cost optimization
- **Cross-platform**: Claude Code, Codex, Cursor, OpenCode, Pi, GitHub Copilot
- **Source**: https://github.com/getagentseal/codeburn, Show HN with positive reception, awesome-claude-code issue #1550
- **No equivalent**: First task-type cost analytics tool in registry

**Redundancy triggers**: "codeburn", "task-level cost", "token analytics TUI", "cost per task type", "13 categories token", "one-shot success rate", "JSONL session analytics", "task type cost breakdown", "ccusage complement", "activity cost breakdown", "token category analysis"

---

## Memory Solutions

**Current Status**: Official Memory System available in Claude Code 2.1.32+ (auto-records and recalls memories)

### Official Memory System (2.1.32+)

As of Claude Code 2.1.32, Claude has a built-in memory system that automatically records and recalls relevant memories as it works. This is zero-token-overhead and handles project isolation natively.

**Previous concerns (resolved):**
- Cross-project confusion: Handled natively by official system
- Auto-injection conflicts: Official system is context-aware
- Token overhead: Zero (built-in)

### MCP Memory Solutions (No Longer Needed)

| Solution | Status | Notes |
|----------|--------|-------|
| Official Memory System | **ACTIVE** | Built-in to Claude Code 2.1.32+, zero overhead |
| mcp-memory-service (doobidoo) | **NOT NEEDED** | Official system supersedes |
| claude-mem | **DEPRECATED** | Superseded by official system |

### Current Memory Stack

- **Official Memory System**: Auto-record/recall (2.1.32+)
- **CLAUDE.md files**: Project-specific context (always loaded)
- **Auto-memory directory**: `~/.claude/projects/*/memory/` for persistent notes
- **Library system**: `claude-evolution/library/` for archived learnings
- **Session persistence**: Native Claude Code session resume

**Redundancy triggers**: "mcp memory", "persistent memory mcp", "semantic memory", "cross-session memory", "memory plugin", "claude-mem"

---

## Claude Code v2.1.32 Features (2026-02-05)

Tracked features from Claude Code 2.1.10 through 2.1.32:

### Major Features

| Feature | Version | Purpose |
|---------|---------|---------|
| Official Memory System | 2.1.32 | Auto-records and recalls memories (replaces claude-mem) |
| Agent Teams (experimental) | 2.1.32 | Multi-agent parallel coordination (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) |
| Skills from --add-dir | 2.1.32 | Skills in additional directory `.claude/skills/` auto-loaded |
| Skill budget scales with context | 2.1.32 | 2% of context window (~20k chars with 1M) |
| Partial summarization | 2.1.32 | "Summarize from here" in message selector |
| PDF page ranges | 2.1.30 | `pages: "1-5"` parameter in Read tool |
| OAuth for MCP servers | 2.1.30 | `--client-id` and `--client-secret` with `claude mcp add` |
| `/debug` command | 2.1.30 | Claude helps troubleshoot current session |
| Task tool metrics | 2.1.30 | Token count, tool uses, duration in Task results |
| `--from-pr` flag | 2.1.27 | Resume sessions linked to specific PR number/URL |
| Content-level permissions | 2.1.27 | `ask: ["Bash(rm *)"]` overrides tool-level allow |
| CLAUDE.md from --add-dir | 2.1.20 | Load CLAUDE.md from additional dirs (`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`) |
| Task deletion | 2.1.20 | TaskUpdate tool can delete tasks |
| PR review status indicator | 2.1.20 | Colored dot in prompt footer showing PR state |

### Settings (from v2.1.9)

| Feature | Purpose | Usage |
|---------|---------|-------|
| `auto:N` threshold | Fine-tune MCP tool search trigger | `"mcpToolSearchAutoThreshold": "auto:5"` |
| `plansDirectory` | Centralize plan files | `"plansDirectory": "~/.claude/plans"` |
| PreToolUse `additionalContext` | Inject context per-tool | Hook returns `{"additionalContext": "..."}` |
| `${CLAUDE_SESSION_ID}` | Session ID in skills | String substitution in skill files |
| `spinnerVerbs` | Customizable spinner text | 2.1.23 |

**Redundancy triggers**: "auto:N", "plans directory", "additional context hook", "session id variable", "from-pr", "debug command", "pdf page ranges", "oauth mcp", "task metrics", "agent teams", "memory system", "skill budget"

---

## Anti-Patterns & Rejected Patterns

These are discovery patterns that have been evaluated and should be rejected on sight:

| Pattern | Score | Rejection Reason | Example |
|---------|-------|------------------|---------|
| Zero-functionality MCPs | 23.5/100 | Provides no capabilities by design, adds token overhead | Null MCP Server (2026-01-26) |
| Proof-of-concept without utility | <30/100 | Protocol compliance testing belongs in SDK examples, not user installs | Null MCP Server |
| MCP wrappers of built-in tools | <25/100 | 100% redundant, adds token overhead for existing functionality | Git MCP, Filesystem MCP |
| External orchestrators as internal MCPs | <60/100 | Designed for coordinating external instances, not internal tools | Claude Flow (51.75/100) |
| Recursive Claude Code wrappers | <25/100 | Creates pointless loops (Claude Code → MCP → Claude Code) | claude-code-mcp (23.5/100) |

**Redundancy triggers**: "null mcp", "noop server", "empty capability", "protocol compliance only", "proof of concept mcp", "testing mcp", "do nothing server"

**Evaluation Guidance**:
- If discovery is a proof-of-concept without operational utility → REJECT immediately
- If discovery wraps existing built-in tools → Check Filesystem/Git MCP evaluations, apply same logic
- If discovery creates recursive patterns → Validate whether it's designed for internal or external use

---

## Claude Code v2.1.58–v2.1.59 Features (2026-02-26)

### v2.1.58 (2026-02-25)

| Feature | Status | Notes |
|---------|--------|-------|
| Remote Control expansion | **EXPANDING** | Expanded from enterprise-only to more users (Pro/Max rollout); `--help` now shows help text without admin error |

### v2.1.59 (2026-02-26)

| Feature | Status | Notes |
|---------|--------|-------|
| Auto-memory `/memory` command | **ACTIVE** | Enhancement to existing memory system (2.1.32+); Claude now automatically saves useful context; `/memory` slash command for interactive management |
| `/copy` command | **ACTIVE** | Interactive picker for code blocks in responses; built-in slash command (v2.1.59+), zero config, interactive sessions only; evaluated 78.75/100 |
| Bash per-subcommand "always allow" | **ACTIVE** | Compound commands (e.g. `cmd1 && cmd2 && cmd3`) now analyzed per-subcommand for smarter "always allow" prefixes; automatic behavior improvement |
| Multi-agent memory optimization | **ACTIVE** | Completed subagent task state released automatically; reduces memory usage in parallel agent sessions |
| MCP OAuth race condition fix | **ACTIVE** | Fixed token refresh race condition when running multiple Claude Code instances simultaneously |

**Redundancy triggers**: "/copy command", "copy code block", "copy picker", "/memory command", "auto memory", "remote-control mobile", "bash compound allow", "per-subcommand prefix", "always allow compound"

---

## Prompt Optimization

| Capability | Status | Implementation |
|------------|--------|----------------|
| DSPy-inspired BootstrapFewShot | **IMPLEMENTED** | `lib/prompt_optimizer/bootstrap.py` |
| COPRO & Iterative Optimizers | **IMPLEMENTED** | `lib/prompt_optimizer/copro.py`, `iterative.py` |
| Holdout/Cross-Validation Verification | **IMPLEMENTED** | `lib/prompt_optimizer/verification.py` |
| Assertion-based Test Format | **IMPLEMENTED** | `lib/prompt_optimizer/metrics.py` — `assertion_metric()` |
| Model Drift Detection | **IMPLEMENTED** | `scripts/verify_optimizations.py` — `--check-model-drift` |
| Failure Analysis | **IMPLEMENTED** | `scripts/verify_optimizations.py` — `--analyze-failures` |

**Core System** (2026-01-26 to 2026-02-07):
- DSPy-style few-shot optimization: BootstrapFewShot, COPRO, Iterative algorithms
- 13 targets optimized (9 agents + 4 skills), 11 deployed
- Holdout evaluation, k-fold cross-validation, probe holdout for overfitting detection
- Phase 5 regularization: dropout, cross-validation during optimization
- Phase 6: demo transformer, format instructions for metric mismatch
- Plan quality metric with A/B testing (19 training + 6 holdout examples)

**Skills 2.0 Improvements** (2026-03-06):
- Assertion-based test format: JSON assertions as lightweight alternative to Python metrics
- Model tracking: `optimized_with_model` field on OptimizedPrompt, backfilled on all 13 targets
- `--check-model-drift` flag: warns when verification model differs from optimization model
- `--analyze-failures` flag: structured programmatic failure analysis (zero token cost)

**Skipped**: Tessl CI/CD (paid), auto-regression triggers (token budget)

**Redundancy triggers**: "prompt optimization", "DSPy", "BootstrapFewShot", "skill eval", "A/B testing skill", "assertion test", "model drift", "skill reliability testing", "benchmark skill", "prompt tuning"

---

## Claude Code v2.1.68 Features (2026-03-06)

### CLI & Agent Architecture

| Feature | Status | Notes |
|---------|--------|-------|
| `claude agents` CLI subcommand | **ACTIVE** | Built-in command to list and inspect custom agent definitions from CLI (v2.1.68+). Zero config, useful for automation scripts verifying agent inventory. Evaluated 80/100. |
| `isolation: worktree` agent frontmatter | **ACTIVE** | Declarative per-agent worktree isolation. Agent auto-gets isolated git worktree at spawn, auto-cleaned on finish. Enables safe parallel agents without manual setup. Active in: capability-discoverer, capability-evaluator. Evaluated 87/100. |

**`claude agents` Details**:
- Usage: `claude agents` (list all), `claude agents --help` (usage)
- Replaces: Manual `ls ~/.claude/agents/` filesystem browsing
- Use in heartbeat automation to validate agent inventory
- Pattern: registry entry only (like `/copy`, `/batch`, `/simplify`) — no skill file needed
- Integration type: built-in command, zero maintenance

**`isolation: worktree` Details**:
- Add to any agent that should run in isolation: `isolation: worktree` in frontmatter YAML
- Compatible with all other frontmatter fields (name, description, tools, memory, model)
- Distinct from WorktreeCreate/Remove hooks (those are lifecycle events, this is declarative)
- Automates the manual workflow described in `~/.claude/skills/using-git-worktrees/SKILL.md`
- Caveat (Codex): Edge cases in shallow-clone CI environments — test before relying on cleanup guarantee

**Redundancy triggers**: "claude agents command", "list agents cli", "agent introspection command", "agent listing tool", "list custom agents", "inspect agents cli", "agent inventory script", "isolation: worktree", "agent worktree isolation", "declarative worktree frontmatter", "automatic agent isolation", "per-agent git worktree", "worktree cleanup on finish"

---

## Claude Code v2.1.69 Features (2026-03-05)

| Feature | Status | Notes |
|---------|--------|-------|
| `/reload-plugins` command | **ACTIVE** | Reloads skill/plugin changes without restarting Claude Code. Iterate on skills and see changes immediately. |
| InstructionsLoaded hook | **ACTIVE** | See Hook Lifecycle section (fires after CLAUDE.md/skills loaded; v2.1.69+) |
| Hook agent metadata fields | **ACTIVE** | See Hook Lifecycle section (agent_id, agent_type, worktree in payloads; v2.1.69+) |

**`/reload-plugins` Details**:
- Run `/reload-plugins` after editing skill/agent/plugin files
- Replaces restart-session workflow for skill authoring
- Useful for rapid iteration on skill definitions, agent frontmatter, MCP configs

**Redundancy triggers**: "/reload-plugins", "reload plugins command", "hot-reload skills", "reload skill changes", "plugin hot reload"

---

## Claude Code v2.1.71 Features (2026-03-07)

| Feature | Status | Notes |
|---------|--------|-------|
| `/loop` command + Cron tools | **ACTIVE** | In-session recurring prompt scheduling. `/loop 5m prompt`. Programmatic: CronCreate/CronDelete/CronList tools. Session-scoped only. |

**`/loop` Details**:
- Usage: `/loop <interval> <prompt-or-command>` (e.g., `/loop 5m check deploy status`)
- CronCreate/CronDelete/CronList available as deferred tools (loaded on-demand by Tool Search)
- All scheduled tasks end when session closes
- NOT a replacement for external cron (heartbeats need persistence across sessions)
- Distinction: external cron creates new sessions; /loop runs within current session

**`/proactive` alias** (v2.1.105): `/proactive` is now a built-in alias for `/loop`. Identical functionality. Use either interchangeably in heartbeat scripts and documentation.

**Redundancy triggers**: "/loop command", "loop slash command", "CronCreate tool", "in-session cron", "recurring prompt", "session scheduling", "interval command", "CronDelete", "CronList", "/proactive", "proactive alias loop"

---

## Claude Code v2.1.77 Features (2026-03-17)

### Agent Continuation

| Feature | Status | Notes |
|---------|--------|-------|
| SendMessage auto-resume | **ACTIVE** | `SendMessage({to: agentId})` now automatically resumes stopped agents in background — no longer returns error on stopped agents. Simplifies long multi-agent pipelines. |
| Agent `resume` parameter removed | **BREAKING CHANGE** | The `Agent` tool's `resume` parameter is removed in v2.1.77. Previous pattern `Agent({resume: sessionId})` is now invalid. Use `SendMessage({to: agentId})` for all agent continuation. |

**Migration note**: Grep your agent definitions for `resume:` parameter usage. Confirmed: zero usage in `~/.claude/agents/` — no migration needed. For new code, use `SendMessage({to: agentId})` exclusively for agent continuation.

### Security Fix

| Feature | Status | Notes |
|---------|--------|-------|
| PreToolUse `allow` no longer overrides `deny` | **SECURITY FIX (BREAKING)** | Hook result `{"allow": true}` from PreToolUse no longer bypasses `deny` rules. If any rule denies the tool call, `allow` from a hook cannot override it. |

**Impact**: If your PreToolUse hooks return `{"allow": true}` assuming it overrides deny rules, those hooks now behave differently. Audit hooks that rely on `allow` result bypassing deny policies. The `additionalContext` hook result pattern is unaffected.

### Sandbox Filesystem Permissions

| Feature | Status | Notes |
|---------|--------|-------|
| `allowRead` sandbox setting | **ACTIVE** | Re-allows read access within `denyRead` regions. Enables "deny-first" permission models with specific path exceptions. |

**Pattern**:
```json
{
  "sandbox": {
    "denyRead": ["/etc", "/home", "~/.ssh"],
    "allowRead": ["/etc/timezone", "~/.claude"]
  }
}
```

Use for: heartbeat agents, iterative-improve, openclaw-sandbox — lock to least-privilege reads, whitelist only what the agent actually needs. No `~/.claude/settings.json` change needed until a specific sandboxing use case arises.

### Output Token Limits (Elevated)

| Model | Default Output | Upper Bound |
|-------|----------------|-------------|
| Opus 4.6 | 64k tokens | 128k tokens |
| Sonnet 4.6 | (unchanged) | 128k tokens |

Upper bound elevated from prior limits. Default for Opus 4.6 is now 64k (was lower). Applies to both interactive and API use.

**Behavioral rule — "Output & Large Artifacts"** (CLAUDE.md, integrated 2026-06-21, Score 71.75): Write large output to a file (Write tool) instead of inlining huge blocks; split genuinely multi-part output across messages. Prevents "output token maximum" API errors that have aborted whole sessions — especially in `claude -p`/headless runs where the harness may not auto-continue. NOVEL preventive *Claude-behavior* piece, distinct from the capacity facts above and from `Auto-Continuation on Token Limit` (v2.1.90+, harness-level/reactive). Integrated at `~/.claude/CLAUDE.md ## Output & Large Artifacts`. First surfaced /insights weekly 2026-06-21 (0 prior digest matches).

**Redundancy triggers**: "output token maximum", "output token max error", "inline large output", "write large output to file", "chunk large output", "huge block response", "500 output token maximum", "response too large", "output limit api error", "lost session output limit", "output and large artifacts"

### CLI & UX Improvements

| Feature | Status | Notes |
|---------|--------|-------|
| `/branch` command | **ACTIVE** | Replaces `/fork`. The `/fork` command is preserved as an alias for backward compatibility. |
| `/copy N` optional index | **ACTIVE** | `/copy` now accepts an optional index parameter to directly select a code block without interactive picker. |
| Auto-name sessions from plan content | **ACTIVE** | Sessions started with a plan are automatically named from the plan content. |
| Background bash 5GB kill limit | **ACTIVE** | Background bash processes consuming over 5GB are automatically killed. |
| `--resume` performance | **ACTIVE** | 45% faster resume, -150MB memory usage. |
| Stale-worktree cleanup race fix | **ACTIVE** | Race condition in stale worktree cleanup fixed. |

**Redundancy triggers**: "allowRead", "sandbox allowread", "sandbox denyRead exception", "filesystem allow within deny", "sandbox path exception", "agent filesystem permissions", "sandbox read permissions", "granular sandbox settings", "Agent resume parameter", "agent continuation v2177", "SendMessage auto-resume v2177", "PreToolUse allow override deny", "hook allow bypass deny", "pretooluse security fix", "output token limit 64k", "output token limit 128k", "opus output tokens", "sonnet output tokens", "/branch command", "/fork renamed", "branch slash command", "copy N index", "session auto-name", "bash 5gb limit", "resume 45 percent faster", "stale worktree race condition"

---

## Claude Code v2.1.78 Features (2026-03-18)

### Hook System

| Feature | Status | Notes |
|---------|--------|-------|
| StopFailure hook event | **ACTIVE** | Fires when a turn ends due to API error (rate limit, auth failure, network timeout). Enables heartbeat/cron jobs to auto-retry or pause instead of silently failing. See `helpers/playbooks/stopfailure-hook-error-recovery.md`. |

### Plugin System

| Feature | Status | Notes |
|---------|--------|-------|
| `${CLAUDE_PLUGIN_DATA}` | **ACTIVE** | Per-plugin persistent data directory that survives plugin updates. `/plugin uninstall` now prompts before deletion. Exact resolved path TBD — verify empirically. |
| Plugin agent frontmatter: effort/maxTurns/disallowedTools | **ACTIVE** | Plugin-shipped agents can constrain behavior at definition time via frontmatter fields. Extends existing agent spawn restrictions to plugin distribution context. |
| Memory file last-modified timestamps | **ACTIVE** | Claude can reason about memory file freshness — automatic, no config needed. Improves stale memory detection. |

### Model Management

| Feature | Status | Notes |
|---------|--------|-------|
| `modelOverrides` setting | **ACTIVE** | Maps model picker entries to custom provider model IDs (Bedrock ARNs, proxy endpoints). Configure in `settings.json`. |
| `ANTHROPIC_CUSTOM_MODEL_OPTION` | **ACTIVE** | Env vars to add a single custom entry to the `/model` picker. Simpler than `modelOverrides` for single-model additions. See `~/.claude/CLAUDE.md` Development Environment section. |

### CLI & UX

| Feature | Status | Notes |
|---------|--------|-------|
| `/btw` Side-Chain Query | **ACTIVE** | Ask ephemeral mid-task questions without adding to conversation history. Reuses prompt cache. Overlay UI dismissed with Space/Enter/Escape. Use for quick mid-task clarifications without polluting context. |

**`/btw` Details**:
- Usage: `/btw [question]` during any active task
- Answer shown in overlay UI only — not added to conversation history
- Reuses prompt cache (lower latency, no context cost)
- Dismiss overlay: Space / Enter / Escape
- Use case: "what's the current phase?", "does this file exist?", quick sanity checks mid-task

**Redundancy triggers**: "v2.1.78", "stopfailure hook", "api error hook", "turn failure hook", "CLAUDE_PLUGIN_DATA", "plugin persistent data", "plugin agent effort", "plugin disallowedTools", "memory timestamps", "modelOverrides", "ANTHROPIC_CUSTOM_MODEL_OPTION", "custom model picker entry", "/btw command", "btw slash command", "side chain query", "mid-task question", "context-free question", "ephemeral query", "overlay question", "question without history", "cache reuse query"

---

## Claude Code v2.1.80 Features (2026-03-20)

### MCP Architecture

| Feature | Status | Notes |
|---------|--------|-------|
| `--channels` MCP Push Messaging | **MONITOR** | Research preview (v2.1.80+). Enables MCP servers to push messages into active Claude sessions — bidirectional MCP communication. Previously MCP was strictly request/response (Claude calls tool → server responds). With `--channels`, MCP servers can proactively inject events, completions, or data into a running session. Eliminates polling loops for async workflows (CI results, webhook events, background task completion). Not yet GA — defer building production workflows until stable release. |

**`--channels` Use Cases (Future)**:
- Real-time build/CI completion → session resumes when CI passes
- Webhook events (GitHub, Stripe, Discord) pushed directly into session
- Async agent coordination → one agent signals another
- Long-running task completion notifications
- Rate limit reset countdown (replaces polling)

**When to promote to full integration**:
- `--channels` reaches GA (stable release)
- High-quality MCP server publishes channel push support
- Anthropic publishes protocol spec for implementing channel push in custom MCP servers

### Statusline System

| Feature | Status | Notes |
|---------|--------|-------|
| `rate_limits` statusline field | **ACTIVE** | v2.1.82+: statusline scripts can read Claude.ai rate limit usage as percentages with reset timestamps. Format: `{rate_limits: {5h_used_percentage: N, 5h_resets_at: ISO, 7d_used_percentage: N, 7d_resets_at: ISO}}`. Supersedes v2.1.80 raw-count format. See `helpers/navigation/hook-environment-variables.md` § Statusline. |

**`rate_limits` field format (v2.1.82+)**:
```json
{
  "rate_limits": {
    "5h_used_percentage": 42,
    "5h_resets_at": "2026-03-25T18:00:00Z",
    "7d_used_percentage": 17,
    "7d_resets_at": "2026-03-28T00:00:00Z"
  }
}
```

**Superseded v2.1.80 format** (raw counts, no longer returned):
```json
{ "rate_limits": { "hour5": { "used": 12, "limit": 50 }, "day7": { "used": 87, "limit": 500 } } }
```

**Use case**: Threshold check is now direct — `if [ "$USED_PCT" -gt 80 ]`. No division needed. `resets_at` timestamps enable scheduling awareness (defer heartbeat until window resets).

### Enterprise Policy (v2.1.83+)

| Feature | Status | Notes |
|---------|--------|-------|
| `managed-settings.d/` drop-in directory | **ACTIVE** | v2.1.83+: policy fragments dropped into this directory are merged alphabetically into the effective managed-settings config. Enables independent policy layers without merge conflicts. Companion: `permissions.disableBypassPermissionsMode` lockdown flag. |
| `forceRemoteSettingsRefresh` | **ACTIVE (v2.1.92+)** | Fail-closed policy enforcement: CLI blocks startup until remote managed settings are freshly fetched; exits on fetch failure. Extends `managed-settings.d/` with startup-time compliance guarantee. Enterprise/team deployments only. |

**How it works**: Multiple `.json` files in `managed-settings.d/` are merged in alphabetical filename order. Later files override earlier on key conflicts. Enables IT/admin teams to deploy policy layers independently without touching a central monolithic `managed-settings.json`.

**Companion field** — `permissions.disableBypassPermissionsMode`:
```json
{ "permissions": { "disableBypassPermissionsMode": true } }
```
Prevents users from switching to `bypassPermissions` mode, locking Auto Mode at the session level. Relevant for this workspace: could lock heartbeat/cron agents to standard permission mode.

**Single-user relevance**: Low. No MDM, no multi-user coordination. Approving as documentation entry. Re-evaluate if workspace involves team deployment or shared automation infrastructure.

**`forceRemoteSettingsRefresh` Details** (v2.1.92+, 2026-04-04):
- **Purpose**: Fail-closed managed-settings enforcement — blocks CLI startup until remote managed settings are freshly fetched
- **Behavior**: If the remote fetch fails (network down, server unreachable), CLI exits rather than starting with potentially stale policy
- **Use case**: Enterprise compliance where a revoked permission or new policy must be applied before any session starts; prevents policy-bypass via network failure
- **Relationship**: Companion to `managed-settings.d/` (v2.1.83) — that's the *structure*; this is the *enforcement*
- **Relevance**: Zero — personal Max plan with no remote managed settings server. Document for future team/enterprise adoption.
- **Adoption trigger**: If workspace moves to team account with centralized policy management

### Plugin System

| Feature | Status | Notes |
|---------|--------|-------|
| `source: 'settings'` inline plugin config | **ACTIVE** | v2.1.80+: plugins can now be declared inline in `settings.json` without using the marketplace UI. Format: `{plugins: [{source: 'settings', ...}]}`. Enables version-controlled plugin configuration — plugins tracked in git alongside other settings. |

**`source: settings` example**:
```json
{
  "plugins": [
    {
      "source": "settings",
      "name": "my-plugin",
      "config": { "key": "value" }
    }
  ]
}
```

### Skills & Slash Commands

| Feature | Status | Notes |
|---------|--------|-------|
| `effort` frontmatter for skills and slash commands | **ACTIVE** | v2.1.80+: extends the v2.1.78 `effort` frontmatter (previously plugin-shipped agents only) to skills and slash commands. Add `effort: low\|medium\|high\|max` to skill SKILL.md frontmatter or command frontmatter. Use `effort: low` for lightweight decision-tree/routing skills to reduce compute allocation. |

**`effort` levels**:
- `low` — Quick reference, routing, decision trees, lightweight lookups
- `medium` — Standard skill invocations (default)
- `high` — Complex multi-step reasoning
- `max` — Maximum compute, reserved for critical analysis

**Applied**:
- `~/.claude/agents/model-router.md`: `effort: low` (routing only, uses haiku)
- `~/.claude/agents/event-bus-publisher.md`: `effort: low` (lightweight publish operations)
- `~/.claude/skills/mcp-search-framework/SKILL.md`: `effort: low` (decision tree)

**Redundancy triggers**: "v2.1.80", "v2.1.82", "v2.1.83", "mcp push", "mcp channels", "server-initiated messages", "bidirectional mcp", "push messaging mcp", "mcp server push", "channels flag", "rate limits statusline", "rate limit monitoring", "5-hour rate limit", "7-day rate limit", "5h_used_percentage", "7d_used_percentage", "resets_at statusline", "source settings plugin", "inline plugin config", "version controlled plugins", "effort frontmatter skills", "effort slash commands", "skill effort level", "low effort skill", "managed-settings.d", "drop-in policy", "policy fragments", "disableBypassPermissionsMode", "enterprise policy directory", "forceRemoteSettingsRefresh", "fail-closed managed settings", "managed settings refresh", "force settings refresh", "startup policy enforcement", "remote settings enforcement"

---

## Claude Code v2.1.101 Features (2026-04-12)

### Built-in Commands

| Feature | Status | Notes |
|---------|--------|-------|
| `/team-onboarding` Command | **ACTIVE** | Generates a teammate ramp-up guide from local CLAUDE.md hierarchy, agent definitions, command patterns, and usage history. Zero setup — built-in to Claude Code. Run in claude-evolution workspace for a synthesized ramp-up guide covering 40+ agents, helpers/, and workflow conventions. Output is reviewable; commit useful sections to docs/ if valuable. |

**`/team-onboarding` Details** (v2.1.101, 2026-04-12):
- **How it works**: Reads local CLAUDE.md files, agent definitions in `~/.claude/agents/`, installed skills, and command patterns to synthesize a ramp-up guide tailored to how this specific workspace is actually used
- **Intended audience**: New team members, returning users after long absences, or anyone onboarding into a complex Claude Code setup
- **Workspace relevance**: claude-evolution has 59-project CLAUDE.md hierarchy, 40+ custom agents, `helpers/` system, pipeline workflow, and evolution loop — all high-value ramp-up content
- **Action**: Run `/team-onboarding` interactively in the claude-evolution workspace; review output; determine if guide is commit-worthy (save to `docs/`) or ephemeral
- **Replaces**: Manual documentation of agent catalog, workflow conventions, and helper patterns

**Redundancy triggers**: "/team-onboarding", "team onboarding command", "ramp-up guide", "teammate onboarding", "usage-based docs", "onboarding automation", "claude code docs generation", "synthesized onboarding", "v2.1.101 onboarding"

### Subagent Architecture Fixes

| Feature | Status | Notes |
|---------|--------|-------|
| Subagent MCP Tool Inheritance from Dynamic Servers | **FIXED (v2.1.101)** | Subagents now inherit MCP tools from dynamically-injected servers (added at runtime via hook injection or programmatic MCP addition). Previously, only statically configured MCP tools were visible to spawned subagents. |
| Worktree Subagent File Access | **FIXED (v2.1.101)** | Subagents running with `isolation: worktree` frontmatter now have full Read/Edit access to files inside their own worktree. Previously denied even for files the agent created within its own isolated tree. |

**Subagent MCP Inheritance Details** (v2.1.101, 2026-04-12):
- **Bug**: When MCP servers were added at runtime (e.g., via hook injection, `claude mcp add` in session), spawned Task subagents did not see those tools — only the parent saw them
- **Fix**: Dynamic server tool lists now propagate to child subagents at spawn time
- **Affected agents**: Any agent using `isolation: worktree` that spawns Task subagents AND requires access to dynamically-added MCP servers
- **Audit result**: Existing agents (`capability-discoverer`, `capability-evaluator`, `code-reviewer`) list MCP tools explicitly in frontmatter as intentional declarations, not as workarounds for this bug. No agent definition changes needed — explicit tool lists remain valid and are not redundant overhead.
- **Future guidance**: Agents that rely on runtime-injected MCP servers no longer need a compensatory explicit tool list in frontmatter; inherited tools are now reliable

**Worktree Subagent File Access Details** (v2.1.101, 2026-04-12):
- **Bug**: Agents with `isolation: worktree` were denied Read/Edit/Write access to files within their own worktree, requiring workarounds (absolute paths, pre-copy of files to a non-worktree location)
- **Fix**: Agents in worktrees now have native file access to their isolated tree — no path manipulation needed
- **Audit result**: No workarounds found in existing worktree agents. `capability-discoverer` and `capability-evaluator` both use `isolation: worktree` but had no explicit path workarounds for this limitation.
- **Future guidance**: New agents using `isolation: worktree` can use standard relative paths within the worktree without path aliasing hacks

**Redundancy triggers**: "subagent MCP inheritance", "dynamic MCP tools subagent", "worktree subagent access", "isolation worktree fix", "subagent tool availability", "dynamically-injected MCP", "worktree file access fix", "worktree read denied", "worktree edit denied", "subagent worktree file access", "v2.1.101", "dynamic server tools subagent", "runtime MCP inheritance"

### API Observability (OTEL Debugging)

| Feature | Status | Notes |
|---------|--------|-------|
| OTEL Debugging Quartet | **ACTIVE (v2.1.101 + v2.1.111)** | Four env vars enabling full API observability: `OTEL_LOG_USER_PROMPTS` (prompts), `OTEL_LOG_TOOL_DETAILS` (tool decisions), `OTEL_LOG_TOOL_CONTENT` (tool I/O content), `OTEL_LOG_RAW_API_BODIES` (v2.1.111: raw API bodies). Together enable complete debug trace from prompt → tool decision → content → raw request. |

**OTEL Debugging Quartet Details** (v2.1.101 + v2.1.111, 2026-04-17):
- **OTEL_LOG_USER_PROMPTS** (v2.1.101): Log user prompt content to OTEL exporter — enables prompt-level debugging
- **OTEL_LOG_TOOL_DETAILS** (v2.1.101): Log which tools were selected and why — enables tool routing debugging
- **OTEL_LOG_TOOL_CONTENT** (v2.1.101): Log full tool input/output content — enables tool execution debugging
- **OTEL_LOG_RAW_API_BODIES** (v2.1.111): Log raw API request/response bodies — enables prompt caching and model behavior debugging
- **Combined observability tier**: prompts → tool decisions → tool content → raw API — complete session debug trace
- **When to use**: Debugging prompt caching failures, unexpected model behavior, tool routing issues in heartbeat development. Not for production — verbose log output.
- **Replaces**: The single-variable `otel-raw-api-bodies-v2.1.111.md` pending file (merged into unified entry)

**Redundancy triggers**: "OTEL debugging", "OTEL_LOG_USER_PROMPTS", "OTEL_LOG_TOOL_DETAILS", "OTEL_LOG_TOOL_CONTENT", "OTEL_LOG_RAW_API_BODIES", "opentelemetry claude debug", "API body logging", "prompt debug otel", "tool routing debug", "otel debug quartet", "raw API bodies log"

---

## Anthropic Advisor Tool (APPROVED_PENDING_API_KEY)

| Feature | Status | Notes |
|---------|--------|-------|
| Advisor Tool (advisor-tool-2026-03-01) | **APPROVED_PENDING_API_KEY** | Pairs a faster executor model (Haiku 4.5 / Sonnet 4.6) with Opus 4.6 advisor within a SINGLE `/v1/messages` request. No extra round trips. Executor invokes advisor mid-generation; Opus produces 400-700 token plan/course-correction; executor continues. Announced April 9, 2026. Score: 74.75/100. |

**Advisor Tool Details** (2026-04-14):
- **Why approved**: Genuinely novel — single-request multi-model consultation with zero round-trip overhead; not achievable via model-router (whole-task routing) or Codex integration (routes to different model)
- **Why pending**: Requires `ANTHROPIC_API_KEY` — this workspace runs on Max plan with no API key. Integration deferred until API key available.
- **Cost model**: executor at Sonnet rates + advisor at Opus rates (only 400-700 tokens per consultation). Anthropic-documented 35-45% advisor output token reduction. Sonnet+Opus-advisor ≈ Sonnet default quality at lower cost for coding tasks.
- **Integration path**: Build thin wrapper script with `anthropic-beta: advisor-tool-2026-03-01` beta header. `max_uses` parameter limits advisor calls per request.
- **Key trade-off**: advisor doesn't stream (pause in SSE); no built-in conversation-level cap (track client-side)
- **Suggested system prompt**: Include explicit advisor timing instruction (documented in official Anthropic docs) for consistent advisor invocation
- **Inversion pattern**: The smaller model drives end-to-end and escalates to Opus — opposite of typical sub-agent patterns

**Redundancy triggers**: "advisor tool", "advisor-tool-2026-03-01", "executor advisor pattern", "mid-generation consultation", "single request multi-model", "Opus advisor Sonnet executor", "advisor strategy", "strategic guidance mid-generation", "executor escalation pattern", "cost-efficient agentic intelligence", "advisor_20260301"

---

## Claude Code v2.1.104 Behavior Changes (2026-04-13)

### Permissions

| Feature | Status | Notes |
|---------|--------|-------|
| Blocked tool calls require explicit approval | **ACTIVE (v2.1.104)** | Tool calls blocked by permission mode now surface an explicit UI approval prompt instead of silently failing. In headless `-p` mode, blocked calls terminate the process (fail-fast, no stall). Companion to Adversa AI deny-rules bypass fix (v2.1.94-96). |

**Blocked Tool Approval Details** (v2.1.104, 2026-04-13):
- **Before**: Tool calls blocked by `permissions.defaultMode: "auto"` would silently fail or be skipped
- **After**: Interactive sessions get an explicit approval prompt; headless sessions terminate fast (no indefinite stall)
- **Headless safety**: In `claude -p` unattended sessions, a blocked tool terminates the process rather than hanging — safe fail-fast behavior for heartbeat/cron runs on requiem
- **Source**: @ClaudeCodeLog on X (2026-04-13), corroborated by GitHub issue #47114
- **Evolution impact**: Heartbeat sessions using `defaultMode: "auto"` will now fail-fast on unexpected blocked tools instead of stalling silently

**Redundancy triggers**: "v2.1.104", "blocked tool explicit approval", "permission mode explicit", "auto mode blocked tool", "headless blocked tool termination", "silent fail permission", "deny rules bypass fix companion", "explicit approval permission"

---

## Claude Code v2.1.105–107 Features (2026-04-14)

### Built-in Tools

| Feature | Status | Notes |
|---------|--------|-------|
| `EnterWorktree` `path` parameter | **ACTIVE (v2.1.105)** | New `path` parameter lets an agent switch into an EXISTING worktree without creating a new one. Closes the gap in multi-agent workflows where one agent creates a worktree and a second needs to work in the same isolated branch. Complements ExitWorktree (v2.1.87+). |

**`EnterWorktree path` Details** (v2.1.105, 2026-04-14):
- **Before**: `EnterWorktree` could only create NEW worktrees; agents couldn't enter a pre-existing worktree another agent had set up
- **After**: Pass `path: "/absolute/path/to/worktree"` to switch into an existing worktree
- **Multi-agent pattern**: Agent A creates worktree → passes path to Agent B → Agent B calls `EnterWorktree(path: ...)` to enter the same branch without duplication
- **Squash-merge cleanup**: v2.1.105 also fixes stale agent worktree cleanup to detect squash-merged PRs (previously only detected regular merges). Workflows using GitHub squash-and-merge strategy no longer accumulate stale worktrees.
- **Documented in**: `~/.claude/skills/using-git-worktrees/SKILL.md`

**Redundancy triggers**: "EnterWorktree path", "enter existing worktree", "worktree path parameter", "switch worktree agent", "multi-agent worktree shared", "squash-merged worktree cleanup", "v2.1.105 worktree"

### Session and Commands

| Feature | Status | Notes |
|---------|--------|-------|
| `/proactive` alias | **ACTIVE (v2.1.105)** | `/proactive` is now an official alias for `/loop` (autonomous task queue mode). Equivalent functionality; different entry point for discoverability. |
| Stalled stream recovery | **ACTIVE (v2.1.105)** | API streams that produce no data for 5 minutes are now aborted and retried non-streaming. Prevents silent hang during long-running API calls. Relevant for heartbeat/cron sessions that may hit slow API periods. |
| Skill description cap raised | **ACTIVE (v2.1.105)** | Skill description field limit raised from 250 → 1,536 characters. Enables richer skill descriptions that appear in the tool search catalog without truncation. |
| WebFetch style/script stripping | **ACTIVE (v2.1.105)** | WebFetch now strips `<style>` and `<script>` content from fetched pages. Reduces noise; relevant pages return cleaner content with less token waste. |
| `/doctor` auto-fix | **ACTIVE (v2.1.105)** | Press `f` in `/doctor` to auto-fix reported issues without manual steps. Previously `/doctor` only reported; now actionable in-place. |
| MCP large-output truncation recipes | **ACTIVE (v2.1.105)** | Format-specific recipes for handling MCP tools that return oversized output. Reduces context pollution from verbose MCP responses. |
| Thinking hints shown sooner | **ACTIVE (v2.1.107)** | Extended thinking hints displayed earlier during long operations (UX improvement). No functional change; reduces perceived latency for complex queries. |

**`/proactive` alias Details** (v2.1.105, 2026-04-14):
- Identical to `/loop` — same underlying autonomous task queue mode
- Heartbeat command reference: use `/loop` or `/proactive` interchangeably
- No settings.json change required; built-in alias

**Stalled Stream Recovery Details** (v2.1.105, 2026-04-14):
- 5-minute timeout before abort+retry triggers
- Falls back to non-streaming mode on retry
- Relevant for: long heartbeat sessions on requiem where slow API periods could previously cause silent failure

**WebFetch Stripping Details** (v2.1.105, 2026-04-14):
- Affects: all WebFetch tool calls including MCP Exa crawling
- Impact: research/discovery runs return cleaner content — CSS/JS noise removed
- No configuration needed; automatic behavior change

**Redundancy triggers**: "/proactive alias", "proactive loop alias", "stalled API stream", "stream abort retry", "skill description cap 1536", "WebFetch strip scripts", "WebFetch strip styles", "doctor auto-fix", "MCP output truncation recipes", "thinking hints sooner", "v2.1.105", "v2.1.106", "v2.1.107"

---

## Claude Code v2.1.108 Features (2026-04-15)

### Skill Tool Enhancement

| Feature | Status | Notes |
|---------|--------|-------|
| Model-invokable built-in slash commands | **ACTIVE (v2.1.108)** | The Skill tool now exposes built-in slash commands (`/init`, `/review`, `/security-review`) for autonomous model invocation. Agents can self-invoke security audits, code reviews, and project initialization without user typing. |

**Model-Invokable Built-in Skills Details** (v2.1.108, 2026-04-15):
- **Before**: Built-in commands like `/init`, `/review`, `/security-review` required explicit user invocation via keyboard
- **After**: Built-in commands appear in the Skill tool's catalog; agents can invoke them autonomously as part of workflows
- **Key use cases**: `security-auditor` can invoke `/security-review` autonomously; `code-reviewer` can invoke `/review` on a PR; `feature-implementer` can `/init` a new project context before starting work
- **Evolution pipeline**: Heartbeat can invoke `/security-review` on new discoveries without user input
- **Open questions**: Full list of exposed built-ins undocumented; verify permission model for autonomous invocation empirically
- **Updated agents**: code-reviewer, security-auditor, feature-implementer definitions updated to reference this capability

**Redundancy triggers**: "model-invokable built-in", "built-in slash command agent", "/review agent invoke", "/security-review autonomous", "/init agent", "Skill tool built-in", "v2.1.108 skill tool", "autonomous slash command", "model invoke built-in skill"

### Session Management

| Feature | Status | Notes |
|---------|--------|-------|
| `/recap` command | **ACTIVE (v2.1.108)** | On-demand session recap for context restoration when returning to long-running sessions. Configurable in `/config`; manually invokable anytime via `/recap`. `CLAUDE_CODE_ENABLE_AWAY_SUMMARY=1` enables away-summary for telemetry-off users. **PENDING_APPROVAL**: env var → shell profile. |
| Prompt cache TTL control | **ACTIVE (v2.1.108)** | `ENABLE_PROMPT_CACHING_1H=1` explicitly guarantees 1hr prompt cache TTL (prevents silent 5-min fallback when `DISABLE_TELEMETRY` is set). `FORCE_PROMPT_CACHING_5M=1` for testing. **PENDING_APPROVAL**: env var → shell profile. |

**`/recap` Details** (v2.1.108, 2026-04-15):
- Provides human-readable session context summary on return to long-running sessions
- Distinct from `/compact` (model-facing context compression) — `/recap` is human-facing recall
- `CLAUDE_CODE_ENABLE_AWAY_SUMMARY=1` enables the away-summary feature even with telemetry disabled
- **Pending proposal**: `pipeline/pending-approval/recap-session-context.proposal.md`

**`ENABLE_PROMPT_CACHING_1H` Details** (v2.1.108, 2026-04-15):
- Explicitly guarantees 1hr prompt cache TTL instead of relying on implicit defaults
- Fixes silent bug: `DISABLE_TELEMETRY` users were getting 5-min TTL instead of 1hr (now corrected)
- `FORCE_PROMPT_CACHING_5M=1` forces 5-min TTL for testing cache expiry behavior without waiting 1hr
- Complements `--exclude-dynamic-system-prompt-sections` (v2.1.97)
- **Pending proposal**: `pipeline/pending-approval/enable-prompt-caching-1h.proposal.md`

**Redundancy triggers**: "/recap command", "session recap context", "away summary", "CLAUDE_CODE_ENABLE_AWAY_SUMMARY", "ENABLE_PROMPT_CACHING_1H", "prompt cache TTL explicit", "1hr cache TTL", "FORCE_PROMPT_CACHING_5M", "v2.1.108 session"

### External Capabilities

| Feature | Status | Notes |
|---------|--------|-------|
| context-mode (PostToolUse output sandboxing) | **APPROVED, PENDING_INSTALL** | PostToolUse hooks intercept large tool outputs (Playwright snapshots, grep dumps, curl responses), route full data to filesystem, inject compact summaries into context. Claims 98% token reduction per-tool. 7.3k GitHub stars. Install: `/plugin marketplace add mksglu/context-mode`. Requires approval gate (plugin config). |

**context-mode Details** (plugin, 2026-04-15):
- Lossless output routing: full data preserved on disk; only summary tokens enter context window
- NOT truncation (`maxResultSizeChars` is lossy) — active redirection to filesystem + summary injection
- Install via plugin marketplace: `/plugin marketplace add mksglu/context-mode` (requires Claude Code v1.0.33+)
- 12 platform support; all 5 Claude Code hook types supported
- Elastic License 2.0: free to use/modify, cannot resell as managed service
- **Pending proposal**: `pipeline/pending-approval/context-mode-plugin.proposal.md`

**Redundancy triggers**: "context-mode", "PostToolUse sandboxing", "tool output routing", "context window optimization plugin", "98% token reduction hooks", "mksglu context-mode", "lossless output routing", "Playwright snapshot context reduction", "grep output context"

### Scheduling & Automation

| Feature | Status | Notes |
|---------|--------|-------|
| Claude Code Routines | **RESEARCH_PREVIEW (2026-04-14)** | Cloud-persistent Claude Code automations on Anthropic infrastructure. Three trigger types: Schedule (cron-style, 1hr min interval), API (POST endpoint + bearer token), GitHub events (PR open/push/labeled with filters). 15 runs/day on Max plan. Not session-scoped — survives session close, runs without local laptop. |

**Claude Code Routines Details** (Research Preview, 2026-04-14):
- **Key distinction**: NOT session-scoped (unlike `/loop`, CronCreate) — runs on Anthropic cloud infrastructure independently of any local session
- **Max plan**: 15 routine runs/day; Pro: 5/day; Team/Enterprise: 25/day
- **Min schedule interval**: 1 hour (vs arbitrary cron intervals — best for nightly/weekly automations)
- **Connectors**: Gmail, Slack, Linear, Google Drive, and MCP-compatible services
- **API trigger**: POST to claude.ai endpoint with bearer token; claude.ai-only, not Anthropic Platform API
- **GitHub event triggers**: Filter by event type (PR open, push, label), branch patterns, repo
- **Does NOT require ANTHROPIC_API_KEY**: Max plan auth works (this is Claude Code, not the Claude API)
- **Evolution pipeline fit**: Routines complement cron+`claude -p`; better for simpler cloud automations (PR review, nightly sweeps); cron better for high-frequency heartbeat (15/day cap makes Routines impractical for hourly loops)
- **Setup**: Web UI at claude.ai/code, no CLI config needed; connector setup has per-service OAuth
- **Research preview risks**: 15/day quota, behavior may change, API endpoint is claude.ai-specific

**Redundancy triggers**: "claude code routines", "cloud routines", "cloud-persistent agent", "serverless claude code", "routine research preview", "schedule routine anthropic", "API trigger routine", "GitHub event routine", "Anthropic cloud automation", "anthropic-beta experimental-cc-routine-2026-04-01", "routine runs/day", "Routines trigger"

### Desktop App

| Feature | Status | Notes |
|---------|--------|-------|
| Claude Code Desktop Redesign | **ACTIVE (v2.1.108)** | Multi-session sidebar for managing parallel Claude Code sessions from a single window. Drag-and-drop workspace layout, integrated terminal pane, faster diff viewer. Released April 14, 2026. Registry-only integration (zero-config, automatic app update). Limited relevance on requiem (Linux CLI + tmux workflow). |

**Claude Code Desktop Redesign Details** (v2.1.108, 2026-04-14):
- **Multi-session sidebar**: Replaces cmd-tabbing between terminal tabs; visual panel for all open sessions
- **Drag-and-drop workspace**: Arrange session panels; equivalent to tmux split-pane management but GUI-native
- **Integrated terminal pane**: Terminal embedded within Claude Code UI (not separate app)
- **Faster diff viewer**: Expanded preview area for reviewing file changes
- **Linux/CLI note**: requiem uses tmux for parallel session management — functionally equivalent. Direct impact limited until Linux desktop app ships with same feature set
- **Companion**: Released same day as Claude Code Routines (April 14, 2026)
- **Integration type**: Registry-only; automatic app update — no configuration required

**Redundancy triggers**: "claude code desktop redesign", "multi-session sidebar", "parallel sessions UI", "integrated terminal pane", "session management UI desktop", "drag-drop workspace Claude", "diff viewer redesign", "v2.1.108 desktop", "desktop app session sidebar"

---

## Claude Code v2.1.109–111 Features (2026-04-17)

### Permission Workflow

| Feature | Status | Notes |
|---------|--------|-------|
| `/less-permission-prompts` built-in skill | **ACTIVE (v2.1.111)** | Scans session transcripts for common read-only Bash and MCP tool calls, proposes a prioritized permission allowlist for `.claude/settings.json`. Closes the Auto Mode adoption friction loop — previously required manual allow-rule-by-rule construction. Companion to `permissions.defaultMode: "auto"` (v2.1.76+). |

**`/less-permission-prompts` Details** (v2.1.111, 2026-04-17):
- **How it works**: Analyzes session transcripts, identifies high-frequency tool calls that triggered permission prompts, generates a ranked allowlist
- **Output target**: Writes to project `.claude/settings.json` (not global settings) — scoped to current project
- **Companion**: Works alongside `permissions.defaultMode: "auto"` — Auto Mode handles live sessions; `/less-permission-prompts` handles setup
- **Replaces**: Manual process of adding allow rules one by one after encountering prompts
- **Local skill status**: No custom local skill found at `~/.claude/skills/less-permission-prompts/` — built-in version is the first and only implementation
- **Trigger**: Run interactively after a session with many permission prompts to capture the pattern

**Redundancy triggers**: "/less-permission-prompts", "less permission prompts", "permission allowlist builder", "allowlist automation", "auto mode setup companion", "transcript permission scan", "allow rule generator", "permission prompt reducer", "v2.1.111 permissions"

### Cloud Planning & Review

| Feature | Status | Notes |
|---------|--------|-------|
| `/ultraplan` — Cloud-Based Interactive Planning | **RESEARCH_PREVIEW (v2.1.91+)** | Hands planning to a Claude Code web session while terminal stays free. Browser-based inline comments on plan sections, emoji-react, iterate, then either execute on web+PR or teleport approved plan back to local terminal. Triggers: `/ultraplan` command, keyword "ultraplan" in prompt, or "Refine with Ultraplan" when declining a local plan. |
| `/ultrareview` — Cloud Multi-Agent Code Review | **RESEARCH_PREVIEW (v2.1.111)** | Fleet of reviewer agents in remote cloud sandbox. Takes 5-10 min, runs in background. Reports only verified findings (cross-agent verification eliminates false positives). Accepts local diffs or PR numbers. Track via `/tasks` command. Costs $5-$20/review after 3 free runs. |

**`/ultraplan` Details** (v2.1.91+, documented v2.1.111, 2026-04-17):
- **Cloud planning**: Plan drafts in Anthropic cloud session; local terminal stays responsive
- **Browser review**: Section-level inline comments, emoji reactions, iterative refinement
- **Teleport back**: Approved plan injected into local conversation or starts fresh local session
- **Three trigger modes**: (1) `/ultraplan` command, (2) keyword "ultraplan" in any prompt, (3) "Refine with Ultraplan" option when declining a local plan
- **Execution path A**: Execute plan on web, open PR — useful when repo is GitHub-linked
- **Execution path B**: Teleport approved plan back to local terminal — hybrid workflow
- **Requires**: claude.ai account + GitHub repo; not available on Bedrock/Vertex/Foundry
- **Evolution relevance**: Off-loads planning to cloud, preserving local context budget for implementation; browser annotation adds review loop without separate session
- **CLAUDE.md note**: Add `/ultraplan` reference to Plan Mode Quality section as cloud complement to local plan mode (requires approval gate — files outside ~/claudeworkspace/)

**`/ultrareview` Details** (v2.1.111, 2026-04-17):
- **Multi-agent verification**: Multiple reviewer agents work independently then cross-verify — only consensus findings reported
- **False positive elimination**: Independent verification means findings that only one agent sees are filtered out
- **Input modes**: (1) local diff (run from working tree), (2) PR number (GitHub required)
- **Background execution**: 5-10 min; use `/tasks` to monitor status and retrieve results
- **Cost model**: 3 free runs included; $5-$20/review beyond that; billed to claude.ai account
- **Distinct from local code-reviewer**: `code-reviewer` subagent is single-pass, local resources; `/ultrareview` is cloud multi-agent with cross-verification
- **Requires**: claude.ai account + GitHub (for PR mode); not available on Bedrock/Vertex/Foundry, no ZDR orgs
- **When to use over local code-reviewer**: Pre-merge for important PRs; when false-positive rate from single-pass review is a concern

**Redundancy triggers**: "/ultraplan", "ultraplan cloud planning", "cloud plan teleport", "browser plan review", "inline plan comments", "plan refine web", "ultraplan teleport", "cloud interactive planning", "/ultrareview", "ultrareview cloud review", "multi-agent code review", "verified findings review", "pre-merge cloud review", "parallel reviewer agents", "false positive review elimination", "ultrareview cost", "v2.1.111 cloud commands"

---

## Claude Code v2.1.111–112 Features (2026-04-16/18)

### Model: Claude Opus 4.7 + xhigh Effort Level

| Feature | Status | Notes |
|---------|--------|-------|
| `claude-opus-4-7` model ID | **ACTIVE (v2.1.111+)** | New Opus 4.7 model. Model ID: `claude-opus-4-7`. Minimum Claude Code v2.1.111. Default effort level for Opus 4.7 is `xhigh`. Available via model picker, `--model` flag, and frontmatter. |
| `xhigh` effort level | **ACTIVE (v2.1.111+)** | New effort level between `high` and `max`. Available via `/effort`, `--effort` flag, and model picker. Default for Opus 4.7. Five total effort levels: `low`, `medium`, `high`, `xhigh`, `max`. |

**Claude Opus 4.7 Details** (v2.1.111, 2026-04-16, Score: 83.0/100):
- **Model ID**: `claude-opus-4-7` (minimum Claude Code v2.1.111; v2.1.112 fixed "temporarily unavailable" bug for auto mode)
- **Default effort**: `xhigh` — sits between `high` and `max`, giving more granular compute control
- **Auto Mode**: Now available to Max subscribers when using Opus 4.7 (see Auto Mode entry — was previously Teams/Enterprise only; already documented there)
- **CLAUDE.md update**: Model table needs updating — proposal in `pipeline/pending-approval/opus47-claude-md-update.proposal.md`
- **v2.1.117 bug fix**: Context window calculation corrected from 200K to 1M — sessions were computing `/context` percentage against 200K instead of the native 1M limit, triggering premature autocompaction. Fixed automatically in v2.1.117; no configuration needed.

**Updated effort level scale** (five levels, v2.1.111+):
| Level | Use case |
|-------|----------|
| `low` | Quick reference, routing, decision trees |
| `medium` | Standard skill invocations (default for most models) |
| `high` | Complex multi-step reasoning |
| `xhigh` | **(NEW)** Between high and max; **default for Opus 4.7** |
| `max` | Maximum compute, reserved for critical analysis |

**Redundancy triggers**: "claude-opus-4-7", "opus 4.7", "opus 4-7", "xhigh effort", "xhigh level", "effort xhigh", "five effort levels", "opus 4.7 model ID", "v2.1.111 model", "v2.1.112 opus", "auto mode Max opus 4.7"

---

## Claude Code v2.1.113 Features (2026-04-19)

### Security: Bash Permission Hardening

| Feature | Status | Notes |
|---------|--------|-------|
| `Bash(find:*)` — `find -exec`/`-delete` no longer auto-approved | **ACTIVE (v2.1.113)** | Wildcard allow rules for `find` no longer implicitly approve `find -exec` and `find -delete`. These require separate explicit approval. Also: `cd <current-dir> && git ...` no longer triggers a permission prompt when the `cd` is a no-op. |

**Bash Security Hardening Details** (v2.1.113, 2026-04-19, Score: 70.0/100):
- **Behavior change**: `Bash(find:*)` allow rules no longer auto-approve `find -exec` and `find -delete` subcommands. Previously, a wildcard allow rule for `find` implicitly approved dangerous subcommands (arbitrary command execution, file deletion).
- **Why it matters**: Privilege escalation vector via existing wildcard allow rules is now closed.
- **Audit result**: No `Bash(find:*)` rules found in `~/.claude/settings.json`, `~/claudeworkspace/.claude/settings.json`, or project settings — zero remediation needed for this workspace.
- **QoL fix**: Running `cd <current-directory> && git ...` no longer triggers a permission prompt when the `cd` is a no-op (evaluates to the same directory).
- **Source**: claudeupdates.dev/version/2.1.113

**Redundancy triggers**: "bash find exec auto-approve", "find -exec security", "find -delete auto-approve", "bash allow rule security", "permission allow rule tightening", "bash wildcard security", "v2.1.113 security", "bash security hardening", "allow rule bypass prevention", "find exec privilege escalation"

---

## Anthropic Tool Design Philosophy (2026-04-10)

| Feature | Status | Notes |
|---------|--------|-------|
| Seeing Like an Agent (Progressive Disclosure) | **ACTIVE** | First-party Anthropic engineering post by Thariq Shihipar. Primary principle: design tools from the agent's perceptual model, not a human's. Progressive disclosure = surface just enough to act. Validated the existing SKILL.md 2KB cap + decision-tree-first conventions. Full doc: `library/techniques/seeing-like-an-agent-tool-design-2026-04-20.md` |

**Key Principles** (from official Anthropic post, 2026-04-10):
- **Progressive disclosure**: Tool descriptions should lead with "when to use," not "how it works." Decision tree before details.
- **Agent-native perceptual model**: Ask "if this tool result were the ONLY thing Claude could see, could it take the correct next action?"
- **Discoverability first**: Verb+noun tool names, use-case-first descriptions, self-documenting parameter names, defaults for the common case
- **Case studies**: `AskUserQuestion` blocking modal (forces interaction pattern); Task tool context isolation (subagent output never enters parent context)
- **Application to this system**: SKILL.md 2KB cap + decision-tree-first layout are implementations of progressive disclosure. Agent frontmatter `description` field = discoverability surface.
- **Complements**: Tool Search Tool (supply-side progressive disclosure pairs with demand-side filtering), advanced-tool-use skill (that covers selection; this covers authoring)
- **Cross-link**: Add reference to advanced-tool-use SKILL.md under "Tool & Skill Authoring" section (proposal in `pipeline/pending-approval/seeing-like-an-agent-advanced-tool-use-xlink.proposal.md`)

**Redundancy triggers**: "seeing like an agent", "progressive disclosure tool design", "tool design philosophy anthropic", "agent perceptual model", "tool discoverability design", "AskUserQuestion blocking modal", "tool design first-party", "thariq shihipar", "SKILL.md progressive disclosure", "agent-native tool design", "seeing-like-an-agent", "tool description when to use"

---

## Claude Code v2.1.115 Bug Fix Cluster (2026-04-20)

| Fix | Status | Notes |
|-----|--------|-------|
| `--resume` pre-v2.1.85 sessions | **FIXED (v2.1.115)** | Sessions created before v2.1.85 no longer fail with "tool_use ids were found without tool_result blocks" |
| Outside-root file edit regression | **FIXED (v2.1.115)** | Write/Edit/Read on files outside project root (e.g. `~/.claude/CLAUDE.md`) no longer fail when conditional skills or rules are configured |
| Config write storm | **FIXED (v2.1.115)** | Unnecessary config disk writes on every skill invocation eliminated — performance regression resolved |
| `--bare` regression | **FIXED (v2.1.115)** | Bare mode no longer drops MCP tools in interactive sessions or silently discards enqueued messages |

**v2.1.115 Bug Fix Details** (2026-04-20, Score: 72.5/100):
- **Outside-root edit fix — HIGH relevance**: `~/.claude/CLAUDE.md` and memory files in `~/.claude/projects/` are edited frequently by agents in this workspace. The regression in conditional skills/rules configs broke these writes silently. Now resolved.
- **--resume backward compat**: Sessions created pre-v2.1.85 now resume correctly. Relevant for any archived heartbeat sessions predating that version.
- **Config write storm**: Performance regression — every skill invocation was triggering unnecessary disk writes. Fixed; no config change needed.
- **--bare MCP tools**: Interactive `--bare` sessions now correctly expose MCP tools. Silent message discard also fixed.
- **Version verified**: Workspace is on v2.1.116 (verified 2026-04-21) — all fixes active.

**Redundancy triggers**: "v2.1.115", "resume regression pre-v2185", "outside root edit regression", "CLAUDE.md write fail conditional skills", "config write storm", "skill invocation performance", "bare mode MCP regression", "bare mode drops tools", "tool_use ids tool_result blocks", "file outside root permission"

---

## Claude Code v2.1.116 Features (2026-04-21)

| Feature | Status | Notes |
|---------|--------|-------|
| `/resume` 67% faster on large sessions | **ACTIVE (v2.1.116)** | Dead-fork entry handling improved — sessions 40MB+ resume ~2/3 faster |
| Thinking spinner inline progress | **ACTIVE (v2.1.116)** | Shows "still thinking", "thinking more", "almost done thinking" — UX signal during long operations |
| `/config` search matches option values | **ACTIVE (v2.1.116)** | Searching "vim" in `/config` now finds Editor mode setting — not just option keys |
| Auto-install missing plugin dependencies | **ACTIVE (v2.1.116)** | `/reload-plugins` and background plugin auto-update now install missing plugin deps automatically |
| Sandbox auto-allow rm/rmdir safety fix | **ACTIVE (v2.1.116)** | `auto-allow` mode no longer bypasses dangerous-path safety check for `rm` and `rmdir` — security hardening |

**v2.1.116 Feature Details** (2026-04-21, Score: 77.5/100):
- **`/resume` 67% faster — HIGH relevance for heartbeat**: Long heartbeat sessions accumulate dead-fork entries over time. Previously, resuming a 40MB+ session (common for multi-day heartbeat chains) was slow. Now ~2.3x faster. Heartbeat patterns that use `-n "heartbeat-$(date)"` naming + `/resume` benefit directly.
- **Thinking spinner**: Visual UX improvement. No config. "almost done thinking" is a welcome signal during Opus deep analysis.
- **`/config` value search**: Minor QoL — `vim`, `auto`, `dark` now match option values in the config picker, not just setting keys.
- **Plugin dep auto-install**: Reduces friction in the evolution pipeline — skill/agent plugins with missing npm deps no longer block on manual install after `/reload-plugins`.
- **Sandbox rm safety**: `auto-allow` now correctly runs rm/rmdir through the dangerous-path check. Relevant for heartbeat cron sessions using auto permission mode.
- **Version verified**: Workspace confirmed on v2.1.116 (2026-04-21).

**Heartbeat note**: `/resume` speed improvement is directly relevant to heartbeat commands. Updated `helpers/commands/heartbeat-commands.md` with this note.

**Redundancy triggers**: "v2.1.116", "resume performance large sessions", "dead-fork session resume", "thinking spinner", "still thinking spinner", "thinking progress", "config value search", "config search option values", "plugin dep auto install", "reload-plugins missing deps", "sandbox rm safety", "auto-allow rm bypass", "auto-allow dangerous path", "resume 67 percent faster", "resume speed improvement"

---

## Claude Code v2.1.117 Features (2026-04-22)

### Native Tool Backend Replacement + Agent MCP Bundling

| Feature | Status | Notes |
|---------|--------|-------|
| bfs + ugrep native tool backends | **ACTIVE (v2.1.117)** | Glob uses `bfs` (breadth-first search), Grep uses `ugrep` (parallel grep) on macOS/Linux. Automatic — no config. Windows unchanged. Performance improvement; behavioral note: ugrep has edge-case regex differences vs ripgrep (PCRE lookaheads may differ). Score: 71.0/100. |
| Agent frontmatter `mcpServers` field | **ACTIVE (v2.1.117)** | MCP servers declared in agent frontmatter now load in `--agent` mode (previously: subagent/Task mode only). Enables self-contained agents that bundle their own MCP server dependencies. Score: 76.25/100. |

**v2.1.117 Details** (2026-04-22):

**bfs + ugrep Native Tool Backends** (Score: 71.0/100):
- **Change**: Glob tool now uses `bfs` (faster than find, breadth-first ordering); Grep tool now uses `ugrep` (parallel regex search, faster than ripgrep on most file sets)
- **Platforms**: macOS and Linux only — standard npm and native builds. Windows unchanged.
- **No config needed**: Automatic upgrade at the tool invocation layer
- **Behavioral note**: ugrep syntax is compatible with ripgrep in the common case but has edge-case differences — PCRE2 lookaheads, certain character class expressions, and ripgrep-specific flags may behave differently. Validate custom regex patterns if relying on ripgrep-specific extensions.

**Agent Frontmatter `mcpServers`** (Score: 76.25/100):
- **New frontmatter key**: `mcpServers:` in agent frontmatter — loaded in both `--agent` and Task-tool invocation modes
- **Before**: Agent frontmatter MCP declarations only worked in subagent (Task tool) mode
- **Now**: Self-contained agents can bundle their own MCP server configuration — portable across sessions without relying on global `~/.claude.json` config
- **Use cases**: `pipeline-orchestrator` could declare `event-bus` MCP directly; specialized agents that need a specific MCP without polluting global config
- **Integration action**: Document in `~/.claude/agents/INDEX.md` agent design patterns section; evaluate `event-bus-publisher`, `event-bus-reader`, `pipeline-orchestrator` for bundled mcpServers adoption

**Default Effort Raised (Pro/Max) — v2.1.117 Registry Correction**:
- **v2.1.94 note correction**: The v2.1.94 entry stated "Max plan users unaffected." v2.1.117 changes this.
- **v2.1.117**: Default effort for Pro and Max subscribers raised to `high` for Opus 4.6 and Sonnet 4.6
- **Action**: Add `--effort medium` to heartbeat/cron `claude -p` invocations to maintain prior cost profile

**Opus 4.7 Context Window Fix — v2.1.117**:
- **Bug**: Sessions on Opus 4.7 computed context usage against 200K instead of native 1M limit
- **Impact**: `/context` showed inflated percentages; autocompaction triggered far too early on Opus 4.7
- **Fix**: Automatic in v2.1.117 — no configuration needed

**Redundancy triggers**: "v2.1.117", "bfs glob backend", "ugrep grep backend", "native tool backend replacement", "bfs breadth-first", "ugrep parallel grep", "agent mcpServers frontmatter", "frontmatter mcpServers field", "agent bundled mcp", "self-contained agent mcp", "agent --agent mcp servers", "opus 4.7 context bug", "opus47 200K context", "opus47 premature compaction", "1M context fix opus47", "default effort Max plan v2.1.117", "Pro Max effort high default"

---

## Active External Workspace Projects

Projects outside `claude-evolution/` that the evolution pipeline regularly receives discoveries about. Before evaluating a new discovery that mentions one of these projects, check the project hub for prior coverage to avoid re-evaluating items already routed.

| Project | Hub | Status |
|---------|-----|--------|
| **Historical Nanochat** | [`library/projects/historical-nanochat.md`](../library/projects/historical-nanochat.md) | **Active training** on requiem 3090. Run `governed_v4_d22_r30_parallel_family` at step 10,000, val BPB 1.2406, ETA ~2026-05-10. Hub indexes 6 investigation reports + 3 blog-ideas + 1 completed evaluation + 1 technique cross-reference. Methodology now includes the Mr. Chatterbox comparison, an SFT provenance and era-purity gate, and a period-native dialogue/QA experiment with a separated modern-synthetic control. Open problems: multi-family corpus dynamics (BLOCKING), OCRonos-Vintage preprocessing (UNEVALUATED), rights audit, provenance bug. |

**Redundancy triggers**: "historical-nanochat", "historical_nanochat", "historical nanochat", "time-locked LLM", "pre-1913 corpus", "nanochat training", "governed_v4", "Phase-0-lite", "OCRonos-Vintage", "talkie-lm", "Pleias OCR", "Karpathy nanochat", "615M params d22", "Chinchilla r=30", "diverse corpus training dynamics", "shard-flip divergence", "parallel-shard dataloader", "REWIRE pretraining", "Mr. Chatterbox", "SFT provenance and era-purity gate", "period-native dialogue/QA", "modern synthetic SFT contamination"

**When a new discovery mentions historical-nanochat**:
1. Read `library/projects/historical-nanochat.md` first
2. Check the "Investigation Reports", "Blog-Idea Sources", and "Already-Evaluated Items" sections for prior coverage
3. If genuinely novel, evaluate normally; then add to the hub's appropriate section
4. If duplicate of prior coverage, skip and note in evaluation

---

## Backlog Integration Tranche — 2026-07-19

Documentation-only integrations from the reattached approved backlog (items approved
2026-06-23 → 2026-07-08 while the integration step was disconnected). Each entry below
has a full technique note and a verification report; nothing here installed tools or
changed runtime config.

### Deterministic SOP Workflows for High-Risk Recurring Tasks

Pattern from agentic-sop-to-work: decompose recurring ops work into single-tool steps
with per-step command/schema/trace gates, emit DRAFT outputs, require explicit approval
before side effects. Note: `library/techniques/deterministic-sop-workflows-2026-06-16.md`.
Score: 73.5/100.

**Redundancy triggers**: "deterministic SOP", "SOP to workflow", "agentic-sop-to-work", "gated workflow steps", "single-tool steps", "draft outputs approval", "hermetic step gates", "recurring ops task automation safety"

### Build with Claude — Monitored Claude Code Extension Index

`https://github.com/davepoon/buildwithclaude` (MIT, 3k+ stars): curated catalog of
Claude Code skills, agents, commands, hooks, plugins, MCP servers, and marketplaces.
Registered as a **monitored discovery/reference source** for the capability-discoverer
and heartbeat scans — check it before implementing a new skill/agent from scratch, and
before evaluating a "new" community capability that may already be cataloged there.
Nothing is auto-installed from it. Score: 80.5/100.

**Redundancy triggers**: "buildwithclaude", "build with claude", "davepoon", "claude code catalog", "skill marketplace index", "curated claude skills list", "claude code extension directory", "community skills catalog"

### ctx — Task-Scoped Skill/MCP Recommendation (evaluation candidate)

`https://github.com/stevesolun/ctx`: recommends a minimal task-relevant bundle of
skills/agents/MCP servers from a large installed graph. Approval-gated dry-run
evaluation plan documented; not adopted for automated use. Note:
`library/techniques/context-recommendation-ctx-2026-06-17.md`. Score: 80.5/100.

**Redundancy triggers**: "ctx recommender", "task-scoped skills", "skill recommendation tool", "capability bundle selection", "which skills to load", "context recommendation", "minimal capability bundle"

### oh-my-pi Harness Patterns — Hash-Anchored Edits / Summarized Reads / LSP-First

Extracted harness-design patterns (not a tool adoption): hash-anchored edit addressing,
summary-first file reads with full-read escalation, LSP-first symbol navigation,
deduplicated search windows. Note:
`library/techniques/hash-anchored-edits-summarized-reads-2026-06-17.md`. Score: 82.5/100.

**Redundancy triggers**: "oh-my-pi", "hash anchored edits", "summarized reads", "LSP-first context", "edit anchor hash", "summary-first file read", "token efficient editing harness"

### Polygraph Litmus — MCP Pre-Integration Behavioral Safety Gate

Procedure: before proposing any third-party MCP server, gather Litmus-style behavioral
evidence — tool-output injection, permission/egress, canary data handling, adversarial
inputs — in a sandbox. README review alone is insufficient. Note:
`library/techniques/mcp-litmus-safety-gate-2026-06-17.md`. Score: 71.75/100.

**Redundancy triggers**: "litmus", "polygraph litmus", "MCP behavioral testing", "MCP safety gate", "tool output injection test", "MCP canary test", "MCP pre-integration checks", "MCP server vetting"

### Context-Rent Memory Governance (token-warden)

Method: every standing rule/memory pays token rent; benchmark candidate rules against a
frozen task suite and retain only rules whose measured savings exceed carrying cost.
Quantified companion to the prune-constraints principle and weekly bloat check. Note:
`library/techniques/token-warden-context-rent-2026-06-18.md`. Score: 71.5/100.

**Redundancy triggers**: "context rent", "token warden", "memory governance", "rule carrying cost", "rules that pay rent", "benchmark rules frozen suite", "evict stale rules", "claude md rule cost"

### Claude Code Artifacts for Agent Work Handoff

Guidance: repo markdown stays the system of record; publish a Claude Code artifact
rendering when the audience is a human reviewing visually (PR walkthroughs, incident
reports, checklists, dashboards, owner-facing summaries). Doc: `docs/agent-reporting.md`.
Score: 79.2/100.

**Redundancy triggers**: "artifacts in claude code", "artifact handoff", "shareable session report", "PR walkthrough artifact", "incident report page", "agent reporting artifact", "live report page"

### Anthropic API response_inclusion + Code-Execution Cell Limits

Official API features: `response_inclusion` trims web_search/web_fetch result blocks
returned to context (API-layer sibling of local spill-to-file); code_execution cells are
killed at 90s — checkpoint long work across cells. Note:
`library/techniques/claude-api-response-inclusion-2026-06-25.md`. Score: 84.5/100.

**Redundancy triggers**: "response_inclusion", "response inclusion", "web_search_20260318", "web_fetch_20260318", "code_execution_20260521", "90 second cell limit", "code execution cell timeout", "web tool result trimming"

### Agent Containment Checklist (Anthropic official)

Checklist for unattended runs from "How We Contain Claude": credentials outside the
sandbox, workspace-only writes, deny-by-default egress, OS sandbox/VM for high-risk
work, hard limits instead of approval prompts (approval fatigue is measurable). Note:
`library/techniques/agent-containment-2026-06-25.md`. Score: 81.5/100.

**Redundancy triggers**: "how we contain claude", "agent containment", "containment checklist", "approval fatigue", "egress deny by default", "credentials outside sandbox", "hard limits not prompts", "unattended agent safety"

### Transcript Bloat Analysis Recipe (claude-session-analyzer)

Optional read-only recipe: run claude-session-analyzer on copied/redacted transcript
samples to attribute runtime token cost per skill, per session, and to standing context;
feed findings into bloat sweeps and prune-constraints audits. Note:
`library/techniques/claude-session-analyzer-token-bloat-2026-06-25.md`. Score: 74/100.

**Redundancy triggers**: "claude-session-analyzer", "session analyzer", "transcript token analysis", "per-skill token cost", "standing context share", "transcript bloat", "session cost breakdown"

### Agent Containment — Defense-in-Depth Design Note

Design argument companion to the containment checklist: every single layer (prompts,
approvals, sandbox scope) fails in a known way, so containment = independent stacked
layers; proposals saying "the agent will be instructed not to X" without a structural
layer are approval-gated, not autonomous. Note:
`library/techniques/agent-containment-defense-in-depth.md`. Score: 82.5/100.

**Redundancy triggers**: "defense in depth agents", "layered containment", "instructions are not boundaries", "structural boundary vs prompt", "approval prompt weakness", "containment layers"

### Domain-Expertise Planning Layer for Agent Sessions

From Anthropic's Claude Code usage study (humans plan / agents execute; expertise per
instruction drives delegation efficiency): before delegating execution, plans must state
explicit domain constraints, decision ownership (agent-owned vs reserved), and evidence
of completion. Note: `library/techniques/domain-expertise-planning-for-agents.md`.
Score: 85/100.

**Redundancy triggers**: "domain expertise planning", "decision ownership", "reserved decisions", "claude code expertise study", "constraints before delegation", "evidence of completion planning", "planning layer agents"

### Flow-Next Pattern — Specs, Re-Anchored Workers, Receipts

Extracted workflow loop: repo-owned durable specs → workers periodically re-anchored
from spec + repo state (not growing transcripts) → adversarial review of spec-vs-diff
(never the worker's self-report) → evidence receipts per step. Plugin not installed.
Note: `library/techniques/flow-next-reanchored-workers-receipts.md`. Score: 76.8/100.

**Redundancy triggers**: "flow-next", "flow next", "repo-owned spec", "re-anchored workers", "worker reanchoring", "evidence receipts", "adversarial review spec diff", "durable spec workflow"

### git-lazy-mount — Lazy Checkout for Very Large Repos

Evaluation candidate: FUSE-based lazily-materialized checkout + sgrep-routed search for
disposable agent sandboxes on very large repos; benchmark claims unverified locally;
not for primary working copies. Note:
`library/techniques/git-lazy-mount-large-repos.md`. Score: 71.5/100.

**Redundancy triggers**: "git-lazy-mount", "lazy checkout", "lazy clone large repo", "FUSE repo mount", "sgrep", "large repo cold start", "disposable sandbox checkout"

### Managed Agents — MCP Tunnels / Self-Hosted Sandboxes / Spill-to-File

Official capability record: MCP tunnels to private-network servers, self-hosted
sandboxes for Managed Agents, active-session MCP/tool config updates, automatic
spill-to-file for tool outputs >100K tokens. Documentation only; any tunnel experiment
against private infra stays approval-gated. Note:
`library/techniques/managed-agents-mcp-tunnels-2026-05-19.md`. Score: 82/100.

**Redundancy triggers**: "MCP tunnel", "managed agents tunnel", "private network MCP", "self-hosted sandbox managed agents", "spill to file 100K", "tool output spill", "mid-session MCP config", "dynamic tool configuration"

### Claude Code v2.1.193 / v2.1.195 Operational Changes

Recorded from the official changelog (capability record only — nothing enabled):

| Change | Version | Operational relevance |
|--------|---------|----------------------|
| Hook matchers with hyphenated identifiers exact-match (was substring) | 2.1.195 | Hooks matching MCP servers by bare name silently stop firing — rewrite as explicit patterns like `mcp__brave-search__.*`; audit checklist in `library/techniques/claude-code-hooks-2026-06.md` |
| MCP auth helper reconnects on 401/403 | 2.1.193 | Transient MCP auth failures self-heal; local auth-retry workarounds are now dead scaffolding candidates |
| Background agent reliability fixes | 2.1.193/195 | Fewer orphaned background tasks in long orchestrator sessions |
| Background shells reaped under memory pressure | 2.1.193/195 | Long-lived background shells may be killed on constrained hosts — do not park critical state in an idle shell |
| `CLAUDE_CODE_DISABLE_MOUSE_CLICKS` | 2.1.193/195 | Opt-out env var for terminal mouse handling (tmux copy-mode friction) |
| `autoMode.classifyAllShell` | 2.1.193/195 | **NOT enabled — requires sandbox testing before any enablement** (April 2026 env-var incident protocol: behavioral side effects must be tested, not read about) |

Score: 80.8/100.

**Redundancy triggers**: "v2.1.193", "v2.1.195", "hook matcher exact match", "hyphenated hook matcher", "mcp auth reconnect 401", "background shell memory pressure", "CLAUDE_CODE_DISABLE_MOUSE_CLICKS", "classifyAllShell", "autoMode classify all shell"

### Ocarina — Deterministic MCP Playbooks + Testing

YAML playbooks that drive MCP tool calls without an LLM in the loop: reproducible,
token-free, diffable. Adopted documentation-first as an optional MCP evaluation harness
(playbooks = fixed call sequences; testing = playbooks + assertions for replayable
smoke/regression tests, sandbox-only). Notes:
`library/techniques/mcp-deterministic-playbooks-ocarina.md`,
`library/techniques/deterministic-mcp-server-testing-ocarina-2026-06-29.md`.
Scores: 78.25/100, 76.5/100.

**Redundancy triggers**: "ocarina", "deterministic MCP playbook", "YAML MCP playbook", "MCP replay testing", "MCP assertions", "no-LLM tool driving", "MCP smoke test harness", "reproducible MCP testing"

### Claude Code Hook Matcher Exact-Match Audit (2.1.x)

Compatibility note + audit checklist for the 2.1.195 exact-match fix: find hyphenated
matchers, rewrite implicit server-prefix intent as explicit `mcp__server__.*` patterns,
empirically verify hooks still fire, sweep obsolete auth workarounds. Note:
`library/techniques/claude-code-hooks-2026-06.md`. Score: 72.25/100.

**Redundancy triggers**: "hook matcher audit", "hook stopped firing", "hook substring match", "mcp__ wildcard matcher", "hook exact match 2.1.195", "silent hook failure"

### MCP Server Security Evaluation Template (Capframe + battery)

Evaluation template at `pipeline/evaluation/templates/mcp-server-security.md`: every
third-party MCP server proposal must record a Capframe leaderboard check
(https://capframe.ai/leaderboard — external authority-hygiene signal; not-listed is not
a pass), static config review, Litmus-style behavioral evidence, and optionally an
Ocarina playbook. Score: 74.5/100.

**Redundancy triggers**: "capframe", "capframe leaderboard", "MCP risk signal", "MCP server security template", "authority hygiene", "MCP evaluation checklist", "third-party MCP vetting"

### Procedure-versus-Capability Ceiling Debugging

Evidence-first debugging guidance that separates repairable procedure gaps from
probable model capability ceilings. It requires stable success criteria, passing
tool and environment checks, materially different attempts, independent evidence,
and explicit escalation records before routing to a stronger model or human review.
Skill: `skills/systematic-debugging/SKILL.md`. Score: 72/100.

**Redundancy triggers**: "procedure gap", "capability ceiling", "systematic debugging", "debug escalation boundary", "stronger model escalation", "repeated procedural churn", "harness capability limit"
