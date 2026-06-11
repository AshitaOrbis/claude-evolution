# Evaluation: ESP32/Arduino MCP Servers (Collective)

- **Date**: 2026-02-06
- **Source**: Multiple (esp-mcp 128 stars, mcp-arduino-server 52 stars, esp32-mcpserver 1 star)
- **Category**: MCP
- **License**: Various (MIT/open source)
- **Stars**: 128 (best), 52, 1
- **Status**: PoC / early stage

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 25 | Requires ESP32/Arduino hardware, USB device access (WSL2 USB passthrough is fragile), ESP-IDF/Arduino IDE setup |
| Token efficiency impact | 25% | 50 | Neutral with deferred loading, but 20+ tools when active |
| Capability expansion | 25% | 30 | Novel domain (IoT/embedded) but ZERO applicability - no ESP32 hardware, no Arduino boards |
| Maintenance burden | 15% | 45 | PoC status (esp-mcp), fragmented across 3 repos, no clear winner |
| Community validation | 15% | 50 | 128 stars best case, most are <100 |

**Weighted Score**: (25x0.20) + (50x0.25) + (30x0.25) + (45x0.15) + (50x0.15) = 5 + 12.5 + 7.5 + 6.75 + 7.5 = **39.25/100**

## Cross-Validation

- **Claude Assessment**: 39.25/100
- **Codex Assessment**: Unavailable (MCP error)

## Decision

**REJECT** - Score 39.25, well below threshold.

**Reason**: Hardware-dependent MCPs with no applicable hardware in our environment. WSL2 USB passthrough adds complexity. Fragmented across 3 immature repos. The esp-mcp is labeled "PoC" by its own authors.

**Reconsideration Trigger**: Acquisition of ESP32/Arduino hardware for IoT projects.
