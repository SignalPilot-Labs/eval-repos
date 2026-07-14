with rows as (

-- One row per impression.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'fjord_travel'

),

imps as (

    select
        {{ j('blob', '$.batch_id') }}                                 as enrollment_id,
        {{ j('blob', '$.test.test_id') }}                             as experiment_key,
        {{ j('blob', '$.user.ref') }}                                 as subject_key,
        t.elem                                                        as imp,
        t.seq                                                         as imp_seq
    from src, {{ jarr_ord('blob', '$.imps') }} as t(elem, seq)

)

select
    enrollment_id || '-' || imp_seq::text as exposure_id,
    enrollment_id,
    'fjord_travel'                        as client_id,
    experiment_key,
    subject_key,
    {{ ts_iso(j('imp', '$.t')) }}         as exposure_ts,
    {{ j('imp', '$.s') }}                 as surface
from imps

)

select * from rows
where exposure_ts >= '2025-12-01'
