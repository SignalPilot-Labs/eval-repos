-- One row per experiment, conformed columns. Metadata comes from the test catalog.
with enrollments as (

    select distinct
        experiment_key,
        client_id
    from {{ ref('stg_halcyon__enrollments') }}

),

catalog as (

    select * from {{ ref('test_catalog') }}
    where client_id = 'halcyon_bank'

)

select
    e.experiment_key,
    e.client_id,
    c.experiment_name,
    c.randomization_unit,
    c.status,
    cast(c.start_date as timestamp)          as start_ts,
    cast(c.end_date as timestamp)            as end_ts,
    cast(c.variant_count as integer)         as variant_count,
    c.primary_metric
from enrollments e
left join catalog c
    on c.canonical_key = e.experiment_key
