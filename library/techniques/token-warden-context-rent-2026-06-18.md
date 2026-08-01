# Context-Rent Memory Governance (token-warden)

**Source**: https://github.com/vukkt/token-warden
**Date**: 2026-06-18 (integrated 2026-07-19)
**Type**: technique (memory/rules governance method)
**Score**: 71.5/100 (approved 2026-06-23)

## The Core Idea

Every rule, memory entry, and standing instruction pays **rent**: it occupies prompt
tokens in every session it loads into. token-warden's governance principle is that a
rule may only stay if it demonstrably saves more tokens (or prevents more damage) than
it costs to carry. Memory is not free storage — it is leased context.

The method, independent of the tool:

1. **Price each rule** — tokens it adds to standing context × sessions it loads into.
2. **Benchmark against a frozen suite** — run a fixed set of representative tasks with
   and without the candidate rule. Measure task tokens, retries, and error rates.
3. **Retain only net-positive rules** — measured savings (or prevented failures) must
   exceed the carrying cost. Everything else is evicted or demoted to an on-demand doc
   behind a bare-path pointer.
4. **Re-audit periodically** — a rule that paid rent under an older model may be
   scaffolding the current model no longer needs.

## Relationship to Existing Practice

This is a quantified version of two principles already active in this workspace:

- The **prune-constraints maintenance principle** (remove scaffolding as capabilities
  grow) — context-rent adds the measurement discipline that decides *which* scaffolding.
- The **progressive-disclosure authoring rule** (decision tree in the skill, detail
  behind bare-path pointers) — demotion to a pointer is exactly the eviction move.
- The weekly bloat check (`scripts/weekly-bloat-check.sh`, `reports/weekly/bloat-*.md`)
  already measures size; context-rent adds the *value* side of the ledger.

## When To Apply

- Before adding any always-loaded rule to a CLAUDE.md / memory file: state what it saves
  and how often that situation occurs. If the answer is "rarely," it belongs in a
  referenced doc, not standing context.
- During bloat sweeps: rank existing rules by (frequency of relevance × savings per
  firing) ÷ token cost, and cut from the bottom.

## Caveats

- token-warden itself is young; the proposal adopted the method, not the plugin.
- Prevented-damage rules (safety gates, privacy rules) can be cheap to carry and
  catastrophic to evict — score them on expected loss avoided, not just token savings.

**Tags**: `context-rent`, `memory-governance`, `token-efficiency`, `rule-auditing`,
`claude-md-hygiene`, `bloat-control`, `token-warden`
