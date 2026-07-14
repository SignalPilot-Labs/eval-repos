-- One row per enrollment, with exposure and metric-event rollups.
with enrollments as (

    select * from {{ ref('stg_granite__enrollments') }}
    where assigned_ts >= '2025-12-01'

),

exposure_rollup as (

    select
        enrollment_id,
        count(*)          as exposure_count,
        min(exposure_ts)  as first_exposure_ts
    from {{ ref('stg_granite__exposures') }}
    group by 1

),

event_rollup as (

    select
        e.enrollment_id,
        count(*)                                                    as event_count,
        count(*) filter (where x.is_conversion)                     as conversion_count,
        coalesce(sum(e.amount_usd) filter (where x.is_monetary), 0) as revenue_usd
    from {{ ref('stg_granite__metric_events') }} e
    left join {{ ref('metric_xref') }} x
        on x.client_id = e.client_id
       and x.raw_metric = e.metric
    group by 1

)

select
    en.enrollment_id,
    en.client_id,
    en.experiment_key,
    en.subject_key,
    {{ variant_canonical('en.variant') }}       as variant,
    en.assigned_ts,
    en.sdk_version,
    en.platform,
    en.is_internal                              as is_internal_subject,
    coalesce(ex.exposure_count, 0)              as exposure_count,
    ex.first_exposure_ts,
    coalesce(ev.event_count, 0)                 as event_count,
    coalesce(ev.conversion_count, 0)            as conversion_count,
    coalesce(ev.conversion_count, 0) > 0        as converted,
    coalesce(ev.revenue_usd, 0)                 as revenue_usd
from enrollments en
left join exposure_rollup ex using (enrollment_id)
left join event_rollup ev using (enrollment_id)
