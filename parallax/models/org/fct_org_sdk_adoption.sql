-- SDK version adoption. One row per (client, sdk_version, platform).
select
    client_id,
    sdk_version,
    platform,
    count(*)                    as enrollments,
    min(assigned_ts)            as first_seen_ts,
    max(assigned_ts)            as last_seen_ts
from {{ ref('int_all__enrollments') }}
group by 1, 2, 3
