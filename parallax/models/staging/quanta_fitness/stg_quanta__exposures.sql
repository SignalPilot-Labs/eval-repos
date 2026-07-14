with rows as (

-- One row per exposure frame.
with frames as (

    select * from {{ ref('stg_quanta__frames') }}

),

enrollments as (

    select stream_id, enrollment_id, client_id, experiment_key, subject_key
    from {{ ref('stg_quanta__enrollments') }}

)

select
    {{ j('f.frame', '$.id') }}               as exposure_id,
    en.enrollment_id,
    en.client_id,
    en.experiment_key,
    en.subject_key,
    {{ ts_iso(j('f.frame', '$.at')) }}       as exposure_ts,
    {{ j('f.frame', '$.surface') }}          as surface
from frames f
join enrollments en using (stream_id)
where f.kind = 'expose'

)

select * from rows
where exposure_ts >= '2025-12-01'
