---
date: 2026-04-19
topic: "https://github.com/neka-nat/freecad-mcp — We should make a CAD experiment. This seems like it could be relevant there"
discord_message_id: "1495394244771315795"
status: complete
---

# FreeCAD MCP — CAD Experiment Feasibility

## Topic
The user flagged `freecad-mcp` (a Model Context Protocol server for FreeCAD) and expressed interest in running a CAD experiment. This investigates what freecad-mcp offers, how hard it is to set up on requiem, and what a meaningful first experiment might look like.

## Key Findings
- **freecad-mcp** exposes 12 FreeCAD operations as MCP tools: document create/open, object create/edit/delete, Python code execution, parts library insertion, viewport screenshot capture, and object listing. Essentially, full programmatic 3D modeling via natural language.
- **768 stars / 130 forks** — healthy community engagement for a niche tool; not a toy project.
- **Requirements**: FreeCAD installed on the host + uvx (already available on requiem) + one-time addon placement in FreeCAD's Mod directory. No exotic dependencies.
- **Remote support**: Can run FreeCAD on a different machine and have Claude connect via IP — relevant if FreeCAD runs headless on requiem while Claude drives it.
- **Visual feedback loop**: The MCP can capture viewport screenshots mid-session, enabling iterative "describe → generate → see → refine" workflows identical to how we use better-playwright for web testing.
- **No workspace CAD presence**: Nothing in `experiments/`, `games/`, or `tools/` touches CAD currently. This would be net new territory.

## Details

FreeCAD is a full parametric 3D modeler (open source, well-supported on Linux). The freecad-mcp server wraps its Python API and presents it as callable MCP tools, so Claude can say "create a box 50mm × 30mm × 10mm, chamfer the top edges, export as STL" and get it done without writing a script file. The screenshot capture tool closes the feedback loop — Claude can see what it built and iterate.

The repo pattern is essentially the same as our better-playwright setup: a running desktop app (FreeCAD instead of Chrome) exposed to Claude via an MCP sidecar process. The prior art from our playwright integration de-risks this: we know how to configure MCP servers, manage running GUI apps on requiem, and write agents that iterate based on visual feedback.

Potential experiment directions: (1) **Mechanical part generation** — prompt Claude to design a simple bracket or enclosure and export STL for 3D printing; (2) **Game asset modeling** — low-poly props for slime-survivor or <private-project>-gacha; (3) **Engineering exploration** — parametric designs where changing one dimension propagates correctly (testing FreeCAD's parametric engine via AI). Direction (1) is the cleanest first experiment because success/failure is unambiguous (does the STL make sense geometrically?).

The main unknown is how well Claude handles spatial/geometric reasoning in natural language → FreeCAD Python code. The MCP exposes a Python execution tool, meaning it can run arbitrary FreeCAD Python commands — so Claude isn't limited to a fixed vocabulary of shapes. That's powerful but also means hallucinated API calls are possible; the visual feedback loop is what catches those.

## Relevance to Workspace
- **Games asset pipeline** (`games/asset-pipeline/`): FreeCAD could complement the AI art pipeline — 2D concept → 3D base mesh → texture.
- **Experiments directory** (`experiments/`): Clean fit for a "can Claude design a 3D object from scratch?" experiment alongside existing Bayesian/MAB work.
- **MCP ecosystem**: We already know how to wire MCP servers; freecad-mcp would be the second hardware-adjacent MCP (after playwright) — broadens our capability surface into physical-world tooling.

## Recommended Actions
1. **Install FreeCAD on requiem**: `sudo apt install freecad` or AppImage — verify headless mode works (FreeCAD needs a display; Xvfb virtual framebuffer if running headless).
2. **Clone and wire up freecad-mcp**: Follow the addon install steps, add to `.mcp.json`, test with a simple "create a box" prompt.
3. **Define experiment scope**: Start with a mechanical part (bracket, enclosure lid) as the test case — clear success criteria, exportable as STL.
4. **Document in BACKLOG.md**: Log this as an `experiments/freecad-cad/` experiment candidate with the headless-display caveat as the primary technical risk.
