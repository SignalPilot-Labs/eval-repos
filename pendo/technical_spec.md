# Technical Spec: pendo001 — Daily Metrics Reports for Guides and Pages

## Build Order
1. stg_pendo__guide_history (staging — pre-built via pendo_source package)
2. stg_pendo__guide_event (staging — pre-built via pendo_source package)
3. stg_pendo__page_history (staging — pre-built via pendo_source package)
4. stg_pendo__page_event (staging — pre-built via pendo_source package)
5. int_pendo__latest_guide (intermediate — depends on stg_pendo__guide_history)
6. int_pendo__latest_guide_step (intermediate)
7. int_pendo__latest_application (intermediate)
8. int_pendo__guide_info (intermediate — depends on int_pendo__latest_guide, int_pendo__latest_guide_step, int_pendo__latest_application, stg_pendo__user)
9. pendo__guide_event (mart — depends on guide_event source, int_pendo__guide_info)
10. int_pendo__guide_alltime_metrics (intermediate — depends on pendo__guide_event)
11. int_pendo__guide_daily_metrics (intermediate — depends on pendo__guide_event)
12. **pendo__guide** (mart — depends on int_pendo__guide_info, int_pendo__guide_alltime_metrics, pendo__guide_event)
13. int_pendo__latest_page (intermediate)
14. int_pendo__page_info (intermediate — depends on int_pendo__latest_page, int_pendo__latest_application, stg_pendo__user, stg_pendo__group, int_pendo__latest_page_rule, int_pendo__latest_feature)
15. pendo__page_event (mart — depends on page_event source, int_pendo__page_info)
16. pendo__page (mart — depends on int_pendo__page_info, pendo__page_event)
17. int_pendo__page_daily_metrics (intermediate — depends on pendo__page_event)
18. **pendo__page_daily_metrics** (mart — depends on int_pendo__calendar_spine, int_pendo__page_daily_metrics, pendo__page)
19. **pendo__guide_daily_metrics** (mart — depends on int_pendo__calendar_spine, int_pendo__guide_info, int_pendo__guide_daily_metrics, pendo__guide_event)

---

## Model: pendo__guide

- **Source**:
  - `ref('int_pendo__guide_info')` — guide entity with all dimension columns, step count, user names, app info
  - `ref('int_pendo__guide_alltime_metrics')` — pre-computed count_visitors, count_accounts, count_events, first_event_at, last_event_at
  - `ref('pendo__guide_event')` — for pivoted event-type visitor counts (type column)

- **Driving table**: `int_pendo__guide_info` (one row per guide; 5 rows in test data)

- **Joins**:
  - `LEFT JOIN int_pendo__guide_alltime_metrics ON guide_info.guide_id = alltime_metrics.guide_id`
  - `LEFT JOIN pivoted_events CTE ON guide_info.guide_id = pivoted_events.guide_id` (pivoted_events aggregates pendo__guide_event by guide_id)

- **Key expressions**:
  - All info columns: `guide_info.*` then override metric columns from alltime_metrics
  - `COALESCE(alltime_metrics.count_visitors, 0) AS count_visitors`
  - `COALESCE(alltime_metrics.count_accounts, 0) AS count_accounts`
  - `COALESCE(alltime_metrics.count_events, 0) AS count_events`
  - `alltime_metrics.first_event_at` (no COALESCE — NULL means no events)
  - `alltime_metrics.last_event_at` (no COALESCE — NULL means no events)
  - Pivoted event counts (COUNT DISTINCT visitor_id per type):
    - `count_visitors_guideSeen` = `COUNT(DISTINCT CASE WHEN type = 'guideSeen' THEN visitor_id END)`
    - `count_visitors_guideDismissed` = `COUNT(DISTINCT CASE WHEN type = 'guideDismissed' THEN visitor_id END)`
    - `count_visitors_guideActivity` = `COUNT(DISTINCT CASE WHEN type = 'guideActivity' THEN visitor_id END)`
    - `count_visitors_guideAdvanced` = `COUNT(DISTINCT CASE WHEN type = 'guideAdvanced' THEN visitor_id END)`
    - `count_visitors_guideTimeout` = `COUNT(DISTINCT CASE WHEN type = 'guideTimeout' THEN visitor_id END)`
    - `count_visitors_guideSnoozed` = `COUNT(DISTINCT CASE WHEN type = 'guideSnoozed' THEN visitor_id END)`
  - All wrapped with `COALESCE(..., 0)`

