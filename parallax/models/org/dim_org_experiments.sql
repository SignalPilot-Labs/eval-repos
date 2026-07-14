-- Experiment dimension across all clients.
with experiments as (
    select * from {{ ref('int_org__experiments_canonical') }}
),

catalog as (
    select * from {{ ref('test_catalog') }}
)

select
    e.canonical_experiment_key,
    e.experiment_key,
    e.client_id,
    coalesce(c.experiment_name, e.experiment_name) as experiment_name,
    e.randomization_unit,
    e.status,
    e.start_ts,
    e.end_ts,
    e.variant_count,
    e.primary_metric
from experiments e
left join catalog c
    on c.client_id = e.client_id
   and c.canonical_key = e.canonical_experiment_key
