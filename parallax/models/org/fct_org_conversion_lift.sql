-- Variant-vs-control lift. One row per (client, canonical experiment, non-control variant).
with results as (
    select * from {{ ref('fct_org_experiment_results') }}
),

control as (
    select client_id, canonical_experiment_key, conversion_rate, revenue_per_enrollment_usd
    from results
    where variant = 'control'
)

select
    r.client_id,
    r.canonical_experiment_key,
    r.variant,
    r.enrollments,
    r.conversion_rate,
    c.conversion_rate                            as control_conversion_rate,
    case when c.conversion_rate > 0
         then round((r.conversion_rate / c.conversion_rate - 1)::numeric, 4) end as conversion_lift,
    r.revenue_per_enrollment_usd,
    c.revenue_per_enrollment_usd                 as control_revenue_per_enrollment_usd,
    case when c.revenue_per_enrollment_usd > 0
         then round((r.revenue_per_enrollment_usd / c.revenue_per_enrollment_usd - 1)::numeric, 4) end as revenue_lift
from results r
join control c
    on c.client_id = r.client_id
   and c.canonical_experiment_key = r.canonical_experiment_key
where r.variant != 'control'
