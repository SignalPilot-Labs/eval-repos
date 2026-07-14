-- One row per client: attributed revenue and enrollment volumes.
with enrollments as (
    select * from {{ ref('int_all__enrollments') }}
)

select
    client_id,
    count(*)                        as enrollments,
    count(distinct subject_key)     as subjects,
    count(distinct experiment_key)  as experiments,
    sum(conversion_count)           as conversions,
    round((sum(revenue_usd))::numeric, 2)      as revenue_usd,
    round((sum(revenue_usd) filter (where not is_internal_subject))::numeric, 2) as revenue_usd_external
from enrollments
group by 1
