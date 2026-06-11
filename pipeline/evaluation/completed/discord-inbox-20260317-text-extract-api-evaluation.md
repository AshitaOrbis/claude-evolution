# Text Extract API (CatchTheTornado)

- **Date**: 2026-03-17
- **Source**: Discord #general inbox
- **URL**: https://github.com/CatchTheTornado/text-extract-api
- **Category**: Document extraction / PDF parsing
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1483553228183306315
- **Discord Context**: "Could this be useful for PDF Parser?"
- **Evaluated**: 2026-03-18

## What It Is

A document extraction and parsing API for PDFs, Word documents, PowerPoint, and images. Key features:
- State-of-the-art OCR with Ollama-supported models
- Document anonymization and PII removal
- Converts documents to structured JSON or Markdown output
- TypeScript client library available
- ~2.6k GitHub stars

## Registry Check

The workspace has an existing PDF Parser project at `tools/pdf-parser/` using its own approach (venv + ~11GB data). No MCP or built-in tool provides direct document-to-structured-text extraction comparable to text-extract-api's OCR+anonymization stack.

**Result**: NOVEL for this specific capability profile — broader format support + PII removal are not covered by existing tools.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 60 | Separate service (REST API or Docker); needs integration with tools/pdf-parser/ or standalone |
| Token efficiency | 60 | Direct structured extraction without browser overhead; moderately efficient |
| Capability expansion | 60 | Broader format support (Word, PPTX, images) + PII removal beyond current PDF Parser scope |
| Maintenance burden | 60 | Active community (2.6k stars), TypeScript client; moderate maintenance |
| Community validation | 70 | 2.6k stars — 1k+ range |

**Weighted Score**: (60×0.20) + (60×0.25) + (60×0.25) + (60×0.15) + (70×0.15) = 12 + 15 + 15 + 9 + 10.5 = **61.5/100**

## Decision

**NEEDS_RESEARCH** (61.5)

## Research Questions

1. **vs existing pdf-parser**: What does `tools/pdf-parser/` already do? Would text-extract-api replace or complement it?
2. **Self-hosting**: Can this run locally without Docker? Or is the Docker setup lightweight?
3. **PII removal value**: Is PII removal needed for any current projects (membership PDFs?)?
4. **MCP integration**: Is there an existing MCP server wrapper for text-extract-api?

**Re-evaluate at**: 70+ if PII removal + multi-format is needed and self-hosting is simple (could replace or supplement pdf-parser). ~45 if Docker overhead is high and pdf-parser already covers needs.
