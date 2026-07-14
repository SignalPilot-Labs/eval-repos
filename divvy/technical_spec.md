## Build Order
1. stg_divvy_data (staging — depends on source divvy_data)
2. facts_divvy (mart — depends on stg_divvy_data, dim_neighbourhoods)

---

## Model: stg_divvy_data
- Source: `source('main', 'divvy_data')` — 426,887 rows
- Driving table: divvy_data (426,887 rows)
- Joins: none
- Key expressions:
  - r_id = `md5(ride_id || '-' || CAST(started_at AS VARCHAR))` — surrogate key (verified: ride_id='EACB19130B0CDA4A' → '242d827bdf0bdd75cc4655e28a36c6ad')
  - membership_status = `member_casual` (source column rename; member_casual UNMAPPED-INCLUDE from map-columns)
  - start_lat = `ROUND(start_lat, 3)` — pre-built table schema shows DECIMAL(18,3)
  - start_lng = `ROUND(start_lng, 3)` — same
  - end_lat = `ROUND(end_lat, 3)` — same
  - end_lng = `ROUND(end_lng, 3)` — same
  - start_station_id = `CAST(start_station_id AS VARCHAR)` — pre-built schema shows VARCHAR; source is INTEGER
  - end_station_id = `CAST(end_station_id AS VARCHAR)` — same
- Filters: none
- Expected grain: one row per bike ride (ride_id is unique in source)
- Expected rows: 426,887 (all rows from divvy_data, no filtering)

---

## Model: facts_divvy
- Source: `ref('stg_divvy_data')` (426,887 rows) + `ref('dim_neighbourhoods')` (1,669 rows)
- Driving table: stg_divvy_data (426,887 rows)
- Joins:
  - INNER JOIN dim_neighbourhoods AS start_n ON stg.start_station_name = start_n.station_name
  - INNER JOIN dim_neighbourhoods AS end_n ON stg.end_station_name = end_n.station_name
- Key expressions:
  - start_station_id = `start_n.station_id` (lookup ID, not raw source ID)
  - end_station_id = `end_n.station_id` (lookup ID, not raw source ID)
  - duration_minutes = `(epoch_us(stg.ended_at) - epoch_us(stg.started_at)) / 60000000.0`
  - start_neighbourhood = `start_n.primary_neighbourhood`
  - end_neighbourhood = `end_n.primary_neighbourhood`
  - start_location = `CAST(start_n.lat AS VARCHAR) || ',' || CAST(start_n.lng AS VARCHAR)`
  - end_location = `CAST(end_n.lat AS VARCHAR) || ',' || CAST(end_n.lng AS VARCHAR)`
- Filters: `WHERE duration_minutes BETWEEN 1 AND 1440` (YML description: "duration between 1 minute and 24 hours"; 24h = 1440 min)
- Expected grain: one row per bike ride (ride_id unique in output)
- Expected rows: 413,689 (verified: COUNT(*) from divvy_data INNER JOIN both station lookups WHERE duration BETWEEN 1 AND 1440 = 413,689)

---

## Decisions
- stg_divvy_data uses raw source station IDs (INTEGER cast to VARCHAR); facts_divvy overrides these with lookup IDs — pre-built stg_divvy_data shows raw IDs (239, 234); pre-built facts_divvy shows lookup IDs (403992, 464934)
- station_id join key is station_name (not station_id) — divvy_data station_id range 2-675; divvy_stations_lookup station_id range ~400K+; direct ID join yields 0 matches; name join yields 413,689
- INNER JOIN both station lookups in facts_divvy — row count 413,689 exactly matches INNER JOIN query; LEFT JOIN would give more rows (no neighbourhood data for unmatched stations needed by YML)
- duration_minutes uses epoch_us math not date_diff — avoids DuckDB DATE_DIFF signature issues; decimal precision matches pre-built (74.183...)
- start_location / end_location from lookup lat/lng (not stg source lat/lng) — pre-built facts_divvy "41.9067,-87.6348" matches divvy_stations_lookup values; format: CAST(lat AS VARCHAR) || ',' || CAST(lng AS VARCHAR)
- lat/lng in stg_divvy_data rounded to 3 decimal places — pre-built stg_divvy_data shows DECIMAL(18,3) type and rounded values (41.967 not 41.9665)
- start_station_id cast to VARCHAR in stg_divvy_data — pre-built table shows typeof(start_station_id)=VARCHAR
- duration filter applied in facts_divvy not stg_divvy_data — stg is a passthrough staging layer; facts is the business logic layer per YML description
