# Evaluation Report: SkillNet (zjunlp)

## Basic Information
- **Source**: https://github.com/zjunlp/SkillNet
- **Category**: Framework / Skill Registry
- **License**: MIT
- **Last Updated**: 2026-03-13 (active development)
- **Stars/Validation**: 327 stars, 19 forks
- **Paper**: arXiv 2603.04448 (26 authors, Zhejiang University + Alibaba + Tencent + others)
- **PyPI**: `skillnet-ai` v0.0.13 (released 2026-03-08)
- **Prior Evaluation**: 2026-03-12 scored 60.25/100 (NEEDS_RESEARCH), research flag active

## Context: Prior Evaluation + Research Resolution

This evaluation supersedes `discord-inbox-20260309-skillnet-zjunlp-evaluation.md` (60.25/100, NEEDS_RESEARCH). The research flag at `pipeline/evaluation/pending/discord-inbox-20260309-skillnet-zjunlp-research-flag.txt` posed 5 specific research questions. All 5 have now been answered:

| Research Question | Answer |
|-------------------|--------|
| 1. How many stars does SkillNet have? | **327 stars** (up from "unknown") |
| 2. Is CycleChain/skillnet-mcp stable? | **No.** 1 star, 1 fork. Immature: regex-parses CLI output, no build pipeline, minimal tests |
| 3. What does the corpus contain? | **General LLM skills**, not Claude-specific. OpenClaw, clawdbot, anthropics repos. 200K+ skills |
| 4. Does `get_skill_rules` provide token-safe path? | **Partially.** Extracts core rules only, but depends on the unstable MCP wrapper |
| 5. What integration architecture does the paper describe? | Skill ontology + graph + 5D evaluation. Academic infrastructure, not a drop-in Claude Code tool |

---

## Live API Testing (2026-03-13)

**Endpoint**: `http://api-skillnet.openkg.cn/v1/search`

| Test | Result | Notes |
|------|--------|-------|
| HTTPS (port 443) | **FAILED** (ECONNREFUSED) | No TLS support |
| HTTP keyword search (`q=pdf`) | **SUCCESS** | 2,464 results, full 5D evaluation scores, structured JSON |
| HTTP keyword search (`q=claude code`) | **SUCCESS** | Returns OpenClaw/clawdbot skills, not Claude Code skills per se |
| HTTP vector search (`q=evaluation scoring`) | **FAILED** (statement timeout) | Database timeout on semantic search |
| Web interface (skillnet.openkg.cn) | **FAILED** (ECONNREFUSED) | Website not accessible |

**Corpus quality observations**:
- "Stars" field is repo-level (e.g., 230,194 for clawdbot), not skill-level adoption. Misleading ranking.
- Search precision is poor: keyword search for "react" returns Slack skills first because they mention "reacting to messages."
- 5D evaluation scores are pre-computed and detailed (safety, completeness, executability, cost-awareness, maintainability) -- this is genuinely useful structured metadata.
- Script execution results are included where available (py_compile status, exit codes).

---

## Capability Overlap Analysis

### What SkillNet offers that we DON'T have:
1. **Pre-evaluated skill corpus** (200K+ skills with 5D quality scores) -- no equivalent
2. **Skill relationship graph** (`compose_with`, `depend_on`, `similar_to` edges) -- no equivalent
3. **Create-from-trajectory** (`skillnet create --trajectory`) -- we have manual skill creation only
4. **Automated skill evaluation** against 5 dimensions -- our evaluation is manual and uses different criteria

### What SkillNet overlaps with:
1. **Skill search**: capability-discoverer + Exa + Brave already search GitHub, newsletters, communities
2. **Skill evaluation**: our 5-criterion weighted framework (IC/TE/CE/MB/CV) is purpose-built for Claude Code
3. **Redundancy checking**: registry/existing-capabilities.md serves this function for our ecosystem
4. **Skill download/install**: manual workflow already works; skills are just markdown files

### Critical gap: Corpus relevance
The SkillNet corpus is general-purpose LLM agent skills. The top results for "claude code" are OpenClaw routing skills and coding-agent wrappers -- useful for exploring what the broader ecosystem looks like, but NOT directly usable as Claude Code skills without adaptation. This is a **discovery enrichment source**, not a drop-in capability provider.

