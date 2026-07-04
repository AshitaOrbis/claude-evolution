# Library Index

> Knowledge archive for Claude Code evolution system
> **Last Updated**: 2026-03-07

## By Category

### Techniques
*Coding, prompting, and workflow techniques*

- **[OpenClaw Agent Operational Patterns](techniques/openclaw-agent-operational-patterns-2026-03-07.md)** — Extracted patterns from 130+ hour autonomous Claude-in-Docker agent: tiered autonomy, runaway loop detection, stagnation protocol, capability lifecycle, sub-agent verification, small diff doctrine. Tags: `openclaw`, `autonomous-agent`, `operational-patterns`, `self-governance`, `anti-patterns`
- **[Rules Directory — Conditional Context Loading](techniques/rules-directory-conditional-loading-2026-03-06.md)** — `.claude/rules/` with `paths:` frontmatter for conditional rule loading. Rules load only when editing matching files, reducing per-session context. v2.1.69 fixed print mode. Tags: `rules-directory`, `conditional-loading`, `context-management`, `token-efficiency`
- **[Skills 2.0 Evaluation Improvements](techniques/skill-evaluation-improvements-2026-03-06.md)** — Assertion-based test format, model drift detection, and failure analyzer pass adopted from Anthropic Skills 2.0 into DSPy optimizer. Tags: `prompt-optimization`, `assertion-testing`, `model-drift`, `failure-analysis`
- **[Anchor-Based Paraphrase Matching](techniques/anchor-based-paraphrase-matching-2026-03-23.md)** — 3-signal hybrid matcher for comparing findings across different vocabularies (gold-standard manifest vs model output). Anchors (entities/numbers/terms) + char n-grams + keyword Jaccard. 4-7x improvement over pure Jaccard. Use when both texts reference the same source document but use different language. Tags: `metric`, `matching`, `paraphrase-detection`, `review`, `nlp`, `prompt-optimization`
- **[Seeing Like an Agent — Anthropic Tool Design Philosophy](techniques/seeing-like-an-agent-tool-design-2026-04-20.md)** — First-party Anthropic engineering post (Thariq Shihipar, 2026-04-10). Progressive disclosure principle: tools/skills should lead with "when to use," not "how it works." Agent perceptual model vs. human model. Case studies: AskUserQuestion blocking modal, Task tool context isolation. Validates 2KB SKILL.md cap + decision-tree-first layout. Tags: `tool-design`, `progressive-disclosure`, `skill-authoring`, `agent-perceptual-model`, `discoverability`
- **[WSL → Native Linux Migration](techniques/wsl-to-native-linux-migration-2026-03-03.md)** — Desktop migration from WSL (imperator-1) to native Linux (requiem). Key improvements: 9x I/O, native Chrome, direct localhost DevTools, native systemd/Docker. WSL scripts preserved for orbis laptop. Tags: `migration`, `wsl`, `native-linux`, `browser-automation`, `chrome`, `infrastructure`
- **[Synthetic Pretraining & REWIRE](techniques/synthetic-pretraining-rewire-2026-03-01.md)** — REWIRE rephrasing framework for improving fact retention in pretraining data. Three-stage taxonomy (memorization, logical hardwiring, system simulations). Directly applicable to historical-nanochat project. Tags: `pretraining`, `fine-tuning`, `REWIRE`, `historical-nanochat`, `data-quality`

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