- **Filters**: none — include all guides regardless of state

- **Expected grain**: one row per guide (guide_id is unique key)

- **Expected rows**: 3 rows (3 distinct guides in int_pendo__guide_info in test dataset — spec originally said 5, verifier measured 3 from actual driving table)

---

## Model: pendo__guide_daily_metrics

- **Source**:
  - `ref('int_pendo__calendar_spine')` — date spine (1,629 rows, date_day)
  - `ref('int_pendo__guide_info')` — guide dimension for created_at (lower spine bound) and guide_name
  - `ref('int_pendo__guide_daily_metrics')` — pre-computed daily aggregates: count_visitors, count_accounts, count_guide_events, count_first_time_visitors, count_first_time_accounts (keyed on occurred_on + guide_id)
  - `ref('pendo__guide_event')` — for event-type pivots per day (type, visitor_id, occurred_at)

- **Driving table**: calendar spine INNER JOIN guide_info (cross-join limited by date bounds)

- **Joins**:
  - `JOIN int_pendo__guide_info ON spine.date_day >= CAST(guide_info.created_at AS DATE) AND spine.date_day <= CURRENT_DATE` → guide_spine CTE
  - `LEFT JOIN int_pendo__guide_daily_metrics ON guide_spine.date_day = daily_metrics.occurred_on AND guide_spine.guide_id = daily_metrics.guide_id`
  - `LEFT JOIN pivoted_daily_events ON guide_spine.date_day = pivoted_daily_events.occurred_on AND guide_spine.guide_id = pivoted_daily_events.guide_id`

- **Key expressions**:
  - `guide_spine.date_day AS date_day`
  - `guide_spine.guide_id`
  - `guide_spine.guide_name`
  - `COALESCE(daily_metrics.count_visitors, 0) AS count_visitors`
  - `COALESCE(daily_metrics.count_accounts, 0) AS count_accounts`
  - `COALESCE(daily_metrics.count_guide_events, 0) AS count_guide_events`
  - `COALESCE(daily_metrics.count_first_time_visitors, 0) AS count_first_time_visitors`
  - `COALESCE(daily_metrics.count_first_time_accounts, 0) AS count_first_time_accounts`
  - Pivoted daily event counts from pendo__guide_event (group by CAST(date_trunc('day', occurred_at) AS DATE), guide_id):
    - `COALESCE(COUNT(DISTINCT CASE WHEN type = 'guideSeen' THEN visitor_id END), 0)`
    - ... repeated for all 6 event types

- **Filters**: `spine.date_day >= CAST(guide_info.created_at AS DATE) AND spine.date_day <= CURRENT_DATE` (domain-product: calendar spine must be capped at current_date; description says "to the current date")

- **Expected grain**: one row per (date_day, guide_id) pair from guide creation through today

