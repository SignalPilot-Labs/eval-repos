-- One row per enrollment, with exposure and metric-event rollups.
with enrollments as (

    select * from (
        select *, row_number() over (partition by subject_key order by bucketed_at) as rn
        from {{ ref('stg_ember__enrollments') }}
    ) t
    where rn = 1

),

exposure_rollup as (

    select
        enrollment_id,
        count(*)          as exposure_count,
        min(exposure_ts)  as first_exposure_ts
    from {{ ref('stg_ember__exposures') }}
    group by 1

),

event_rollup as (

    select
        e.enrollment_id,
        count(*)                                                    as event_count,
        count(*) filter (where x.is_conversion)                     as conversion_count,
        coalesce(sum(e.amount_usd) filter (where x.is_monetary), 0) as revenue_usd
    from {{ ref('stg_ember__metric_events') }} e
    left join {{ ref('metric_xref') }} x
        on x.client_id = e.client_id
       and x.raw_metric = e.kind
    group by 1

),

platforms as (

    select * from {{ ref('platform_xref') }}

)

select
    en.enrollment_id,
    en.client_id,
    en.experiment_key,
    en.subject_key,
    {{ variant_canonical('en.bucket') }}        as variant,
    en.bucketed_at                              as assigned_ts,
    en.sdk_version,
    p.platform,
    false                                       as is_internal_subject,
    coalesce(ex.exposure_count, 0)              as exposure_count,
    ex.first_exposure_ts,
    coalesce(ev.event_count, 0)                 as event_count,
    coalesce(ev.conversion_count, 0)            as conversion_count,
    coalesce(ev.conversion_count, 0) > 0        as converted,
    coalesce(ev.revenue_usd, 0)                 as revenue_usd
from enrollments en
left join exposure_rollup ex using (enrollment_id)
left join event_rollup ev using (enrollment_id)
left join platforms p
    on p.raw_value = en.device
