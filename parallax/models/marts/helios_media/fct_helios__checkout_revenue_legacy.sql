-- Experiment-level checkout revenue rollup. Superseded by fct_helios__experiment_results.
select
    experiment_key,
    count(*)          as checkout_events,
    sum(amount_usd)   as revenue
from {{ ref('stg_helios__metric_events') }}
where kind = 'checkout'
group by 1
