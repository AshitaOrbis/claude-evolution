---
date: 2026-05-11
topic: "Could this be useful for our automated pipelines that we've delegated to Hermes?"
discord_message_id: "1502335727097090088"
url: "https://github.com/Intelligent-Internet/zenith"
status: complete
---

# Zenith — Agent Harness for Long-Running Tasks

## Topic
> Could this be useful for our automated pipelines that we've delegated to Hermes? https://github.com/Intelligent-Internet/zenith

## Key Findings

- **What it is**: Zenith is a research implementation of an agent harness designed for tasks spanning days or weeks. Core claim: the dominant failure mode in long-running agents is premature stopping, not inability to progress. Zenith addresses this with repeated gap-finding, revisable planning, independent verification, and principled stopping discipline.
- **Performance**: Best mean rank 1.38 vs RALPH's 1.75 on benchmarks; $175/task vs RALPH's $407/task. 5 of 8 benchmark tasks won.
- **Architecture**: Single orchestrator session reads task state each turn, dynamically spawns worker/tester subagents, registers reusable skills, replans as needed. Workers report back to orchestrator before next decision. JavaScript/Python.
- **Hermes fit**: The architecture directly mirrors how we use Hermes — long-running delegated tasks with state persistence. Zenith's gap-finding and stopping discipline address known failure modes in Hermes sessions.
- **Key innovation**: "Principled stopping discipline" — the agent only stops when it can verify the gap between current state and original requirements is closed. This directly addresses premature-done claims, which have been a recurring issue in this workspace (noted in CLAUDE.md).
- **Integration path**: Zenith could be adopted as a pattern for Hermes task structuring, or its gap-finding loop could be ported into the existing iterative-improve skill.

## Details

Zenith's core insight is architectural: most long-running agent failures come not from the agent hitting an obstacle but from the agent falsely deciding it's done. The gap-finding mechanism — repeatedly measuring the delta between current state and the original specification — is a direct countermeasure to the "premature-done" anti-pattern documented in CLAUDE.md ("Multi-Item Plan Verification: never mark a task complete with failing tests unless explicitly told to skip").

The orchestrator + worker/tester separation is well-suited to Hermes' task model. Hermes already runs long tasks with holographic memory (state persistence across invocations). Adding a gap-finder loop — re-checking requirements against current output before stopping — would directly improve Hermes task completion quality.

The "reusable skills registration" mechanism is interesting: the orchestrator learns skills from successful worker runs and applies them in subsequent tasks. This is analogous to the context-librarian pattern in claude-evolution, but automated at the agent level rather than requiring explicit human-triggered archiving.

The tech stack (JavaScript 79%, Python 3%) is compatible with existing workspace tooling. The benchmark task (building an Angry Birds physics game end-to-end) suggests it's been tested on complex, multi-hour engineering tasks — not just simple lookups.

The $175/task cost efficiency (vs $407 for RALPH) is notable: Zenith is cheaper because the orchestrator is lean and only spawns workers when needed, rather than running workers speculatively. This matches the workspace's cost-conscious patterns (MAB source allocation experiment, Codex budget limits).

## Relevance to Workspace

- **Hermes**: Most directly relevant. Hermes handles the exact use case Zenith is designed for (long-running autonomous tasks with state persistence). The gap-finding loop and principled stopping discipline would improve Hermes task quality.
- **iterative-improve skill**: The gap-finding mechanism could be extracted as a pattern for the iterative-improve loop — the quality-gate exit condition already partially implements this, but Zenith formalizes it.
- **claude-evolution pipeline**: The skills-registration mechanism is worth studying for the context-librarian workflow — could automate library extraction without requiring human trigger.
- **CLAUDE.md "premature-done" anti-pattern**: Zenith is essentially a system-level enforcement of the multi-item plan verification rule. Demonstrates that this can be automated, not just documented.

## Recommended Actions

1. **Adopt the gap-finding pattern for Hermes task structuring** — document as a Hermes task template: before stopping, restate original requirements and measure delta against current state.
2. **Review Zenith's stopping discipline implementation** (`github.com/Intelligent-Internet/zenith`) — extract the gap-finding logic for potential port into the iterative-improve skill's phase-8 triage.
3. **File in evaluation pipeline**: The orchestrator + worker/tester architecture is worth a formal capability evaluation (score ~75/100 estimate: high capability expansion, medium integration complexity, low maintenance burden). Recommend routing through capability-evaluator.
4. **Consider for historical-nanochat training oversight**: A Zenith-style harness could manage the governed corpus re-run verification loop (steps 1k → 5k → 10k check pattern) autonomously.
