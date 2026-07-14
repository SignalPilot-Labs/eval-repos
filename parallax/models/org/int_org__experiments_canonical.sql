-- One row per (client, canonical experiment).
with experiments as (
    select * from {{ ref('int_all__experiments') }}
),

xref as (
    select client_id, wire_key, canonical_key from {{ ref('experiment_xref') }}
)

select
    coalesce(x.canonical_key, e.experiment_key) as canonical_experiment_key,
    e.experiment_key,
    e.client_id,
    e.experiment_name,
    e.randomization_unit,
    e.status,
    e.start_ts,
    e.end_ts,
    e.variant_count,
    e.primary_metric
from experiments e
left join xref x
    on x.client_id = e.client_id
   and x.wire_key = e.experiment_key
