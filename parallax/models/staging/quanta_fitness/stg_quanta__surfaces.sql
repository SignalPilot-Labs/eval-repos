select
    surface,
    count(*)              as exposure_count,
    min(exposure_ts)      as first_seen_ts
from {{ ref('stg_quanta__exposures') }}
group by 1
