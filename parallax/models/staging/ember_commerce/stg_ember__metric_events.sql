-- One row per outcome event.
with src as (

    select blob
    from (
        select
            blob,
            row_number() over (
                partition by {{ j('blob', '$.testing.enrollment.id') }}
                order by cast({{ j('blob', '$.revision') }} as integer) desc
            ) as rn
        from {{ source('raw', 'client_blob') }}
        where source_client = 'ember_commerce'
    ) ranked
    where rn = 1

)

select
    {{ j('o', '$.oid') }}                                as event_id,
    {{ j('blob', '$.testing.enrollment.id') }}           as enrollment_id,
    {{ j('blob', '$.client') }}                          as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}     as experiment_key,
    {{ j('blob', '$.session.user_ref') }}                as subject_key,
    {{ j('o', '$.kind') }}                               as kind,
    {{ ts_iso(j('o', '$.at')) }}                         as event_ts,
    cast({{ jnum('o', '$.units') }} as integer)          as quantity,
    {{ jnum('o', '$.amount') }}                          as amount_usd
from src, {{ jarr('blob', '$.testing.outcomes') }} as t(o)
