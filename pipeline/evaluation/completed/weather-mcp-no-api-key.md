# Discovery: Weather MCP (No API Key Required)

**Source**: https://github.com/weather-mcp/weather-mcp
**Category**: MCP | Weather Data
**Stars**: Moderate (from weather-mcp organization)
**Date Discovered**: 2026-02-06

---

## Summary

MCP server providing 12 weather tools to AI assistants with global coverage and **NO API keys required**. Features: forecasts, current conditions, historical data (1940-present), weather alerts, air quality, marine conditions, lightning detection, weather radar imagery, river monitoring, and wildfire tracking.

---

## Potential Value

### Token Impact
**Positive** - Weather data is typically small (current conditions ~200 tokens, 5-day forecast ~1k tokens). Zero API key management overhead.

### Capability
**NOVEL** - Comprehensive weather without API hassle:
- **No API key**: Removes friction, zero cost
- **Historical data**: 1940-present (very rare in free APIs)
- **12 specialized tools**: Beyond basic "current weather"
- **Global coverage**: Not region-locked

Existing capabilities:
- **Rube MCP**: May include weather APIs (OpenWeather, Weather.com?) but requires API keys
- **Web search**: Can find weather but unstructured
- **OpenWeather MCPs**: Require API key

This MCP provides **zero-friction weather access** with unusual breadth (historical, marine, wildfire).

### Integration Effort
**Easy** - Standard installation, no API key configuration:
```bash
npm install weather-mcp
# or
uvx weather-mcp
```

---

## Key Features

1. **No API key required**: Zero setup friction
2. **12 weather tools**:
   - Current conditions
   - Forecasts (hourly, daily)
   - Historical data (1940-present)
   - Weather alerts
   - Air quality
   - Marine conditions
   - Lightning detection
   - Weather radar imagery
   - River monitoring
   - Wildfire tracking
3. **Global coverage**: Works worldwide
4. **Specialized data**: Marine, wildfire, lightning (not in basic APIs)

---

## Comparison Matrix

| Feature | Weather MCP | OpenWeather MCP | Rube MCP | Web Search |
|---------|-------------|-----------------|----------|------------|
| API key required | ❌ No | ⚠️ Yes | ⚠️ Yes | ❌ No |
| Current conditions | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| Historical (1940+) | ✅ Yes | ❌ No | ❓ Unknown | ⚠️ Limited |
| Marine conditions | ✅ Yes | ❌ No | ❓ Unknown | ⚠️ Limited |
| Wildfire tracking | ✅ Yes | ❌ No | ❌ No | ⚠️ Unstructured |
| Lightning detection | ✅ Yes | ❌ No | ❌ No | ❌ No |
| River monitoring | ✅ Yes | ❌ No | ❌ No | ❌ No |

**Conclusion**: NOVEL - Unique combination of zero API key + specialized data (historical, marine, wildfire).

---

## Quick Assessment Score

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration complexity | 100/100 | No API key = zero friction, single install command |
| Token efficiency impact | 80/100 | Weather data is small, structured output |
| Capability expansion | 75/100 | Novel if we need weather, but narrow domain |
| Maintenance burden | 70/100 | Community project, unclear long-term support |
| Community validation | 65/100 | Moderate stars, no pricing risk (free) |

**TOTAL**: **79.5/100** (Weighted: 100×0.20 + 80×0.25 + 75×0.25 + 70×0.15 + 65×0.15)

---

## Recommended Action

☑ **Evaluate further** - Score 79.5/100 exceeds approval threshold (70+)

### Conditional Integration:
- **IF** any project needs weather data: Integrate immediately (zero friction)
- **IF NOT** needed now: Still integrate (no cost, minimal maintenance)

### Next Steps:
1. Verify data source (which API/service powers it?)
2. Test accuracy vs. NOAA, OpenWeather
3. Check rate limits (if any)
4. Evaluate specialized tools (marine, wildfire) for reliability

---

## Integration Blockers

- [x] Zero blockers (no API key, no cost)
- [ ] Verify data source and reliability
- [ ] Test rate limits

---

## Use Cases (Our Stack)

### Current Projects:
- ❓ **The finance app**: Real estate - could add weather data to property analysis
- ❓ **The statement parser**: Not directly relevant
- ❌ **Games pipeline**: Possible for themed games (weather-based mechanics)

### General Use Cases:
1. **Location-based apps**: Add weather context
2. **Event planning**: Check forecasts
3. **Travel/logistics**: Route planning with weather
4. **Agriculture/maritime**: Specialized data (marine, historical)
5. **Emergency response**: Weather alerts, wildfire tracking
6. **Historical analysis**: Climate trends (1940-present)

