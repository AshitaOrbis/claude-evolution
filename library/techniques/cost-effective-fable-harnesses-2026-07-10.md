# Cost-Effective Harnesses with Fable 5 — When to Spend Frontier Intelligence

**Source**: https://x.com/RLanceMartin/status/2075641284635799865 → X Article https://x.com/i/article/2075610072118702081
**Author**: Lance Martin (MTS @anthropicai)
**Published**: 2026-07-10 (18:00 UTC)
**Type**: First-Party Anthropic engineering write-up (harness cost-design)
**Discovered**: 2026-07-10 (owner shared in Discord #general)

---

## Why this matters here

The workspace runs a lot of Fable/Opus orchestration under a hard cost constraint: Fable is
capped at 50% of Claude usage and is [leaving the subscription window soon](../../../psyche) —
so "when is it actually worth spending Fable tokens?" is a live, load-bearing question for the
automation fleet (workflows, `/goal` loops, cache warmer, council runs). This article is the
first-party framework for exactly that decision. Key cross-refs: `strategic-context-chunking.md`,
`agentic-engineering-patterns.md`, `../../../orchestration/freeze-protocol.md`, the cache-warmer
stack, and the `/goal`-as-verifier pattern the workspace already leans on.

---

## Core thesis

**Tasks have *asymmetry* in the intelligence needed across their tokens.** A good harness
recognizes that asymmetry and spends frontier intelligence (Fable 5) only where it pays off,
delegating the bulk of tokens to cheaper workers (Sonnet 5). Fable is also good at deciding
*for itself* how/when to deploy its own intelligence, if you give it the guidance below.

Three emerging patterns for placing Fable in a harness:

1. **Orchestrator** — Fable plans and delegates to lower-cost workers.
2. **Advisor** — cheap executors call up to Fable for advice at checkpoints.
3. **Verifier** — Fable checks work in a loop (e.g. Claude Code `/goal` or Managed-Agents
   *Outcomes* loop).

---

## Evidence 1 — Parameter Golf (judgment scattered across the task)

Task: ML-engineering agent loop (edit training code → launch → read results → pick next
experiment). Goal: best model fitting in 16MB, trained < 10 min on 8×H100. Setup: Sonnet 5
executor on a self-hosted 8×H100 sandbox (Modal), able to call Fable 5 as an **advisor** on the
initial plan + at 2 checkpoints across 20 experiments (via Claude Managed Agents).

**Result: Fable + Sonnet together got ~90% of Fable-solo's improvement at ~34% of the token cost.**

- The **upfront advising step was *not* the win** — Fable's initial ranking of experiments was
  *anti-correlated* with what actually worked.
- The value was in the **advisory checkpoints**. Sonnet tends to hill-climb on marginal gains and
  won't step back to re-rank; Fable's mid-run checkpoints provide steering / re-prioritization.
- Lesson: for **exploratory** tasks where each result reshapes what's worth trying next, judgment
  must be **scattered across** the task, not front-loaded.

## Evidence 2 — BrowseComp (delegation has a coordination cost)

Task: multi-constraint web search (Fable plans, Sonnet workers search/open/cross-reference).

- **BrowseComp200** (easy subset, ~0.37M tokens read/problem): Fable-alone was **cheaper** than
  mixing in Sonnet. Orchestration added a **~60% markup for no performance benefit.**
- **Full BrowseComp** (~31M tokens read/problem): orchestration paid off — **96% of the score at
  46% of the cost.**

Delegation's token arbitrage must offset a roughly-fixed **coordination cost per handoff**:
- **Boundary duplication** — every token crossing between models is billed ≥ twice (lead writes
  brief → worker reads it; worker writes report → lead reads it).
- **Fan-out overlap** — non-communicating workers redo overlapping research (cf. Cognition,
  "Don't Build Multi-Agents").

Worker benefit scales with tokens each worker absorbs; if the volume delegated is small, the
handoff overhead dominates. And because Fable can be *more token-efficient* than a cheaper-per-token
model, "cheaper $/token" doesn't automatically mean "cheaper overall."

---

## The 4 guidelines for writing cost-effective harnesses

1. **Examine the task shape.** Assess where intelligence is needed across the task.
   *Scattered* judgment (Parameter Golf) → cheap executor + Fable *advisor*. *Upfront* judgment or
   *review* → Fable *orchestrator* or *verifier*.
2. **Use delegation heuristics.** Give Claude priors for worker routing (e.g. models ranked by
   "taste" vs "intelligence") so the harness knows when to pull each one in.
3. **Assess the cost of coordination.** Delegate a large-enough token volume to offset the
   per-handoff cost (the BrowseComp200 lesson). Small delegations lose.
4. **Ensure prompt caching.** Each model keeps its own prompt cache. **Route calls to the *same*
   worker so its cache accumulates**, rather than spawning a fresh worker per request and re-paying
   the context write every time. A low cache-hit rate can wipe out the entire cost benefit of a
   cheaper worker. (Directly validates the workspace cache-warmer investment; cf. Cognition's
   "devin-fusion" on sub-agent prompt caches.)

> Punchline: Claude can write its own harness on the fly per task — these considerations help it
> write ones that spend frontier intelligence *selectively*.

---

## Takeaways to apply in this workspace

- The `Workflow` tool's default **pipeline (Fable orchestrator → cheaper workers)** matches
  pattern (1); reserve Fable for the finder/judge/synthesis stages, push mechanical stages to
  lower effort/tier. This article is the empirical backing for that split.
- The `/goal`-as-**verifier** loop the workspace already uses is pattern (3) — endorsed.
- **Don't reflexively delegate.** For small tasks (< ~1M tokens of work), Fable-solo may be both
  cheaper *and* better; the coordination markup is real. Weigh it before fanning out.
- **Cache discipline is a first-class cost lever**, not a nice-to-have — reuse worker sessions,
  keep hit-rates high. Reinforces the cache-warmer / prefix-proxy work.
- For **exploratory** runs (benchmarks, experiment loops, genealogy digs), sprinkle a Fable
  advisor at checkpoints rather than one big upfront plan.

---

## Linked references (from the article)

- Parameter Golf — https://github.com/openai/parameter-golf
- Karpathy autoresearch — https://github.com/karpathy/autoresearch
- Claude Managed Agents — https://platform.claude.com/docs/en/managed-agents/overview
- Managed Agents *Outcomes* — https://platform.claude.com/docs/en/managed-agents/define-outcomes
- `/goal` docs — https://code.claude.com/docs/en/goal
- Cognition "Don't Build Multi-Agents" — https://cognition.com/blog/dont-build-multi-agents
- Cognition "devin-fusion" (sub-agent caches) — https://cognition.com/blog/devin-fusion
- BrowseComp eval — https://openai.com/index/browsecomp/

Tags: `fable-5`, `cost-optimization`, `harness-design`, `orchestrator-advisor-verifier`,
`delegation`, `prompt-caching`, `multi-agent`, `token-efficiency`, `anthropic-first-party`

---

## Full archived article (verbatim)

> Archived because the owner flagged Fable's subscription window is closing and the source is a
> platform-gated X Article. Retrieved via fxtwitter render 2026-07-10.

There is a lot of interest in cost effective use of Fable 5. Agent harnesses will get better at
knowing when to use frontier intelligence. I wanted to share some tests I've run to better
understand when and how to use Fable 5.

### The task shape

Many tasks have asymmetry in the intelligence needed across their tokens. Harnesses can recognize
this and pick when to use Fable 5. A few patterns have emerged, but we'll likely see more over time:

- Use Fable 5 as an orchestrator that delegates to lower cost workers.
- Use Fable 5 as an advisor that lower cost executors ask for advice.
- Use Fable 5 as a verifier to check work (e.g., in a /goal or Outcomes loop).

For example, @mitchellh called out an orchestrator-verifier approach:

I explored this on Parameter Golf, an ML engineering challenge similar to @karpathy's autoresearch:
let an agent edit training code, launch training, see results, and decide what experiment to run
next.

The goal is to train the best model that fits in a 16MB artifact in < 10 minutes on 8xH100s. I
previously showed that Fable 5 is strong at this task. So, I wanted to see if I could use Fable 5
only for experimental design and Sonnet 5 as a worker to absorb the implementation tokens.

I set this up with Claude Managed Agents with access to a @modal self-hosted 8xH100 sandbox and a
Sonnet 5 executor that can call Fable 5. I instructed Sonnet 5 to consult Fable 5 as an advisor on
the initial plan and later at 2 checkpoints during the 20 experiments.

The results below show validation loss (bits per byte) across 3 configurations (where lower is
better): Fable 5 and Sonnet 5 together got ~90% of Fable-5-solo's improvement at ~34% of the token
cost.

The upfront advising step was not the primary benefit. Fable 5's initial ranking was anti-correlated
with what worked.

The value came from the advisory checkpoints. Sonnet 5 tends to get caught hill-climbing on marginal
gains with no tendency to step back and re-rank. Fable's checkpoints provide steering and
re-prioritization.

The distribution of judgment mattered in this case: upfront planning wasn't sufficient, but
sprinkling Fable 5 as an advisor across the task at fixed points helped steer it in more promising
directions.

In hindsight this matches the task's shape: this type of experimentation is exploratory and each
result reshapes what's worth trying next. Judgment needs to be scattered across it rather than
front-loaded.

### The cost of delegation

Even if a task has intelligence asymmetry that the harness can exploit, it doesn't always pay to
offload it. Sometimes we just do things ourselves because there's a coordination cost involved in
delegation.

@brada and I saw this when testing Fable 5 with BrowseComp, an eval for multi-constraint web search.
It's a good task shape for Fable 5 to plan and delegate to Sonnet 5 workers that search, open pages,
and cross-reference until the constraints pin a unique answer.

On BrowseComp200, an easy subset with ~0.37M tokens of reading per problem, Fable 5 alone was
cheaper than mixing Fable 5 with Sonnet 5. Orchestration added a 60% markup for no benefit in
performance.

But on the full BrowseComp eval set (~31M tokens of reading per problem), orchestration paid off.
Fable 5 orchestrator with Sonnet 5 workers landed at 96% of the score at 46% of the cost.

The token cost arbitrage gained by delegation to workers needs to offset the coordination cost. In
this case, coordination cost has a few components:

- Boundary duplication — every token that crosses between models is billed at least twice: the lead
  writes a brief, the worker reads it; the worker writes a report, the lead reads it.
- Fan-out overlap — In many harnesses, workers don't communicate and many partially overlap in their
  research. @walden_yan wrote a nice article on this problem last year.

This means the cost benefit of cheap workers has to offset a coordination cost that is roughly fixed
per handoff. In this case, the worker benefit scales with the tokens each worker absorbs.

### Cost effective harnesses

Here are the types of guidance that I've been giving Fable 5 when writing cost effective harnesses
for various tasks; Fable is effective at understanding how and when to utilize its own intelligence
with some of this guidance:

1. Examine the task shape. Assess the intelligence needed across the task. Judgement scattered across
   the task, as we saw in Parameter Golf, can benefit from a cheap executor and a Fable 5 advisor.
   Judgement upfront or to review work can benefit from a Fable 5 orchestrator or verifier.
2. Use delegation heuristics. Sometimes we can provide Claude with priors for worker delegation.
   @theo has an example where various models are ranked according to "taste" and "intelligence";
   these can help the harness decide when to incorporate each one.
3. Assess the cost of coordination. Delegation comes with a cost. As I saw with BrowseComp, make sure
   that you are delegating a large enough volume of tokens to offset the coordination cost. Because
   Fable 5 can be more token efficient than a model with a lower $ / token, the benefit of delegation
   should be carefully considered.
4. Ensure prompt caching. Models maintain their own prompt caches, and getting this wrong is an easy
   way for delegation costs to blow up. As @cognition calls out, sub-agents should maintain a prompt
   cache across calls. Route calls to the same worker so its cache accumulates, rather than spawning
   a fresh worker per request and re-paying the context write every time. In my experiments, Claude
   Managed Agents has sub-agents that supported this natively, but I've seen cases where a low prompt
   cache hit rate offsets the cost benefit of using a lower $ / token worker.

As @trq212 shared, Claude can write its own harness on the fly based upon the task. Some of the
considerations in this article can help Claude write cost effective harnesses that selectively apply
frontier intelligence.
