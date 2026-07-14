-- One row per user ref.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'fjord_travel'

)

select
    {{ j('blob', '$.user.ref') }}                    as subject_key,
    'fjord_travel'                                   as client_id,
    max({{ j('blob', '$.user.market') }})            as market,
    min({{ ts_iso(j('blob', '$.test.entered')) }})   as first_entered_ts,
    count(*)                                         as enrollment_count
from src
group by 1, 2
