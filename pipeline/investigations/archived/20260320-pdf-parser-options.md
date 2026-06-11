---
date: 2026-03-20
topic: "arXiv paper model for PDF parser (Qianfan-OCR) and text-extract-api comparison"
discord_message_id: "1484451690995253349,1483553228183306315"
status: complete
---

# PDF Parser Options: Qianfan-OCR vs text-extract-api

## Topic

Two related PDF parser questions posted to Discord:

1. (Mar 20) "find the model from this paper, would it be good for our PDF parser? Assuming it can run locally?" — arXiv 2603.13398
2. (Mar 17) "Could this be useful for PDF Parser?" — github.com/CatchTheTornado/text-extract-api

## Key Findings

- **arXiv 2603.13398** introduces **Qianfan-OCR**, a 4B parameter vision-language model from Baidu (Qianfan platform) that does direct image-to-Markdown conversion with state-of-the-art benchmark results
- Qianfan-OCR is **cloud-deployed** (Baidu AI Cloud Qianfan platform) — no confirmed local deployment path; the model weights are not currently open-sourced
- **text-extract-api** is **fully local/self-hosted**, open-source, uses Ollama-backed models (LLama 3.2 vision, MiniCPM-V) for OCR + LLM post-processing — directly comparable workload to `tools/pdf-parser/`
- text-extract-api was already evaluated at **NEEDS_RESEARCH (61.5/100)** — not rejected, pending investigation of whether it would replace or complement the existing PDF parser
- The current `tools/pdf-parser/` handles ~2.5GB of membership PDFs — the key question is whether text-extract-api's multi-format support and PII removal are worth the migration overhead
- For local document intelligence, **Qianfan-OCR cannot currently be run locally**; the appropriate open alternative is **Nanonets-OCR-s** or **GOT-OCR2.0** (both fully open and local)

## Details

### Qianfan-OCR (arXiv 2603.13398)

The "Layout-as-Thought" technique is genuinely innovative — the model first generates a layout representation (bounding boxes, element types, reading order) before producing final Markdown. This produces superior results on complex documents with tables and mixed layouts. Performance highlights:
- 93.12 on OmniDocBench v1.5 (first among end-to-end models)
- Beats Gemini 3.1 Pro on key information extraction
- 4B parameters is local-feasible (8–16GB VRAM), **but weights are not currently released**

**Verdict for PDF Parser**: Not usable locally today. Monitor for open-weight release. If Baidu releases weights, this would be a strong upgrade for the membership PDF pipeline.

### text-extract-api

- Fully local, Docker-deployed FastAPI/Celery service
- Supports PDFs, Word, PPTX, images; 30+ languages via EasyOCR
- Three OCR backends: EasyOCR, LLama-vision, MiniCPM-V
- PII removal via LLM post-processing (relevant if membership PDFs contain personal data)
- ~2.6k GitHub stars (community validated)
- NEEDS_RESEARCH status: main open question was whether it replaces or complements existing `tools/pdf-parser/`

The existing PDF Parser uses a custom venv with ~11GB of data. If text-extract-api provides equivalent accuracy with less custom code and adds PII removal, it's a worthwhile migration. The Docker setup is the main friction point.

## Relevance to Workspace

- `tools/pdf-parser/`: Direct replacement/augmentation candidate
- Membership PDFs (~2.5GB): Core use case; PII removal could be beneficial for exported reports
- Historical Nanochat: If any document-heavy data ingestion is needed, text-extract-api provides broader format support than a pure PDF parser

## Recommended Actions

1. **text-extract-api**: Run the Docker container on a sample of the membership PDFs; compare accuracy and extraction quality vs. current pipeline. If results match or exceed, migrate
2. **Qianfan-OCR**: Monitor for open-weight release. Star the arXiv paper and check back in 3 months. If weights are released, evaluate as a vision-based backend for text-extract-api
3. **Intermediate option**: Consider [GOT-OCR2.0](https://github.com/Ucas-HaoranWei/GOT-OCR2.0) (open weights, local, good benchmarks) as a local PDF intelligence model in the interim
