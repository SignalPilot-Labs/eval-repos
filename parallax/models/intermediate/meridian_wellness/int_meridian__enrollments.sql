-- One row per enrollment, with exposure and outcome rollups.
with enrollments as (

    select * from {{ ref('stg_meridian__enrollments') }}

),

exposure_rollup as (

    select
        enrollment_id,
        count(*)          as exposure_count,
        min(exposure_ts)  as first_exposure_ts
    from {{ ref('stg_meridian__exposures') }}
    group by 1

),

event_rollup as (

    select
        e.enrollment_id,
        count(*)                                                    as event_count,
        count(*) filter (where x.is_conversion)                     as conversion_count,
        coalesce(sum(e.amount_usd) filter (where x.is_monetary), 0) as revenue_usd
    from {{ ref('stg_meridian__metric_events') }} e
    left join {{ ref('metric_xref') }} x
        on x.client_id = e.client_id
       and x.raw_metric = e.kind
    group by 1

)

select
    en.enrollment_id,
    en.client_id,
    en.test_key                                 as experiment_key,
    en.subject_key,
    {{ variant_canonical('en.bucket') }}        as variant,
    en.bucketed_at                              as assigned_ts,
    en.sdk_version,
    p.platform,
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
left join {{ ref('platform_xref') }} p
    on p.raw_value = en.device
