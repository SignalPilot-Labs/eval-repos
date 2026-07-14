-- One row per experiment, conformed columns. Metadata comes from the test catalog.
with observed as (

    select * from {{ ref('stg_fjord__experiments') }}

),

catalog as (

    select * from {{ ref('test_catalog') }}
    where client_id = 'fjord_travel'

)

select
    o.experiment_key,
    o.client_id,
    c.experiment_name,
    c.randomization_unit,
    c.status,
    cast(c.start_date as timestamp)          as start_ts,
    cast(c.end_date as timestamp)            as end_ts,
    cast(c.variant_count as integer)         as variant_count,
    c.primary_metric
from observed o
left join catalog c
    on c.canonical_key = o.experiment_key
