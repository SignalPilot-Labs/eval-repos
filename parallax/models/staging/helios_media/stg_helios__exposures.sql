with rows as (

-- One row per impression.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'helios_media'

)

select
    {{ j('e', '$.imp_id') }}                          as exposure_id,
    {{ j('blob', '$.testing.enrollment.id') }}        as enrollment_id,
    {{ j('blob', '$.client') }}                       as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}  as experiment_key,
    {{ j('blob', '$.session.user_ref') }}             as subject_key,
    {{ ts_epoch_ms(j('e', '$.at')) }}                 as exposure_ts,
    {{ j('e', '$.placement') }}                       as placement
from src, {{ jarr('blob', '$.testing.impressions') }} as t(e)

)

select * from rows
where exposure_ts >= '2025-12-01'
