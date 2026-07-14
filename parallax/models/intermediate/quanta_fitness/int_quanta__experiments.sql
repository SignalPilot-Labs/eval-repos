-- One row per experiment, conformed columns. Metadata comes from the test catalog;
-- the wire format carries no experiment block.
with catalog as (

    select * from {{ ref('test_catalog') }}
    where client_id = 'quanta_fitness'

),

observed as (

    select distinct experiment_key
    from {{ ref('stg_quanta__enrollments') }}

)

select
    c.canonical_key                              as experiment_key,
    c.client_id,
    c.experiment_name,
    c.randomization_unit,
    c.status,
    cast(c.start_date as timestamp)              as start_ts,
    cast(c.end_date as timestamp)                as end_ts,
    cast(c.variant_count as integer)             as variant_count,
    c.primary_metric
from catalog c
join observed o
    on o.experiment_key = c.canonical_key
