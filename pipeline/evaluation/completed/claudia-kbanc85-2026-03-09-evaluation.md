# Evaluation Report: Claudia (kbanc85) -- Extractable Techniques

## Basic Information

- **Source**: https://github.com/kbanc85/claudia
- **Category**: Agent framework / Claude Code skill system (evaluating TECHNIQUES, not full framework)
- **License**: Apache 2.0
- **Last Updated**: Active (110 releases, last commit fd08cba on main)
- **Stars/Validation**: 181 stars, 20 forks
- **Date**: 2026-03-13 (re-evaluation; prior evaluation 2026-03-11 scored 52.25/100 on whole-framework basis)
- **Evaluator**: capability-evaluator (Opus 4.6)

## Context: Re-Evaluation Rationale

The prior evaluation (2026-03-11, 52.25/100) assessed Claudia as a **whole framework** and correctly rejected it -- the multi-runtime stack (Python daemon + SQLite + Ollama + MCP) is too complex for direct adoption. This re-evaluation answers the research question from that evaluation: **can specific techniques be extracted as lightweight patterns into existing skills/playbooks?**

Four techniques were identified for individual assessment:
1. `/meditate` session reflection pattern
2. Multi-tier model delegation (Haiku/Sonnet)
3. Background memory consolidation
4. Provenance tracking for decisions

---

## Technique-by-Technique Analysis

### Technique 1: `/meditate` Session Reflection Pattern

**What it does**: End-of-session skill that extracts four reflection types (observations, patterns, learnings, questions) plus judgment rules (escalation, priority, delegation preferences). Reflections are user-approved before storage. Stores with importance (0.7+), confidence (0.8), and slow decay (0.999 = ~2-year half-life). Merges semantically similar reflections over time.

**Key distinction from session-handoff**: The existing `session-handoff` skill preserves **work state** (current phase, completed work, next steps, blockers). `/meditate` preserves **behavioral learnings** about how to work with the user and decision heuristics. These are different semantic categories:

| Aspect | session-handoff | /meditate |
|--------|----------------|-----------|
| Focus | Work state continuity | User preference learning |
| Output | Next steps, blockers, verification commands | Observations, patterns, judgment rules |
| When useful | Between sessions on same project | Across sessions on any project |
| Persistence | CLAUDE.md / handoff notes | Memory system (cross-session) |

**Classification**: IMPROVEMENT -- adds a behavioral learning dimension to the existing session-end workflow.

**Extractable value**: A "reflection appendix" could be added to `session-handoff` skill: 1-3 user-approved learnings per session, optionally one judgment rule candidate. This does NOT require Claudia's SQLite/Ollama stack -- it can be stored in CLAUDE.md auto-memory or agent memory frontmatter.

**Integration cost**: LOW -- extend existing `session-handoff` skill with 15-20 lines of additional guidance. No new dependencies.

### Technique 2: Multi-Tier Model Delegation

**What it does**: Fixed routing -- Haiku for lightweight processing, Sonnet for research-heavy tasks.

**Classification**: DUPLICATE -- existing `model-router` subagent already routes across Opus/Sonnet/Haiku/Codex/Gemini based on task type. Claudia's pattern is strictly narrower (two tiers vs five models). The `model-selection.md` playbook already documents this decision tree. Effort controls (API-level low/medium/high/max) provide additional granularity.

**Extractable value**: NONE. Our existing implementation is more capable.

### Technique 3: Background Memory Consolidation

**What it does**: Scheduled jobs -- adaptive decay (2 AM), consolidation (3 AM merges duplicates + detects patterns + tracks relationship health), vault sync (3:15 AM to Obsidian), pattern detection (every 6h).

**Classification**: DUPLICATE with caveats. Our existing stack covers this:
- **Official Memory System** (2.1.32+): Auto-records and recalls
- **Agent Memory frontmatter** (2.1.33+): Scoped persistent state
- **Auto-compacting**: Automatic conversation summarization
- **ACE Framework**: Strategic pattern extraction (documented, manual CLI available)
- **Instinct System**: Confidence-scored pattern extraction (documented)

Claudia's consolidation is more structured (scheduled, with decay rates and semantic merging), but requires a parallel Python daemon with Ollama embeddings -- a significant infrastructure addition for incremental value over what ACE + Instinct already document.

**Codex notes**: The upstream implementation has a code smell -- `pattern_detection_interval_hours` exists in config but the scheduler uses `consolidation_interval_hours` for pattern detection.

