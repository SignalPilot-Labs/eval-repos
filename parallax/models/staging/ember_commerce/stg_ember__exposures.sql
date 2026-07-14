-- One row per impression.
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
    {{ j('i', '$.imp_id') }}                             as exposure_id,
    {{ j('blob', '$.testing.enrollment.id') }}           as enrollment_id,
    {{ j('blob', '$.client') }}                          as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}     as experiment_key,
    {{ j('blob', '$.session.user_ref') }}                as subject_key,
    {{ ts_iso(j('i', '$.at')) }}                         as exposure_ts,
    {{ j('i', '$.placement') }}                          as placement
from src, {{ jarr('blob', '$.testing.impressions') }} as t(i)
