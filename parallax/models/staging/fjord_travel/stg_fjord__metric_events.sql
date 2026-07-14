-- One row per hit.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'fjord_travel'

)

select
    {{ j('h', '$.h') }}                       as event_id,
    {{ j('blob', '$.batch_id') }}             as enrollment_id,
    'fjord_travel'                            as client_id,
    {{ j('blob', '$.test.test_id') }}         as experiment_key,
    {{ j('blob', '$.user.ref') }}             as subject_key,
    {{ j('h', '$.m') }}                       as metric,
    {{ ts_iso(j('h', '$.t')) }}               as event_ts,
    cast({{ jnum('h', '$.q') }} as integer)   as quantity,
    {{ jnum('h', '$.amt') }}                  as amount_usd
from src, {{ jarr('blob', '$.hits') }} as t(h)
