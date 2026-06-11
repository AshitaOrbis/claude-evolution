---
date: 2026-05-18
topic: "Investigate this and if it has much that could be applicable to me — frontier lab job guide"
discord_message_id: "1506013722366312478"
url: "https://vladfeinberg.com/2026/05/10/how-to-land-a-job-at-a-frontier-lab.html"
status: complete
---

# Frontier Lab Job Guide — Applicability Assessment

## Topic
> Investigate this and if it has much that could be applicable to me
> https://vladfeinberg.com/2026/05/10/how-to-land-a-job-at-a-frontier-lab.html

## Key Findings

- **Two main paths the article identifies**: (1) Below the LLM stack — kernel work, systems optimization, device-level GPU programming; (2) Above the LLM stack — rigorous agent behavior research, moving beyond "using agents" to formally measuring them.
- **Below-stack path (kernel work) is not applicable in the near term** — it requires CUDA kernel development, Flash Attention-style contributions, hardware-level performance analysis. Years of specialized ramp-up from a standing start.
- **Above-stack path (agent research) is the realistic one** — and the current workspace already occupies this territory. The gap is formalization: running experiments that are "rigorous" by ML research standards (controlled variables, measurable outcomes, clear ablations), not just practical automation.
- **The article corroborates the Anthropic Fellows investigation** (see `20260507-anthropic-fellows-job-qualification.md`): publication is the primary accelerant. Public artifacts > credentials.
- **New specific signal from Vlad's article**: The above-stack path isn't about building agent systems — it's about *measuring how agents behave*. Formal experiments assessing agent capabilities, failure modes, and behaviors. This is different from what the current workspace does (orchestrating agents to do tasks).
- **Mathematical maturity requirement is real but not binary**: Proof-based reasoning (abstract math, formal logic) isn't a checkbox — it's a filtering signal. The article says "take proof-based classes." This is a years-long commitment, but not entirely absent given CRT 7/7 performance.
- **The article's practical steps** (JAX/Flax tutorials, implement transformer from scratch, write custom kernels) are calibrated for someone starting from a CS background. Most steps skip the below-stack path for this profile.

## Details

### The Two Paths and Why Only One Applies

**Below the LLM stack** is Vlad's term for GPU kernel development, inference optimization, quantization research, and hardware-level ML systems work. His examples: Flash Attention (memory bandwidth optimization), LLM.int8() (quantization), accelerator constraint analysis. This path requires fluency in CUDA, deep knowledge of GPU memory hierarchies, and the kind of systems intuition built from years of low-level performance work. Starting from zero, getting to "publishable kernel contribution" is a multi-year commitment. Not applicable.

**Above the LLM stack** is agent research — but Vlad draws a sharp distinction: "develop rigorous experiments assessing how LLM agents behave" vs "simply using pre-built agents." This is an important line. The current workspace sits closer to the "using agents" end: orchestrating Claude Code, Hermes, and Codex for practical tasks, running iterative improvement loops, building pipelines. The work is real and demonstrates capability, but it's not *research into agent behavior* in the ML sense.

The shift needed to cross that line: designing controlled experiments where agent behavior is the *object of study*, not the *tool used*. Example: "Under what conditions do Claude Code agents exhibit position bias in multi-file edits?" or "How does context window position affect agent planning quality?" — formal experiments with measurement frameworks, ablations, and publishable findings.

The plan-quality optimization work from the DSPy project is closer to this line — it has a metric, controlled comparisons (A/B vs baseline), and quantified results. That's the right shape. The gap is: it hasn't been framed as agent behavior research and hasn't been published.

### Where the Profile Fits vs the Article's Template

The article is calibrated for CS/ML students with mathematical training. Several steps (JAX/Flax tutorials, transformer from scratch, custom kernel writing) assume a programming-first background. The profile here is different: stronger in framework-level work, psychometrics, and systems architecture than in low-level ML engineering.

**What maps well**:
- "Build a portfolio demonstrating skills publicly" — already exists but private. Claude-evolution, historical-nanochat, DSPy experiments all qualify.
- "Demonstrated contributions" — the workspace has substantive work; it just needs external visibility.
- "Understand LLM history, theory, foundational ML concepts" — strong here given active engagement with the research frontier.
- "Subject matter knowledge" — the psychometrics + AI intersection (PsycheEval, persona testing) is a genuine niche that maps to alignment/interpretability research, which is underrepresented at labs.

**What doesn't map**:
- Mathematical maturity (proof-based classes): not in place. This is a real gap. Proof-based reasoning is measurable through academic credentials or research output; neither is currently present.
- "Implement a small transformer from scratch": doable but not done. Historical nanochat does train LLMs but with existing architectures (DeepSeek), not implemented from scratch.
- Systems fluency (CUDA, kernel writing): not applicable to this path.

### The Core Honest Assessment

The profile is unusual — CRT 7/7, Intellect 90, active agentic ML work, substantive writing — but unusual in ways that create an unconventional fit rather than a clean path. The standard "how to get a frontier lab job" guides are calibrated for recent CS/ML graduates. The relevant precedents are: researchers who came from adjacent fields (psychology, linguistics, philosophy) into alignment/interpretability. Those paths exist, are uncommon, and typically require a publication bridge.

This was the conclusion of the Anthropic Fellows investigation too, and this article doesn't change it — it reinforces it. The gap isn't credentials; it's publicly visible research output. The workspace has the work. It needs the publication artifacts.

The agent research path above the stack is the right target. The article names the specific shift: from *using agents* to *formally studying how they behave*. The plan-quality optimization work is closest to that line. That's where to push.

## Relevance to Workspace

- **Directly connects to Anthropic Fellows investigation** (`20260507-anthropic-fellows-job-qualification.md`) — same conclusion reached from a different article, with additional specificity about what "above-stack agent research" means.
- **Agent behavior research framing**: Applying formal experiment design to existing agentic work (iteration loops, persona testing, capability discovery) would produce publishable output and position the work correctly.
- **Historical nanochat**: Running and documenting a from-scratch pretraining at scale IS the transformer-from-scratch credentialing equivalent. Needs to be written up and published.

## Recommended Actions

1. **Frame the plan-quality optimization work as agent behavior research** — write it up as a short paper: controlled comparison, methodology, results. The 11.9% delta with Opus is a defensible finding at workshop level.
2. **Identify one agent behavior experiment** currently executable with the workspace infrastructure — something where the agent is the object of study, not the tool. Candidate: position bias in Claude Code multi-file edits, or context-window effects on subagent planning quality.
3. **The JAX/Flax/from-scratch implementation steps** from the article are low priority for this profile — they're calibrated for below-stack paths and CS graduates. Don't invest there.
4. **No immediate curriculum change needed** — the workspace work IS frontier-adjacent research. The action is documentation and publication, not a different kind of work.
