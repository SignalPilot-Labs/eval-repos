-- One row per subject.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'northwind_marketplace'

)

select
    {{ j('blob', '$.subject.subject_key') }}                      as subject_key,
    {{ j('blob', '$.client_id') }}                                as client_id,
    min({{ ts_iso(j('blob', '$.subject.first_seen_ts')) }})       as first_seen_ts,
    max({{ j('blob', '$.subject.platform') }})                    as platform,
    max({{ j('blob', '$.subject.region') }})                      as region,
    bool_or(cast({{ j('blob', '$.subject.is_internal') }} as boolean)) as is_internal,
    count(*)                                                      as enrollment_count
from src
group by 1, 2
