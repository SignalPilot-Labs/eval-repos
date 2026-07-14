-- One row per enrollment: the assign frame plus subject attributes.
with frames as (

    select * from {{ ref('stg_halcyon__frames') }}

),

assigns as (

    select stream_id, client_id, schema_version, frame
    from frames
    where kind = 'assign'

),

subjects as (

    select
        stream_id,
        {{ j('frame', '$.key') }}         as subject_key,
        {{ j('frame', '$.platform') }}    as platform
    from frames
    where kind = 'subject'

)

select
    {{ j('a.frame', '$.enrollment') }}          as enrollment_id,
    a.client_id,
    {{ j('a.frame', '$.test') }}                as experiment_key,
    s.subject_key,
    {{ j('a.frame', '$.arm') }}                 as variant,
    {{ ts_iso(j('a.frame', '$.at')) }}          as assigned_ts,
    {{ j('a.frame', '$.sdk') }}                 as sdk_version,
    a.schema_version,
    s.platform,
    a.stream_id
from assigns a
left join subjects s using (stream_id)
