-- One row per experiment, conformed columns.
with tests as (

    select * from {{ ref('stg_meridian__experiments') }}

),

catalog as (

    select * from {{ ref('test_catalog') }}
    where client_id = 'meridian_wellness'

)

select
    t.test_key                                                        as experiment_key,
    t.client_id,
    c.experiment_name,
    c.randomization_unit,
    c.status,
    coalesce(cast(c.start_date as timestamp), t.first_bucketed_at)    as start_ts,
    cast(c.end_date as timestamp)                                     as end_ts,
    cast(coalesce(c.variant_count, t.observed_bucket_count) as integer) as variant_count,
    c.primary_metric
from tests t
left join catalog c
    on c.canonical_key = t.test_key
