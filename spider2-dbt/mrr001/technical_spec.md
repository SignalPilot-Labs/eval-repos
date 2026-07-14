# Technical Spec — mrr001

## Build Order
1. util_months (utils — no dependencies, already built)
2. customer_revenue_by_month (core — depends on util_months + source subscription_periods, already built)
3. customer_churn_month (core — depends on customer_revenue_by_month, already built)
4. **mrr** (mart — depends on customer_revenue_by_month + customer_churn_month, STUB TO COMPLETE)

---

## Model: mrr

- **Source**: `ref('customer_revenue_by_month')` UNION ALL `ref('customer_churn_month')`
  — these two already compute all base fields (date_month, customer_id, mrr,
  is_active, first_active_month, last_active_month, is_first_month, is_last_month).
  Do NOT recompute from raw source.

- **Driving table**: The stub already UNIONs both upstreams in `unioned` CTE.
  customer_revenue_by_month (358 rows) + customer_churn_month (52 rows) = 410 total rows.

- **Joins**: None — all data comes from the UNION ALL. The `lagged_values` CTE uses
  window functions (LAG) over the unioned result, partitioned by customer_id ordered
  by date_month.

- **Key expressions**:
  - `previous_month_is_active` = `COALESCE(LAG(is_active) OVER (PARTITION BY customer_id ORDER BY date_month), false)` [already in stub]
  - `previous_month_mrr` = `COALESCE(LAG(mrr) OVER (PARTITION BY customer_id ORDER BY date_month), 0)` [already in stub]
  - `mrr_change` = `mrr - previous_month_mrr` (FLOAT)
  - `change_category`:
    - `'new'`         when is_active=True AND NOT previous_month_is_active AND is_first_month=True
    - `'reactivation'` when is_active=True AND NOT previous_month_is_active AND is_first_month=False
    - `'upgrade'`     when is_active=True AND previous_month_is_active AND mrr > previous_month_mrr
    - `'downgrade'`   when is_active=True AND previous_month_is_active AND mrr < previous_month_mrr
    - `'churn'`       when NOT is_active AND previous_month_is_active
    - NULL            otherwise (no change, or inactive->inactive)
  Reference sample confirms: customer 35, Oct 2019: new; Nov 2019: downgrade; Dec 2019: churn.

- **Filters**: none — all 410 rows must appear (active + churn months)

- **Expected grain**: one row per (customer_id, date_month)

- **Expected rows**: 410 (358 from customer_revenue_by_month + 52 from customer_churn_month,
  confirmed in reference_snapshot.md)

---

## Decisions

- UNION ALL customer_revenue_by_month + customer_churn_month: already in stub; preserves
  both active months and the churn row after last active month
- LAG window for previous_month_is_active / previous_month_mrr: already in stub with COALESCE
  to handle first-month boundary (false / 0)
- mrr_change = mrr - previous_month_mrr: simple subtraction, cast results in FLOAT naturally
  since mrr is FLOAT in the union (churn rows have 0.0::float)
- change_category uses is_first_month to distinguish 'new' vs 'reactivation' (both are
  active with inactive previous month, but 'new' is strictly first ever month)
- No filters: domain-financial driving table rule does not apply here — this is a union-based
  spine model, not a dimension-joined aggregation
- Materialized as table (required by CLAUDE.md)
