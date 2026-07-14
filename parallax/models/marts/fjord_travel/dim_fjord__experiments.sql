-- One row per experiment.
with experiments as (

    select * from {{ ref('int_fjord__experiments') }}

),

metrics_seen as (

    select
        experiment_key,
        string_agg(distinct metric, ', ' order by metric) as metric_list
    from {{ ref('stg_fjord__metric_catalog') }}
    group by 1

),

enrollment_span as (

    select
        experiment_key,
        count(*)          as total_enrollments,
        min(assigned_ts)  as first_enrollment_ts,
        max(assigned_ts)  as last_enrollment_ts
    from {{ ref('int_fjord__enrollments') }}
    group by 1

)

select
    ex.experiment_key,
    ex.client_id,
    ex.experiment_name,
    ex.randomization_unit,
    ex.status,
    ex.start_ts,
    ex.end_ts,
    ex.variant_count,
    m.metric_list,
    ex.primary_metric,
    es.total_enrollments,
    es.first_enrollment_ts,
    es.last_enrollment_ts
from experiments ex
left join metrics_seen m using (experiment_key)
left join enrollment_span es using (experiment_key)
