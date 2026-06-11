# Evaluation Report: Mission Control (builderz-labs)

## Basic Information
- **Source**: https://github.com/builderz-labs/mission-control
- **Category**: Tool / Dashboard (full web application)
- **License**: MIT
- **Last Updated**: 2026-03-11 (v2.0.0)
- **Stars/Validation**: 2,455 stars / 405 forks / 213 commits
- **Stability**: Alpha (explicitly labeled; APIs and schemas may change between releases)
- **Tech Stack**: Next.js 16, React 19, TypeScript 5.7, SQLite (better-sqlite3), Node 22+, pnpm

## Summary

Mission Control is an open-source dashboard for AI agent orchestration. It provides 32 panels covering agent fleet management, real-time WebSocket monitoring, cost tracking, natural language cron scheduling, Claude Code session scanning, local agent discovery, a Skills Hub with registry integration, a 4-layer agent evaluation framework, security audit panel, and framework adapters for OpenClaw/CrewAI/LangGraph/AutoGen/Claude SDK.

The discovery prompt specifically asks whether **extractable techniques** provide value even if the full dashboard is too heavy to adopt. This evaluation covers both paths.

---

## Redundancy Analysis

### Overlapping Capabilities

| Mission Control Feature | Existing Equivalent | Overlap Level |
|------------------------|---------------------|---------------|
| Agent fleet management / monitoring | agent-event-bus (16 MCP tools, agent registration, heartbeat, status tracking) | HIGH (80%+) |
| Real-time activity stream | event-bus-publisher/reader subagents + playground dashboard | HIGH (80%+) |
| Task management (Kanban) | TodoWrite (built-in) + plan-tracker skill | MEDIUM (60%) |
| Natural language cron scheduling | CronCreate/CronList/CronDelete (native Claude Code) | MEDIUM (50%) |
| Claude Code session discovery | Not currently tracked beyond event-bus publish | LOW (20%) |
| Agent discovery from ~/.claude/agents/ | Agents already in INDEX.md; no live inventory UI | LOW (30%) |
| Cost/token tracking | No existing equivalent | NOVEL |
| Skills security scanner | security-auditor agent (code scanning, not skill-specific) | LOW (30%) |
| 4-layer agent eval framework | capability-evaluator (discovery scoring, not runtime eval) | LOW (20%) |
| Framework adapters (OpenClaw, etc.) | openclaw-sandbox (Docker isolation, task submission) | LOW (20%) |

### Classification

**Mixed**: 3 features are DUPLICATE/near-duplicate (agent management, activity stream, cron). 2 features are NOVEL (cost tracking, skills security scanner). 4 features are partial IMPROVEMENTS (session discovery, agent inventory, eval framework, NL cron). However, the delivery mechanism (full Next.js web app) creates significant integration overhead that reduces the net value.

---

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 30/100 | 20% | 6.0 | Full Next.js 16 web app requiring its own deployment (Docker or local Node 22+). Not an MCP server, not a skill, not a drop-in. Requires SQLite database, WebSocket infrastructure, auth configuration, TLS proxy for network access. Even "technique extraction" requires reading and porting source code manually. |
| Token Efficiency Impact | 40/100 | 25% | 10.0 | Neutral to slightly negative for Claude Code token usage. Cost tracking could help identify waste after the fact, but does not reduce tokens at generation time. Any integration adapter adds instrumentation overhead. The dashboard itself consumes zero Claude tokens (runs independently), but configuring integration points costs setup effort. No direct token savings pathway. |
| Capability Expansion | 50/100 | 25% | 12.5 | Two genuinely novel capabilities: (1) token/cost tracking dashboard and (2) skills security scanner with pre-install scanning. The 4-layer eval framework (output, trace, component, drift) is conceptually interesting but operationally distinct from our discovery-evaluation pipeline. Most other features are redundant with agent-event-bus + native Claude Code cron. The novel features are useful but narrow. |
| Maintenance Burden | 25/100 | 15% | 3.75 | Alpha-labeled software with explicit schema instability warning. Next.js 16 + React 19 + better-sqlite3 require ongoing updates. 32 panels means large surface area for bugs. The project is active (v2.0.0 just released, 213 commits) but alpha stability means breaking changes are expected. If only extracting techniques, maintenance drops to zero -- but so does ongoing value. |
| Community Validation | 80/100 | 15% | 12.0 | 2,455 stars / 405 forks is strong community validation. Active development with recent v2.0.0 release. Multiple framework adapters suggest real usage. The fork by PrakharMNNIT suggests community engagement. Deducted from 100 because the project is explicitly alpha. |
| **WEIGHTED TOTAL** | | | **44.25/100** | |

---

## Cross-Validation

- **Claude Assessment**: 44.25/100
- **Codex Assessment**: 46/100
- **Variance**: 1.75 points
- **Consensus**: ACHIEVED (strong agreement on rejection)

Both assessments converge on the same conclusion: the full dashboard is too heavy for direct integration, but 2-3 techniques are worth extracting. Codex specifically called out the skill scanner rules, session scanner, and drift heuristics as extractable value. The tight score convergence (1.75 points) indicates high confidence in the evaluation.

---

