# Evaluate Pending Discoveries

Process all items in `pipeline/evaluation/pending/`. For each item:

## Evaluation Criteria

Score each criterion from 0-100:

| Criterion | Weight | Scoring Guide |
|-----------|--------|---------------|
| Integration complexity | 20% | Easy (drop-in)=100, Moderate (config needed)=70, Hard (code changes)=50, Impossible=0 |
| Token efficiency impact | 25% | Major savings=100, Minor savings=70, Neutral=50, Costs more=0 |
| Capability expansion | 25% | Genuinely novel=100, Incremental improvement=70, Marginal=40, None=0 |
| Maintenance burden | 15% | Zero maintenance=100, Low (monthly check)=70, Medium (weekly)=50, High (constant)=30 |
| Community validation | 15% | Official (Anthropic)=100, 1k+ stars=90, 100-1k stars=70, <100 stars=50, No community=30 |

## Scoring Formula

```
total = (complexity * 0.20) + (token_efficiency * 0.25) + (capability * 0.25) + (maintenance * 0.15) + (community * 0.15)
```

## Decision Thresholds

| Score | Decision | Action |
|-------|----------|--------|
| 70+ | **APPROVED** | Move to `pipeline/integration/` |
| 50-69 | **NEEDS_RESEARCH** | Flag for manual review, keep in pending |
| <50 | **REJECTED** | Move to `pipeline/evaluation/completed/` with reason |

## Output

Move each evaluated item to `pipeline/evaluation/completed/` with added fields:

```json
{
  "...original fields...",
  "evaluation": {
    "scores": {
      "integration_complexity": 80,
      "token_efficiency": 70,
      "capability_expansion": 90,
      "maintenance_burden": 85,
      "community_validation": 60
    },
    "total": 77.5,
    "decision": "APPROVED",
    "reasoning": "Brief explanation of the scoring"
  }
}
```

Output a JSON summary as the final line:
```json
{"evaluated": 3, "approved": 1, "rejected": 1, "needs_research": 1, "items": [{"title": "...", "score": 77.5, "decision": "APPROVED"}]}
```
