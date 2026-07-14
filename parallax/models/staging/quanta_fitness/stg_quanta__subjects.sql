-- One row per subject.
select
    subject_key,
    client_id,
    min(first_seen_ts)   as first_seen_ts,
    max(platform)        as platform,
    count(*)             as enrollment_count
from {{ ref('stg_quanta__enrollments') }}
group by 1, 2
