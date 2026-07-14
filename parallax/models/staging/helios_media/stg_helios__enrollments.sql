-- One row per enrollment document: assignment fields plus session attributes.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'helios_media'

)

select
    {{ j('blob', '$.testing.enrollment.id') }}                     as enrollment_id,
    {{ j('blob', '$.client') }}                                    as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}               as experiment_key,
    {{ j('blob', '$.session.user_ref') }}                          as subject_key,
    {{ j('blob', '$.testing.enrollment.bucket') }}                 as bucket,
    {{ ts_epoch_ms(j('blob', '$.testing.enrollment.bucketed_at')) }} as bucketed_at,
    {{ j('blob', '$.testing.enrollment.sdk') }}                    as sdk_version,
    {{ j('blob', '$.schema_version') }}                            as schema_version,
    {{ j('blob', '$.session.session_id') }}                        as session_id,
    {{ ts_epoch_ms(j('blob', '$.session.started_at')) }}           as session_started_at,
    {{ j('blob', '$.session.device') }}                            as device,
    {{ j('blob', '$.session.geo') }}                               as geo,
    (
        ({{ j('blob', '$.session.user_ref') }} like 'qa-%'
         or {{ j('blob', '$.session.user_ref') }} like 'bot-%')
        and {{ j('blob', '$.session.device') }} = 'headless'
    )                                                              as is_internal
from src
