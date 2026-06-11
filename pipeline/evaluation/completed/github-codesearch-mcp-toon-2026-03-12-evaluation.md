# Evaluation Report: GitHub Code Search MCP (TOON Token-Efficient Format)

## Basic Information
- **Source**: https://lobehub.com/mcp/hudrazine-github-codesearch-mcp
- **Category**: MCP Server
- **License**: Unknown (repository inaccessible)
- **Last Updated**: Unknown (listed 2026-03-07 on LobeHub)
- **Stars/Validation**: 0 stars (GitHub repo returns 404), 1 install on LobeHub, 0 ratings
- **Version**: 0.1.0 (per LobeHub listing)
- **Author**: hudrazine

---

## Research Findings

### Critical Supply Chain Issues

1. **GitHub repository returns HTTP 404**: `https://github.com/hudrazine/github-codesearch-mcp` is inaccessible. The repository has been deleted, made private, or never existed.

2. **npm package does not exist**: Both `@hudrazine/github-codesearch-mcp` and `hudrazine-github-codesearch-mcp` return 404 from the npm registry. The installation command (`npx -y @hudrazine/github-codesearch-mcp`) will fail.

3. **LobeHub listing is a ghost**: The LobeHub marketplace page exists with metadata (version 0.1.0, identifier, install command) but points to non-existent source code and package. This is either stale metadata from a since-removed package, or the listing was never backed by a real artifact.

4. **No auditable code path**: Without source code, there is no way to verify how the GitHub Personal Access Token is handled, what data is sent where, or what the TOON transformation actually does.

### TOON Format Assessment

TOON (Token-Oriented Object Notation) itself is a real, well-documented format with 23.2k stars (MIT license). However:

- **Claimed savings of 30-60% apply primarily to flat/tabular data** (uniform arrays of objects)
- **Reddit criticism** (r/LocalLLaMA) highlights that TOON performs *worse* than JSON for nested objects, which are common in real-world API responses
- **GitHub code search responses** contain nested structures (repository metadata, file info, match contexts), which are exactly the case where TOON's advantage is smallest or negative
- **TOON benchmarks** (76.4% accuracy vs JSON 75.0% on 209 questions) show marginal accuracy improvement, not the dramatic efficiency gains marketed

### Official GitHub MCP Already Covers This

The **official GitHub MCP server** (27.9k stars, actively maintained by GitHub) already provides:

- `search_code`: Full GitHub code search with query language support (language filters, path filters, org filters, exact matching)
- `search_repositories`: With `minimal_output: true` option for compact responses
- `search_code` currently returns full result objects, but the official server is under active development

**Codex cross-validation note**: Codex identified that `minimal_output` is implemented for `search_repositories` but not yet for `search_code` in the official GitHub MCP. This means there is a *theoretical* gap for compact code search output. However, this gap is better addressed by upstreaming a PR to the official server (27.9k stars, active maintainers) than by adopting a phantom third-party wrapper.

### Existing Alternatives Comparison

| Capability | Exa `get_code_context_exa` | Official GitHub MCP | This MCP (hudrazine) |
|------------|--------------------------|--------------------|--------------------|
| GitHub code search | Indirect (via web) | Native API | Native API (claimed) |
| Token efficiency | AI-native compact | Full JSON response | TOON format (claimed) |
| Semantic search | Yes (neural) | No (keyword/syntax) | No (keyword/syntax) |
| Stars/validation | Commercial SaaS | 27.9k stars | 0 (repo deleted) |
| Installable | Yes | Yes | **No (404)** |
| Source auditable | N/A (SaaS) | Yes | **No (deleted)** |
| Maintenance | Exa team | GitHub team | Unknown author |

