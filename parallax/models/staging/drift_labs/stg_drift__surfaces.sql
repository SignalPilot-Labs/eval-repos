-- Exposure counts per surface.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'drift_labs'

)

select
    {{ j('e', '$.surface') }}         as surface,
    count(*)                          as exposure_count,
    min({{ ts_iso(j('e', '$.ts')) }}) as first_seen_ts
from src, {{ jarr('blob', '$.exposures') }} as t(e)
group by 1
