# Library Index

> Knowledge archive for Claude Code evolution system
> **Last Updated**: 2026-03-07

## By Category

### Techniques
*Coding, prompting, and workflow techniques*

- **[Cost-Effective Harnesses with Fable 5](techniques/cost-effective-fable-harnesses-2026-07-10.md)** — First-party Anthropic write-up (Lance Martin, 2026-07-10). When to spend frontier intelligence: task-shape asymmetry → Fable as orchestrator / advisor / verifier. Empirical: Parameter Golf (Fable+Sonnet = 90% of Fable-solo gain at 34% cost, value from *scattered advisory checkpoints* not upfront planning); BrowseComp (delegation only pays above a token-volume threshold — +60% markup on the easy set, 96% score at 46% cost on the full set). 4 guidelines: examine task shape, delegation heuristics, coordination cost, prompt-cache discipline. Verbatim article archived. Tags: `fable-5`, `cost-optimization`, `harness-design`, `orchestrator-advisor-verifier`, `delegation`, `prompt-caching`, `token-efficiency`
- **[OpenClaw Agent Operational Patterns](techniques/openclaw-agent-operational-patterns-2026-03-07.md)** — Extracted patterns from 130+ hour autonomous Claude-in-Docker agent: tiered autonomy, runaway loop detection, stagnation protocol, capability lifecycle, sub-agent verification, small diff doctrine. Tags: `openclaw`, `autonomous-agent`, `operational-patterns`, `self-governance`, `anti-patterns`
- **[Rules Directory — Conditional Context Loading](techniques/rules-directory-conditional-loading-2026-03-06.md)** — `.claude/rules/` with `paths:` frontmatter for conditional rule loading. Rules load only when editing matching files, reducing per-session context. v2.1.69 fixed print mode. Tags: `rules-directory`, `conditional-loading`, `context-management`, `token-efficiency`
- **[Skills 2.0 Evaluation Improvements](techniques/skill-evaluation-improvements-2026-03-06.md)** — Assertion-based test format, model drift detection, and failure analyzer pass adopted from Anthropic Skills 2.0 into DSPy optimizer. Tags: `prompt-optimization`, `assertion-testing`, `model-drift`, `failure-analysis`
- **[Anchor-Based Paraphrase Matching](techniques/anchor-based-paraphrase-matching-2026-03-23.md)** — 3-signal hybrid matcher for comparing findings across different vocabularies (gold-standard manifest vs model output). Anchors (entities/numbers/terms) + char n-grams + keyword Jaccard. 4-7x improvement over pure Jaccard. Use when both texts reference the same source document but use different language. Tags: `metric`, `matching`, `paraphrase-detection`, `review`, `nlp`, `prompt-optimization`
- **[Seeing Like an Agent — Anthropic Tool Design Philosophy](techniques/seeing-like-an-agent-tool-design-2026-04-20.md)** — First-party Anthropic engineering post (Thariq Shihipar, 2026-04-10). Progressive disclosure principle: tools/skills should lead with "when to use," not "how it works." Agent perceptual model vs. human model. Case studies: AskUserQuestion blocking modal, Task tool context isolation. Validates 2KB SKILL.md cap + decision-tree-first layout. Tags: `tool-design`, `progressive-disclosure`, `skill-authoring`, `agent-perceptual-model`, `discoverability`
- **[WSL → Native Linux Migration](techniques/wsl-to-native-linux-migration-2026-03-03.md)** — Desktop migration from WSL (imperator-1) to native Linux (requiem). Key improvements: 9x I/O, native Chrome, direct localhost DevTools, native systemd/Docker. WSL scripts preserved for orbis laptop. Tags: `migration`, `wsl`, `native-linux`, `browser-automation`, `chrome`, `infrastructure`
- **[Synthetic Pretraining & REWIRE](techniques/synthetic-pretraining-rewire-2026-03-01.md)** — REWIRE rephrasing framework for improving fact retention in pretraining data. Three-stage taxonomy (memorization, logical hardwiring, system simulations). Directly applicable to historical-nanochat project. Tags: `pretraining`, `fine-tuning`, `REWIRE`, `historical-nanochat`, `data-quality`
- **[Deterministic SOP Workflows](techniques/deterministic-sop-workflows-2026-06-16.md)** — Convert recurring high-risk ops SOPs into deterministic gated workflows: single-tool steps, per-step command/schema/trace gates, DRAFT outputs, explicit approval before side effects. From agentic-sop-to-work; pattern adopted, not the tool. Tags: `deterministic-workflow`, `sop`, `gated-execution`, `approval-gate`, `ops-safety`
- **[ctx — Task-Scoped Skill/MCP Recommendation](techniques/context-recommendation-ctx-2026-06-17.md)** — Recommender that maps a task description to a minimal bundle of skills/agents/MCP servers. Approval-gated dry-run evaluation plan (precision/recall vs transcript ground truth) before any automated use. Tags: `context-management`, `token-efficiency`, `skill-selection`, `recommender`
- **[oh-my-pi Harness Patterns](techniques/hash-anchored-edits-summarized-reads-2026-06-17.md)** — Extracted token-efficiency mechanisms: hash-anchored edit addressing, summary-first reads with full-read escalation, LSP-first symbol navigation, deduplicated search windows. Benchmark claims unverified locally. Tags: `token-efficiency`, `harness-design`, `hash-anchored-edits`, `summarized-reads`, `lsp`
- **[Polygraph Litmus — MCP Safety Gate](techniques/mcp-litmus-safety-gate-2026-06-17.md)** — Require Litmus-style behavioral evidence (output injection, permission/egress, canary handling, adversarial inputs) in a sandbox before proposing any third-party MCP server. Procedure adopted; tool itself still young. Tags: `mcp-safety`, `pre-integration-gate`, `behavioral-testing`, `prompt-injection`
- **[Context-Rent Memory Governance](techniques/token-warden-context-rent-2026-06-18.md)** — Every standing rule pays token rent; benchmark rules against a frozen suite and retain only those whose measured savings exceed carrying cost. Quantified companion to the prune-constraints principle. Tags: `context-rent`, `memory-governance`, `token-efficiency`, `bloat-control`
- **[Claude API response_inclusion + Cell Limits](techniques/claude-api-response-inclusion-2026-06-25.md)** — Official API controls: `response_inclusion` trims web_search/web_fetch result blocks returned to context; code-execution cells die at 90s — checkpoint across cells. Tags: `anthropic-api`, `response-inclusion`, `token-efficiency`, `code-execution`
- **[Agent Containment Checklist](techniques/agent-containment-2026-06-25.md)** — Anthropic-official containment for unattended runs: credentials outside sandbox, workspace-only writes, deny-by-default egress, VM isolation for high risk, hard limits over approval prompts (approval fatigue is measurable). Tags: `agent-containment`, `sandboxing`, `egress-control`, `unattended-runs`
- **[Transcript Bloat Analysis Recipe](techniques/claude-session-analyzer-token-bloat-2026-06-25.md)** — Read-only recipe: run claude-session-analyzer on copied transcript samples to attribute runtime token cost per skill/session/standing-context; feeds bloat sweeps. Tags: `transcript-analysis`, `token-bloat`, `standing-context`, `bloat-sweep`
- **[Agent Containment — Defense-in-Depth](techniques/agent-containment-defense-in-depth.md)** — Design argument: every single containment layer fails in a known way (prompts via injection, approvals via fatigue, sandboxes via scope creep); safety = independent stacked layers, and "the agent will be instructed not to X" without a structural layer means approval-gated, not autonomous. Tags: `defense-in-depth`, `agent-containment`, `layered-safety`
- **[Domain-Expertise Planning Layer](techniques/domain-expertise-planning-for-agents.md)** — Before delegating execution: explicit domain constraints, decision ownership (agent-owned vs reserved), and declared evidence of completion. From Anthropic's Claude Code usage study. Tags: `planning`, `decision-ownership`, `delegation`, `completion-evidence`
- **[Flow-Next — Specs, Re-Anchored Workers, Receipts](techniques/flow-next-reanchored-workers-receipts.md)** — Repo-owned durable specs; workers re-anchored from spec+repo state instead of growing transcripts; adversarial review of spec-vs-diff; per-step evidence receipts. Tags: `repo-owned-specs`, `worker-reanchoring`, `evidence-receipts`, `adversarial-review`
- **[git-lazy-mount for Very Large Repos](techniques/git-lazy-mount-large-repos.md)** — FUSE lazy-materialization checkout + sgrep search for disposable agent sandboxes on huge repos; evaluation plan included, claims unverified locally; not for primary working copies. Tags: `large-repos`, `lazy-checkout`, `fuse`, `disposable-sandbox`
- **[Managed Agents — MCP Tunnels & Spill-to-File](techniques/managed-agents-mcp-tunnels-2026-05-19.md)** — Official: MCP tunnels to private-network servers, self-hosted sandboxes, mid-session MCP config updates, auto spill-to-file for >100K-token tool outputs. Documentation-only record; tunnel experiments approval-gated. Tags: `managed-agents`, `mcp-tunnels`, `spill-to-file`, `token-efficiency`
- **[Ocarina — Deterministic MCP Playbooks](techniques/mcp-deterministic-playbooks-ocarina.md)** — YAML playbooks drive MCP tool calls with no LLM in the loop: reproducible, token-free, diffable. Primary fit: MCP evaluation harness; sandbox-only until proven. Tags: `ocarina`, `mcp-playbooks`, `deterministic-execution`, `token-efficiency`
- **[Claude Code Hook Matcher Exact-Match Audit](techniques/claude-code-hooks-2026-06.md)** — 2.1.195 made hyphenated hook matchers exact-match; bare server-name matchers silently stop firing. Audit checklist: rewrite as `mcp__server__.*` patterns, verify empirically, sweep dead auth workarounds. Tags: `claude-code-hooks`, `hook-matchers`, `silent-failure`, `config-audit`
- **[Deterministic MCP Server Testing (Ocarina)](techniques/deterministic-mcp-server-testing-ocarina-2026-06-29.md)** — Playbooks + assertions as replayable MCP smoke/regression tests: enumerate tools, fix inputs, assert structure, record run artifact, re-run on change. Functional twin of the Litmus adversarial gate. Tags: `mcp-testing`, `replay-assertions`, `regression-testing`, `sandbox`

