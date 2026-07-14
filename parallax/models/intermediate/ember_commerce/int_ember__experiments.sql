-- One row per experiment, conformed columns.
with observed as (

    select distinct experiment_key
    from {{ ref('stg_ember__enrollments') }}

),

catalog as (

    select * from {{ ref('test_catalog') }}
    where client_id = 'ember_commerce'

)

select
    o.experiment_key,
    c.client_id,
    c.experiment_name,
    c.randomization_unit,
    c.status,
    cast(c.start_date as timestamp)          as start_ts,
    cast(c.end_date as timestamp)            as end_ts,
    cast(c.variant_count as integer)         as variant_count,
    c.primary_metric
from observed o
join catalog c
    on c.canonical_key = o.experiment_key
