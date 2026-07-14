# Technical Spec — airbnb001

## Build Order
1. `dim_listings_hosts` (mart — depends on dim_listings, dim_hosts; both already built)
2. `daily_agg_reviews` (mart — depends on fct_reviews; already built)
3. `mom_agg_reviews` (mart — depends on fct_reviews; already built)

---

## Model: daily_agg_reviews

- **Source**: `ref('fct_reviews')` — per agg.yml refs; fct_reviews is the canonical review fact; do NOT re-read src_reviews
- **Driving table**: fct_reviews (409,697 rows)
- **Joins**: None — single-source aggregation
- **Key expressions**:
  - `REVIEW_DATE::DATE AS REVIEW_DATE` — cast TIMESTAMP to DATE for daily grain
  - `COUNT(*) AS REVIEW_TOTALS` — grain check: COUNT(*) = COUNT(DISTINCT <composite>) on daily level
  - `REVIEW_SENTIMENT` — pass through as-is
  - `dbt_utils.surrogate_key(['REVIEW_DATE', 'REVIEW_SENTIMENT']) AS DATE_SENTIMENT_ID` — confirmed formula: md5(cast(col1 as varchar) || '-' || col2), matching sibling wow_agg_reviews pattern
- **Filters**: None — no YML restriction, no status column on reviews
- **Expected grain**: one row per (REVIEW_DATE::DATE, REVIEW_SENTIMENT) combination
- **Expected rows**: 10,005 (verified: SELECT COUNT(DISTINCT REVIEW_DATE::DATE || '~' || REVIEW_SENTIMENT) FROM fct_reviews = 10,005)

---

## Model: dim_listings_hosts

- **Source**: `ref('dim_listings')` + `ref('dim_hosts')` — per dim.yml refs; dim_listings has cleaned MINIMUM_NIGHTS, dim_hosts has coalesced HOST_NAME
- **Driving table**: dim_listings (17,499 rows)
- **Joins**: `LEFT JOIN ref('dim_hosts') AS hosts_cte ON listings_cte.HOST_ID = hosts_cte.HOST_ID`
- **Key expressions**:
  - `listings_cte.CREATED_AT AS CREATED_AT` — listing creation date
  - `GREATEST(listings_cte.UPDATED_AT, hosts_cte.UPDATED_AT) AS UPDATED_AT` — per YML description: "takes the greater value of listings_cte.UPDATED_AT and hosts_cte.UPDATED_AT"
  - `listings_cte.LISTING_ID AS LISTING_ID`
  - `listings_cte.LISTING_NAME AS LISTING_NAME`
  - `listings_cte.ROOM_TYPE AS ROOM_TYPE`
  - `listings_cte.MINIMUM_NIGHTS AS minimum_nights` — lowercase alias required by YML contract
  - `listings_cte.PRICE AS PRICE`
  - `listings_cte.HOST_ID AS HOST_ID`
  - `hosts_cte.HOST_NAME AS HOST_NAME` — from dim_hosts (already coalesced to 'anonymous')
  - `hosts_cte.IS_SUPERHOST AS IS_SUPERHOST`
  - `dbt_utils.surrogate_key(['LISTING_ID', 'HOST_ID']) AS LISTING_HOST_ID` — surrogate key per YML description
- **Filters**: None
- **Expected grain**: one row per LISTING_ID
- **Expected rows**: 17,499 (dim_listings has 17,499 rows; each listing has exactly one HOST_ID matching dim_hosts)

---

## Model: mom_agg_reviews

- **Source**: `ref('fct_reviews')` — per agg.yml refs; dim_dates not needed for table-materialized single-date output
- **Driving table**: fct_reviews (409,697 rows) filtered via max_date CTE
- **Joins**: None — self-contained aggregation against max_date
- **Key expressions**:
  - `AGGREGATION_DATE` = `MAX(REVIEW_DATE::DATE)` from fct_reviews = 2021-10-22
  - `COUNT(*) AS REVIEW_TOTALS` — reviews where REVIEW_DATE::DATE BETWEEN max_date - INTERVAL '29' DAY AND max_date (30-day window: last 29 + current)
  - `REVIEW_SENTIMENT` — group dimension
  - `CAST(NULL AS DOUBLE) AS MOM` — no prior aggregated state (table-materialized, first build; sibling wow_agg_reviews uses LAG but that requires incremental history)
  - `dbt_utils.surrogate_key(['AGGREGATION_DATE', 'REVIEW_SENTIMENT']) AS DATE_SENTIMENT_ID` — same formula as wow_agg_reviews sibling
- **Filters**: Output only latest AGGREGATION_DATE (temporal scope: "rolling window" + "month-over-month" → one output date)
- **Expected grain**: one row per (AGGREGATION_DATE, REVIEW_SENTIMENT) at latest date only
- **Expected rows**: 3 (1 date × 3 sentiments: positive, negative, neutral)

---

## Decisions
- `daily_agg_reviews` sources from `ref('fct_reviews')` not `src_reviews` — agg.yml explicitly refs fct_reviews; fct_reviews filters REVIEW_TEXT IS NOT NULL (409,697 vs 410,284 src_reviews rows)
- `daily_agg_reviews` REVIEW_DATE cast to DATE — REVIEW_DATE in fct_reviews is TIMESTAMP; daily grain requires DATE cast
- `daily_agg_reviews` surrogate_key order: ['REVIEW_DATE', 'REVIEW_SENTIMENT'] — matches wow_agg_reviews sibling order (['AGGREGATION_DATE','REVIEW_SENTIMENT']); no pre-built value to compare against
- `dim_listings_hosts` uses LEFT JOIN dim_hosts — dim_listings drives (17,499 rows); LEFT JOIN preserves all listings even if host data missing
- `dim_listings_hosts` UPDATED_AT = GREATEST(...) — YML description explicitly states "takes the greater value of listings_cte.UPDATED_AT and hosts_cte.UPDATED_AT"
- `dim_listings_hosts` minimum_nights alias is lowercase — YML column contract specifies lowercase `minimum_nights`; all others are UPPERCASE
- `mom_agg_reviews` outputs ONE row per sentiment (3 rows total) — temporal scope rule: "rolling window" + "MoM" description → latest date only
- `mom_agg_reviews` MOM = CAST(NULL AS DOUBLE) — table-materialized new model with no incremental history; dbt-workflow incremental rule applies
- `mom_agg_reviews` 30-day window = BETWEEN max_date - INTERVAL '29' DAY AND max_date — 30 days inclusive (29 prior + current day)
