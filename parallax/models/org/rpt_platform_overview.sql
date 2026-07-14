-- Weekly platform rollup. One row per (week, client).
select
    date_trunc('week', assigned_ts) as week_start,
    client_id,
    count(*)                        as enrollments,
    count(distinct subject_key)     as subjects,
    sum(conversion_count)           as conversions,
    round((sum(revenue_usd))::numeric, 2)      as revenue_usd
from {{ ref('int_all__enrollments') }}
group by 1, 2
