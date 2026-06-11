---
date: 2026-04-10
topic: "Put this into the backlog for PDF Parser, we'll try it in the workflow"
discord_message_id: "1490535643040710808"
status: complete
---

# GLM-OCR — PDF Parser Backlog Entry

## Topic
Add GLM-OCR to the PDF Parser backlog as a potential alternative VLM backend.

Source: https://github.com/zai-org/GLM-OCR

## Key Findings

- GLM-OCR is a lightweight (0.9B params) multimodal OCR model built on GLM-V encoder-decoder architecture with CogViT visual encoder + GLM-0.5B language decoder
- Achieves **94.62 on OmniDocBench V1.5** — strong for complex tables, code-heavy documents, seals, and challenging real-world layouts
- Supports local deployment via **Ollama** (simplest path), vLLM, SGLang, MLX (Apple Silicon), and self-hosted SDK
- Current PDF parser uses olmOCR (allenai/olmOCR-2-7B-1025) — 7B params; GLM-OCR at 0.9B is ~8x smaller with comparable or better structured-document performance
- The BCWF membership forms have printed fields + handwriting; GLM-OCR's "real-world layout" optimization and seal recognition are potentially more relevant than olmOCR's pure handwriting strength
- Ollama deployment path is already established in the PDF parser codebase (existing `ollama` VLM backend)

## Details

The PDF parser (`tools/pdf-parser/`) uses a zonal OCR approach with two VLM backends:
- `olmocr` (default): 7B model, best for handwriting
- `ollama`: 13B llava, faster but less accurate

GLM-OCR would slot naturally into the `ollama` backend since it supports Ollama deployment. Adding it as a third backend (`glm-ocr`) would require minimal changes — likely just the model name and prompt formatting.

Key question for evaluation: the BCWF forms combine printed labels + handwritten fills. olmOCR was chosen for handwriting accuracy. GLM-OCR's claim to fame is complex document layouts (tables, seals), which may or may not apply to a simple membership form. The test would be: run GLM-OCR on the same crops that olmOCR currently handles and compare confidence scores and accuracy.

At 0.9B, GLM-OCR would run significantly faster on the existing hardware and require less VRAM, which matters for batch processing large membership form sets.

## Relevance to Workspace

- `tools/pdf-parser/` — direct applicability; the VLM backend abstraction already supports multiple models
- Current stack: olmOCR-2-7B-1025 (Qwen2.5-VL) via transformers
- Ollama is already supported as a fallback backend (llava:13b)
- GLM-OCR via Ollama would be: pull model → update backend name → test

## Recommended Actions

1. **Add to PDF Parser backlog**: Test GLM-OCR as a third VLM backend via Ollama
2. **Benchmark** against olmOCR on a sample of BCWF crops (zones where olmOCR currently shows lower confidence)
3. **Priority: low** — olmOCR is working well; this is a "try when batch throughput or VRAM becomes a constraint"
4. **Setup**: `ollama pull glm-ocr` (or equivalent model name), then modify `extract_forms.py` to accept `--vlm-backend glm-ocr`
