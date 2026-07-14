with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'drift_labs'

)

select distinct
    {{ j('blob', '$.experiment.experiment_key') }}    as experiment_key,
    {{ j('v', '$') }}                                 as variant
from src, {{ jarr('blob', '$.experiment.variants') }} as t(v)
