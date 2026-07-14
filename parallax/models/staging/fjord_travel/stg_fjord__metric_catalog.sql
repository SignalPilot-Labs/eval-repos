-- One row per batch and listed metric, from the metric_list catalog string.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'fjord_travel'

)

select
    {{ j('blob', '$.batch_id') }}                                      as enrollment_id,
    {{ j('blob', '$.test.test_id') }}                                  as experiment_key,
    unnest(string_to_array({{ j('blob', '$.metric_list') }}, '|'))     as metric
from src
