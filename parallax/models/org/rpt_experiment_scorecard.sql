-- Client-facing scorecard. One row per (client, canonical experiment).
with results as (
    select * from {{ ref('fct_org_experiment_results') }}
),

lift as (
    select * from {{ ref('fct_org_conversion_lift') }}
),

experiments as (
    select * from {{ ref('dim_org_experiments') }}
),

totals as (
    select
        client_id,
        canonical_experiment_key,
        sum(enrollments)                as enrollments,
        round((sum(revenue_usd))::numeric, 2)      as revenue_usd,
        max(exposure_rate)              as max_variant_exposure_rate
    from results
    group by 1, 2
),

best_variant as (
    select client_id, canonical_experiment_key, variant, conversion_lift, revenue_lift
    from (
        select l.*, row_number() over (
            partition by client_id, canonical_experiment_key
            order by conversion_lift desc nulls last
        ) as rn
        from lift l
    ) ranked
    where rn = 1
)

select
    t.client_id,
    t.canonical_experiment_key,
    x.experiment_name,
    x.status,
    x.start_ts,
    x.end_ts,
    x.primary_metric,
    t.enrollments,
    t.revenue_usd,
    b.variant           as leading_variant,
    b.conversion_lift   as leading_conversion_lift,
    b.revenue_lift      as leading_revenue_lift
from totals t
left join experiments x
    on x.client_id = t.client_id
   and x.canonical_experiment_key = t.canonical_experiment_key
left join best_variant b
    on b.client_id = t.client_id
   and b.canonical_experiment_key = t.canonical_experiment_key
