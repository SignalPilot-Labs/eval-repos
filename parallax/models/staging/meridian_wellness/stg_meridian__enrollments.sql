with rows as (

-- One row per enrollment document: assignment fields plus session attributes.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'meridian_wellness'

)

select
    {{ j('blob', '$.testing.enrollment.id') }}                    as enrollment_id,
    {{ j('blob', '$.client') }}                                   as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}              as test_key,
    {{ j('blob', '$.session.user_ref') }}                         as subject_key,
    {{ j('blob', '$.testing.enrollment.bucket') }}                as bucket,
    {{ ts_iso(j('blob', '$.testing.enrollment.bucketed_at')) }}   as bucketed_at,
    {{ j('blob', '$.testing.enrollment.sdk') }}                   as sdk_version,
    {{ j('blob', '$.session.session_id') }}                       as session_id,
    {{ ts_iso(j('blob', '$.session.started_at')) }}               as session_started_at,
    {{ j('blob', '$.session.device') }}                           as device,
    {{ j('blob', '$.session.geo') }}                              as geo,
    {{ j('blob', '$.schema_version') }}                           as schema_version
from src

)

select * from rows
where bucketed_at >= '2025-12-01'
