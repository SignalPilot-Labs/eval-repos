# Technical Spec — apple_store001

## Models to Build

### 1. `apple_store__source_type_report`

**Grain:** One row per (source_relation, date_day, app_id, source_type)
**Expected rows:** ~9 (driven by `int_apple_store__app_store_source_type` which has 9 rows)
**YML unique key:** source_relation + date_day + app_id + source_type

**Sources:**
| CTE Name | Source | Rows | Purpose |
|---|---|---|---|
| `app` | `var('app')` → stg_apple_store__app | 1 | app_name lookup |
| `app_store_source_type` | `ref('int_apple_store__app_store_source_type')` | 9 | Driving grain + impressions, page_views |
| `downloads_source_type` | `ref('int_apple_store__downloads_source_type')` | 10 | first_time_downloads, redownloads, total_downloads |
| `usage_source_type` | `ref('int_apple_store__usage_source_type')` | 10 | active_devices, deletions, installations, sessions |

**Pattern:**
- `reporting_grain` CTE: `SELECT DISTINCT source_relation, date_day, app_id, source_type FROM app_store_source_type`
- LEFT JOIN all others on (source_relation, date_day, app_id, source_type)
- LEFT JOIN `app` on (app_id, source_relation)
- No UNION ALL needed (no crashes_source_type exists in this project)
- All metric columns wrapped in `COALESCE(..., 0)`

**Column mapping:**
| YML Column | Source |
|---|---|
| source_relation | reporting_grain.source_relation |
| date_day | reporting_grain.date_day |
| app_id | reporting_grain.app_id |
| app_name | app.app_name |
| source_type | reporting_grain.source_type |
| impressions | app_store_source_type.impressions |
| page_views | app_store_source_type.page_views |
| first_time_downloads | downloads_source_type.first_time_downloads |
| redownloads | downloads_source_type.redownloads |
| total_downloads | downloads_source_type.total_downloads |
| active_devices | usage_source_type.active_devices |
| deletions | usage_source_type.deletions |
| installations | usage_source_type.installations |
| sessions | usage_source_type.sessions |

**Sibling pattern:** Follows `apple_store__overview_report` structure (single grain source, all others LEFT JOINed, COALESCE metrics to 0).

---

### 2. `apple_store__territory_report`

**Grain:** One row per (source_relation, date_day, app_id, source_type, territory_long)
**Expected rows:** ~17 (driven by `stg_apple_store__app_store_territory` which has 17 rows)
**YML unique key:** source_relation + date_day + app_id + source_type + territory_long

**Sources:**
| CTE Name | Source | Rows | Purpose |
|---|---|---|---|
| `app` | `var('app')` → stg_apple_store__app | 1 | app_name lookup |
| `app_store_territory` | `var('app_store_territory')` → stg_apple_store__app_store_territory | 17 | Driving grain + impressions, page_views (unique device too) |
| `downloads_territory` | `var('downloads_territory')` → stg_apple_store__downloads_territory | 10 | first_time_downloads, redownloads, total_downloads |
| `usage_territory` | `var('usage_territory')` → stg_apple_store__usage_territory | 10 | active_devices, active_devices_last_30_days, deletions, installations, sessions |
| `country_codes` | `var('apple_store_country_codes')` → apple_store_country_codes | 250 | territory_short (alpha_2), region, sub_region |

**Territory enrichment:**
- Raw `territory` column holds full country names: "Canada", "Côte d'Ivoire", "Cote d'Ivoire", "Kosovo", "Turkey", "Türkiye"
- country_codes join: `territory = country_codes.country_name OR territory = country_codes.alternative_country_name`
- territory_long = raw `territory` (preserves encoding variant as distinct rows per dbt-write rule)
- territory_short = country_codes.country_code_alpha_2
- region = country_codes.region
- sub_region = country_codes.sub_region

**Pattern:**
- `reporting_grain` CTE: `SELECT DISTINCT source_relation, date_day, app_id, source_type, territory FROM app_store_territory`
- LEFT JOIN all others on (source_relation, date_day, app_id, source_type, territory)
- LEFT JOIN `app` on (app_id, source_relation)
- LEFT JOIN `country_codes` on territory = country_name OR territory = alternative_country_name
- No UNION ALL needed (no crashes_territory intermediate exists)
- All metric columns wrapped in `COALESCE(..., 0)`

**Column mapping:**
| YML Column | Source |
|---|---|
| source_relation | reporting_grain.source_relation |
| date_day | reporting_grain.date_day |
| app_id | reporting_grain.app_id |
| app_name | app.app_name |
| source_type | reporting_grain.source_type |
| territory_long | reporting_grain.territory (raw name, preserves variant) |
| territory_short | country_codes.country_code_alpha_2 |
| region | country_codes.region |
| sub_region | country_codes.sub_region |
| impressions | app_store_territory.impressions |
| impressions_unique_device | app_store_territory.impressions_unique_device |
| page_views | app_store_territory.page_views |
| page_views_unique_device | app_store_territory.page_views_unique_device |
| first_time_downloads | downloads_territory.first_time_downloads |
| redownloads | downloads_territory.redownloads |
| total_downloads | downloads_territory.total_downloads |
| active_devices | usage_territory.active_devices |
| active_devices_last_30_days | usage_territory.active_devices_last_30_days |
| deletions | usage_territory.deletions |
| installations | usage_territory.installations |
| sessions | usage_territory.sessions |
