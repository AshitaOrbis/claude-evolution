---
date: 2026-05-18
topic: "This seems useful, built into Hermes I guess but worth documenting I think."
discord_message_id: "1505931267202613248"
sources:
  - https://hermes-agent.nousresearch.com/docs/user-guide/features/kanban
  - https://github.com/NousResearch/hermes-agent/pull/27572
status: complete
---

# Hermes Kanban — Durable Multi-Agent Task Board

## Topic

"This seems useful, built into Hermes I guess but worth documenting I think. Seems useful"
— with links to the Hermes Kanban docs and PR #27572 (orchestrator auto-decomposition)

## Key Findings

- **Kanban is already in our Hermes** — it's built into the Nous Research Hermes Agent that runs as `hermes-gateway-kimi.service` on requiem. No install needed; it's accessible immediately via `hermes --profile kimi kanban`.
- **SQLite-backed, cross-session durable** — task state persists at `~/.hermes/kanban.db` and survives gateway restarts. This is architecturally superior to our current file-based state (`state.json` files, cron flags) for long-running pipelines.
- **PR #27572 adds auto-decomposition** — drop a one-liner task into Triage, and Hermes uses an auxiliary LLM to decompose it into a DAG of child tasks, automatically assigned to named profiles. The root task waits until all descendants complete.
- **Multi-profile dispatch** — the dispatcher claims ready tasks and spawns the assigned profile. With profiles like `kimi` (GPT-5.5/xhigh) available, this enables async multi-agent work without Claude session dependencies.
- **Human-in-the-loop is first-class** — `kanban_block` / manual unblock / comments support the checkpoint-and-approve workflow we use for sensitive operations (deploy confirmations, DB writes).
- **REST + WebSocket API** — REST at `/api/plugins/kanban/` supports full CRUD and bulk operations; WebSocket enables live streaming of board state. Both are localhost-only (requires dashboard session token, no external auth needed).
- **CLI surface**: `hermes kanban show`, `hermes kanban create`, `hermes kanban complete`, `hermes kanban block` (or slash commands `/kanban ...` inside a session).

## Details

### What the Kanban System Is

Hermes Kanban is described in the docs as "a durable task board, shared across all your Hermes profiles, that lets multiple named agents collaborate on work without fragile in-process subagent swarms." The key design philosophy is durability over in-memory coordination — tasks are SQLite records, not live subagent threads, so failures don't lose work.

Task statuses span: `triage → todo → in_progress → blocked → done`. The dispatcher ticks every 60 seconds by default (configurable via `kanban.dispatch_interval_seconds`), claims ready tasks, and spawns the assigned profile. A parent task waits for all its child tasks to complete before moving to `ready`.

### PR #27572: Auto-Decomposition via LLM

The orchestrator-driven auto-decomposition feature (merged per the PR) is the most impactful addition:

1. User drops a high-level description into Triage
2. Dispatcher detects a triage task, calls an auxiliary LLM with the full profile roster
3. LLM produces a JSON task graph — nodes with assignees, descriptions, and dependency edges
4. Hermes atomically creates all child tasks and links the root as dependent on every leaf
5. Child tasks dispatch to their assigned profiles in parallel; root promotes when all complete

Configuration: `kanban.auto_decompose: true` (default), `kanban.orchestrator_profile` (which profile handles decomposition), `kanban.default_assignee` (fallback for unknown assignees). Three decompositions per dispatcher tick by default (to prevent runaway spawning).

The PR also adds profile `description` fields — either manually set or LLM-generated from a profile's skills and model. These descriptions are what the decomposition LLM uses to route tasks to the right profile.

### Workspace Architecture Fit

Our current multi-step pipeline coordination relies on:
- Claude Code cron scripts with file-based state (`state.json` at various project roots)
- `pipeline-orchestrator` and `workspace-orchestrator` subagents invoked from shell wrappers
- Sequential execution with in-session memory (context-dependent, lost on session end)

Kanban solves the statelessness problem. The `kimi` profile's cron history (`hermes-cron-cutover.md`) shows we already have the infrastructure; Kanban is a higher-level coordination layer on top of the same running gateway.

**Concrete application areas:**

| Pipeline | Current | Kanban Opportunity |
|----------|---------|-------------------|
| Evolution heartbeat | Shell script → Claude Code | Triage task auto-decomposed into discovery/eval/integration subtasks |
| Historical nanochat training phases | Manual triggers + notes | Kanban DAG: data prep → training → eval → blog trigger |
| Investigation runner | Cron → Claude Code session | Kanban tasks per Discord topic; dispatcher claims and runs in kimi profile |
| Multi-step deployments | Sequential shell | Blocked tasks at approval gates (deploy, DB write) |

### What's Different from `workspace-orchestrator`

The workspace orchestrator reads project state and orchestrates Claude subagents within a single Claude session — it's synchronous and context-bound. Kanban is asynchronous, persistent, and runs through Hermes — tasks survive Claude usage limits, session context exhaustion, and requiem reboots. The two complement each other: Claude for interactive synthesis, Kanban for long-running background coordination.

## Relevance to Workspace

This is directly relevant to three active areas:

1. **Hermes cron migration** — `hermes-cron-cutover.md` describes migrating OS cron jobs to Hermes built-in cron. Kanban extends this: instead of scheduled prompts, define a dependency graph for multi-phase work that Hermes manages end-to-end.

2. **Historical nanochat training** — training runs span days (requiem 3090, active through ~2026-05-10). Kanban could track phase transitions (warmup → train → eval) with automatic downstream task spawning on completion, replacing the current manual monitoring.

3. **Claude evolution pipeline** — the discovery → evaluation → integration → verification pipeline is a natural DAG. Currently managed with `pipeline/` file states; migrating to Kanban would provide an audit trail, durability, and cross-session visibility.

## Recommended Actions

1. **Verify Kanban is available in current kimi profile**: `hermes --profile kimi kanban show` — if it errors, update Hermes to the version containing PR #27572.
2. **Set up profile descriptions** for the `kimi` profile and any specialist profiles to enable auto-decomposition routing.
3. **Run a pilot Kanban task**: Create one task manually, let the dispatcher claim it, observe the flow. Low-risk candidate: a one-shot investigation task.
4. **Update `hermes-cron-cutover.md`** to document Kanban as the preferred coordination layer for new multi-phase work (above and beyond simple scheduled prompts).
