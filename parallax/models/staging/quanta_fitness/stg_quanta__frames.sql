-- One row per frame in the event stream, tagged with its kind.
with src as (

    select load_id, blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'quanta_fitness'

)

select
    {{ j('blob', '$.stream_id') }}         as stream_id,
    load_id,
    {{ j('blob', '$.org') }}               as client_id,
    {{ j('blob', '$.schema_version') }}    as schema_version,
    {{ j('f', '$.kind') }}                 as kind,
    f                                      as frame
from src, {{ jarr('blob', '$.frames') }} as t(f)
