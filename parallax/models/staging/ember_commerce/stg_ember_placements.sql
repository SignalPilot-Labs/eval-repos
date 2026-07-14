with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'ember_commerce'

)

select
    {{ j('i', '$.placement') }}         as placement,
    count(*)                            as impression_count,
    min({{ ts_iso(j('i', '$.at')) }})   as first_seen_ts
from src, {{ jarr('blob', '$.testing.impressions') }} as t(i)
group by 1
