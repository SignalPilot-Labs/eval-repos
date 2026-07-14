-- One row per export batch: test assignment plus user attributes.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'fjord_travel'

)

select
    {{ j('blob', '$.batch_id') }}                    as enrollment_id,
    'fjord_travel'                                   as client_id,
    {{ j('blob', '$.test.test_id') }}                as experiment_key,
    {{ j('blob', '$.user.ref') }}                    as subject_key,
    {{ j('blob', '$.test.cell') }}                   as cell,
    {{ ts_iso(j('blob', '$.test.entered')) }}        as assigned_ts,
    {{ j('blob', '$.user.market') }}                 as market,
    {{ j('blob', '$.metric_list') }}                 as metric_list,
    {{ j('blob', '$.schema_version') }}              as schema_version
from src