**Extractable value**: MARGINAL. The concept of "scheduled memory decay" is interesting but not worth the infrastructure. If we ever need it, ACE's CLI approach is the lighter path.

### Technique 4: Provenance Tracking

**What it does**: Every memory links back to its source through a multi-table schema:
- `memories` table: `origin_type` (user_stated, extracted, inferred, corrected), `source_channel` (claude_code, telegram, slack), timestamps, correction/invalidation fields
- `memory_sources` junction: Links memories to source documents with excerpt tracking
- `episodes` table: Session narratives with key topics
- `_build_provenance_chain()`: Reconstructs human-readable source-to-storage lineage
- `trace_memory()`: Full audit trail showing how a belief evolved

**Classification**: NOVEL. Nothing in our current stack provides claim-level provenance:

| Existing Tool | What It Tracks | Gap |
|---------------|----------------|-----|
| Git history | Code file changes | Cannot answer "which conversation produced this fact?" |
| context-librarian | Archives useful info | No source linking, no correction history |
| Official Memory | Auto-records facts | No provenance chain, no invalidation tracking |
| Agent Memory | Agent state | State, not reasoning provenance |

Provenance tracking answers questions none of our tools can:
- "Why do we believe X?" (source chain)
- "When was this belief corrected, and what was it before?" (correction history)
- "Which session produced this decision?" (episode linking)
- "Has this fact been invalidated?" (invalidation records)

**Extractable value**: HIGH -- but requires careful scoping. The full SQLite schema is overengineered for our needs. A lightweight version could work as:
- Append-only YAML/JSON log with fields: `claim`, `source_kind`, `source_ref`, `session_id`, `derived_from`, `corrected_by`, `invalidated_by`
- Stored alongside existing CLAUDE.md or in a dedicated `provenance.jsonl` file
- Queried on-demand ("why do you believe this?") rather than via a daemon

**Integration cost**: MEDIUM -- requires designing a lightweight schema and adding provenance awareness to context-librarian or a new small skill. No external dependencies needed.

---

## Scores

### Scoring Basis: Extractable Techniques Bundle

Since we are scoring the extractable patterns (not the full framework), integration complexity is evaluated for pattern extraction, not Claudia installation.

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 75/100 | Technique 1 (session-handoff extension): trivial. Technique 4 (provenance pattern): requires schema design + skill creation but no external deps. Techniques 2-3: not adopted. Overall LOW-MEDIUM effort. |
| Token Efficiency Impact | 55/100 | Neutral-to-slight-positive. Session reflection adds minor session-end cost but may reduce re-learning across sessions. Provenance is zero-cost until queried. No major savings or costs. |
| Capability Expansion | 62/100 | One genuinely novel technique (provenance tracking) and one incremental improvement (session reflection). Two techniques are duplicates. Net novelty is real but narrow -- it's one new pattern, not a capability category. |
| Maintenance Burden | 80/100 | Extracted patterns are self-contained (a skill extension + a lightweight schema). No daemon, no Ollama, no SQLite dependency. Near-zero maintenance once written. |
| Community Validation | 46/100 | 181 stars, single maintainer (311 commits vs next contributor at 8 = bus-factor-1). Active development but no ecosystem adoption. Apache 2.0 is fine. The patterns we'd extract don't depend on upstream maintenance. |

### Weighted Calculation

```
Total = (75 x 0.20) + (55 x 0.25) + (62 x 0.25) + (80 x 0.15) + (46 x 0.15)
      = 15.0 + 13.75 + 15.5 + 12.0 + 6.9
      = 63.15/100
```

---

## Cross-Validation

- **Claude Assessment**: 63.15/100
- **Codex Assessment**: 58/100
- **Variance**: 5.15 points
- **Consensus**: Achieved (within 20-point threshold)

### Variance Analysis

