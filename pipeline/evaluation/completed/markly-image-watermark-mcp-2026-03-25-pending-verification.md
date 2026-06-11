# Markly – Image Watermarking MCP: Pending GitHub Verification

**Status**: APPROVED (75.5/100) — integration BLOCKED pending GitHub verification
**Blocked since**: 2026-03-25
**Unblocked by**: Confirm GitHub repo URL with 100+ stars + active maintenance

## Integration Plan (execute when unblocked)

1. Search: `markly image watermark mcp github` — confirm repo URL and star count
2. If 100+ stars and actively maintained (commits within 6 months):
   ```bash
   claude mcp add --transport stdio markly -- npx -y markly-mcp
   ```
   (adjust package name based on confirmed npm/GitHub package name)
3. Test with sample Ashita Orbis image:
   ```
   Add "© Ashita Orbis 2026" watermark, bottom-right, 70% opacity
   ```
4. Create integration report in `pipeline/verification/`
5. Add to registry under new "Image Manipulation" subsection

## Registry Entry (draft, pending activation)

```
| Markly Image Watermarking MCP | **PENDING** | Zero-setup image manipulation via npx. Batch watermarking, natural language commands (e.g., "Add Copyright 2026 bottom-right, semi-transparent"). No API key required. Use cases: Ashita Orbis blog asset management, game screenshot overlays. |
```

## Redundancy Triggers (for future redundancy check)

"markly", "image watermark mcp", "watermarking mcp", "image manipulation mcp", "batch watermark", "copyright overlay", "logo overlay images"