## Security Assessment

- [ ] No sensitive permissions required -- **FAILS**: Reads ~/.claude/projects/, ~/.claude/agents/, ~/.claude/tasks/, ~/.claude/teams/. Codex confirmed the codebase can also WRITE back to local agent/skill files from the UI.
- [x] No excessive data access -- Partial: read access is reasonable for a dashboard, but write-back capability is a concern.
- [x] License compatible (MIT/Apache/BSD) -- MIT license, fully compatible.
- [ ] No known vulnerabilities -- Alpha software with explicit security warnings (change defaults, deploy behind TLS, configure MC_ALLOWED_HOSTS). No CVEs found, but alpha stability implies unaudited code paths.
- [x] API keys manageable -- No external API keys required (SQLite local, reads local filesystem).

---

## Existing Alternatives

| Feature | Existing Alternative | Gap? |
|---------|---------------------|------|
| Agent fleet monitoring | agent-event-bus (16 tools) + playground dashboard | No significant gap |
| Activity stream | event-bus-publisher/reader + sync-to-website.sh | No significant gap |
| Cron scheduling | Native CronCreate/CronList/CronDelete | NL syntax is nice-to-have, not critical |
| Cost/token tracking | **No equivalent** | Real gap, but solvable with lightweight scripts |
| Skills pre-install scanning | security-auditor agent (general code) | Real gap for skill-specific scanning |
| 4-layer eval (output/trace/component/drift) | capability-evaluator (discovery scoring) | Different domains; runtime eval is a real gap |
| Session tracking | event-bus publish (manual) | Automatic discovery is better; extractable as a script |

---

## Technique Extraction Analysis

The discovery prompt specifically asks about extractable techniques. Assessment:

### Worth Extracting (low effort, high value)

1. **Claude Code session scanner pattern** -- Reading ~/.claude/projects/ to discover active sessions/history. Could be a lightweight bash script feeding into event-bus. Estimated effort: 2-4 hours.

2. **Skill security scanner rules** -- Pre-install scanning heuristics for skills. Could be integrated into security-auditor agent or a pre-install hook. Estimated effort: 4-8 hours to port rules.

3. **Token cost aggregation pattern** -- Parsing Claude Code session data for token usage. Could feed into event-bus as a cron job. Estimated effort: 4-8 hours.

### Not Worth Extracting (high effort, low incremental value)

4. **4-layer eval framework** -- Conceptually interesting but operationally complex. Our capability-evaluator serves a different purpose (discovery scoring vs runtime eval). Would require building trace infrastructure we don't have.

5. **Natural language cron** -- Native CronCreate already handles scheduling. NL parsing adds a convenience layer but not a capability jump.

6. **Framework adapters** -- We only use OpenClaw, and our Docker-isolated sandbox approach is more secure than an adapter pattern.

---

## Recommendation

**DECISION**: [x] REJECT (<70)

**Score**: 44.25/100

**Rationale**: Mission Control is a well-executed alpha dashboard, but it fundamentally solves a different problem than what the claude-evolution system needs. Our system optimizes Claude Code's internal capabilities (skills, agents, techniques, MCPs), while Mission Control provides external human-facing observability. The 3 core areas of overlap (agent management, activity stream, cron) are already better served by agent-event-bus and native Claude Code features. The 2 genuinely novel features (cost tracking, skill security scanning) are narrow enough to extract as lightweight scripts or hooks rather than adopting a full Next.js deployment.

The alpha stability label, write-back security concern, and significant maintenance burden of a 32-panel web app all weigh against integration. The Codex cross-validation independently reached the same conclusion (46/100) with the same recommendation: technique-harvest, not full integration.

**Technique Harvest Path** (recommended alternative to full integration):

1. **Session scanner script**: Port the Claude Code session discovery pattern from `claude-sessions.ts` into a bash/TypeScript script that publishes to agent-event-bus. Estimated: 2-4 hours, zero ongoing maintenance.
2. **Skill security pre-install hook**: Extract scanner rules from `skill-registry.ts` and integrate into a SessionStart or pre-install hook. Estimated: 4-8 hours, low maintenance.
3. **Token usage aggregation**: Build a lightweight cron job that parses session data for token/cost reporting. Feed into event-bus. Estimated: 4-8 hours, low maintenance.

These extractions would capture ~80% of the novel value at ~5% of the integration cost.

**Reconsideration Triggers**:
- Mission Control reaches v1.0 stable release with guaranteed schema stability
- An official MCP adapter is published (making it a drop-in rather than a full deployment)
- Cost tracking becomes a critical pain point that lightweight scripts cannot address

---

## Files Referenced

- Registry: `/home/<user>/claudeworkspace/claude-evolution/registry/existing-capabilities.md`
- Event Bus Architecture: `/home/<user>/claudeworkspace/orchestration/agent-event-bus.md`
- Agent Index: `~/.claude/agents/INDEX.md`
- Security Auditor: `~/.claude/agents/security-auditor.md`

---

*Evaluated: 2026-03-13*
*Evaluator: capability-evaluator (Opus 4.6)*
*Cross-validated: Codex (GPT-5.4) -- 46/100, consensus achieved (1.75pt variance)*