---

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 45/100 | 20% | 9.0 | Two integration paths, both problematic. (A) MCP wrapper: 1-star repo, regex-parses CLI output, requires Python+Node+pip, no HTTPS. (B) Direct API: HTTP-only, vector search unreliable, no SDK for JS/TS. A minimal curl-based search integration is feasible but requires custom work. |
| Token Efficiency Impact | 40/100 | 25% | 10.0 | `import_best_skill` dumps full skill documentation into context (token-expensive). `get_skill_rules` extracts rules only (token-safe) but depends on unstable MCP wrapper. Direct API calls return JSON that needs parsing. The 5D evaluation metadata is compact and useful, but the skill content itself is verbose. Net: slightly negative for autonomous use, neutral for manual discovery enrichment. |
| Capability Expansion | 60/100 | 25% | 15.0 | The pre-evaluated corpus (200K+ skills with structured quality scores) and relationship graph are genuinely novel. Create-from-trajectory is interesting but requires OpenAI API key. However, practical utility is limited: corpus is general LLM, not Claude Code-specific. Skills found still need manual evaluation against our IC/TE/CE/MB/CV framework. This is incremental enrichment to discovery, not a new capability class. |
| Maintenance Burden | 45/100 | 15% | 6.75 | Main repo is academically maintained (active, 26 authors). But: (1) API has no SLA (academic infrastructure), (2) vector search already times out, (3) HTTP-only is a security concern, (4) MCP wrapper is unmaintained community contrib, (5) v0.0.13 SDK suggests rapid churn. Would need monitoring for API availability and wrapper breakage. |
| Community Validation | 55/100 | 15% | 8.25 | 327 stars is decent for academic tooling (3 weeks old). Paper has strong institutional backing. But MCP wrapper has 1 star. PyPI package is v0.0.13. No evidence of production adoption by Claude Code users specifically. Academic projects have historically poor long-term maintenance track records for developer tools. |

**WEIGHTED TOTAL: 49.0/100**

---

## Cross-Validation

- **Claude Assessment**: 49.0/100
- **Codex Assessment**: 43/100
- **Variance**: 6.0 points
- **Consensus**: Achieved (both below 50, both recommend REJECT for full integration)

**Codex key insights that influenced scoring:**
- Search ranking quality is poor (repo-level "stars" dominate, not skill-level adoption)
- HTTP-only API is a transport security concern for always-on discovery
- `import_best_skill` can import wrong skills on common topics (precision problem)
- Better alternative: use `anthropics/skills` directly for Claude-specific content
- Recommended hedge: narrow pilot with search/download only, no MCP wrapper

**Score movement from prior evaluation:**
- Prior: 60.25/100 (NEEDS_RESEARCH) -- this was inflated by Codex's 66/100 when key facts were unknown
- Current: 49.0/100 (REJECT) -- research answered all 5 questions, most answers were unfavorable

---

## Security Assessment

- [x] No sensitive permissions required (search/download are free, no auth)
- [ ] No excessive data access -- **CONCERN**: `import_best_skill` dumps full external content into agent context without validation
- [x] License compatible (MIT)
- [ ] No known vulnerabilities -- **CONCERN**: HTTP-only API (no TLS), skill content is not sanitized before injection
- [ ] API keys manageable -- **CONCERN**: `create_skill`/`evaluate_skill` require OpenAI-compatible API key (unclear cost, per-call LLM inference)

**Key security risk**: Autonomous skill import from an unvetted 200K corpus into Claude's context is a prompt injection surface. Any skill in the corpus could contain adversarial instructions. This would require a content validation layer before use.

---

## Existing Alternatives

| Need | Current Solution | SkillNet Adds |
|------|-----------------|---------------|
| Skill discovery | capability-discoverer + Exa + Brave | Searchable corpus (but general LLM, not Claude-specific) |
| Skill evaluation | 5-criterion weighted framework | Pre-computed 5D scores (different criteria, different purpose) |
| Skill creation | Manual SKILL.md writing | create-from-trajectory (requires OpenAI key) |
| Redundancy check | registry/existing-capabilities.md | Relationship graph (but for their corpus, not ours) |
| Code search | Exa `get_code_context_exa` | Skill-structured results (but lower precision) |

**Better alternatives identified by Codex:**
1. `anthropics/skills` (GitHub) -- higher signal for Claude-specific skills, direct source
2. Curated internal skill catalog from approved sources -- same speed, far less noise
3. Continue current stack (capability-discoverer + Exa/Brave + manual eval) -- slower but higher precision

---

## Recommendation

**DECISION**: [x] REJECT (<70)

**Final Score**: 49.0/100

**Rationale**: SkillNet is an impressive academic project with genuine novelty (200K pre-evaluated skill corpus, relationship graph, create-from-trajectory). However, the practical integration story is weak for Claude Code specifically: the MCP wrapper has 1 star and is immature, the API is HTTP-only with unreliable vector search, the skill corpus is general-purpose LLM content that still requires manual evaluation against our framework, and search ranking precision is poor. The security implications of autonomous skill import from an unvetted corpus are non-trivial. The delta over existing capability-discoverer + Exa + manual evaluation does not justify the maintenance burden and security risk.

**What would change this decision:**
1. SkillNet ships HTTPS API with reliable vector search (addresses security + reliability)
2. MCP wrapper reaches 50+ stars with stable release (addresses adoption + maturity)
3. Corpus adds Claude Code-specific skill category with curated, high-quality content (addresses relevance)
4. Integration story simplifies to single `npm install` or native Claude Code plugin (addresses complexity)

**Reconsideration trigger**: If any 2 of the above conditions are met, re-evaluate. Check at 2026-06-01 (90-day window given academic development pace).

---

## Research Flag Resolution

The research flag at `pipeline/evaluation/pending/discord-inbox-20260309-skillnet-zjunlp-research-flag.txt` is now resolved. All 5 research questions answered. Score moved from 60.25 (NEEDS_RESEARCH) to 49.0 (REJECT) based on unfavorable findings on API reliability, MCP wrapper maturity, and corpus relevance.
