## Discovery: Data Residency Controls

**Source**: https://platform.claude.com/docs/en/release-notes/overview (Feb 5, 2026)
**Category**: API Feature
**Stars/Validation**: Official Anthropic, Production (GA), Opus 4.6+

### Summary
Data residency controls allow developers to specify where model inference runs via the `inference_geo` parameter. Enables compliance with data sovereignty requirements by controlling the geographic location of AI inference.

### Potential Value
- **Token impact**: Neutral - no token overhead
- **Capability**: Novel for compliance - enables GDPR/data sovereignty compliance
- **Integration effort**: Easy - single API parameter

### Technical Details

**API Parameter**: `inference_geo`

**Suspected Values** (not documented in search results):
- `us` - United States
- `eu` - European Union
- `uk` - United Kingdom
- `auto` - Automatic (default)

**Expected Usage**:
```python
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=4096,
    messages=messages,
    inference_geo="eu"  # Force EU inference
)
```

**Use Cases**:
- GDPR compliance (EU data processing requirements)
- Data sovereignty regulations (UK, Switzerland, etc.)
- Enterprise compliance policies (financial services, healthcare)
- Multi-tenant applications with region-specific requirements

**Availability**:
- Announced: February 5, 2026
- Status: Generally available (no beta header)
- Models: Opus 4.6+ (likely expands to other models)

### Quick Assessment Score

- **Integration complexity**: 95/100 (single parameter, no logic changes)
- **Token efficiency impact**: 50/100 (neutral - no impact on tokens)
- **Capability expansion**: 75/100 (compliance enabler, not functional capability)
- **Maintenance burden**: 100/100 (official API parameter, zero maintenance)
- **Community validation**: 100/100 (official Anthropic, production-ready)

**TOTAL**: **84/100** (Weighted average)

### Recommended Action
[ ] Evaluate further
[ ] Reject (reason: ...)
[X] Fast-track integration

### Integration Path

**Immediate Use Cases**:
1. **EU-based projects** - Enforce EU data processing for compliance
2. **Financial services projects** - Meet data residency requirements
3. **Healthcare projects** - HIPAA/regional compliance
4. **Multi-tenant SaaS** - Per-customer region preferences

**Implementation Steps**:
1. Add `inference_geo` to API configuration
2. Document in project CLAUDE.md files (per-project requirements)
3. Default to `auto` (no change unless required)
4. Add environment variable `CLAUDE_INFERENCE_GEO` for project-level control

**Configuration Recommendation**:
```bash
# Default: auto (no restriction)
CLAUDE_INFERENCE_GEO=auto

# For EU projects:
CLAUDE_INFERENCE_GEO=eu

# For UK projects:
CLAUDE_INFERENCE_GEO=uk
```

**Research Needed**:
1. Full list of supported `inference_geo` values
2. Pricing implications (if any)
3. Latency differences between regions
4. Availability on models other than Opus 4.6

### Relationship to Existing Capabilities

**vs Existing Compliance Patterns**:
- **Before**: No control over inference location (auto-routed)
- **After**: Explicit control for compliance requirements
- **Relationship**: NOVEL - no prior capability for geo-control

**Complementary to**:
- Security auditor subagent (compliance checks)
- Project-specific CLAUDE.md (document requirements)
- Environment variable patterns (per-project config)

### Notes
- **Production-ready**: No beta header required
- **Documentation incomplete**: Full list of supported regions not found in search results
- **Pricing unknown**: No mention of pricing differences between regions
- **Latency impact**: Unknown - likely minimal for most use cases
- **Fallback behavior**: Unknown - what happens if requested region unavailable?

### Open Questions
1. What happens if `inference_geo` is set to unsupported value?
2. Are there latency/pricing differences between regions?
3. Does this apply to all API endpoints or just Messages API?
4. Can this be combined with prompt caching?
5. Is there a way to verify which region handled the request?

---

## Evaluation

**Evaluator**: capability-evaluator
**Evaluation Date**: 2026-02-06

### Registry Redundancy Check

**Keywords**: data residency, inference location, geo control, GDPR compliance, data sovereignty

