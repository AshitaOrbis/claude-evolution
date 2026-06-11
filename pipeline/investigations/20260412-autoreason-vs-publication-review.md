---
date: 2026-04-12
topic: "https://github.com/NousResearch/autoreason - Look into this, seems potentially ver"
discord_message_id: "1493059055864774797"
status: complete
---

# Autoreason: Tournament-Based Self-Refinement vs Our Publication-Review System

## Topic
Look into NousResearch/autoreason — seems potentially very useful as something to test against our existing publication-review system.

## Key Findings

- **Autoreason uses tournament selection, not iterative critique**: it generates 3 competing revisions each round (original, adversarial, synthesis) and uses fresh blind judges to pick the winner — fundamentally different from our accumulate-and-fix approach
- **"Do nothing" is a first-class option**: the original document always competes, so the system only revises when revisions actually improve things — our system has no equivalent guard against over-editing
- **Fresh evaluation agents with no shared context**: judges never see previous rounds, eliminating the leniency bias our system may have (reviewers knowing what was "already fixed" may be softer)
- **Performance gains**: 77% vs 73% on CodeContests (Sonnet 4.6); Haiku 3.5 achieved perfect Borda scores on 3 writing tasks where all baselines degraded
- **Critical limitation**: gains vanish at the ~60% accuracy threshold (Haiku 4.5 in code) — when model competence is high enough that generation and evaluation capabilities converge, the tournament collapses; unknown if this applies to writing/review tasks
- **Word count contracts 59–70%** under weak model refinement — would destroy blog posts that need voice preservation
- **Convergence rule**: incumbent wins twice consecutively — more principled than our "reviewers stop finding MUST FIX items" heuristic
- **No role specialization**: autoreason uses uniform judges; our system deliberately splits factual, structural, and steelmanning roles across GPT/Gemini/Opus — this specialization is likely a significant advantage for publication review

## Details

Autoreason attacks three failure modes in naive self-refinement: hallucinated critique (models inventing flaws that don't exist), scope creep (outputs expanding uncontrollably across iterations), and inability to decline (no mechanism for "the original was fine"). The tournament solves all three: blind Borda counting across multiple judges means hallucinated critiques get outvoted, the original always competes (so expansion is penalized), and the incumbent wins if revisions don't actually improve things.

Our publication-review skill solves different problems: factual accuracy verification (via GPT-5.4's reasoning and web access), structural coherence (Gemini's sentence-level precision), and logical stress-testing (Opus steelmanning opposition). These roles are domain-specific and calibrated to publication concerns that autoreason wasn't designed for. Autoreason is domain-general (writing + code) and makes no distinction between "this claim is factually wrong" and "this sentence is clunky." For our use case, those are very different priority tiers.

The "fresh agents" insight is actionable for our system: our current prompts pass cumulative prior-fix lists to reviewers, which likely softens later rounds. Reviewers may implicitly give the document more credit because they know effort was invested. Running at least one "fresh" review pass with no prior-fix context injected could catch issues that accumulated leniency is masking. This would fit naturally at round 3+ when we suspect convergence but aren't sure.

The adversarial B candidate concept (generate a revision that explicitly tries to improve weaknesses) has a partial analog in our Opus steelmanning role, but Opus generates critique, not a complete alternative revision. A hybrid experiment: after round 2 fixes, generate a full adversarial revision of the post (ask Opus to rewrite with all weaknesses addressed), then have our panel evaluate original vs adversarial vs synthesis.

## Relevance to Workspace

Our publication-review skill (`~/.claude/skills/publication-review/SKILL.md`) is a 3-model parallel review loop (GPT-5.4 + Gemini + Opus) with priority tiers and human-gated iterations. It was optimized via DSPy in March 2026 (BACKLOG.md: holdout scores 0.669/0.532/0.473). Autoreason is complementary, not a replacement:

- Our system excels at **factual verification and role-specialized critique** — autoreason has no equivalent
- Autoreason excels at **convergence discipline and protecting against over-editing** — our system has no equivalent
- The "fresh judges" principle could be incorporated as a late-round variant in our skill with minimal effort
- Autoreason's tournament structure is most compelling for **polish rounds** (round 3+) where factual issues are resolved and the question is "is this revision actually better?"

## Recommended Actions

1. **Add BACKLOG item**: "Autoreason-mode late rounds in publication-review — after round 2 when no MUST FIX items remain, run a tournament (original vs adversarial revision vs synthesis) with fresh panel judges to identify best final version"
2. **Incorporate fresh-judge option**: Add a note to the publication-review SKILL.md that round 3+ reviewers should optionally be called *without* the prior-fix context list, to catch leniency drift
3. **Monitor for paper release**: The repo includes LaTeX source — a formal paper with full ablations is likely forthcoming; worth reading when published for implementation details
4. **Do not wholesale adopt**: Autoreason's word-count compression behavior and domain-general design make it unsuitable as a drop-in replacement; our factual-review specialization is a core feature worth preserving
