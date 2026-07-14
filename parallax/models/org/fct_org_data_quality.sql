-- Data-quality signals per client.
with enrollments as (
    select * from {{ ref('int_all__enrollments') }}
),

events as (
    select * from {{ ref('int_all__metric_events') }}
),

pre_exposure as (
    select ev.client_id, count(*) as pre_assignment_events
    from events ev
    join enrollments en using (enrollment_id)
    where ev.event_ts < en.assigned_ts
    group by 1
)

select
    en.client_id,
    count(*)                                                  as enrollments,
    count(*) filter (where en.exposure_count = 0)             as never_exposed,
    round((count(*) filter (where en.exposure_count = 0) * 1.0 / count(*))::numeric, 4) as never_exposed_rate,
    count(*) filter (where en.is_internal_subject)            as internal_enrollments,
    count(*) filter (where en.sdk_version is null)            as null_sdk_enrollments,
    count(*) filter (where en.revenue_usd < 0)                as negative_revenue_enrollments,
    max(coalesce(pe.pre_assignment_events, 0))                as pre_assignment_events
from enrollments en
left join pre_exposure pe on pe.client_id = en.client_id
group by 1
