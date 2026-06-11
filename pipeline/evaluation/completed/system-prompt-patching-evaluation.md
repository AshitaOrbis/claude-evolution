# Evaluation: System Prompt Patching

- **Date**: 2026-02-06
- **Category**: Technique
- **Source**: https://agenticcoding.substack.com/p/32-claude-code-tips-from-basics-to (Tip 14)
- **License**: N/A (technique)

## Redundancy Check

**Classification**: IMPROVEMENT (but conflicts with existing official approach)

Registry has Tool Search Tool (85% token reduction, official, automatic). System prompt patching targets a different layer (base prompt vs tool schemas) but requires disabling auto-updater.

## Kill Signal Triggered

**AUTOMATIC REJECTION: Requires disabling auto-updater = security risk**

Setting `DISABLE_AUTOUPDATER=1` means:
- No security patches applied automatically
- No bug fixes received
- No feature updates
- User manually responsible for all updates
- Contradicts our security-first approach

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 30/100 | Requires patching internal Claude Code files + disabling updater. Fragile, version-specific |
| Token Efficiency Impact | 60/100 | 44% base prompt reduction is real, but Tool Search Tool already handles 85% of tool tokens officially |
| Capability Expansion | 20/100 | No new capability -- just token reduction that overlaps with existing official solution |
| Maintenance Burden | 0/100 | Constant -- must re-patch after every manual update. Version-specific patches break on new releases |
| Community Validation | 20/100 | Single blog post tip. No repo, no stars, no community adoption |

**WEIGHTED TOTAL**: (30 * 0.20) + (60 * 0.25) + (20 * 0.25) + (0 * 0.15) + (20 * 0.15) = 6.0 + 15.0 + 5.0 + 0.0 + 3.0 = **29.0/100**

## Cross-Validation

- **Claude Assessment**: 29.0/100
- **Codex Assessment**: N/A (MCP unavailable)
- **Variance**: N/A

## Analysis

This technique achieves a measurable 44% base prompt reduction, which is a real optimization. However, the cost-benefit analysis is decisively negative:

1. **Security risk**: Disabling auto-updater leaves the system vulnerable to unpatched issues
2. **Maintenance nightmare**: Every Claude Code update requires manual re-patching
3. **Official alternative superior**: Tool Search Tool provides 85% reduction for tool tokens with zero risk
4. **Unsupported modification**: Editing internal prompts voids any reasonable expectation of support
5. **Diminishing returns**: The 8k token savings (~4% of 200k context) is marginal given the risk

The discovery document itself recommends rejection, which is correct.

## Recommendation

**DECISION**: REJECT (29.0 < 50)

**Rationale**: Kill signal triggered -- requires disabling auto-updater (security risk). Even without that, the maintenance burden is constant (0/100), and Tool Search Tool already provides official, zero-risk token optimization. The 44% base prompt reduction is real but not worth the trade-offs.

**Alternative**: If base prompt overhead becomes a critical issue, advocate for Anthropic to add a "minimal prompt mode" officially.
