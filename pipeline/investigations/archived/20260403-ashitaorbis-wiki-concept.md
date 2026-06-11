---
date: 2026-04-03
topic: "This seems like a similar but complementary idea to the Ashitaorbis website, perhaps w"
discord_message_id: "1489719877710385162"
status: complete
---

# Ashitaorbis Research Wiki: Concept Evaluation

## Topic
A tweet (X/Twitter URL, inaccessible) described a concept the user sees as similar to Ashitaorbis but complementary. The user's takeaway: build a **wiki section** on the site that links/stores deep research and GPT Pro results, surfacing long-form AI-generated research for public access.

## Key Findings
- The idea is distinct from the blog: a **wiki is persistent reference material** (evergreen), while blog posts are time-anchored narrative pieces
- The best existing model for this is probably a **Notion-style or Obsidian-publish style** knowledge base — but building it into Ashitaorbis itself would keep it under the same brand and routing
- The Parallel-Task MCP (`createDeepResearch`) already generates citation-rich analyst-grade reports — these are natural source material for wiki entries
- A wiki would be complementary to, not competing with, the blog: the wiki stores the dense research backing, the blog interprets and argues from it
- Technically, this would likely be a new section of the Astro site (`/wiki` or `/research`) with a flat-file content model (MDX or Markdown in git)

## Details

The core intuition is sound: AI is generating research artifacts (deep research reports, GPT Pro outputs, Parallel-Task synthesis) that currently disappear into local files. Surfacing them publicly as a wiki makes the underlying knowledge work visible and linkable.

The architecture question is whether to build a proper wiki with edit/revision history (like MediaWiki), a simpler read-only knowledge base, or a hybrid where Claude agents write entries and humans curate. Given that the workspace already has Parallel-Task deep research generating full reports, the simplest path is: **research runs → MDX files → published wiki entries**. The blog would link into wiki entries for supporting evidence; the wiki would stand alone as reference.

One consideration is maintenance burden. A wiki that grows organically but rarely gets updated becomes stale quickly. A model where wiki entries are agent-generated and human-reviewed would scale better. The context-librarian agent already does something adjacent (archiving useful knowledge from conversations) — a wiki could be the public-facing counterpart to the private context-librarian output.

The "linking GPT Pro results" angle is particularly interesting: long research sessions from Parallel-Task or Codex could be published as wiki entries verbatim (with appropriate framing), making the research pipeline a content production pipeline simultaneously.

## Relevance to Workspace
- **Ashitaorbis** (`applications/ashitaorbis/`): new `/wiki` route in the Astro site
- **claude-evolution** library: already a private analog — the wiki would be the public-facing version of `library/`
- **context-librarian agent**: could be extended to publish notable findings to wiki entries automatically
- **Parallel-Task MCP**: ideal source for wiki entries — citation-rich, analyst-grade, structured

## Recommended Actions
1. Sketch a `/wiki` information architecture for Ashitaorbis: categories, entry format, how entries link to blog posts
2. Evaluate existing Astro-compatible wiki/knowledge-base integrations (Starlight, Astro docs theme, or simple MDX content collections)
3. Decide on the entry creation model: purely agent-written, human-edited, or reviewed-before-publish pipeline
4. Consider whether wiki entries should have public edit history (git already provides this if built on MDX in the repo)

---

## Resolution (2026-05-09 walkthrough)

**Status: IMPLEMENTED.** The wiki concept has been fully built out:

- **Location**: `applications/ashitaorbis/wiki/` with 51 deployed articles
- **Public route**: Astro `/research` (`tier-2-astro/src/pages/research/index.astro` + `[slug].astro`)
- **Content collection**: `applications/ashitaorbis/shared/content/research/`
- **Generation pipeline**: Three validated methods, with assignments tracked in `wiki/BATCH-3-PROVENANCE.md`:
  - Codex Council + Opus synthesizer (12 articles)
  - GPT Max + Opus synthesizer (12 articles)
  - ChatGPT Pro single-call deep reasoning (12 articles)
  - 15 earlier articles via GPT Pro DeepResearch
- **Empirical method validation**: `experiments/gpt-max/eval-results/2026-05-05T153654Z/findings.md` (Opus synthesizer dominates GPT-5.5 ~89% same-arch; codex-council vs gpt-max essentially tied with Opus synth)

**Decision**: Archived. Investigation preceded implementation; concept executed substantially beyond original scope.
