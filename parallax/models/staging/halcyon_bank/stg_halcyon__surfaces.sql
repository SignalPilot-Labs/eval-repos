with frames as (

    select * from {{ ref('stg_halcyon__frames') }}
    where kind = 'expose'

)

select
    {{ j('frame', '$.surface') }}             as surface,
    count(*)                                  as exposure_count,
    min({{ ts_iso(j('frame', '$.at')) }})     as first_seen_ts
from frames
group by 1
