# Weekly Evolution Analysis

Run once per week. Deeper analysis than the daily heartbeat.

## Tasks

1. **Review the week's discoveries**: Read all reports in `pipeline/discovery/daily/` from the past 7 days. Summarize trends and patterns.

2. **Audit the registry**: Check `registry/existing-capabilities.md` for:
   - Stale entries (capabilities that are no longer used)
   - Missing entries (capabilities that exist but aren't registered)
   - Overlapping entries that could be consolidated

3. **Helper consolidation**: Review `helpers/` for:
   - Duplicate helpers that should be merged
   - Outdated helpers that should be archived
   - Gaps where common patterns aren't captured

4. **Generate weekly report**: Save to `reports/weekly/YYYYMMDD.md` with:
   - Discoveries this week (count, types, sources)
   - Evaluations (approved, rejected, pending)
   - Integrations completed
   - Registry health
   - Helper quality

## Output

```json
{"discoveries_this_week": 12, "integrated": 3, "registry_health": "good", "helpers_consolidated": 2}
```
