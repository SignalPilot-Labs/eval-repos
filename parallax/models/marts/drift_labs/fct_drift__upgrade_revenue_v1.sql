-- Upgrade revenue by experiment and variant. Superseded by fct_drift__experiment_results.
with enrollments as (

    select enrollment_id, experiment_key, variant
    from {{ ref('stg_drift__enrollments') }}

),

upgrades as (

    select enrollment_id, amount_usd
    from {{ ref('stg_drift__metric_events') }}
    where metric = 'plan_upgrade'

)

select
    en.experiment_key,
    en.variant,
    count(u.enrollment_id)         as upgrade_events,
    coalesce(sum(u.amount_usd), 0) as upgrade_revenue_usd
from enrollments en
left join upgrades u using (enrollment_id)
group by 1, 2
