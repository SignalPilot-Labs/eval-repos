with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'meridian_wellness'

)

select
    {{ j('imp', '$.placement') }}          as placement,
    count(*)                               as impression_count,
    min({{ ts_iso(j('imp', '$.at')) }})    as first_seen_ts
from src, {{ jarr('blob', '$.testing.impressions') }} as t(imp)
group by 1
