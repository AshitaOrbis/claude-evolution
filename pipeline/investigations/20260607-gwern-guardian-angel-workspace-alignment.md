---
date: 2026-06-07
topic: "Look into this post, tell me how it aligns with my system, both the workspace and ashitaorbis. Also give me excerpts and summaries that you think I would find interesting and novel"
discord_message_id: "1513262822614892554"
url: https://gwern.net/guardian-angel
status: complete
---

# Guardian Angels: Alignment with Workspace and Ashita Orbis

## Topic
Gwern proposes "Guardian Angels" (GAs) — personalized LLMs that amplify a specific individual rather than replacing them. The user asked how this aligns with the workspace and Ashita Orbis, and which excerpts are most novel/interesting.

## Key Findings

- **The workspace IS a primitive Guardian Angel prototype.** The CLAUDE.md hierarchy, 39-instrument psychometric battery, 1.47M-word corpus analysis, claude-context.md behavioral specification, and persistent agent memory are a working implementation of Gwern's "preference elicitation + behavioral spec" loop — achieved without weight-level finetuning, using prompt engineering and contextual override instead.
- **Psyche/PsycheEval is exactly GA data collection infrastructure.** Gwern identifies "psychological inventory training" and "interview-style preference elicitation" as the core data augmentation strategies. That is already built.
- **The identity frame in the essay maps directly to the post-concussion self-concept.** "You are not your autobiographical memories...you are what your brain does, its desires, hopes, goals, preferences, esthetics, personality, beliefs, ideologies" — this is the precise architecture the workspace operates under. The psychometric spec was built on the same principle: cognitive self persists through memory loss.
- **The blog writing pipeline approximates Gwern's 100× productivity claim.** He frames the goal as "input a single sentence topic and get out an essay I could endorse and publish as-is without embarrassment." The publication-review skill + voice guide + iterative-improve loop is the current path toward that.
- **Hermes partially implements the "append-only log + continual learning" architecture.** Gwern proposes holographic memory and append-only logging; Hermes uses persistent holographic memory and the agent event bus serves as the shared log.
- **The "confused deputy" security argument is novel and directly applicable.** Generic chatbots aligned to everyone can be manipulated to act against any specific user; a GA aligned to one person detects outlier requests as attacks by definition.

## Details

### Where the Workspace Already Is a GA

The core GA proposal has three pillars: (1) learn the principal's values/preferences, (2) align to amplify not replace, (3) defend against manipulation. The workspace currently implements all three — just at the prompt layer rather than the weight layer.

- **Preference learning**: The 39-instrument battery plus 1.47M-word corpus analysis produced a behavioral specification that shapes every Claude interaction. This is Gwern's "psychological inventory training" realized without finetuning.
- **Amplification not replacement**: The 80/20 coding philosophy, human-in-the-loop review steps, and the spec-driven-dev skill all enforce augmentation over autonomy. The workspace is architecturally hostile to "remove the human from the loop."
- **Security/alignment**: The per-agent trust boundaries (capability-discoverer can't spawn integrators; read-only agents can't write), the output-validator gating OpenClaw discoveries, and the Thomistic moral vibe check are all defensive GA-class mechanisms.

The gap is weight-level personalization. The CLAUDE.md spec resets each session context — it's a frozen persona overlay, not dynamic evaluation. Gwern's vision would close this gap with online finetuning, but the practical equivalent exists today: the memory system, persistent agent state, and CLAUDE.md hierarchy collectively approximate a "warm" GA even without weight updates.

### Most Novel Angle: Confused Deputy Security

This framing is genuinely new and worth incorporating into the agent trust hierarchy. A generic chatbot is a "confused deputy" — it has elevated privileges (access to your data, your writing style, your contacts) but is aligned to a third party (the platform). It cannot tell the difference between a request that serves you and a request that exploits you.

A GA aligned to one person is immune by definition: anything that deviates sharply from the principal's known preferences, values, and behavioral signatures is flagged as a potential attack. The existing claude-context.md behavioral spec is a crude implementation of this — the system can already detect when a response pattern is "off-character" because it has a reference model for what on-character looks like.

### The 1.47M Word Corpus as GA Training Data

