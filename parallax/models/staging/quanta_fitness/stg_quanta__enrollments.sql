-- One row per enrollment document: assign frame joined to its subject frame.
with frames as (

    select * from {{ ref('stg_quanta__frames') }}

),

assigns as (

    select
        stream_id,
        client_id,
        schema_version,
        {{ j('frame', '$.enrollment') }}          as enrollment_id,
        {{ j('frame', '$.test') }}                as experiment_key,
        {{ j('frame', '$.arm') }}                 as variant,
        {{ ts_iso(j('frame', '$.at')) }}          as assigned_ts,
        {{ j('frame', '$.sdk') }}                 as sdk_version
    from frames
    where kind = 'assign'

),

subjects as (

    select
        stream_id,
        {{ j('frame', '$.key') }}                 as subject_key,
        {{ ts_iso(j('frame', '$.seen')) }}        as first_seen_ts,
        {{ j('frame', '$.platform') }}            as platform
    from frames
    where kind = 'subject'

)

select
    a.enrollment_id,
    a.client_id,
    a.experiment_key,
    s.subject_key,
    a.variant,
    a.assigned_ts,
    a.sdk_version,
    a.schema_version,
    s.platform,
    s.first_seen_ts,
    a.stream_id
from assigns a
join subjects s using (stream_id)
