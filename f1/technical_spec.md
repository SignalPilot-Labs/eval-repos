# Technical Spec: f1002 — Formula 1 Constructors & Driver Championships

## Build Order
1. `finishes_by_constructor` (stats/mart — depends on stg_f1_dataset__results, stg_f1_dataset__constructors)
2. `driver_championships` (stats/mart — depends on stg_f1_dataset__drivers, stg_f1_dataset__results, stg_f1_dataset__races, stg_f1_dataset__driver_standings)

---

## Model: finishes_by_constructor

- **Source**: `ref('stg_f1_dataset__results')`, `ref('stg_f1_dataset__constructors')`
- **Driving table**: `stg_f1_dataset__results` (26,599 rows, 211 distinct constructor_ids) — domain-media rule: drive from event/participation table, not content table
- **Joins**:
  - `JOIN stg_f1_dataset__constructors ON constructors.constructor_id = results.constructor_id` — need constructor_name; INNER JOIN matches sibling pattern (finishes_by_driver uses JOIN, not LEFT JOIN)
- **Key expressions** (copied exactly from sibling `finishes_by_driver.sql`):
  - `races = COUNT(*)`
  - `podiums = COUNT_IF(position_order BETWEEN 1 AND 3)`
  - `pole_positions = COUNT_IF(grid = 1)` — grid=1 means started from pole
  - `fastest_laps = COUNT_IF(rank = 1)` — rank column from results; sibling aliases `r.rank as fastest_lap` then uses `count_if(fastest_lap = 1)`
  - `p1..p20 = SUM(CASE WHEN position_order = N THEN 1 ELSE 0 END)`
  - `p21plus = SUM(CASE WHEN position_order > 20 THEN 1 ELSE 0 END)`
  - `disqualified = SUM(CASE WHEN position_desc = 'disqualified' THEN 1 ELSE 0 END)`
  - `excluded = SUM(CASE WHEN position_desc = 'excluded' THEN 1 ELSE 0 END)`
  - `failed_to_qualify = SUM(CASE WHEN position_desc = 'failed to qualify' THEN 1 ELSE 0 END)`
  - `not_classified = SUM(CASE WHEN position_desc = 'not classified' THEN 1 ELSE 0 END)`
  - `retired = SUM(CASE WHEN position_desc = 'retired' THEN 1 ELSE 0 END)`
  - `withdrew = SUM(CASE WHEN position_desc = 'withdrew' THEN 1 ELSE 0 END)`
- **Filters**: none — include all constructors and all result types (YML has no explicit filter)
- **Expected grain**: one row per constructor
- **Expected rows**: 211 (distinct constructor_ids in stg_f1_dataset__results)

---

## Model: driver_championships

- **Source**: `ref('stg_f1_dataset__drivers')`, `ref('stg_f1_dataset__results')`, `ref('stg_f1_dataset__races')`, `ref('stg_f1_dataset__driver_standings')`
- **Driving table**: `stg_f1_dataset__constructors` equivalent logic — drive via JOIN from results, following sibling `construtor_drivers_championships.sql`
- **Joins** (mirror sibling `construtor_drivers_championships.sql` exactly):
  - Start from `stg_f1_dataset__drivers` (853 drivers)
  - `JOIN stg_f1_dataset__results ON drivers.driver_id = results.driver_id`
  - `JOIN stg_f1_dataset__races ON results.race_id = races.race_id`
  - `JOIN stg_f1_dataset__driver_standings ON ds.raceid = races.race_id AND ds.driverid = results.driver_id`
- **Key expressions**:
  - CTE 1 `driver_points`: `MAX(driver_standings.points) AS max_points` grouped by `driver_full_name, race_year`
  - CTE 2 `driver_championships_ranked`: `RANK() OVER (PARTITION BY race_year ORDER BY max_points DESC) AS r_rank` — mirrors sibling use of RANK()
  - Filter: `WHERE race_year != EXTRACT(YEAR FROM CURRENT_DATE())` — mirrors sibling exactly (excludes in-progress season)
  - Final: `COUNT(*) AS total_championships` grouped by `driver_full_name` where `r_rank = 1`
- **Filters**:
  - `race_year != EXTRACT(YEAR FROM CURRENT_DATE())` — mirrors sibling to exclude current partial season
  - `r_rank = 1` in final SELECT — pick championship winner per season
- **Expected grain**: one row per driver who has won at least one championship
- **Expected rows**: 34 (verified by query: 34 distinct drivers with r_rank=1 seasons)

---

## Decisions

- `finishes_by_constructor` drives from `stg_f1_dataset__results` not `stg_f1_dataset__constructors` — domain-media rule: event table drives aggregation, not entity table; 211 distinct constructors in results matches blueprint
- INNER JOIN to `stg_f1_dataset__constructors` for `finishes_by_constructor` — sibling `finishes_by_driver` uses JOIN (not LEFT JOIN) to drivers; constructors table has 212 rows vs 211 in results — one constructor with no races is silently excluded, matching sibling intent
- `fastest_laps = COUNT_IF(rank = 1)` — sibling maps `r.rank as fastest_lap` then counts `fastest_lap = 1`; NOT `r.fastest_lap` column which is the lap number, not rank
- `pole_positions = COUNT_IF(grid = 1)` — matches sibling's `count_if(grid_position_order = 1)` where grid_position_order = r.grid
- `driver_championships` uses same JOIN chain as sibling `construtor_drivers_championships` — `results` bridges `drivers` → `races` → `driver_standings`
- `RANK()` not `ROW_NUMBER()` for championships — sibling uses RANK(); ties in max_points share rank 1 (both drivers get championship credit)
- `race_year != EXTRACT(YEAR FROM CURRENT_DATE())` filter in both models — matches sibling exactly; excludes current season where championship not yet finalized
- `driver_full_name = CONCAT(driver_first_name, ' ', driver_last_name)` — from `stg_f1_dataset__drivers` which already computes this column
