-- One row per date and experiment.
with enrollments as (

    select
        cast(assigned_ts as date)  as metric_date,
        experiment_key,
        count(*)                   as enrollments
    from {{ ref('int_drift__enrollments') }}
    group by 1, 2

),

exposures as (

    select
        cast(exposure_ts as date)  as metric_date,
        experiment_key,
        count(*)                   as exposures
    from {{ ref('int_drift__exposures') }}
    group by 1, 2

),

events as (

    select
        cast(event_ts as date)                    as metric_date,
        experiment_key,
        count(*)                                  as metric_events,
        count(*) filter (where is_conversion)     as conversions,
        coalesce(sum(amount_usd), 0)              as revenue_usd
    from {{ ref('int_drift__metric_events') }}
    group by 1, 2

),

spine as (

    select metric_date, experiment_key from enrollments
    union
    select metric_date, experiment_key from exposures
    union
    select metric_date, experiment_key from events

)

select
    s.metric_date,
    s.experiment_key,
    coalesce(en.enrollments, 0)    as enrollments,
    coalesce(ex.exposures, 0)      as exposures,
    coalesce(ev.metric_events, 0)  as metric_events,
    coalesce(ev.conversions, 0)    as conversions,
    coalesce(ev.revenue_usd, 0)    as revenue_usd
from spine s
left join enrollments en using (metric_date, experiment_key)
left join exposures ex using (metric_date, experiment_key)
left join events ev using (metric_date, experiment_key)
