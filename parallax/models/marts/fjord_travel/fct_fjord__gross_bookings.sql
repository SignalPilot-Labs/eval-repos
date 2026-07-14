-- Experiment-level booking revenue rollup. Superseded by fct_fjord__experiment_results.
select
    experiment_key,
    count(*)          as booking_events,
    sum(amount_usd)   as revenue_usd
from {{ ref('stg_fjord__metric_events') }}
where amount_usd > 0
group by 1
