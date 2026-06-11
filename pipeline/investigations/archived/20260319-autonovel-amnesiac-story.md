---
date: 2026-03-19
topic: "AutoNovel for translation project and amnesiac story - deeper analysis"
discord_message_id: "1484291011889856670"
status: complete
---

# AutoNovel for Translation Project and Amnesiac Story

## Topic

> "Look into this for potential use in both the translation project and more likely the amnesiac story (also probably making a new experimental folder for stories based on it as well)" — github.com/NousResearch/autonovel

## Key Findings

- **AutoNovel** is a four-phase autonomous novel pipeline: Foundation (world-building, characters) → First Draft (chapter-by-chapter) → Revision (adversarial editing, reader panels, Opus review) → Export (PDF, ePub, audiobook, landing page)
- **Production-validated**: The team produced a 79,456-word novel (*The Second Son of the House of Bells*) in 19 chapters with 6 automated revision cycles and 6 Claude Opus review rounds — this is a genuinely complete system
- Already evaluated at **NEEDS_RESEARCH (54.25/100)** by the standard pipeline; star count, LLM flexibility, and concrete use case still open questions
- **For amnesiac-story**: The bidirectional narrative/lore propagation (changes cascade between world details and chapters) is directly relevant — amnesiac story needs lore consistency across days
- **For translation project (RtW)**: Less relevant — RtW is about translation quality, not original generation; AutoNovel has no translation mode
- **Creating a new experimental folder**: The user's intuition to create `experiments/autonovel-stories/` is sound — AutoNovel can run independently of the existing story agent pipeline

## Details

### For the Amnesiac Story

The existing amnesiac-story pipeline uses story-writer → story-curator → story-editor agents. AutoNovel's contribution would be:
1. **Quality control layer**: Its adversarial editing + reader panel approach exceeds what our single story-curator agent provides
2. **Lore consistency engine**: The bidirectional "narrative layers" system (world → chapters → world updates) is more sophisticated than the curator's current consistency checking
3. **Export pipeline**: The PDF/ePub/audiobook export is fully implemented; our story-editor currently only produces text

The key question (from the NEEDS_RESEARCH evaluation): does AutoNovel work with Claude, or is it OpenAI-locked? The paper mentions "Claude Opus reviews" which suggests Claude compatibility.

### New Experimental Folder

`experiments/autonovel-stories/` as a parallel experiment to the amnesiac-story project makes sense. This would be a **different creative mode** — AutoNovel generates a complete novel autonomously, while amnesiac-story is a first-person journal with human-in-the-loop curation. They're complementary, not competing.

The "stories based on it" framing suggests generating new stories in the same world/voice as the amnesiac story, or standalone new concepts — both are viable.

## Relevance to Workspace

- `experiments/amnesiac-story/`: Quality control and lore consistency improvements
- `experiments/` (new): `experiments/autonovel-stories/` for fully autonomous novel generation
- `~/.claude/agents/`: AutoNovel's adversarial-editing pattern worth extracting as an enhancement to `story-editor`

## Recommended Actions

1. **Answer the open NEEDS_RESEARCH questions**: Confirm GitHub stars, verify Claude/multi-LLM compatibility, test a short story generation run
2. **Create `experiments/autonovel-stories/`**: Set up the directory with a README linking to AutoNovel and describing the experimental plan
3. **Extract the adversarial editing pattern**: Regardless of full AutoNovel adoption, implement the "adversarial editor + reader panel" evaluation loop in the existing story-editor agent
4. **RtW translation**: No action — AutoNovel is irrelevant to translation workflows
