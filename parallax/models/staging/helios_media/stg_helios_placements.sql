with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'helios_media'

)

select
    {{ j('e', '$.placement') }}            as placement,
    count(*)                               as impression_count,
    min({{ ts_epoch_ms(j('e', '$.at')) }}) as first_seen_ts
from src, {{ jarr('blob', '$.testing.impressions') }} as t(e)
group by 1