---

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 0/100 | 20% | 0.0 | **IMPOSSIBLE** -- npm package does not exist, GitHub repo returns 404. Cannot be installed. |
| Token Efficiency Impact | 30/100 | 25% | 7.5 | TOON format has real but limited savings (30-60% on flat data only); GitHub search responses are nested; marginal improvement over JSON for this use case. Unverifiable without source. |
| Capability Expansion | 20/100 | 25% | 5.0 | Official GitHub MCP already provides `search_code`. Exa provides semantic code search. This fills a narrow gap (compact GitHub search output) that the official server will likely add. |
| Maintenance Burden | 0/100 | 15% | 0.0 | **ABANDONED** -- repo deleted, npm package missing, single unknown author, no community, no way to file issues or get updates. |
| Community Validation | 0/100 | 15% | 0.0 | 0 GitHub stars (repo 404), 1 LobeHub install, 0 ratings. Zero community adoption or validation. |
| **WEIGHTED TOTAL** | | | **12.5/100** | |

---

## Cross-Validation

- **Claude Assessment**: 12.5/100
- **Codex Assessment**: 12/100
- **Variance**: 0.5 points
- **Consensus**: Achieved (strong agreement on rejection)

Both models independently identified the same critical blockers: non-existent source code, non-existent npm package, and strong existing alternatives.

---

## Security Assessment

- [x] **FAIL**: No source code to audit -- GitHub repo returns 404
- [x] **FAIL**: Requires GitHub PAT with no auditable code path for secret handling
- [ ] License unknown (cannot verify -- no accessible repository)
- [x] **FAIL**: Potential typosquatting risk if package name appears later
- [x] **FAIL**: API key handling unverifiable

---

## Kill Signals Triggered

- [x] **No documentation or examples**: GitHub repo returns 404, no README accessible
- [x] **Abandoned**: Repository deleted/inaccessible, npm package non-existent
- [x] **Requires API keys with unclear cost implications**: GitHub PAT required, no code to audit how it's used

**Three kill signals triggered** -- any single one is grounds for automatic rejection.

---

## Existing Alternatives

| Alternative | Status | Coverage |
|-------------|--------|----------|
| **Official GitHub MCP** (github/github-mcp-server) | 27.9k stars, actively maintained | `search_code` with full query language, `search_repositories` with `minimal_output` |
| **Exa `get_code_context_exa`** | Integrated, production | Semantic code search across GitHub, docs, Stack Overflow -- token-efficient by design |
| **Brave `brave_web_search`** | Integrated, production | Can search GitHub via web queries (less precise but functional) |
| **Codex `mcp__codex__codex`** | Integrated, production | Can delegate code search to GPT-5.4 with web search |

---

## Recommendation

**DECISION**: [x] REJECT (<70)

**Rationale**: This MCP cannot be integrated because it does not exist in any installable form. The GitHub repository returns 404, the npm package is not on the registry, and the LobeHub listing is a ghost entry pointing to non-existent artifacts. Even if the source code were available, the value proposition is weak: the official GitHub MCP server (27.9k stars) already provides `search_code`, and Exa provides token-efficient semantic code search. The TOON format's advantages are marginal for nested GitHub API responses. Three automatic kill signals were triggered (no documentation, abandoned, unauditable API key handling).

**If the gap matters**: The correct path to compact GitHub code search output is to upstream a `minimal_output` parameter for `search_code` in the official GitHub MCP server, or create a thin local adapter script. Not adopting a phantom third-party wrapper from an unknown author.

---

## Discovery File Disposition

The pending discovery file at `pipeline/evaluation/pending/github-codesearch-mcp-toon-format-2026-03-12.md` classified this as NOVEL. Post-research, it is more accurately:

- **Classification correction**: Not NOVEL but DUPLICATE with claimed improvement. The official GitHub MCP already provides `search_code`. This MCP claimed to add TOON formatting on top, but cannot be verified.
- **Discovery accuracy note**: The discovery file stated "GitHub MCP (official): Full GitHub API access, not token-optimized" -- this understates the official server's capabilities. The official server has `minimal_output` for repository search and actively developing more compact modes.

---

*Evaluated by: Claude Opus 4.6 (capability-evaluator)*
*Cross-validated by: GPT-5.4 (Codex)*
*Date: 2026-03-13*
