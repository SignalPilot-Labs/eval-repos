{{ config(materialized='table') }}

-- EXPECTED SHAPE: 1 row per (date_day, guide_id) from guide creation to current_date — REASON: "daily event metrics for tracked guides, from creation to the current date"

with spine as (

    select *
    from {{ ref('int_pendo__calendar_spine') }}

),

guide_info as (

    select *
    from {{ ref('int_pendo__guide_info') }}

),

daily_metrics as (

    select *
    from {{ ref('int_pendo__guide_daily_metrics') }}

),

guide_event as (

    select *
    from {{ ref('pendo__guide_event') }}

),

guide_spine as (

    select
        spine.date_day,
        guide_info.guide_id,
        guide_info.guide_name

    from spine
    join guide_info
        on spine.date_day >= cast( {{ dbt.date_trunc('day', 'guide_info.created_at') }} as date)
        and spine.date_day <= current_date

),

pivoted_daily_events as (

    select
        guide_id,
        cast( {{ dbt.date_trunc('day', 'occurred_at') }} as date) as occurred_on,
        count(distinct case when type = 'guideSeen' then visitor_id end) as count_visitors_guideSeen,
        count(distinct case when type = 'guideDismissed' then visitor_id end) as count_visitors_guideDismissed,
        count(distinct case when type = 'guideActivity' then visitor_id end) as count_visitors_guideActivity,
        count(distinct case when type = 'guideAdvanced' then visitor_id end) as count_visitors_guideAdvanced,
        count(distinct case when type = 'guideTimeout' then visitor_id end) as count_visitors_guideTimeout,
        count(distinct case when type = 'guideSnoozed' then visitor_id end) as count_visitors_guideSnoozed

    from guide_event
    group by 1, 2

),

final as (

    select
        guide_spine.date_day,
        guide_spine.guide_id,
        guide_spine.guide_name,
        coalesce(daily_metrics.count_visitors, 0) as count_visitors,
        coalesce(daily_metrics.count_accounts, 0) as count_accounts,
        coalesce(daily_metrics.count_guide_events, 0) as count_guide_events,
        coalesce(daily_metrics.count_first_time_visitors, 0) as count_first_time_visitors,
        coalesce(daily_metrics.count_first_time_accounts, 0) as count_first_time_accounts,
        coalesce(pivoted_daily_events.count_visitors_guideSeen, 0) as count_visitors_guideSeen,
        coalesce(pivoted_daily_events.count_visitors_guideDismissed, 0) as count_visitors_guideDismissed,
        coalesce(pivoted_daily_events.count_visitors_guideActivity, 0) as count_visitors_guideActivity,
        coalesce(pivoted_daily_events.count_visitors_guideAdvanced, 0) as count_visitors_guideAdvanced,
        coalesce(pivoted_daily_events.count_visitors_guideTimeout, 0) as count_visitors_guideTimeout,
        coalesce(pivoted_daily_events.count_visitors_guideSnoozed, 0) as count_visitors_guideSnoozed

    from guide_spine
    left join daily_metrics
        on guide_spine.date_day = daily_metrics.occurred_on
        and guide_spine.guide_id = daily_metrics.guide_id
    left join pivoted_daily_events
        on guide_spine.date_day = pivoted_daily_events.occurred_on
        and guide_spine.guide_id = pivoted_daily_events.guide_id

)

select *
from final
