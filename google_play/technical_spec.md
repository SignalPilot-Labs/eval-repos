# Technical Spec — google_play002

## Build Order
1. `stats_installs_overview` (staging — reads raw table `stats_installs_overview`)
2. `stats_crashes_overview` (staging — reads raw table `stats_crashes_overview`)
3. `stats_ratings_overview` (staging — reads raw table `stats_ratings_overview`)
4. `stats_store_performance_country` (staging — reads raw table `stats_store_performance_country`)
5. `int_google_play__store_performance` (intermediate — depends on `stats_store_performance_country`)
6. `google_play__overview_report` (mart — depends on `stats_installs_overview`, `stats_crashes_overview`, `stats_ratings_overview`, `int_google_play__store_performance`)

---

## Model: stats_installs_overview
- Source: raw table `stats_installs_overview` (10 rows)
- Driving table: `stats_installs_overview` (10 rows)
- Joins: none
- Key expressions:
  - `source_relation = cast('' as varchar)` — single Fivetran connector, no union schema
  - `date_day = cast(date as date)`
  - `active_devices_last_30_days = cast(active_device_installs as bigint)`
  - `device_installs = cast(daily_device_installs as bigint)`
  - `device_uninstalls = cast(daily_device_uninstalls as bigint)`
  - `device_upgrades = cast(daily_device_upgrades as bigint)`
  - `user_installs = cast(daily_user_installs as bigint)`
  - `user_uninstalls = cast(daily_user_uninstalls as bigint)`
  - `install_events = cast(install_events as bigint)`
  - `uninstall_events = cast(uninstall_events as bigint)`
  - `update_events = cast(update_events as bigint)`
  - `rolling_total_device_installs = SUM(device_installs) OVER (PARTITION BY source_relation, package_name ORDER BY date_day ROWS UNBOUNDED PRECEDING)`
  - `rolling_total_device_uninstalls = SUM(device_uninstalls) OVER (PARTITION BY source_relation, package_name ORDER BY date_day ROWS UNBOUNDED PRECEDING)`
- Filters: none
- Expected grain: one row per (package_name, date)
- Expected rows: 10 (raw table has 10 rows, 10 unique pkg+date combos)

---

## Model: stats_crashes_overview
- Source: raw table `stats_crashes_overview` (10 rows)
- Driving table: `stats_crashes_overview` (10 rows)
- Joins: none
- Key expressions:
  - `source_relation = cast('' as varchar)`
  - `date_day = cast(date as date)`
  - `crashes = cast(daily_crashes as bigint)`
  - `anrs = cast(daily_anrs as bigint)`
- Filters: none
- Expected grain: one row per (package_name, date)
- Expected rows: 10

---

## Model: stats_ratings_overview
- Source: raw table `stats_ratings_overview` (10 rows)
- Driving table: `stats_ratings_overview` (10 rows)
- Joins: none
- Key expressions:
  - `source_relation = cast('' as varchar)`
  - `date_day = cast(date as date)`
  - `average_rating = cast(nullif(cast(daily_average_rating as varchar), 'NA') as double)` — daily_average_rating is stored as VARCHAR in raw table; 'NA' values → NULL
  - `rolling_total_average_rating = total_average_rating` — already a DOUBLE column
- Filters: none
- Expected grain: one row per (package_name, date)
- Expected rows: 10

---

## Model: stats_store_performance_country
- Source: raw table `stats_store_performance_country` (10 rows)
- Driving table: `stats_store_performance_country` (10 rows)
- Joins: none
- Key expressions:
  - `source_relation = cast('' as varchar)`
  - `date_day = cast(date as date)`
  - `country_region = cast(country_region as varchar)`
  - `store_listing_acquisitions = SUM(cast(store_listing_acquisitions as bigint))` grouped
  - `store_listing_visitors = SUM(cast(store_listing_visitors as bigint))` grouped
  - `store_listing_conversion_rate = AVG(store_listing_conversion_rate)` grouped
- Filters: none
- Expected grain: one row per (source_relation, date_day, country_region, package_name)
- Expected rows: 10 (10 unique grain combos already)

---

## Model: int_google_play__store_performance
- Source: `ref('stats_store_performance_country')` (10 rows, has country_region dimension)
- Driving table: `stats_store_performance_country` (10 rows)
- Joins: none (aggregating the country-level data to package/date level)
- Key expressions:
  - GROUP BY (source_relation, date_day, package_name)
  - `store_listing_acquisitions = SUM(store_listing_acquisitions)`
  - `store_listing_visitors = SUM(store_listing_visitors)`
  - `store_listing_conversion_rate = CAST(SUM(store_listing_acquisitions) AS DOUBLE) / NULLIF(SUM(store_listing_visitors), 0)` — recompute from sums after aggregating across countries
  - `total_store_acquisitions = SUM(store_listing_acquisitions) OVER (PARTITION BY source_relation, package_name ORDER BY date_day ROWS UNBOUNDED PRECEDING)`
  - `total_store_visitors = SUM(store_listing_visitors) OVER (PARTITION BY source_relation, package_name ORDER BY date_day ROWS UNBOUNDED PRECEDING)` 
