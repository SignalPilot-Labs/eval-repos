-- One row per outcome event.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'meridian_wellness'

)

select
    {{ j('o', '$.oid') }}                                 as event_id,
    {{ j('blob', '$.testing.enrollment.id') }}            as enrollment_id,
    {{ j('blob', '$.client') }}                           as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}      as test_key,
    {{ j('blob', '$.session.user_ref') }}                 as subject_key,
    {{ j('o', '$.kind') }}                                as kind,
    {{ ts_date(j('o', '$.at')) }}                         as event_ts,
    cast({{ jnum('o', '$.units') }} as integer)           as quantity,
    {{ jnum('o', '$.amount') }}                           as amount_usd
from src, {{ jarr('blob', '$.testing.outcomes') }} as t(o)
