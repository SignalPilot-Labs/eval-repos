-- One row per metric frame as emitted by the SDK.
with frames as (

    select * from {{ ref('stg_quanta__frames') }}

),

enrollments as (

    select stream_id, enrollment_id, client_id, experiment_key, subject_key
    from {{ ref('stg_quanta__enrollments') }}

)

select
    {{ j('f.frame', '$.id') }}                              as event_id,
    en.enrollment_id,
    en.client_id,
    en.experiment_key,
    en.subject_key,
    {{ j('f.frame', '$.name') }}                            as metric,
    {{ ts_iso(j('f.frame', '$.at')) }}                      as event_ts,
    cast({{ jnum('f.frame', '$.qty') }} as integer)         as quantity,
    {{ jnum('f.frame', '$.val') }}                          as amount_usd,
    cast({{ jnum('f.frame', '$.retry_seq') }} as integer)   as retry_seq
from frames f
join enrollments en using (stream_id)
where f.kind = 'metric'
