-- Outcome volume by days between bucketing and the event.
with enrollments as (

    select enrollment_id, experiment_key, assigned_ts
    from {{ ref('int_meridian__enrollments') }}

),

events as (

    select enrollment_id, metric_key, event_ts, is_conversion
    from {{ ref('int_meridian__metric_events') }}

)

select
    en.experiment_key,
    ev.metric_key,
    (cast(ev.event_ts as date) - cast(en.assigned_ts as date))                as days_since_assignment,
    count(*)                                                                  as events,
    count(*) filter (where ev.is_conversion)                                  as conversions
from events ev
join enrollments en using (enrollment_id)
group by 1, 2, 3
