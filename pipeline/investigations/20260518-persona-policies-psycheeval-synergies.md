---
date: 2026-05-18
topic: "This seems useful for persona testing and synthetic data generation like used in PsycheEval, look into it https://github.com/harshita-chopra/persona-policies"
discord_message_id: "1505792809976725535"
status: complete
---

# Persona Policies (PPol): Synergies with PsycheEval

## Topic
GitHub repo `harshita-chopra/persona-policies` flagged as potentially relevant to PsycheEval's persona testing and synthetic data generation pipeline. Requested: investigate what it does and what's applicable.

## Key Findings

- **PPol targets user simulators, not assistant conditioning** — it injects behavioral diversity into the *human* side of LLM conversation (τ²-bench), while PsycheEval conditions the *assistant* side. Different problem, but orthogonally compatible.
- **19-feature behavioral fingerprinting** is the most immediately borrowable technique — PPol extracts a compact behavioral signature from dialogue trajectories using a Random Forest discriminator. This could validate whether PsycheEval's conditions (C0 through C5_CONTRACT) produce measurably distinct behavioral patterns, separate from LLM judge preference scores.
- **Coverage metric (Chamfer distance)** could validate PsycheEval's persona set — PPol measures whether synthetic personas cover diverse regions of behavioral space. PsycheEval's 8 fixed personas haven't been audited for coverage; PPol's approach could check this.
- **Evolutionary policy generation (OpenEvolve)** is PPol's core but heavyweight — 70+ evolutionary iterations, OpenEvolve dependency, OpenRouter/AWS Bedrock integration. Not a drop-in tool; relevant only if PsycheEval wants to auto-generate larger synthetic persona sets beyond the 8 hand-crafted ones.
- **SFT experiments (LoRA on Gemma-4-31B)** exist in `sft_experiments/` — represents a fine-tuning angle PsycheEval hasn't explored. Baking a Psyche profile into a LoRA would be a hypothetical C6 condition not in current v0.2 scope.
- **Discriminator as complementary eval signal** — PPol trains a binary discriminator (simulated vs. real) that could be adapted to measure whether C4/C5_CONTRACT conditioned outputs are more human-realistic, a dimension orthogonal to the pairwise judge preference scoring.

## Details

Persona Policies is an academic framework designed to close the "overly cooperative, homogeneous" gap in LLM user simulators. Rather than specifying personas as character sheets, PPol evolves natural-language behavioral instruction snippets that get appended to system prompts. The fitness function jointly optimizes for (a) looking like a real human based on a learned behavioral fingerprint and (b) covering the distribution of real human behaviors as measured by Chamfer distance to a reference set.

PsycheEval and PPol are solving adjacent but different problems. PsycheEval asks: "does injecting a psychometric profile into the assistant's conditioning improve response quality?" PPol asks: "how do we make the simulated user more diverse and realistic?" The overlap is in shared methods: both manipulate system-prompt content to shape behavior, both need to measure behavioral similarity, and both care about diversity of conditioning signals.

The most concrete and near-term applicable piece is behavioral fingerprinting. PPol's 19-feature fingerprint (extracted from dialogue trajectories) is a model-agnostic behavioral signature. Applied to PsycheEval, you could run all conditions (C0–C5_CONTRACT) on the 8 × 80 scenario corpus, extract fingerprints per output, and check whether condition explains variance in fingerprint space — fully independent of the judge panel. If C4 and C0 fingerprints cluster together, that's evidence the conditioning is having minimal behavioral effect regardless of what judges prefer. This would directly address a threat-to-validity not currently covered in v0.2.

Coverage measurement is the second reusable piece. PsycheEval's 8 personas were selected by hand; there's no quantitative audit of whether they actually span behavioral space. PPol's Chamfer distance approach could be adapted to check this: extract fingerprints from the 8 baseline (C0) outputs, compute coverage against a reference human distribution (if available) or against each other. If the 8 personas cluster in a small region, a later PsycheEval version would want to add personas that fill the gaps.

The evolutionary generation pipeline itself is probably not worth integrating for PsycheEval in the near term — it requires τ²-bench, OpenEvolve, and significant infrastructure, and it's designed for generating behaviorally diverse user simulators, not psychometric profiles. The SFT angle (LoRA on Gemma) is interesting as a future research direction (baking a Psyche profile into weights rather than prompts) but is out of scope for v0.2's methodology pilot.

## Relevance to Workspace

PsycheEval is an active project (`psyche/psycheeval/`) in late-pilot status (v0.2 in flight, v0.3 candidates identified in the skeleton). The behavioral fingerprinting technique is directly applicable to strengthen PsycheEval's methodology by adding a non-judge evaluation signal. The coverage metric is applicable to validate the persona set for v0.3. Neither requires integrating PPol's full infrastructure — both techniques can be reimplemented as a lightweight analysis module inside PsycheEval's `analyze.py`.

No existing workspace project uses τ²-bench or OpenEvolve, so the evolution pipeline would require new infrastructure if adopted.

## Recommended Actions

1. **Extract PPol's 19-feature behavioral fingerprint as a PsycheEval diagnostic** — implement in `analyze.py` to validate condition separation independently of judge scoring; most valuable for v0.2 post-analysis or v0.3 design.
2. **Apply Chamfer distance coverage check to PsycheEval's 8 personas** — audit whether the hand-crafted persona set actually covers diverse behavioral regions; flag any gaps for v0.3 persona additions.
3. **Log PPol's SFT experiments as a v0.3+ candidate** — baking Psyche profiles into a LoRA is worth a note in the v0.3 candidates list but is not v0.2-relevant.
4. **No full PPol integration needed** — the evolutionary pipeline adds significant infrastructure cost for minimal gain over the two targeted borrowings above.
