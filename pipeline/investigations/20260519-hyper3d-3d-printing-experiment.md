---
date: 2026-05-19
topic: "Document this for potential 3d printing/design experimentation — hyper3d.ai"
discord_message_id: "1506368848415297607"
status: complete
---

# Hyper3D — 3D Printing & Design Experimentation Platform

## Topic

User flagged hyper3d.ai for documentation as a potential tool for 3D printing and design experimentation.

## Key Findings

- **Company**: Deemos Tech — produces Hyper3D, a family of AI-powered 3D generation tools
- **Core product**: **Rodin Gen 1.5** — 4B+ parameter model generating 3D assets from text or image prompts, with native quad mesh output and PBR (physically-based rendering) materials — these are production-ready formats, not toy outputs
- **3D printing relevance**: Platform explicitly covers STL file workflows for 3D printing; blog has dedicated print-prep guides
- **API access available**: REST API for developers to integrate 3D generation into pipelines
- **Plugin ecosystem**: Blender, Maya, Unity, Unreal Engine, Daz3D support — broad compatibility with existing 3D tooling
- **Adjacent tools in workspace**: freecad-mcp (already investigated 2026-04-19) provides parametric CAD via FreeCAD; Hyper3D is generative (text/image → mesh) rather than parametric — the two are complementary, not redundant

## Details

Hyper3D's flagship product Rodin Gen 1.5 is a large multimodal model trained on 3D asset datasets. Its differentiator is native quad mesh output — most generative 3D tools output triangle meshes or NeRF representations that require significant cleanup for practical use. Quad meshes are directly usable in standard 3D pipelines (Blender, Unity, Unreal) without retopology, which dramatically reduces the gap between generation and usable output. PBR materials (albedo, roughness, metallic, normal maps) mean generated assets have proper surface properties for rendering and printing.

For 3D printing specifically, the platform's STL export workflow and dedicated blog guides suggest first-class support for that use case. The main constraint for printing is that generated meshes need to be watertight (no holes), and AI-generated geometry sometimes fails this — though Rodin's quad mesh approach mitigates this more than triangle-mesh competitors.

The API is the most relevant integration point for a workspace experiment. It accepts text descriptions or reference images and returns 3D asset files. A simple experiment could be: generate a few objects from text prompts, export as STL, evaluate mesh quality and printability. Pricing for the API is tiered but not publicly listed on the scraped content — requires account creation to see credits.

OmniCraft (their auxiliary toolkit) includes mesh editing, format conversion, and texture generation tools that would be useful for post-processing generated assets before sending to a printer or game pipeline.

## Relevance to Workspace

- **3D printing experiment**: Primary use case. Hyper3D + FreeCAD-MCP gives a two-path experiment: generative (Hyper3D) vs. parametric (FreeCAD) 3D asset creation. A side-by-side comparison would be a natural first experiment.
- **Game asset pipeline**: Secondary use case. The games pipeline (slime-survivor, veilbreak) currently uses asset generation tools. Hyper3D could supply 3D mesh assets where the current pipeline generates 2D sprites/textures.
- **Agent integration**: The API could be called by a Claude Code agent or Hermes as part of a creative pipeline. No complex auth — standard REST with API key.
- **Relates to**: `pipeline/investigations/20260419-freecad-mcp-cad-experiment.md` (parametric CAD via MCP — the complementary non-AI approach)

## Recommended Actions

1. **Create a trial account** at hyper3d.ai to check API pricing and available free credits — determine if a no-cost experiment is feasible before committing.
2. **Design a minimal experiment**: text prompt → Rodin Gen 1.5 → STL export → evaluate mesh quality for printability. Could be done as a one-session workspace experiment once pricing is confirmed.
3. **Cross-reference with freecad-mcp**: The prior investigation proposed a CAD experiment with FreeCAD. Hyper3D makes that experiment richer: parametric (FreeCAD) vs. generative (Hyper3D) for the same target object, then compare printability and turnaround time.
4. **Document Blender plugin**: If the workspace ever integrates Blender (currently not in scope), the Hyper3D plugin provides a direct in-app generation workflow worth noting then.
