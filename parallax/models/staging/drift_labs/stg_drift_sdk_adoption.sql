with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'drift_labs'

)

select
    {{ j('blob', '$.assignment.sdk_version') }}                as sdk_version,
    count(*)                                                   as enrollment_count,
    min({{ ts_iso(j('blob', '$.assignment.assigned_ts')) }})   as first_assigned_ts,
    max({{ ts_iso(j('blob', '$.assignment.assigned_ts')) }})   as last_assigned_ts
from src
group by 1
