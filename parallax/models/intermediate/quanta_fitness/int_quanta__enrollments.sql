-- One row per enrollment, with exposure and metric-event rollups.
with enrollments as (

    select * from {{ ref('stg_quanta__enrollments') }}

),

exposure_rollup as (

    select
        enrollment_id,
        count(*)          as exposure_count,
        min(exposure_ts)  as first_exposure_ts
    from {{ ref('stg_quanta__exposures') }}
    group by 1

),

event_rollup as (

    select
        enrollment_id,
        count(*)                                                  as event_count,
        count(*) filter (where is_conversion)                     as conversion_count,
        coalesce(sum(amount_usd), 0)                              as revenue_usd
    from {{ ref('int_quanta__metric_events') }}
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
    cast(false as boolean)                      as is_internal_subject,
    coalesce(ex.exposure_count, 0)              as exposure_count,
    ex.first_exposure_ts,
    coalesce(ev.event_count, 0)                 as event_count,
    coalesce(ev.conversion_count, 0)            as conversion_count,
    coalesce(ev.conversion_count, 0) > 0        as converted,
    coalesce(ev.revenue_usd, 0)                 as revenue_usd
from enrollments en
left join exposure_rollup ex using (enrollment_id)
left join event_rollup ev using (enrollment_id)
