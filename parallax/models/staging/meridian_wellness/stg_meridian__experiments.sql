-- Per-test aggregates over enrollment documents.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'meridian_wellness'

)

select
    {{ j('blob', '$.testing.enrollment.test_key') }}                  as test_key,
    max({{ j('blob', '$.client') }})                                  as client_id,
    min({{ ts_iso(j('blob', '$.testing.enrollment.bucketed_at')) }})  as first_bucketed_at,
    max({{ ts_iso(j('blob', '$.testing.enrollment.bucketed_at')) }})  as last_bucketed_at,
    count(distinct {{ j('blob', '$.testing.enrollment.bucket') }})    as observed_bucket_count,
    count(*)                                                          as enrollment_count
from src
group by 1
