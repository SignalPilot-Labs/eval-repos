-- One row per exposure frame.
with frames as (

    select * from {{ ref('stg_halcyon__frames') }}
    where kind = 'expose'

)

select
    {{ j('frame', '$.id') }}              as exposure_id,
    enrollment_id,
    client_id,
    experiment_key,
    subject_key,
    {{ ts_iso(j('frame', '$.at')) }}      as exposure_ts,
    {{ j('frame', '$.surface') }}         as surface
from frames
