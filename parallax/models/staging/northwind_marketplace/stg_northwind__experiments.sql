-- One row per experiment, taken from the metadata block on the latest-loaded document.
with src as (

    select load_id, blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'northwind_marketplace'

),

ranked as (

    select
        {{ j('blob', '$.experiment.experiment_key') }}                  as experiment_key,
        {{ j('blob', '$.client_id') }}                                  as client_id,
        {{ j('blob', '$.experiment.name') }}                            as experiment_name,
        {{ j('blob', '$.experiment.unit') }}                            as randomization_unit,
        {{ j('blob', '$.experiment.status') }}                          as status,
        {{ ts_iso(j('blob', '$.experiment.start_ts')) }}                as start_ts,
        {{ ts_iso(j('blob', '$.experiment.end_ts')) }}                  as end_ts,
        cast({{ jarr_len('blob', '$.experiment.variants') }} as integer) as variant_count,
        {{ j('blob', '$.experiment.primary_metric') }}                  as primary_metric,
        row_number() over (
            partition by {{ j('blob', '$.experiment.experiment_key') }}
            order by load_id desc
        ) as rn
    from src

)

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
from ranked
where rn = 1
