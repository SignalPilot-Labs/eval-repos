with frames as (

    select * from {{ ref('stg_quanta__frames') }}

)

select
    stream_id,
    client_id,
    {{ j('frame', '$.text') }}    as annotation_text
from frames
where kind = 'annotation'
