-- Engagement event rollup per experiment and variant. Superseded by fct_quanta__daily_metrics.
with events as (

    select * from {{ ref('stg_quanta__metric_events') }}
    where metric in ('workout_sync', 'app_open')

),

enrollments as (

    select enrollment_id, variant
    from {{ ref('stg_quanta__enrollments') }}

)

select
    e.experiment_key,
    en.variant,
    count(*)                                          as engagement_events,
    count(distinct e.subject_key)                     as engaged_subjects,
    count(*) filter (where e.metric = 'workout_sync') as workout_syncs,
    count(*) filter (where e.metric = 'app_open')     as app_opens
from events e
join enrollments en using (enrollment_id)
group by 1, 2
