-- One row per subject.
with frames as (

    select * from {{ ref('stg_halcyon__frames') }}
    where kind = 'subject'

)

select
    {{ j('frame', '$.key') }}                     as subject_key,
    client_id,
    min({{ ts_iso(j('frame', '$.seen')) }})       as first_seen_ts,
    max({{ j('frame', '$.platform') }})           as platform,
    count(*)                                      as enrollment_count
from frames
group by 1, 2
