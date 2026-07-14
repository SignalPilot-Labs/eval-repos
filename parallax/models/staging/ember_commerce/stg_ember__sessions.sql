-- One row per session.
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
    {{ j('blob', '$.session.session_id') }}              as session_id,
    {{ j('blob', '$.session.user_ref') }}                as subject_key,
    {{ ts_iso(j('blob', '$.session.started_at')) }}      as started_at,
    {{ j('blob', '$.session.device') }}                  as device,
    {{ j('blob', '$.session.geo') }}                     as geo,
    {{ j('blob', '$.testing.enrollment.id') }}           as enrollment_id
from src
