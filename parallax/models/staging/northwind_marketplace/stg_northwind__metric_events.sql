-- One row per metric event.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'northwind_marketplace'

)

select
    {{ j('e', '$.event_id') }}                        as event_id,
    {{ j('blob', '$.assignment.enrollment_id') }}     as enrollment_id,
    {{ j('blob', '$.client_id') }}                    as client_id,
    {{ j('blob', '$.assignment.experiment_key') }}    as experiment_key,
    {{ j('blob', '$.subject.subject_key') }}          as subject_key,
    {{ j('e', '$.metric') }}                          as metric,
    {{ ts_iso(j('e', '$.ts')) }}                      as event_ts,
    cast({{ jnum('e', '$.qty') }} as integer)         as quantity,
    cast({{ jnum('e', '$.value') }} as bigint)        as value_micros,
    {{ jnum('e', '$.value') }} / 1000000.0            as amount_usd
from src, {{ jarr('blob', '$.events') }} as t(e)