- Filters: none
- Expected grain: one row per (source_relation, package_name, date_day)
- Expected rows: ≤10 (data has 1 package — member.android.candyshop — and 10 country rows across dates; after country aggregation expect ≤10 package/date combos)

---

## Model: google_play__overview_report
- Sources:
  - `ref('stats_installs_overview')` — installs metrics (10 rows)
  - `ref('stats_crashes_overview')` — crash/ANR metrics (10 rows)
  - `ref('stats_ratings_overview')` — rating metrics (10 rows)
  - `ref('int_google_play__store_performance')` — store performance metrics (≤10 rows)
- Driving table: installs (FULL OUTER JOIN with crashes, ratings; LEFT JOIN store_performance)
- Joins:
  - FULL OUTER JOIN `stats_crashes_overview` ON (date_day, source_relation, package_name) — disjoint dates possible
  - FULL OUTER JOIN `stats_ratings_overview` ON (date_day, source_relation, package_name) — disjoint dates possible
  - FULL OUTER JOIN `int_google_play__store_performance` ON (date_day, source_relation, package_name) — store performance covers member.android.candyshop which is DISJOINT from installs/crashes/ratings packages; LEFT JOIN silently drops all store rows; must FULL OUTER JOIN to include candyshop rows
- Key expressions (follow sibling `google_play__app_version_report` pattern):
  - Rolling totals in install_metrics CTE before joining:
    - `total_device_installs = SUM(device_installs) OVER (PARTITION BY source_relation, package_name ORDER BY date_day ROWS UNBOUNDED PRECEDING)`
    - `total_device_uninstalls = SUM(device_uninstalls) OVER (PARTITION BY source_relation, package_name ORDER BY date_day ROWS UNBOUNDED PRECEDING)`
  - After FULL OUTER JOIN, coalesce grain keys:
    - `source_relation = COALESCE(installs.source_relation, crashes.source_relation, ratings.source_relation)`
    - `date_day = COALESCE(installs.date_day, crashes.date_day, ratings.date_day)`
    - `package_name = COALESCE(installs.package_name, crashes.package_name, ratings.package_name)`
  - `android_os_version = CAST(NULL AS VARCHAR)` — not in source data (overview has no OS version dimension)
  - Event/metric columns use COALESCE to 0 for missing join sides
  - Rolling backfill for rolling_total_average_rating via partition+first_value pattern (sibling pattern)
  - Final:
    - `net_device_installs = total_device_installs - total_device_uninstalls`
    - `rolling_store_conversion_rate = ROUND(CAST(total_store_acquisitions AS DECIMAL(18,4)) / NULLIF(total_store_visitors, 0), 4)` — matches country_report pattern
    - `total_store_acquisitions = COALESCE(int_store.total_store_acquisitions, 0)`
    - `total_store_visitors = COALESCE(int_store.total_store_visitors, 0)`
- Filters: none
- Expected grain: one row per (source_relation, package_name, date_day)
- Expected rows: union of dates across all source tables — will be driven by whichever source has most coverage

---

## Decisions
- Local stub models (`stats_installs_overview`, `stats_crashes_overview`, `stats_ratings_overview`, `stats_store_performance_country`) read directly from raw DuckDB tables — they are the staging layer for the overview report pipeline (distinct from source package staging models which use fivetran_utils macros)
- `google_play__overview_report` uses `ref()` directly to local stubs (not `var()`), because the YML refs section lists local model names, and the overview pipeline is separate from the device/country/os_version pipeline
- `int_google_play__store_performance` aggregates country-level store data to package/date level before the overview report uses it — this avoids fan-out in the overview join
- `store_listing_conversion_rate` is RECOMPUTED after aggregation (SUM(acq)/NULLIF(SUM(vis),0)) because the original per-country rate would be incorrect after summing across countries
- `android_os_version` is `CAST(NULL AS VARCHAR)` in the overview report — raw data has no OS version dimension at overview level
- FULL OUTER JOIN between installs, crashes, ratings because sources may have different date coverage (different packages in each source table)
- FULL OUTER JOIN `int_google_play__store_performance` because store data (member.android.candyshop) is DISJOINT from all other sources — LEFT JOIN drops all store rows silently; sibling country_report uses FULL OUTER JOIN for store_performance too
- `source_relation = ''` (empty string) — single Fivetran connector, no union schema configured
- Rolling metrics backfilled with partition+first_value pattern matching `google_play__app_version_report` sibling
- `total_device_installs` / `total_device_uninstalls` computed in the installs CTE before joins, NOT after (follows sibling pattern)
