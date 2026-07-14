-- One row per experiment, conformed columns.
select
    experiment_key,
    client_id,
    experiment_name,
    randomization_unit,
    status,
    start_ts,
    end_ts,
    variant_count,
    primary_metric
from {{ ref('stg_granite__experiments') }}
