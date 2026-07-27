# Discovery: Financial Datasets MCP

**Source**: https://github.com/financial-datasets/mcp-server
**Category**: MCP | Financial Data | Stock Market API
**Stars**: 747
**Date Discovered**: 2026-02-06

---

## Summary

MCP server providing access to the Financial Datasets API for stock market data. Retrieves income statements, balance sheets, cash flow statements, stock prices, and market news. Python-based MCP with MIT license.

---

## Potential Value

### Token Impact
**Neutral** - Returns structured financial data (JSON format). Token usage depends on query scope (single stock vs. multiple, historical ranges).

### Capability
**NOVEL (if financial data needed)** - Structured financial statement access:
- Income statements
- Balance sheets
- Cash flow statements
- Current and historical stock prices
- Company news

Existing capabilities:
- **Rube MCP**: May include stock/financial APIs, but unclear if it covers fundamental data (statements)
- **Web search**: Can find financial data, but requires parsing and is unstructured
- **No existing tool**: Provides structured financial statements

This MCP provides **structured fundamental analysis data** that web search can't easily replicate.

### Integration Effort
**Easy** - Standard Python MCP:
```bash
pip install financial-datasets-mcp
```

Requires API key from financialdatasets.ai (pricing unclear).

---

## Key Features

1. **Fundamental data**: Income, balance sheet, cash flow statements
2. **Price data**: Current and historical stock prices
3. **Company news**: Market news related to specific companies
4. **Structured output**: JSON format, ready for analysis
5. **MIT license**: Open source

---

## Rube Comparison

| Feature | Financial Datasets MCP | Rube MCP | Web Search |
|---------|------------------------|----------|------------|
| Stock prices | ✅ Yes | ❓ Maybe | ⚠️ Unstructured |
| Income statements | ✅ Yes | ❌ Unlikely | ⚠️ Unstructured |
| Balance sheets | ✅ Yes | ❌ Unlikely | ⚠️ Unstructured |
| Cash flows | ✅ Yes | ❌ Unlikely | ⚠️ Unstructured |
| API key required | ⚠️ Yes | ✅ Per-app auth | ❌ No |

**Conclusion**: CONDITIONAL - Valuable IF we need financial analysis. Check if Rube includes similar data.

---

## Quick Assessment Score

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration complexity | 85/100 | Simple pip install, requires API key setup |
| Token efficiency impact | 70/100 | Structured data is efficient, but limited to financial domain |
| Capability expansion | 60/100 | High value IF needed, but narrow use case |
| Maintenance burden | 75/100 | Community project (747 stars), MIT license |
| Community validation | 70/100 | 747 stars is moderate, not top-tier |

**TOTAL**: **71/100** (Weighted: 85×0.20 + 70×0.25 + 60×0.25 + 75×0.15 + 70×0.15)

---

## Recommended Action

☑ **Evaluate further** - Score 71/100 barely exceeds approval threshold (70+)

### Conditional Integration:
- **IF** the statement parser needs stock analysis: Integrate
- **IF** Revenue pipeline needs market research: Integrate
- **IF NOT** needed now: DEFER to future

### Next Steps:
1. Check if Rube MCP includes financial statements (not just prices)
2. Determine if any current projects need fundamental analysis
3. Verify financialdatasets.ai pricing (free tier?)
4. Compare vs. free alternatives (Yahoo Finance, Alpha Vantage)

---

## Integration Blockers

- [ ] Requires API key from financialdatasets.ai
- [ ] Pricing unknown (may require paid plan)
- [ ] Verify data accuracy and coverage
- [ ] Check if Rube MCP duplicates this functionality

---

## Use Cases (Our Stack)

### Potentially Relevant:
1. **The statement parser**:
   - Enrich transaction data with company fundamentals
   - Calculate cost basis using historical prices
   - Validate ticker symbols

2. **Revenue pipeline (future)**:
   - Market research for SaaS competitors
   - Analyze public company financials
   - Track industry trends

3. **Personal finance tools**:
   - Portfolio analysis
   - Stock screening
   - Fundamental analysis automation

### NOT Currently Relevant:
- The finance app: Real estate, not stock market

---

## Research Questions

### Before Integration:
1. Does Rube MCP include financial statements or just stock prices?
2. What's the pricing for financialdatasets.ai API?
3. Are there free alternatives with MCP servers?
4. What's the data quality and coverage (exchanges, time range)?

### Alternatives to Check:
- **Alpha Vantage MCP**: Free tier available, 5+ tools
- **Yahoo Finance scrapers**: Free but unreliable
- **FMP (Financial Modeling Prep)**: Similar API, unclear if MCP exists

---

## Notes

- **Homepage**: https://www.financialdatasets.ai/
- **License**: MIT
- **Language**: Python
- **Listed in**: Multiple "Top 5/10 Financial MCP" articles (medium.com)
- **Comparison needed**: vs. Alpha Vantage, FMP, Quandl MCPs
- **Token efficiency**: Financial statements can be large (thousands of line items), consider pagination

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator

### Redundancy Check

**Registry Match**: NO existing financial data capabilities. No stock market data, no fundamental analysis tools.

**Classification**: **NOVEL** (if needed) - Structured financial statement access is new capability.

### Use Case Analysis

**Current projects check**:
- ❌ The finance app: Real estate, not stock market
- ⚠️ The statement parser: Parses brokerage PDFs (transactions), not fundamentals
- ❌ Revenue pipeline: B2B SaaS, not financial market analysis
- ❌ Games pipeline: No financial data needs
- ❌ Claude evolution: No financial analysis use case

**User context check**:
> "We don't actively trade stocks or manage financial portfolios."

**Verdict**: NO ACTIVE USE CASE

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 85/100 | 20% | 17.0 | Simple pip install, requires API key |
| Token efficiency impact | 70/100 | 25% | 17.5 | Structured data efficient, but domain-limited |
| Capability expansion | 35/100 | 25% | 8.75 | Novel but NO current use case (critical penalty) |
| Maintenance burden | 75/100 | 15% | 11.25 | Community project (747 stars), MIT license |
| Community validation | 70/100 | 15% | 10.5 | 747 stars moderate, niche domain |

**TOTAL**: **65.0/100** ⚠️ **FUTURE**

### Decision: FUTURE → Move to pipeline/evaluation/completed/ with FUTURE note

**Rationale**: Scores 65/100, below approval threshold (70+). Novel capability but NO active use case in our stack. User doesn't trade stocks or manage portfolios.

**Defer to future if**:
1. The statement parser needs historical prices for cost basis calculations
2. Revenue pipeline adds financial market research
3. Personal finance tools emerge in project pipeline
4. We adopt Rube MCP (may already include financial APIs)

**Check Rube MCP first**: Verify if Rube already provides stock/fundamental data access via Composio (500+ apps). If yes, this MCP becomes fully redundant.

**API cost blocker**: financialdatasets.ai pricing unknown. Free alternatives (Alpha Vantage, Yahoo Finance) may be better starting point if use case emerges.
