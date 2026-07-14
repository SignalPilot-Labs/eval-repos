-- One row per subject.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'meridian_wellness'

)

select
    {{ j('blob', '$.session.user_ref') }}                      as subject_key,
    {{ j('blob', '$.client') }}                                as client_id,
    min({{ ts_iso(j('blob', '$.session.started_at')) }})       as first_seen_ts,
    max({{ j('blob', '$.session.device') }})                   as device,
    max({{ j('blob', '$.session.geo') }})                      as geo,
    count(*)                                                   as enrollment_count
from src
group by 1, 2