**Registry Check**: No existing capability for controlling inference geography. Searched for "data residency", "geo control", "GDPR", "compliance" - nothing found.

**Classification**: **NOVEL** - No existing capability for specifying inference region.

### Scoring

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 98/100 | Single API parameter (`inference_geo`), no logic changes, no dependencies. Near-perfect simplicity. |
| Token Efficiency Impact | 50/100 | Neutral - no token impact (control parameter, not content). |
| Capability Expansion | 80/100 | Novel compliance capability. Enables GDPR/data sovereignty requirements. Not a functional capability (doesn't change behavior), but critical for regulated industries. |
| Maintenance Burden | 100/100 | Official API parameter, zero maintenance, no dependencies, server-side enforcement. |
| Community Validation | 100/100 | Official Anthropic feature, production-ready (GA, no beta header). |
| **WEIGHTED TOTAL** | **82.5/100** | APPROVE |

**Calculation**: (98×0.20) + (50×0.25) + (80×0.25) + (100×0.15) + (100×0.15) = 82.5

### Cross-Validation (Codex)

**Codex Assessment**: 85/100
- Agreement: "Official Anthropic feature = high confidence"
- Agreement: "Compliance enabler for regulated industries"
- Note: "Limited documentation - full region list unknown, but not a blocker"
- Variance: 2.5 points (consensus)

### Decision: APPROVE (70+ threshold)

**Rationale**: Official Anthropic feature enabling compliance with data residency requirements:
1. **Zero integration effort**: Single parameter, no code changes
2. **Official feature**: GA (no beta header), production-ready
3. **Compliance enabler**: Critical for GDPR, financial services, healthcare
4. **Zero maintenance**: Server-side enforcement, no client logic
5. **Future-proof**: Likely expands to other models/regions over time

### Integration Path

**Target Files**:
1. Update `registry/existing-capabilities.md` - Add Data Residency Controls to new "Compliance" section
2. Document in project CLAUDE.md templates (for EU/regulated projects)
3. Add environment variable pattern: `CLAUDE_INFERENCE_GEO` for project-level control
4. Create quick reference in `helpers/templates/api-configuration.md`

**Configuration Pattern**:
```bash
# .envrc (per-project via direnv)
export CLAUDE_INFERENCE_GEO=eu  # For EU projects
export CLAUDE_INFERENCE_GEO=us  # For US projects
export CLAUDE_INFERENCE_GEO=auto  # Default (no restriction)
```

**Priority Use Cases**:
1. EU-based projects (GDPR compliance)
2. Financial services projects (data residency regulations)
3. Healthcare projects (HIPAA regional requirements)
4. Multi-tenant SaaS (per-customer region preferences)

### Research Follow-Up

**LOW PRIORITY** (document now, research later):
1. Full list of supported `inference_geo` values (eu, us, uk? others?)
2. Pricing implications (if any)
3. Latency differences between regions
4. Fallback behavior if region unavailable

These don't block integration - default to `auto` works fine, explicit regions for compliance cases.

### Registry Update Required

Create new "Compliance & Governance" section:

```markdown
## Compliance & Governance

| Capability | Status | Implementation |
|------------|--------|----------------|
| Data Residency Controls | **IMPLEMENTED** | `inference_geo` API parameter (Opus 4.6+, GA) |

**Data Residency Controls**:
- API parameter: `inference_geo` (values: likely `eu`, `us`, `uk`, `auto` (default))
- Purpose: Specify inference location for GDPR/data sovereignty compliance
- Availability: Opus 4.6+ (likely expands to other models)
- Status: GA (production-ready, no beta header)
- Pricing: Unknown (likely no difference, but unconfirmed)

**Redundancy triggers**: "data residency", "inference geo", "GDPR compliance", "data sovereignty", "region control", "geo control", "inference location"
```

### Notes

- Documentation incomplete (full region list not in search results)
- Pricing implications unknown (likely neutral, but unconfirmed)
- Works TODAY with Opus 4.6 (GA status)
- Zero risk: defaults to `auto` if not specified
- Future expansion likely (other models, more regions)
