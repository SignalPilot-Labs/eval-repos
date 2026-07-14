-- One row per subject with lifetime test activity.
with subjects as (

    select * from {{ ref('stg_fjord__subjects') }}

),

activity as (

    select
        subject_key,
        count(*)                           as enrollments,
        sum(conversion_count)              as conversions,
        sum(revenue_usd)                   as revenue_usd,
        max(assigned_ts)                   as last_assigned_ts
    from {{ ref('int_fjord__enrollments') }}
    group by 1

)

select
    s.subject_key,
    s.client_id,
    s.market,
    s.first_entered_ts,
    coalesce(a.enrollments, 0)   as enrollments,
    coalesce(a.conversions, 0)   as conversions,
    coalesce(a.revenue_usd, 0)   as revenue_usd,
    a.last_assigned_ts
from subjects s
left join activity a using (subject_key)
