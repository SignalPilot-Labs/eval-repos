-- One row per outcome event.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'helios_media'

)

select
    {{ j('e', '$.oid') }}                             as event_id,
    {{ j('blob', '$.testing.enrollment.id') }}        as enrollment_id,
    {{ j('blob', '$.client') }}                       as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}  as experiment_key,
    {{ j('blob', '$.session.user_ref') }}             as subject_key,
    {{ j('e', '$.kind') }}                            as kind,
    {{ ts_epoch_ms(j('e', '$.at')) }}                 as event_ts,
    cast({{ jnum('e', '$.units') }} as integer)       as quantity,
    {{ jnum('e', '$.amount') }}                       as amount_usd
from src, {{ jarr('blob', '$.testing.outcomes') }} as t(e)
