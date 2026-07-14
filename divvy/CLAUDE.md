# Spider2-DBT Benchmark Task: divvy001

## Your Task
Analyze bike trips by combining user data, trip duration, and geo-locational information for start and end stations, while filtering trips based on their duration and associating stations with specific neighborhoods

## Database Access
The DuckDB database is registered in SignalPilot as connection `divvy001`.
Local path: `/workdir/dbt/divvy001/divvy.duckdb`

Use SignalPilot MCP tools to explore and query the database:
- `mcp__signalpilot__list_tables` — list all tables
- `mcp__signalpilot__describe_table` — column details for a table
- `mcp__signalpilot__explore_table` — deep-dive with sample values
- `mcp__signalpilot__query_database` — run SQL queries (read-only)
- `mcp__signalpilot__schema_overview` — quick overview of the whole database
- `mcp__signalpilot__schema_ddl` — full schema as DDL (CREATE TABLE statements)
- `mcp__signalpilot__schema_link` — find tables relevant to a question
- `mcp__signalpilot__find_join_path` — find how to join two tables
- `mcp__signalpilot__explore_column` — distinct values for a column
- `mcp__signalpilot__validate_sql` — check SQL syntax without executing
- `mcp__signalpilot__debug_cte_query` — test CTE steps independently
- `mcp__signalpilot__explain_query` — get execution plan

## Verification & Analysis Tools (use after dbt build)
- `mcp__signalpilot__check_model_schema` — compare materialized columns vs YML expected columns
- `mcp__signalpilot__validate_model_output` — row count + fan-out detection post-build
- `mcp__signalpilot__analyze_grain` — check cardinality / unique keys
- `mcp__signalpilot__audit_model_sources` — single-call cardinality audit: row counts for all upstream sources + model output, fan-out/over-filter ratios, NULL fraction and constant-value scan on all output columns
- `mcp__signalpilot__compare_join_types` — compare row counts for INNER/LEFT/RIGHT/FULL OUTER JOIN between two tables to pick the right JOIN type
- `mcp__signalpilot__dbt_error_parser` — parse dbt error text into fix suggestions
- `mcp__signalpilot__generate_sql_skeleton` — generate SELECT template from YML column list

## Key Rules
- Always use `{ config(materialized='table') }` at the top of every model
- Column names in YML are exact — copy them into SELECT aliases character-for-character
- When a sibling model exists, copy its JOIN types exactly (see dbt-write skill)
