# Technical Spec: intercom__admin_metrics

## Build Order
1. stg_intercom__admin (staging — no dependencies within this project)
2. stg_intercom__team_admin (staging — no dependencies within this project)
3. stg_intercom__team (staging — no dependencies within this project)
4. intercom__conversation_metrics (mart — already built, upstream dependency)
5. intercom__admin_metrics (mart — depends on all above)

---

## Model: intercom__admin_metrics

- **Source**:
  - `{{ var('admin') }}` = `stg_intercom__admin` — columns: `admin_id` (VARCHAR), `name`, `job_title`
  - `{{ var('team_admin') }}` = `stg_intercom__team_admin` — columns: `admin_id` (VARCHAR), `team_id` (BIGINT)
  - `{{ var('team') }}` = `stg_intercom__team` — columns: `team_id` (BIGINT), `name`
  - `{{ ref('intercom__conversation_metrics') }}` — provides all conversation-level metrics; uses pre-computed `time_to_first_response_minutes`, `time_to_last_close_minutes`, `count_reopens`, `count_total_parts`, `count_assignments`, `conversation_rating`

- **Driving table**: `stg_intercom__team_admin` (4 rows — one row per admin-team mapping); drives the FROM clause to establish team-admin grain

- **Joins**:
  - `LEFT JOIN stg_intercom__admin ON team_admin.admin_id = admin.admin_id` — brings in admin name and job_title
  - `LEFT JOIN stg_intercom__team ON team_admin.team_id = team.team_id` — brings in team name (only when `intercom__using_team = True`)
  - `LEFT JOIN intercom__conversation_metrics ON conversation_metrics.last_close_by_admin_id = admin.admin_id` — matches closed conversations to the admin who last closed them (both columns are VARCHAR)
  - All JOINs are LEFT to preserve all admin-team rows even when no conversations are attributed

- **Key expressions**:
  - `admin_id` = `admin.admin_id` (VARCHAR from stg_intercom__admin)
  - `admin_name` = `admin.name`
  - `team_name` = `team.name` (NULL when `intercom__using_team = False`)
  - `team_id` = `team_admin.team_id` (NULL when `intercom__using_team = False`)
  - `job_title` = `admin.job_title`
  - `total_conversations_closed` = `COUNT(conversation_metrics.conversation_id)` — uses COUNT of specific column (not COUNT(*)) so admins with 0 attributed conversations get 0
  - `average_conversation_parts` = `AVG(conversation_metrics.count_total_parts)`
  - `average_conversation_rating` = `AVG(conversation_metrics.conversation_rating)`
  - `median_conversations_reopened` = `MEDIAN(conversation_metrics.count_reopens)`
  - `median_conversation_assignments` = `MEDIAN(conversation_metrics.count_assignments)`
  - `median_time_to_first_response_time_minutes` = `MEDIAN(conversation_metrics.time_to_first_response_minutes)`
  - `median_time_to_last_close_minutes` = `MEDIAN(conversation_metrics.time_to_last_close_minutes)`

- **Filters**:
  - `WHERE conversation_state = 'closed'` on `intercom__conversation_metrics` — domain-hr rule: "Include ONLY closed issues in resolution time calculations"
  - Staging models already filter `_fivetran_deleted = False` and `_fivetran_active`
  - No additional filters on admin or team_admin tables

- **Expected grain**: one row per (admin_id, team_id) combination — per YML unique key comment: "because admins can belong to multiple teams, this model must be at the grain of team-admin"

- **Expected rows**: 4 — from 4 rows in `stg_intercom__team_admin` (each admin belongs to exactly one team in test data)

---

## Decisions

- **Driving table is team_admin, not conversation_metrics**: The model grain is team-admin (per YML unique key definition). Driving from conversation_metrics would produce 0 rows in test data since `last_close_by_admin_id` is NULL for all conversations. Driving from team_admin ensures all admin-team pairs appear regardless of conversation activity.
- **LEFT JOIN conversations**: All admins must appear in output (admin_id has not_null test). Admins with 0 closed conversations get COUNT=0, AVG=NULL, MEDIAN=NULL.
- **Join key is VARCHAR**: `stg_intercom__admin.admin_id` is CAST(id AS VARCHAR) and `conversation_metrics.last_close_by_admin_id` is also VARCHAR (from intermediate model using `dbt.type_string()`). No type cast needed in join.
- **Use last_close_by_admin_id, not assignee_id**: YML description says "total conversations that the admin has *closed*" — the last closer, not the current assignee.
- **Conditional team columns**: `intercom__using_team` variable controls whether team_admin and team CTEs are included. When False, team_id and team_name output as NULL.
- **COUNT(column) not COUNT(*)**: `COUNT(conversation_metrics.conversation_id)` returns 0 for admins with no matching conversations (LEFT JOIN returns NULL for unmatched rows).
- **Pre-computed time metrics from conversation_metrics**: Do NOT recompute from raw timestamps. `intercom__conversation_metrics` already computes `time_to_first_response_minutes` and `time_to_last_close_minutes` correctly.
- **MEDIAN, not AVG for reopen/assignment/response/close metrics**: All `median_*` YML columns require MEDIAN aggregation. DuckDB supports MEDIAN() natively.
