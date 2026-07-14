-- One row per experiment.
with experiments as (

    select * from {{ ref('int_granite__experiments') }}

),

xref as (

    select * from {{ ref('experiment_xref') }}
    where client_id = 'granite_gaming'

),

variants as (

    select
        experiment_key,
        string_agg(variant, ', ' order by variant) as variant_list
    from {{ ref('stg_granite__experiment_variants') }}
    group by 1

),

enrollment_span as (

    select
        experiment_key,
        count(*)          as total_enrollments,
        min(assigned_ts)  as first_enrollment_ts,
        max(assigned_ts)  as last_enrollment_ts
    from {{ ref('int_granite__enrollments') }}
    group by 1

)

select
    ex.experiment_key,
    x.canonical_key,
    ex.client_id,
    ex.experiment_name,
    ex.randomization_unit,
    ex.status,
    ex.start_ts,
    ex.end_ts,
    ex.variant_count,
    v.variant_list,
    ex.primary_metric,
    es.total_enrollments,
    es.first_enrollment_ts,
    es.last_enrollment_ts
from experiments ex
left join xref x
    on x.wire_key = ex.experiment_key
left join variants v using (experiment_key)
left join enrollment_span es using (experiment_key)
