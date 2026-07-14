-- One row per experiment, conformed columns. Metadata from the org test catalog.
with tests_seen as (

    select distinct experiment_key
    from {{ ref('stg_helios__enrollments') }}

),

catalog as (

    select * from {{ ref('test_catalog') }}
    where client_id = 'helios_media'

)

select
    t.experiment_key,
    coalesce(c.client_id, 'helios_media')          as client_id,
    c.experiment_name,
    c.randomization_unit,
    c.status,
    cast(c.start_date as timestamp)                as start_ts,
    cast(c.end_date as timestamp)                  as end_ts,
    cast(c.variant_count as integer)               as variant_count,
    c.primary_metric
from tests_seen t
left join catalog c
    on c.canonical_key = t.experiment_key
