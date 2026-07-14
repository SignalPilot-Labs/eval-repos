{{ config(materialized='table') }}

-- EXPECTED SHAPE: 4 rows (one per team-admin combination) — REASON: "admins can belong to multiple teams, this model must be at the grain of team-admin"

with conversation_metrics as (
    select *
    from {{ ref('intercom__conversation_metrics') }}
    where conversation_state = 'closed'
),

admin as (
    select *
    from {{ var('admin') }}
),

{% if var('intercom__using_team', True) %}
team_admin as (
    select *
    from {{ var('team_admin') }}
),

team as (
    select *
    from {{ var('team') }}
),
{% endif %}

admin_team as (
    select
        admin.admin_id,
        admin.name as admin_name,
        admin.job_title

        {% if var('intercom__using_team', True) %}
        , team_admin.team_id
        , team.name as team_name
        {% else %}
        , cast(null as bigint) as team_id
        , cast(null as varchar) as team_name
        {% endif %}

    from admin

    {% if var('intercom__using_team', True) %}
    left join team_admin
        on team_admin.admin_id = admin.admin_id

    left join team
        on team.team_id = team_admin.team_id
    {% endif %}
),

final as (
    select
        admin_team.admin_id,
        admin_team.admin_name,
        admin_team.team_name,
        admin_team.team_id,
        admin_team.job_title,
        count(conversation_metrics.conversation_id) as total_conversations_closed,
        avg(conversation_metrics.count_total_parts) as average_conversation_parts,
        avg(conversation_metrics.conversation_rating) as average_conversation_rating,
        median(conversation_metrics.count_reopens) as median_conversations_reopened,
        median(conversation_metrics.count_assignments) as median_conversation_assignments,
        median(conversation_metrics.time_to_first_response_minutes) as median_time_to_first_response_time_minutes,
        median(conversation_metrics.time_to_last_close_minutes) as median_time_to_last_close_minutes

    from admin_team

    left join conversation_metrics
        on conversation_metrics.last_close_by_admin_id = admin_team.admin_id

    group by 1, 2, 3, 4, 5
)

select *
from final
