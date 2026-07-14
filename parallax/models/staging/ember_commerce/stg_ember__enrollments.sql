-- One row per enrollment: assignment fields plus session attributes.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'ember_commerce'

),

ranked as (

    select
        blob,
        row_number() over (
            partition by {{ j('blob', '$.testing.enrollment.id') }}
            order by cast({{ j('blob', '$.revision') }} as integer) desc
        ) as rn
    from src

)

select
    {{ j('blob', '$.testing.enrollment.id') }}                   as enrollment_id,
    {{ j('blob', '$.client') }}                                  as client_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}             as experiment_key,
    {{ j('blob', '$.session.user_ref') }}                        as subject_key,
    {{ j('blob', '$.testing.enrollment.bucket') }}               as bucket,
    {{ ts_iso(j('blob', '$.testing.enrollment.bucketed_at')) }}  as bucketed_at,
    {{ j('blob', '$.testing.enrollment.sdk') }}                  as sdk_version,
    {{ j('blob', '$.schema_version') }}                          as schema_version,
    {{ j('blob', '$.session.session_id') }}                      as session_id,
    {{ ts_iso(j('blob', '$.session.started_at')) }}              as session_started_at,
    {{ j('blob', '$.session.device') }}                          as device,
    {{ j('blob', '$.session.geo') }}                             as geo,
    cast({{ j('blob', '$.revision') }} as integer)               as revision
from ranked
where rn = 1
