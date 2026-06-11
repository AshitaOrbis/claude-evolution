# Batch Evaluation: Feb 15-17 Discoveries + Pending Research

**Evaluator**: Claude Opus 4.6
**Date**: 2026-02-20
**Items evaluated**: 9 discoveries + 2 pending research items

## Evaluation Framework

| Criterion | Weight |
|-----------|--------|
| Integration complexity | 20% |
| Token efficiency impact | 25% |
| Capability expansion | 25% |
| Maintenance burden | 15% |
| Community validation | 15% |

---

## 1. CloudRouter (VM/GPU Provisioning) — 65.25/100 → FUTURE

**Scores**: Integration=50, Token efficiency=70, Capability expansion=85, Maintenance=40, Community=70

**Novel capability**: Yes — no VM/GPU provisioning exists in current stack.

**Research findings**:
- 851 GitHub stars, 132 releases, MIT license, active development
- No public pricing page (opaque costs via E2B/Modal backends)
- Credential management for agent workloads: undocumented
- SSH uses `StrictHostKeyChecking=no` (tunneled via TLS WebSocket — acceptable)
- Early-stage: auth bugs, Windows issues, missing git in environments
- GPU tiers: T4 through H100 (B200 requires approval)

**Why FUTURE (not reject)**:
- Capability is genuinely novel (VM/GPU on-demand for agents)
- Strong community signal (134 HN points, engaged founders)
- But: no immediate use case (desktop-first workflow, no GPU workloads)
- Opaque pricing + undocumented credential management = not ready

**Adoption trigger**: If we need isolated cloud compute or GPU workloads.
**Alternative**: SSH to any cloud VM (zero cost, full control, no account).

---

## 2. Canva MCP — 52.5/100 → REJECT

**Scores**: Integration=70, Token efficiency=30, Capability expansion=40, Maintenance=60, Community=80

**Research findings**:
- Two products: AI Connector (design, 53+ tools) + Dev MCP (app scaffolding, ~5 tools)
- Free tier available; autofill/brand templates = Enterprise only
- 53+ tools = ~10-21k token overhead (massive even with Tool Search)
- Dev MCP requires no subscription, runs locally

**Why REJECT**:
- We don't use Canva (zero platform fit)
- Google Stitch already covers AI-driven UI/design generation
- 53+ tools = unacceptable token overhead for unused capability
- Design automation doesn't align with evolution pipeline or game development

---

## 3. Showboat & Rodney — 71.75/100 → APPROVED (Documented, Integration Deferred)

**Scores**: Integration=80, Token efficiency=90, Capability expansion=40, Maintenance=85, Community=70

**Research findings**:
- CLI tools (NOT MCP servers) — Go binaries, installable via `uvx`
- Showboat: 320 stars, Apache-2.0, produces re-runnable verification Markdown docs
- Rodney: 371 stars, persistent Chrome CLI, agent-readable `--help`
- No accounts, no subscriptions, no fly.io requirement
- Simon Willison: trusted author, active maintenance

**Why APPROVED but deferred**:
- Zero token overhead (CLI, not MCP)
- Elegant agent verification concept (re-runnable proof-of-work documents)
- BUT: existing pipeline already produces structured verification (test suites, persona reports, visual inspection, QA summaries)
- No immediate gap that Showboat/Rodney fills
- Worth adopting if we need agent demo/verification documents in future

**Adoption trigger**: If evolution pipeline or game pipeline needs agent-produced verification docs beyond existing test/QA reports.

---

## 4. Omnara (Mobile IDE) — 42/100 → REJECT

**Scores**: Integration=30, Token efficiency=50, Capability expansion=35, Maintenance=60, Community=70

**Why REJECT**: Desktop-first workflow, external platform dependency ($20/mo), security concerns (code synced to third party). Alternative: Termux + SSH (zero cost, full control).

---

## 5. Lean-Collab (Multi-Agent) — 55/100 → REJECT

**Scores**: Integration=65, Token efficiency=50, Capability expansion=35, Maintenance=50, Community=50

**Why REJECT**: 70-80% overlap with evolution-orchestrator + Task tool + batch-orchestrator. "Real-time subscriptions" undefined and likely file-based (same as our pattern). Small community (mutable-state-inc org). Only validated on Putnam math problems.

---

## 6. Qlik MCP — SKIP (No Platform)

We don't use Qlik. Same pattern as Grafana/Terraform FUTURE items.

---

## 7. Nexus Claude Code MCP — REJECT

75-85% overlap with Claude Squad + evolution-orchestrator. iTerm2 dependency (macOS-only, we use WSL). MCP overhead for terminal management that external tools handle better.

---

## 8. Miro MCP — SKIP (No Platform)

We don't use Miro. Same pattern as Qlik/Grafana FUTURE items.

---

## 9. GPT-5.3-Codex-Spark — MONITOR (Version Tracker)

**Confirmed real**: Announced Feb 12, 2026 by OpenAI. 1000+ tokens/sec on Cerebras WSE-3.
**API status**: NOT generally available — select design partners only.
**Model ID**: `gpt-5.3-codex-spark`
**Action**: Watch for general API availability. When available, test via Codex MCP wrapper and update `~/.codex/config.toml` if performance improves over `gpt-5.2-codex`.

---

## 10. Claude Cowork — SKIP (Product Category Mismatch)

**Confirmed real**: Official Anthropic product, launched Jan 12, 2026.
**What it is**: Desktop file/document automation agent in Claude Desktop (not Claude Code).
**Tier**: Max ($100/mo) and Pro ($20/mo).
**Why SKIP**: Consumer desktop product, not relevant to Claude Code evolution pipeline or developer workflows.

---

## 11. Hidden Claude Code Commands — ARCHIVE (Knowledge)

**Potentially new commands found**:
| Command | Description | Actionable? |
|---------|-------------|-------------|
| `/statusline` | Real-time context usage monitor | YES — directly useful for 80% context exit rule |
| `/teleport` | Move sessions between local and web | YES — worth testing for mobile access |
| `/tasks` | Persistent task list across sessions | MAYBE — test persistence claims |
| `/resume` | Resume past sessions | MAYBE — likely already known |
| `/output-style` | Change response style | LOW — cosmetic |
| `/theme` | Syntax highlighting themes | LOW — cosmetic |
| `/terminal-setup` | Enable Shift+Enter for multi-line | LOW — already configured |

**Keyboard shortcuts**: `Ctrl+G` (editor), `Ctrl+T` (toggle task list), `Esc+Esc` (rewind menu).
**Action**: Verify `/statusline` and `/teleport` in current version, archive rest.

---

## Summary

| Discovery | Score | Verdict | Action |
|-----------|-------|---------|--------|
| CloudRouter | 65.25 | FUTURE | Monitor for pricing clarity + use case |
| Canva MCP | 52.5 | REJECT | No platform fit, token overhead |
| Showboat & Rodney | 71.75 | APPROVED (deferred) | Document in registry, defer integration |
| Omnara | 42 | REJECT | Desktop-first, external platform |
| Lean-Collab | 55 | REJECT | Redundant with existing orchestration |
| Qlik MCP | — | SKIP | No platform |
| Nexus MCP | — | REJECT | Redundant + macOS-only |
| Miro MCP | — | SKIP | No platform |
| GPT-5.3-Codex-Spark | — | MONITOR | Watch API availability |
| Claude Cowork | — | SKIP | Wrong product category |
| Hidden Commands | — | ARCHIVE | Verify /statusline, /teleport |
