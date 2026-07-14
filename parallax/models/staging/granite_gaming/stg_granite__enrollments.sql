-- One row per enrollment document: assignment fields plus subject attributes.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'granite_gaming'

)

select
    {{ j('blob', '$.assignment.enrollment_id') }}                as enrollment_id,
    {{ j('blob', '$.client_id') }}                               as client_id,
    {{ j('blob', '$.assignment.experiment_key') }}               as experiment_key,
    {{ j('blob', '$.subject.subject_key') }}                     as subject_key,
    {{ j('blob', '$.assignment.variant') }}                      as variant,
    {{ ts_iso(j('blob', '$.assignment.assigned_ts')) }}          as assigned_ts,
    {{ j('blob', '$.assignment.sdk_version') }}                  as sdk_version,
    {{ j('blob', '$.schema_version') }}                          as schema_version,
    {{ j('blob', '$.subject.platform') }}                        as platform,
    {{ j('blob', '$.subject.region') }}                          as region,
    cast({{ j('blob', '$.subject.is_internal') }} as boolean)    as is_internal
from src
