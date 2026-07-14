-- One row per subject.
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
    {{ j('blob', '$.session.user_ref') }}                        as subject_key,
    {{ j('blob', '$.client') }}                                  as client_id,
    min({{ ts_iso(j('blob', '$.session.started_at')) }})         as first_seen_ts,
    max({{ j('blob', '$.session.device') }})                     as device,
    max({{ j('blob', '$.session.geo') }})                        as geo,
    count(*)                                                     as enrollment_count
from src
group by 1, 2
