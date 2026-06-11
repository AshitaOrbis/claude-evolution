---
date: 2026-05-03
topic: "Look into this, any insights for our workspace? Particularly publication review or historical nanochat? https://github.com/getcompanion-ai/feynman"
discord_message_id: "1500575070840553647"
status: complete
---

# Feynman: Open-Source AI Research Agent — Insights for Publication Review and Historical Nanochat

## Topic
Look into getcompanion-ai/feynman for insights applicable to the workspace, particularly the publication-review skill and the historical nanochat project.

## Key Findings

- **Feynman is a Pi-runtime AI research agent** built on three components: Pi (agent runtime), AlphaXiv (academic paper search + Q&A), and CLI tools for GPU compute (Modal, RunPod, Docker); it is not Claude Code and does not port directly
- **4 specialized agents** — Researcher (evidence), Reviewer (simulated peer review), Writer (drafts), Verifier (source/citation grounding) — parallel to our multi-model publication-review but with an academic paper focus rather than blog writing
- **Skills are Pi-flavored Markdown files** synced to `~/.feynman/agent/skills/` at startup — structurally identical to our `~/.claude/skills/` architecture, validating the pattern we already use
- **Verifier role is the most actionable gap**: Feynman explicitly tracks URL validity and dead links in outputs; our publication-review pipeline has no equivalent step — factual checking but not source-URL integrity checking
- **AlphaXiv integration** gives paper-level Q&A and annotation that Exa/Brave cannot replicate; for historical nanochat's open problems (multi-family corpus training dynamics, OCR correction literature, rights provenance), systematic paper search via AlphaXiv would be valuable
- **`/replicate` + Docker/Modal** can reproduce experiments on GPU — architectural inspiration for a nanochat experiment replication workflow, though we'd build this natively rather than adopting Feynman's runtime
- **`/lit` literature review command** could directly address nanochat open problem #1 (multi-family training dynamics) — a literature search on shard-flip divergence, curriculum learning, and family-weighted sampling could be run via our existing blog-researcher subagent using this pattern

## Details

Feynman is architecturally similar to our system but domain-shifted toward academic research. Where our publication-review skill targets blog writing quality (factual claims, structural coherence, voice fidelity via Opus/GPT/Gemini), Feynman's Reviewer agent targets academic peer review (methodology rigor, citation integrity, reproducibility). The surface-level workflows look similar but the quality axes differ: Feynman cares about "are the citations real and the methodology sound?" while ours cares about "is the claim factually accurate and is the prose compelling?"

The Verifier agent is the most novel component relative to our setup. It checks that every claim has a working source URL — not just factual plausibility, but link liveness. Our fact-checker subagent (GPT-5.5 with web search) verifies factual accuracy but doesn't track URL health. For the blog-researcher pipeline, adding a Verifier-style pass before publication (check that all cited URLs return 200, not 404) is a low-cost, high-value step. This is especially relevant as the pipeline matures and posts reference external papers or GitHub repos that could go stale.

For historical nanochat, the most actionable Feynman feature is not adoption but pattern extraction. The `/lit` command implements something we could run manually with our blog-researcher subagent: a structured literature review against open problems. For nanochat open problem #1 (multi-family corpus training dynamics — shard-flip divergence, loss plateau at fine shard granularity), there is likely recent ML training literature on curriculum learning strategies, domain-weighted sampling, and interleaved multi-domain pretraining that could inform the Path A/B/C decision. Running a Feynman-style `/lit` search using blog-researcher against "multi-domain interleaved pretraining shard scheduling" would take about 20 minutes and could significantly sharpen the decision before the v4 baseline finishes around 2026-05-10.

The AlphaXiv integration is worth evaluating separately as an MCP. It provides paper-native Q&A (not just web search for papers), which Exa's semantic search approximates but doesn't match for deep paper analysis. However, AlphaXiv requires API keys and the MCP likely needs the Pi ecosystem; check if it has a standalone REST API before treating it as an MCP candidate.

On architecture: the Pi skills = Markdown files pattern is confirmed here as a broadly adopted convention, not just our idiosyncrasy. Feynman's startup skill-sync (`~/.feynman/agent/skills/`) is essentially what Claude Code's CLAUDE.md `@`-import system does. No action needed — this is validation.

## Relevance to Workspace

**Publication-review skill** (`~/.claude/skills/publication-review/SKILL.md`): The Verifier role (URL integrity checking) is the clearest gap. The `/compare` command (source comparison matrices) is an analog to our multi-source research synthesis but more structured — could inspire a "source agreement matrix" step in the blog-researcher subagent for posts with multiple competing claims.

**Historical nanochat** (`library/projects/historical-nanochat.md`, open problems #1–#4): The `/lit` pattern is immediately applicable for open problem #1 (multi-family corpus training dynamics). AlphaXiv is worth a separate evaluation as an MCP for the literature-research layer of the project. The `/replicate` + GPU compute pattern is architectural inspiration, not a dependency — we'd implement this natively on the 3090.

**Blog-researcher subagent**: Feynman's Verifier role (dead link detection) should be added as a step in the publication pipeline, probably as a final pre-publish check.

## Recommended Actions

1. **Add URL integrity check to publication pipeline**: After blog-researcher completes, add a Verifier step that checks each cited URL returns a non-error status. Implement as a 15-line bash addition to the pipeline or a new `url-verifier` subagent. Low effort, catches link rot before publish.
2. **Run a `/lit`-style literature review for nanochat open problem #1**: Use blog-researcher with a research brief targeting "multi-domain interleaved pretraining, shard scheduling, curriculum learning at <1B params." The decision on Path A/B/C for multi-family corpus needs sharper priors before the baseline run ends ~2026-05-10.
3. **Evaluate AlphaXiv as standalone MCP**: Check if alphaXiv.org has a REST API usable without the Pi runtime. If so, score it as an MCP candidate (likely 65–75 range — high capability expansion but unknown integration complexity). File under `pipeline/evaluation/pending/`.
4. **No direct Feynman adoption**: The Pi runtime dependency, separate ecosystem, and academic-paper focus mean it doesn't fit our stack. Extract patterns (Verifier role, `/lit` pattern) rather than integrating the project itself.
