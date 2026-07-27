---
date: 2026-05-21
topic: "Document quote for potential Claude.md incorporation: \"10x more codebase autophagy..."
discord_message_id: "1506824373720453140"
status: complete
---

# 10x Codebase Autophagy — A Rule of Thumb for Claude.md

## Topic

Document the following quote for potential incorporation into Claude.md:

> "a rule of thumb here I think is just need to do about 10x more codebase autophagy/compression/simplification/systematic open-ended reviews/canonicalization, and adversarial testing than you probably want to do."

## Key Findings

- The quote distills a well-documented cognitive bias: developers systematically underinvest in maintenance, pruning, and quality assurance because these activities feel unproductive compared to feature work.
- The 10x framing is a calibration heuristic — your gut estimate of "enough" review/simplification is probably wrong by an order of magnitude.
- The workspace already has a related principle (§6 of `advanced-tool-use/SKILL.md`: "Prune Constraints as Capabilities Grow") but it's scoped to AI scaffolding specifically; the quote is broader and applies to all code.
- **Codebase autophagy** is the strongest novel term here — intentional self-consumption of accumulated complexity, treating dead code / stale abstractions as food for renewal rather than waste to be deferred.
- The five named practices (autophagy, compression, simplification, open-ended reviews, canonicalization) are distinct activities; canonicalization is the least represented in existing guidance.
- The adversarial testing component maps to the existing `security-auditor` and `adversarial-explorer` agents, but isn't surfaced as a recurring commitment.
- This heuristic is directionally consistent with the workspace's existing `workspace-audit` skill but adds a magnitude signal that's currently absent.

## Details

**What "codebase autophagy" means**: The term borrows from cellular biology — autophagy is the process by which cells digest and recycle their own components. Applied to codebases, it means actively hunting down accumulated complexity (dead code paths, orphaned files, stale abstractions, outdated skills/agents) and removing or rewriting them. This is distinct from refactoring (which changes structure without removing) and from pruning (which implies external trimming). Autophagy treats the codebase as a living system that must metabolize its own waste.

**Why 10x?**: Human intuition about how much maintenance work to do is calibrated to avoid the discomfort of deleting things that "might be useful." The 10x multiplier forces through that discomfort by making the expected effort explicit. If you think you need 2 hours of review, budget 20. If you think one adversarial test pass is enough, plan for ten. The framing is less about literal multiplication and more about resetting the prior.

**Gap vs. existing workspace guidance**: The `advanced-tool-use` §6 ("Prune Constraints as Capabilities Grow") is the closest analog but is scoped to AI scaffolding (skills, agents, MCPs) and is triggered by capability upgrades rather than operating as a standing bias correction. The quote suggests treating this as a baseline operating posture, not a response to events. The workspace's `workspace-audit` skill runs periodically but doesn't carry a magnitude signal — it doesn't say "you're probably doing too little of this."

**Canonicalization** is the one practice least represented in current CLAUDE.md guidance. It means converging on a single authoritative pattern for recurring structures: agent frontmatter, skill SKILL.md format, memory file schemas, hook scripts. The workspace has drifted across several generations of these formats; a periodic canonicalization pass would reduce the cognitive overhead of maintaining them.

## Relevance to Workspace

- **claude-evolution pipeline**: Directly applicable. The discovery/evaluation/integration cycle tends to accumulate stale entries, deprecated integrations, and redundant helpers. The 10x heuristic argues for dedicating one full heartbeat run per week to autophagy rather than discovery.
- **CLAUDE.md / skills / agents**: These documents accrete guidance without corresponding pruning. Sections written for Claude 3-era limitations are still load-bearing in the current config.
- **Historical nanochat**: Less immediate, but the principle applies to training data curation — systematic compression/canonicalization of data pipelines before the next training run.
- **The finance app / ashitaorbis**: Both would benefit from periodic adversarial testing passes (security, UX) that currently happen reactively rather than systematically.

## Recommended Actions

1. **Add to CLAUDE.md** (Personal Conventions section): A 1-2 line note encoding the 10x heuristic, linked to the advanced-tool-use §6 prune-constraints technique for detail.
2. **Create a canonicalization checklist** for the claude-evolution pipeline — a single source of truth for agent/skill format standards that gets applied quarterly.
3. **Add a standing "autophagy" item** to the workspace-audit skill or heartbeat schedule — one dedicated pass per month focused solely on deletion/compression, not discovery.
4. **Tag the adversarial-explorer agent** as part of a recurring posture, not just a reactive tool — schedule it against the finance app and ashitaorbis monthly.
