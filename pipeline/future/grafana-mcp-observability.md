# Discovery: Grafana MCP Server

- **Source**: https://github.com/grafana/mcp-grafana
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: Official Grafana MCP server providing AI agents with dashboard management, PromQL/LogQL queries, alerting, incident management (Grafana Incident/OnCall), and Sift investigations. Token-efficient with dashboard summaries and JSONPath extraction.
- **Potential Value**: High
- **Integration Complexity**: Medium

## Description

The Grafana MCP Server enables AI assistants to interact with Grafana observability infrastructure through 40+ tools covering:

**Key Features**:
- **Dashboard Management**: Search, retrieve, modify dashboards with context-aware summaries (token minimization)
- **Data Querying**: Execute PromQL (Prometheus) and LogQL (Loki) queries directly
- **Alerting**: Create, update, manage alert rules across Grafana and datasource-managed systems
- **Incident Management**: Integration with Grafana Incident and OnCall for tracking and scheduling
- **Advanced Analysis**: Sift investigations for error pattern detection and slow request analysis
- **Observability Tools**: Pyroscope profiling, annotations, dashboard rendering
- **Navigation**: Generates accurate deeplink URLs for Grafana resources (reduces hallucinations)

**Technical Details**:
- Language: Go
- License: Apache 2.0
- Stars: 2.2k (active development, 425 commits)
- Requires: Grafana 9.0+ for full functionality
- Transport: Stdio/HTTP Streamable

**Unique Value**:
- Token-efficient context management (summaries, JSONPath extraction)
- Direct integration with Prometheus/Loki without custom API wrappers
- Real-time observability insights within AI workflows
- Incident correlation and on-call context

## Redundancy Check

**Status**: NOVEL

Searched registry for: "grafana", "prometheus", "loki", "observability mcp", "monitoring dashboard", "alerting mcp", "incident management", "time-series query"

**Findings**:
- ✅ No existing Grafana integration
- ✅ Brave/Exa search exists but NOT for infrastructure monitoring APIs
- ✅ Browser automation exists but NOT for observability dashboards
- ✅ Task management exists but NOT for incident tracking
- ✅ No Prometheus/Loki query capabilities

**Category**: Monitoring & Observability (gap in current capabilities)

## Evaluation Needs

1. **Token Efficiency**: How much overhead for typical queries vs manual dashboard access?
2. **Use Cases**: Is this valuable for <private-project> monitoring? Evolution pipeline health checks?
3. **Setup Complexity**: Requires Grafana instance - do we have one? Cloud vs self-hosted trade-offs?
4. **Alternative Value**: Could we use for monitoring OTHER services (Discord bot, heartbeat scripts)?
5. **Security**: Credential management for Grafana API tokens
6. **Comparison**: How does this compare to Datadog MCP (if we evaluate that)?

**Quick Assessment Score** (preliminary):
- Integration complexity: 55 (needs Grafana instance + API keys)
- Token efficiency impact: 75 (summarization features, direct API vs screen scraping)
- Capability expansion: 85 (fills observability gap)
- Maintenance burden: 70 (official Grafana project, active development)
- Community validation: 90 (2.2k stars, official)
- **TOTAL**: ~75 (likely APPROVE)

## Notes

- Official Grafana project = well-maintained, follows protocol updates
- Token optimization features show observability-aware design
- Could enable "Claude, investigate that 500 error spike" workflows
- Complementary to existing stack (doesn't replace anything)