- **Expected rows**: varies — (days since each guide's creation) × (number of guides); all spine dates × all guides where date is in range

---

## Model: pendo__page_daily_metrics

- **Source**:
  - `ref('int_pendo__calendar_spine')` — date spine (1,629 rows, date_day)
  - `ref('pendo__page')` — page entity with valid_through, last_pageview_at, created_at — follows sibling pendo__feature_daily_metrics pattern which uses the full mart model, not just int_pendo__page_info
  - `ref('int_pendo__page_daily_metrics')` — pre-computed daily aggregates: all metric columns keyed on occurred_on + page_id

- **Driving table**: calendar spine INNER JOIN pendo__page (cross-join limited by date bounds)

- **Joins**:
  - `JOIN pendo__page ON spine.date_day >= CAST(date_trunc('day', page.created_at) AS DATE) AND spine.date_day <= GREATEST(CAST(page.valid_through AS DATE), CAST(date_trunc('day', page.last_pageview_at) AS DATE))` with COALESCE for NULLs → page_spine CTE
  - `LEFT JOIN int_pendo__page_daily_metrics ON page_spine.date_day = daily_metrics.occurred_on AND page_spine.page_id = daily_metrics.page_id`

- **Key expressions** (all from int_pendo__page_daily_metrics, with COALESCE for numeric zeros):
  - `page_spine.date_day AS date_day`
  - `page_spine.page_id`
  - `page_spine.page_name` (from pendo__page)
  - `page_spine.group_id` (from pendo__page)
  - `page_spine.product_area_name` (from pendo__page)
  - `COALESCE(daily_metrics.sum_pageviews, 0) AS sum_pageviews`
  - `COALESCE(daily_metrics.count_visitors, 0) AS count_visitors`
  - `COALESCE(daily_metrics.count_accounts, 0) AS count_accounts`
  - `COALESCE(daily_metrics.count_first_time_visitors, 0) AS count_first_time_visitors`
  - `COALESCE(daily_metrics.count_first_time_accounts, 0) AS count_first_time_accounts`
  - `COALESCE(daily_metrics.count_return_visitors, 0) AS count_return_visitors`
  - `COALESCE(daily_metrics.count_return_accounts, 0) AS count_return_accounts`
  - `COALESCE(daily_metrics.avg_daily_minutes_per_visitor, 0) AS avg_daily_minutes_per_visitor`
  - `COALESCE(daily_metrics.avg_daily_pageviews_per_visitor, 0) AS avg_daily_pageviews_per_visitor`
  - `COALESCE(daily_metrics.percent_of_daily_pageviews, 0) AS percent_of_daily_pageviews`
  - `COALESCE(daily_metrics.percent_of_daily_page_visitors, 0) AS percent_of_daily_page_visitors`
  - `COALESCE(daily_metrics.percent_of_daily_page_accounts, 0) AS percent_of_daily_page_accounts`
  - `COALESCE(daily_metrics.count_pageview_events, 0) AS count_pageview_events`

- **Filters**: date bounded by page.created_on (lower) and GREATEST(valid_through::date, last_pageview_on) (upper). Description: "from the day that the page was created to either its `valid_through` date or the date of its last tracked event (whichever is later)"

- **Expected grain**: one row per (date_day, page_id) pair from page creation through valid_through/last event

- **Expected rows**: varies — for each page, dates from creation to max(valid_through, last_pageview_on); bounded by calendar spine range

---

## Decisions

- **pendo__guide uses int_pendo__guide_alltime_metrics** for count_visitors/accounts/events/first_event_at/last_event_at — this pre-computed intermediate already aggregates from pendo__guide_event. Recomputing from guide_event would duplicate logic and risk precision drift.
- **pendo__guide pivots guide event types directly from pendo__guide_event** — int_pendo__guide_alltime_metrics does not include event-type-specific pivots, so must aggregate from pendo__guide_event in a separate CTE.
- **pendo__guide: LEFT JOIN int_pendo__guide_alltime_metrics and pivoted_events** — guides with no events still appear in the output (they are valid guides); COALESCE(count, 0) for metrics.
- **pendo__guide: event type column is `type`** (not `event_type`) — confirmed from SELECT * FROM guide_event data showing `type` field with values: guideSeen, guideDismissed, guideActivity (only 3 types in test data, but all 6 YML columns are included using conditional aggregation).
- **pendo__guide_daily_metrics: spine bounded by guide.created_at to CURRENT_DATE** — YML description says "to the current date"; domain-product rule requires calendar spine cap at current_date.
- **pendo__guide_daily_metrics uses int_pendo__guide_daily_metrics** for basic daily aggregates (count_visitors, count_accounts, count_guide_events, count_first_time_visitors, count_first_time_accounts) — intermediate already computes these correctly.
- **pendo__guide_daily_metrics computes event-type pivots separately from pendo__guide_event** — int_pendo__guide_daily_metrics is incomplete (missing those columns); must aggregate from pendo__guide_event with date truncation.
- **pendo__guide_daily_metrics: guide_name comes from int_pendo__guide_info** — this is the stable guide metadata model; pendo__guide_event also has guide_name but it's denormalized from the join.
- **pendo__page_daily_metrics uses pendo__page** (not int_pendo__page_info) as the entity model — follows exact pattern of sibling pendo__feature_daily_metrics.sql which uses `pendo__feature` for the spine. pendo__page provides both valid_through and last_pageview_at needed for the upper bound.
- **pendo__page_daily_metrics upper bound: GREATEST(valid_through::date, last_pageview_at::date)** — YML description explicitly says "to either it's `valid_through` date or the date of its last tracked event (whichever is later)".
- **pendo__page_daily_metrics: all metrics from int_pendo__page_daily_metrics** — this intermediate pre-computes all required metric columns including percentages, averages, and return visitor calculations. No recomputation needed.
- **LEFT JOIN for all daily_metrics joins** — spine drives the population (one row per guide/page per day in range); missing daily data means zero activity, handled via COALESCE.
