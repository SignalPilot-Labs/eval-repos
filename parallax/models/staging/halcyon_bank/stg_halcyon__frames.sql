-- One row per frame in the event stream, tagged with its document identity.
with src as (

    select load_id, blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'halcyon_bank'

),

exploded as (

    select
        {{ j('blob', '$.stream_id') }}         as stream_id,
        {{ j('blob', '$.org') }}               as client_id,
        {{ j('blob', '$.schema_version') }}    as schema_version,
        load_id,
        t.frame
    from src,
        {{ jarr('blob', '$.frames') }} as t(frame)

)

select
    stream_id,
    client_id,
    schema_version,
    load_id,
    {{ j('frame', '$.kind') }}    as kind,
    frame,
    max(case when {{ j('frame', '$.kind') }} = 'assign'
             then {{ j('frame', '$.enrollment') }} end)
        over (partition by stream_id)    as enrollment_id,
    max(case when {{ j('frame', '$.kind') }} = 'assign'
             then {{ j('frame', '$.test') }} end)
        over (partition by stream_id)    as experiment_key,
    max(case when {{ j('frame', '$.kind') }} = 'subject'
             then {{ j('frame', '$.key') }} end)
        over (partition by stream_id)    as subject_key
from exploded
