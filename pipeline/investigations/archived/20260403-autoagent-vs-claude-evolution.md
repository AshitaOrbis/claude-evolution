---
date: 2026-04-03
topic: "How does this compare to our Claude-evolution and DSPy systems, I'm sure there's some"
discord_message_id: "1489722640972255402"
status: complete
---

# AutoAgent vs Claude-Evolution + DSPy Optimizer

## Topic
`kevinrgu/autoagent` — a meta-agent framework that autonomously iterates on an agent harness overnight using benchmarks. How does it compare to the workspace's claude-evolution system and DSPy prompt optimizer?

## Key Findings
- AutoAgent is a **benchmark-driven, overnight meta-agent optimizer**: a meta-agent modifies `agent.py` based on benchmark scores in an autonomous loop, requiring Docker isolation and a Harbor-compatible test harness
- The workspace has **two complementary but different systems**: (1) claude-evolution (capability discovery + integration pipeline) and (2) DSPy prompt optimizer (programmatic few-shot prompt optimization)
- AutoAgent is **most similar to the DSPy optimizer**, not claude-evolution — both hill-climb on metrics, both modify prompts/configuration autonomously
- Key difference: AutoAgent modifies **agent architecture** (tools, routing, system prompts as code), while DSPy modifies **prompt text** (few-shot demonstrations and instruction phrasing)
- AutoAgent's Docker isolation + Harbor benchmark model is a stronger **safety/evaluation framework** than the current DSPy setup, which relies on Claude's own eval
- The most potentially valuable idea from AutoAgent: the **`program.md` directive pattern** — a human-edited Markdown file that guides what the meta-agent should optimize, analogous to a high-level objective for the optimizer

## Details

The claude-evolution system and AutoAgent are solving different problems. Claude-evolution is a **capability acquisition pipeline** (discover → evaluate → integrate new tools/MCPs/skills). AutoAgent is a **performance optimization loop** (take an existing agent, improve its scores on a benchmark). These are complementary: claude-evolution expands the toolkit, AutoAgent squeezes performance from each tool.

The DSPy prompt optimizer is the more direct comparison. Both systems:
- Hill-climb on numeric scores
- Accept/reject changes based on improvement
- Operate autonomously

Where AutoAgent goes further:
1. **Scope**: It modifies the full agent harness (tools, routing logic, system prompt as Python) not just prompt text
2. **Isolation**: Docker containers prevent agents from breaking the host environment during optimization
3. **Benchmark framework**: Harbor provides standardized, reusable task definitions with deterministic or LLM-as-judge scoring

The DSPy optimizer's current advantage is that it's already integrated and working for the specific use case (few-shot prompt optimization for Claude Code skills/agents with a known metric format). AutoAgent would require building Harbor-compatible benchmarks for each target skill/agent, which is non-trivial.

The **`program.md` pattern** is worth stealing regardless. Instead of configuring the optimizer via code parameters, a human writes a Markdown directive ("focus on improving tool selection accuracy, especially for edge cases involving ambiguous file types"). This gives the meta-agent richer guidance than a numeric metric alone. This could be added to the DSPy optimizer as a "objective description" input that gets included in the optimizer's meta-prompt.

## Relevance to Workspace
- **DSPy prompt optimizer** (`applications/dspy-prompt-optimizer/`): most directly affected — the `program.md` concept is worth incorporating
- **claude-evolution**: orthogonal — AutoAgent optimizes existing agents, claude-evolution discovers new ones
- **Future capability**: If the workspace ever needs to optimize full agent behavior (not just prompts), AutoAgent or a similar Harbor-based benchmark loop would be the right architecture

## Recommended Actions
1. **Steal `program.md` pattern**: Add an optional "objective description" Markdown field to the DSPy optimizer that guides the meta-prompt during COPRO/iterative optimization runs
2. **Investigate Harbor**: The standardized benchmark format could replace the custom `metric_fn` pattern in the DSPy optimizer with a more reusable evaluation framework
3. **No full AutoAgent adoption** warranted now — the Docker + Harbor setup is significant infrastructure overhead for current use cases, and the DSPy optimizer covers the most common case (prompt text optimization) well
4. File as `pipeline/future/` candidate for when agent-architecture optimization (beyond prompt text) becomes needed
