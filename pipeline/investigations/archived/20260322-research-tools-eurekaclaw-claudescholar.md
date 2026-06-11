---
date: 2026-03-22
topic: "Research tools for papers/Psyche/Chatledger: EurekaClaw and Claude Scholar"
discord_message_id: "1485405924762849290,1485413111338111038"
status: complete
---

# Research Tools for Psyche and Chatledger: EurekaClaw and Claude Scholar

## Topic

Two related questions about AI research tools for academic work:

1. "Anything we could take from this for our research papers generally and Psyche/Chatledger specifically?" — eurekaclaw.ai
2. "Anything we could take from this for our research papers generally and Psyche/Chatledger specifically?" — github.com/Galaxy-Dawn/claude-scholar

## Key Findings

- Both were evaluated by the standard pipeline and **REJECTED** for claude-evolution integration
- **EurekaClaw** (REJECTED, 38.25/100): Academic research platform for theoretical workflows — arXiv/Semantic Scholar search, Lean4 theorem proving, ML experiments with Jupyter/W&B, LaTeX paper writing. The math/theorem-proving orientation doesn't match Psyche/Chatledger's empirical behavioral data focus
- **Claude Scholar** (REJECTED, 42.5/100): Semi-automated research assistant focused on Zotero integration, literature review, experiment tracking, statistical analysis, and manuscript prep. Human-oversight emphasis ("keeps key judgments in human hands")
- **Claude Scholar is the more relevant tool for Psyche**: Its workflow (literature synthesis, statistical analysis, manuscript preparation) maps directly to what a Psyche research paper would need
- EurekaClaw's **literature analysis** module (arXiv/Semantic Scholar) is potentially useful standalone, but the complexity of the full stack (Lean4, Jupyter) is unjustified for our use case
- Neither offers direct MCP integration; both require standalone environments

## Details

### For Psyche Research

Psyche generates quantitative psychometric data (39+ instruments, corpus analysis). A research paper would need:
1. Literature review of psychometric instruments used
2. Statistical analysis of the instrument scores
3. Manuscript preparation with citations

Claude Scholar addresses all three — Zotero for bibliography management, statistical analysis with auto-generated figures, academic writing with citation verification. The Obsidian vault integration could tie into Psyche's knowledge base.

**What to extract from Claude Scholar without installing it**:
- Its prompting patterns for literature synthesis are documented in the repo — worth reading as a reference for improving the `web-researcher` subagent's academic search behavior
- The statistical analysis workflow (hypothesis tracking, rigorous testing, figure generation) could inform how we structure Psyche result analysis

### For Chatledger Research

Chatledger involves SMS/chat data analysis (8.1GB enriched data). Academic outputs might require:
1. Corpus linguistics literature review
2. Statistical text analysis
3. Behavioral pattern manuscript

EurekaClaw's ML experiment execution (Jupyter/W&B) is actually more relevant to Chatledger than to Psyche — Chatledger involves ML-scale text processing. But the infrastructure overhead (full NeMo-style setup) is still unjustified at this stage.

## Relevance to Workspace

- `research/` projects: Neither tool is ready to deploy, but Claude Scholar's prompting patterns are worth extracting
- Future research publication: When either Psyche or Chatledger matures to paper-publication stage, Claude Scholar should be re-evaluated
- `web-researcher` subagent: Academic search patterns from EurekaClaw (arXiv, Semantic Scholar integration) could enhance the subagent

## Recommended Actions

1. **Read claude-scholar's prompting patterns** in the GitHub repo — extract useful prompt templates for literature synthesis without adopting the full system
2. **Re-evaluate Claude Scholar when a paper is actively being written** — current rejection is based on "not yet at publication stage," not fundamental unsuitability
3. **Add Semantic Scholar to `web-researcher` capabilities**: EurekaClaw's arXiv/Semantic Scholar integration suggests an enhancement to our existing research subagent
4. **No action on EurekaClaw**: The Lean4/theorem-proving focus is categorically mismatched with Psyche/Chatledger workflows
