-- One row per impression.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'meridian_wellness'

)

select
    {{ j('imp', '$.imp_id') }}                            as exposure_id,
    {{ j('blob', '$.testing.enrollment.id') }}            as enrollment_id,
    {{ j('blob', '$.client') }}                           as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}      as test_key,
    {{ j('blob', '$.session.user_ref') }}                 as subject_key,
    {{ ts_iso(j('imp', '$.at')) }}                        as exposure_ts,
    {{ j('imp', '$.placement') }}                         as placement
from src, {{ jarr('blob', '$.testing.impressions') }} as t(imp)
