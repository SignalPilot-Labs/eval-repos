with frames as (

    select * from {{ ref('stg_halcyon__frames') }}
    where kind = 'annotation'

)

select
    stream_id,
    enrollment_id,
    client_id,
    {{ j('frame', '$.text') }}    as annotation,
    load_id
from frames
