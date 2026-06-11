---
date: 2026-04-28
topic: "Look into zotero-scipdf as potentially useful academic database for Psyche and similar research"
discord_message_id: "1498722338001260687"
status: complete
---

# Zotero-SciPDF: Automated Academic PDF Access via Sci-Hub

## Topic
Look into github.com/syt2/zotero-scipdf as a potentially useful academic database for Psyche and similar research.

## Key Findings

- **zotero-scipdf is a Zotero 7/8 plugin that automates PDF downloads via Sci-Hub**: it writes Sci-Hub's resolver into Zotero's `extensions.zotero.findPDFs.resolvers` config field; from there, "Find Full Text" works automatically for any item with a DOI
- **This is a PDF access layer, not a database**: Sci-Hub itself has ~87M papers; zotero-scipdf just makes Zotero pull from it instead of paywalled publishers — the workflow is: add citation to Zotero → right-click → "Find Full Text" → PDF downloads
- **Direct relevance to Psyche**: the psychometric battery references 39 instruments; many of those primary scales (HEXACO, BFI, SDT scales, RIASEC, etc.) are locked behind APA/Wiley/Elsevier paywalls; this is exactly the bottleneck for building a literature base around the assessment
- **Legal status is grey**: Sci-Hub operates in legal grey area (copyright infringement in most jurisdictions); no criminal liability for end users under most legal frameworks, but institutional risk if using on a university network or for commercial research outputs
- **Requires Zotero 7+**: version-locked; Zotero 6 users need to upgrade first
- **Limitation**: only works for items with DOIs; pre-DOI literature, grey literature, and some conference papers won't resolve

## Details

Zotero (https://www.zotero.org) is an open-source reference manager that stores citations, PDFs, notes, and tags in a local library. It supports a plugin ecosystem, and Zotero 7 introduced a more capable `findPDFs.resolvers` configuration that allows custom resolver chains. zotero-scipdf exploits this by inserting Sci-Hub as a resolver: when you ask Zotero to "Find Full Text" for an item, it tries the configured resolvers in order, and Sci-Hub typically succeeds for papers that journal websites would paywalled.

For the Psyche project, the primary use case would be building a primary-source literature library for the instruments used in the 39-instrument battery — BFI-2, HEXACO-PI-R, RIASEC measures, Dark Triad scales, CRT, STAI, etc. Many of these instruments have psychometric validation papers that are APA-paywalled and would otherwise require institutional access or $40-per-paper purchases. With zotero-scipdf, the workflow becomes: add DOI to Zotero, right-click, done.

Secondary use case: if the Psyche project expands to psychometric research (e.g., running validation studies, comparing instrument results across populations), having a well-organized Zotero library with full-text PDFs is the standard research infrastructure for that work.

The legal considerations are real but manageable for personal research use. The workspace is for personal development projects, not institutional research outputs. The risk profile for a private individual building a reading list for self-directed research is essentially zero — enforcement actions have targeted Sci-Hub's operators, not individual users.

## Relevance to Workspace

The Psyche project (`claudeworkspace/psyche/`) contains the 39-instrument psychometric battery and a web interface. Current state: profiles generated, reports completed, claude-context.md in place. Future development depends on understanding the psychometric literature (instrument validation, normative data, interpretation frameworks). zotero-scipdf directly addresses the friction of accessing that literature.

The broader workspace also includes research projects (historical-nanochat, genealogy, etymology-benchmark) where primary academic literature access matters. A shared Zotero library with full-text PDFs would be the appropriate reference infrastructure across those projects.

## Recommended Actions

1. **Install Zotero 7** (if not already present) and the zotero-scipdf plugin as standard research infrastructure
2. **Seed the Psyche library**: add the DOIs for the primary validation papers for the 39 instruments; use "Find Full Text" to batch-download PDFs; organize by instrument family
3. **Consider a shared Zotero group library** for workspace-wide research (genealogy, psychometrics, historical text) — free plan supports unlimited personal libraries