### Projects
*Project hubs — cross-reference indexes for active workspace projects*

- **[Historical Nanochat](projects/historical-nanochat.md)** — Time-locked LLM training (615M params, d22, requiem 3090). Indexes 5 investigation reports, 3 blog-ideas, 1 completed evaluation, 1 technique cross-ref. Active training run `governed_v4_d22_r30_parallel_family` at step 10,000 / val BPB 1.2406, ETA ~2026-05-10. Open problems: multi-family corpus dynamics (BLOCKING governed re-run), OCRonos-Vintage preprocessing (UNEVALUATED), rights audit, provenance bug. Tags: `historical-nanochat`, `llm-training`, `time-locked-llm`, `governed-corpus`, `requiem`

### Tools
*Tool-specific knowledge and gotchas*

<!-- Entries will be added here -->

### Patterns
*Architecture, design, and delegation patterns*

<!-- Entries will be added here -->

### Troubleshooting
*Solutions to problems encountered*

<!-- Entries will be added here -->

### Discoveries
*Raw discoveries and learnings*

<!-- Entries will be added here -->

### People
*Notable people, their work, resources*

<!-- Entries will be added here -->

### Resources
*URLs, feeds, documentation references*

<!-- Entries will be added here -->

---

## Recently Added

| Date | Entry | Category |
|------|-------|----------|
| 2026-03-07 | OpenClaw Agent Operational Patterns | Techniques |
| 2026-03-07 | Rules Directory — Conditional Loading | Techniques |
| 2026-03-06 | Skills 2.0 Evaluation Improvements | Techniques |
| 2026-03-03 | WSL → Native Linux Migration | Techniques |
| 2026-03-01 | Synthetic Pretraining & REWIRE | Techniques |

---

## Tags

*Tags will be indexed here as entries are added*

---

## Library Statistics

- **Total Entries**: 5
- **Categories**: 7
- **Last Maintenance**: Never

---

## How to Add Entries

Use the `context-librarian` subagent:

```
Task (context-librarian):
  "Archive the following:
   - Topic: [topic name]
   - Category: [category]
   - Content: [information]
   - Source: [source]
   - Tags: [keywords]"
```

Or for bulk archival from a session:

```
Task (context-librarian):
  "Review and archive useful information from this session:
   [session summary]"
```
