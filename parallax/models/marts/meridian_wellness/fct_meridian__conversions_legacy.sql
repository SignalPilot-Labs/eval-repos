-- Experiment-level conversion rollup. Superseded by fct_meridian__experiment_results.
select
    test_key            as experiment_key,
    count(*)            as conversion_events,
    sum(amount_usd)     as revenue_usd
from {{ ref('stg_meridian__metric_events') }}
where kind = 'membership_purchase'
group by 1
