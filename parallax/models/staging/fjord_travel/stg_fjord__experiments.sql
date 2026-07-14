-- One row per test observed in the export, with enrollment aggregates.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'fjord_travel'

)

select
    {{ j('blob', '$.test.test_id') }}                    as experiment_key,
    'fjord_travel'                                       as client_id,
    count(*)                                             as enrollment_count,
    count(distinct {{ j('blob', '$.test.cell') }})       as observed_cell_count,
    min({{ ts_iso(j('blob', '$.test.entered')) }})       as first_entered_ts,
    max({{ ts_iso(j('blob', '$.test.entered')) }})       as last_entered_ts
from src
group by 1, 2