Both assessments agree on the same structural conclusion:
- Techniques 2-3 are DUPLICATE (reject)
- Technique 1 is IMPROVEMENT (absorb into session-handoff, don't import standalone)
- Technique 4 is NOVEL (strongest candidate, needs design work)

Codex scored slightly lower due to heavier weighting on the "mostly overlap" techniques. Claude scored slightly higher due to the extracted-only framing (which raises integration complexity scores since we skip the hard parts). The 5-point gap is noise, not a real disagreement.

---

## Security Assessment

- [x] No sensitive permissions required (extracted patterns are just skill files)
- [x] No excessive data access (provenance log is append-only local file)
- [x] License compatible (Apache 2.0)
- [x] No known vulnerabilities (patterns extracted, not code imported)
- [x] API keys manageable (no API keys needed for extracted patterns)

---

## Existing Alternatives

| Claudia Technique | Existing Alternative | Verdict |
|-------------------|---------------------|---------|
| `/meditate` session reflection | `session-handoff` skill + `context-librarian` agent | IMPROVEMENT: add reflection appendix to session-handoff |
| Multi-tier model delegation | `model-router` agent + `model-selection.md` playbook | DUPLICATE: existing is more capable |
| Background consolidation | Official Memory + Agent Memory + ACE + Instinct (documented) | DUPLICATE: existing stack covers this |
| Provenance tracking | Nothing equivalent | NOVEL: design lightweight version |

---

## Comparison to Prior Evaluation

| Dimension | Prior (2026-03-11) | This (2026-03-13) | Delta |
|-----------|-------------------|-------------------|-------|
| Scope | Whole framework | Extractable techniques only | Narrower, more actionable |
| Score | 52.25/100 | 63.15/100 | +10.9 points |
| Decision | NEEDS_RESEARCH | NEEDS_RESEARCH | Same |
| Integration cost | HIGH (daemon, Ollama, SQLite) | LOW-MEDIUM (skill edits, schema design) | Much lower |

The score improved because extracting patterns eliminates the heavy integration/maintenance burden that dragged down the whole-framework evaluation. But it still falls short of the 70 threshold because the net novel capability (provenance tracking alone) is narrow.

---

## Recommendation

**DECISION**: [x] NEEDS_RESEARCH (63.15/100 -- below 70 threshold)

**Rationale**: Claudia contains one genuinely novel pattern (provenance tracking) and one incremental improvement (session reflection). The novel pattern is valuable but requires a focused design spike to define a lightweight schema that works within our existing file-based architecture. The score falls 7 points short of automatic approval because the bundle's net novelty is narrow -- two of four techniques are outright duplicates. However, provenance tracking alone could score 70+ if evaluated as a standalone technique with a concrete implementation spec.

### Research Questions (Focused)

1. **Provenance schema design**: What is the minimal schema for decision provenance that works in a JSONL file alongside CLAUDE.md? Fields: claim, source_kind (conversation/document/inference/correction), source_ref, session_date, derived_from, corrected_by, invalidated_by.

2. **Integration point**: Should provenance tracking live in `context-librarian` (extend existing agent to add source linking) or in a new `provenance-tracker` skill (standalone awareness)?

3. **Query pattern**: How would "why do you believe X?" queries work? On-demand Grep through provenance.jsonl? Or structured lookup via a skill?

### Immediately Actionable (No Research Needed)

**Session-handoff reflection appendix**: This can be added now without further research. Extend `session-handoff` skill with:
- "Extract 1-3 behavioral learnings about user preferences or working patterns"
- "Identify any decision rules (escalation, priority, delegation) observed this session"
- "Store in auto-memory for cross-session recall"

This is a 15-line skill extension with zero dependencies. Estimated value: reduces preference re-learning in future sessions.

### Integration Path (If Provenance Research Succeeds)

1. Design lightweight provenance schema (JSONL, no SQLite)
2. Extend `context-librarian` agent OR create `provenance-tracker` skill
3. Add provenance fields to context-librarian's archive entries
4. Test on 5 evolution pipeline decisions (can we reconstruct why?)
5. If successful (can answer "why do you believe X?" for >80% of test cases), promote to full integration

### What NOT to Do

- Do NOT install Claudia as a dependency
- Do NOT adopt the Python daemon, Ollama embeddings, or SQLite stack
- Do NOT replace `model-router` with Claudia's simpler two-tier pattern
- Do NOT implement background consolidation (ACE + Instinct cover this when needed)

---

## File References

- Prior evaluation: `pipeline/evaluation/completed/claudia-kbanc85-evaluation.md`
- Research flag: `pipeline/evaluation/pending/discord-inbox-20260309-claudia-kbanc85-research-flag.txt`
- Discovery file: `pipeline/evaluation/pending/discord-inbox-20260309-claudia-kbanc85.md`
- Session-handoff skill: `~/.claude/skills/session-handoff/SKILL.md`
- Model-router agent: `~/.claude/agents/model-router.md`
- Context-librarian agent: `~/.claude/agents/context-librarian.md`
- Memory registry section: `registry/existing-capabilities.md` (line 652+)
- Wrap-up ritual registry: `registry/existing-capabilities.md` (line 1042+)