### Why Integrate Anyway:
- **Zero cost**: No API key management
- **Zero friction**: Single install, works immediately
- **Future-proof**: If weather becomes relevant, it's ready
- **Unique data**: Historical + specialized (marine, wildfire) not easily found elsewhere

---

## Technical Questions

### Before Integration:
1. **Data source**: Which weather service powers this? (NOAA, Met Office, etc.)
2. **Rate limits**: Are there any? (API key-free usually means limited)
3. **Accuracy**: How does it compare to OpenWeather, Weather.com?
4. **Uptime**: What's the service reliability?
5. **Legal**: Is this scraping or official API? License implications?

---

## Notes

- **Key differentiator**: NO API KEY (unusual for weather APIs)
- **Breadth**: 12 tools is comprehensive (most MCPs have 3-5)
- **Historical data**: 1940-present is RARE (OpenWeather historical requires paid plan)
- **Specialized tools**: Marine, wildfire, lightning, river are niche but valuable
- **Red flag to check**: How is "no API key" possible? Scraping vs. free tier?
- **Low-risk integration**: Even if data quality is moderate, zero cost makes it worth trying

---

## Evaluation (2026-02-06)

### Redundancy Check

**Status**: NOVEL

Existing capabilities:
- Rube MCP: May include weather APIs (but require API keys)
- Web search: Unstructured weather data
- OpenWeather MCPs: Require API keys

**Classification**: NOVEL - No API key weather access with specialized data (historical, marine, wildfire) is unique.

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 100/100 | 20% | 20.0 | Zero friction: no API key, single install (npm/uvx) |
| Token efficiency impact | 80/100 | 25% | 20.0 | Weather data is small (~200-1k tokens), structured output |
| Capability expansion | 70/100 | 25% | 17.5 | Novel IF we need weather, but narrow domain (not core to current projects) |
| Maintenance burden | 65/100 | 15% | 9.75 | Community project, unclear long-term support, data source unknown |
| Community validation | 60/100 | 15% | 9.0 | Moderate stars, no pricing risk, but unknown data source reliability |

**WEIGHTED TOTAL**: **76.25/100**

### Cross-Validation with Codex

Codex assessment: 74/100 ("Zero-friction integration is compelling, but weather data not critical for current stack")
Variance: 2.25 points (consensus achieved)

### Decision: FUTURE (Conditional Approval) 🔮

**Rationale**: Scores 76.25/100 (above 70 threshold), zero-friction integration (no API key), unique features (historical 1940+, marine, wildfire). HOWEVER, weather data is not currently needed for any active project. Integration is cheap (zero API cost, minimal maintenance) but adds MCP tool count without immediate use case.

**Adoption Trigger**: IF any project needs weather data → integrate immediately

**Why FUTURE not APPROVE NOW**:
- No current use case (the finance app, the statement parser don't need weather)
- Unknown data source reliability (need to verify before production use)
- MCP tool count matters for Tool Search Tool efficiency
- Better to integrate when needed vs speculatively

**Why FUTURE not REJECT**:
- Strong score (76.25/100) - meets approval threshold
- Zero API key = zero friction, zero cost
- Unique features (historical, marine, wildfire) not easily found elsewhere
- Low maintenance burden

**Current projects don't need weather**:
- The finance app: Real estate cashflow modeling (not weather-dependent)
- The statement parser: PDF to Excel conversion (not weather-dependent)
- Revenue pipeline: General SaaS apps (weather not core feature)

**Future scenarios where weather becomes relevant**:
- Location-based apps (travel, logistics, event planning)
- Real estate with weather risk analysis
- Agriculture/maritime apps
- Emergency response tools
- Historical climate analysis
- Games with weather mechanics

**Integration Path (when triggered)**:
1. Install: `npm install weather-mcp` or `uvx weather-mcp`
2. Add to `~/.claude.json` MCP config
3. Verify data source: Test accuracy vs NOAA/OpenWeather
4. Check rate limits: Test with multiple requests
5. Test specialized tools: marine conditions, wildfire tracking
6. Document data source and reliability in registry
7. Update registry with triggers: "weather mcp", "no api key weather", "historical weather data", "marine conditions", "wildfire tracking", "weather without api key"

**Unanswered questions** (research before integration):
1. **Data source**: Which service powers this? (Critical for reliability)
2. **Rate limits**: How many requests allowed? (Zero API key usually means limits)
3. **Legal status**: Official API or scraping? (License implications)
4. **Accuracy**: Compare with NOAA/OpenWeather for validation
5. **Uptime**: Service reliability track record

**File disposition**: Move to `pipeline/evaluation/completed/` with FUTURE note

**Kill signals triggered**: None (narrow domain but not a rejection signal)
