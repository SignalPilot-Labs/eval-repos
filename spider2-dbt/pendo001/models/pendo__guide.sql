{{ config(materialized='table') }}

-- EXPECTED SHAPE: 1 row per guide — REASON: "Table capturing guides - their latest state enhanced with metrics"

with guide_info as (

    select *
    from {{ ref('int_pendo__guide_info') }}

),

guide_alltime_metrics as (

    select *
    from {{ ref('int_pendo__guide_alltime_metrics') }}

),

guide_event as (

    select *
    from {{ ref('pendo__guide_event') }}

),

pivoted_events as (

    select
        guide_id,
        count(distinct case when type = 'guideSeen' then visitor_id end) as count_visitors_guideSeen,
        count(distinct case when type = 'guideDismissed' then visitor_id end) as count_visitors_guideDismissed,
        count(distinct case when type = 'guideActivity' then visitor_id end) as count_visitors_guideActivity,
        count(distinct case when type = 'guideAdvanced' then visitor_id end) as count_visitors_guideAdvanced,
        count(distinct case when type = 'guideTimeout' then visitor_id end) as count_visitors_guideTimeout,
        count(distinct case when type = 'guideSnoozed' then visitor_id end) as count_visitors_guideSnoozed

    from guide_event
    group by 1

),

final as (

    select
        guide_info.app_id,
        guide_info.device_type,
        guide_info.created_at,
        guide_info.created_by_user_id,
        guide_info.guide_id,
        guide_info.is_multi_step,
        guide_info.is_training,
        guide_info.last_updated_at,
        guide_info.last_updated_by_user_id,
        guide_info.launch_method,
        guide_info.guide_name,
        guide_info.published_at,
        guide_info.recurrence,
        guide_info.recurrence_eligibility_window,
        guide_info.reset_at,
        guide_info.root_version_id,
        guide_info.stable_version_id,
        guide_info.state,
        guide_info.app_display_name,
        guide_info.app_platform,
        guide_info.created_by_user_full_name,
        guide_info.created_by_user_username,
        guide_info.last_updated_by_user_full_name,
        guide_info.last_updated_by_user_username,
        guide_info.count_steps,
        coalesce(guide_alltime_metrics.count_visitors, 0) as count_visitors,
        coalesce(guide_alltime_metrics.count_accounts, 0) as count_accounts,
        coalesce(guide_alltime_metrics.count_events, 0) as count_events,
        guide_alltime_metrics.first_event_at,
        guide_alltime_metrics.last_event_at,
        guide_info._fivetran_synced,
        coalesce(pivoted_events.count_visitors_guideSeen, 0) as count_visitors_guideSeen,
        coalesce(pivoted_events.count_visitors_guideDismissed, 0) as count_visitors_guideDismissed,
        coalesce(pivoted_events.count_visitors_guideActivity, 0) as count_visitors_guideActivity,
        coalesce(pivoted_events.count_visitors_guideAdvanced, 0) as count_visitors_guideAdvanced,
        coalesce(pivoted_events.count_visitors_guideTimeout, 0) as count_visitors_guideTimeout,
        coalesce(pivoted_events.count_visitors_guideSnoozed, 0) as count_visitors_guideSnoozed

    from guide_info
    left join guide_alltime_metrics
        on guide_info.guide_id = guide_alltime_metrics.guide_id
    left join pivoted_events
        on guide_info.guide_id = pivoted_events.guide_id

)

select *
from final
