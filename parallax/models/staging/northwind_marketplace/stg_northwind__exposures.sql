-- One row per exposure impression.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'northwind_marketplace'

)

select
    {{ j('e', '$.exposure_id') }}                     as exposure_id,
    {{ j('blob', '$.assignment.enrollment_id') }}     as enrollment_id,
    {{ j('blob', '$.client_id') }}                    as client_id,
    {{ j('blob', '$.assignment.experiment_key') }}    as experiment_key,
    {{ j('blob', '$.subject.subject_key') }}          as subject_key,
    {{ ts_iso(j('e', '$.ts')) }}                      as exposure_ts,
    {{ j('e', '$.surface') }}                         as surface
from src, {{ jarr('blob', '$.exposures') }} as t(e)