Gwern's "GBT" prototype calls for finetuning a ~100B parameter model on his own ~1GB personal corpus. The user has 1.47M words of corpus already analyzed (2008–2026). This isn't 1GB, but it's a substantial seed. When local finetuning becomes practical at this scale (likely 2026–2027 horizon), this corpus is the asset. Historical Nanochat infrastructure — already built for multi-epoch pretraining on the 3090 — is the most direct path to a user-specific GA prototype.

### Ashita Orbis Alignment

The GA blog writing goal ("input a sentence, get a publishable essay") is the explicit ambition of the Ashita Orbis pipeline. The user's voice guide, publication-review multi-model critique, and iterative improvement loop are all steps toward this. The divergence from Gwern's approach: Ashita Orbis uses prompt engineering to approximate the user's voice rather than weight-level finetuning. Distribution fine-tuning (investigated 2026-05-18) is the bridge technique that could close the remaining gap.

### Where Gwern Gets It Wrong (or Incomplete)

Gwern assumes a single finetuned model is the right architecture. The workspace has already discovered empirically that multi-model orchestration — Claude for reasoning, Codex/GPT for code review, Gemini for visual work, Hermes for persistent memory — outperforms any single model for a complex principal. A real GA is probably an orchestrator layer that routes to specialized models, not a single finetuned system.

## Interesting Excerpts and Quotes

These are the five quotes most worth sitting with:

**1. On identity (maps directly to the post-concussion framework):**
> "You are not your autobiographical memories...you are what your brain does, its desires, hopes, goals, preferences, esthetics, personality, beliefs, ideologies, all of that."

**2. On the economic misalignment of current AI (the "glass pane" problem in AI form):**
> "The chatbot personas are deeply misaligned with you, and aligned with their owners; and the economic incentives are to farm you with ads and subscriptions, while racing not to amplify you, but to replace you."

**3. On why replacement is the wrong goal:**
> "One programmer driving 10 Claude instances...will never be as valuable as fully autonomous Claudes...such scaling requires removing him from the loop as much as possible."
This is the economic pressure the workspace is explicitly designed to resist.

**4. On what a real productivity increase looks like:**
> "If I could input a single sentence defining a viable essay topic and get out an essay I could endorse and publish as-is without embarrassment...that would indeed be a >100× productivity increase."
This is the target state for Ashita Orbis.

**5. On what GA alignment actually means:**
> "A GA persona is productive because it learns to emulate the principal's outputs but with higher quality. It is trustworthy because it is, by definition, allied with its principal and shares its values and goals."

## Relevance to Workspace

High relevance across three axes:

1. **Theoretical validation**: The workspace's psychometric-driven personalization approach is independently convergent with Gwern's GA proposal. The workspace arrived at behavioral specification, preference elicitation, and multi-agent orchestration through empirical iteration; Gwern arrives at similar conclusions from first principles. This convergence is a signal.

2. **Practical roadmap**: Gwern's technical recommendations (dynamic evaluation, append-only logs, continual learning) are the natural next layer on top of what exists. Not immediately actionable, but worth knowing as the direction.

3. **Blog potential**: The GA concept is a publishable Ashita Orbis post angle — "I accidentally built a Guardian Angel" — especially given the psychometric battery, behavioral spec, and multi-agent architecture already in place.

## Recommended Actions

1. **Document the workspace as a GA prototype** in the library — specifically that the CLAUDE.md + psyche profile + memory system constitutes the "preference elicitation" layer Gwern describes. File under `library/techniques/`.

2. **Add "Mental Sovereignty" to the workspace philosophy**: Gwern's framing — the AI should help you develop your ideals, not settle for a mode-collapsed median — is worth explicitly encoding in CLAUDE.md as a principle, not just an implicit assumption.

3. **Log the 1.47M-word corpus as GA training data**: When local finetuning becomes practical (2026–2027 range), this corpus is the asset. Note it in the Historical Nanochat project hub.

4. **Incorporate the "confused deputy" model into agent trust hierarchy documentation**: The security argument should be captured in `library/` as a pattern for why the workspace's per-agent capability restrictions are correct.

5. **Consider a blog post**: "I accidentally built a Guardian Angel" — the psychometric battery, behavioral spec, multi-model orchestration, and iterative improvement loop are a compelling real-world GA prototype story. Ashita Orbis readership would find this novel and concrete.
