-- Experiment-level deposit rollup. Superseded by fct_halcyon__experiment_results.
select
    experiment_key,
    count(*)          as deposit_events,
    sum(val_minor)    as revenue
from {{ ref('stg_halcyon__metric_events') }}
where metric = 'funding_deposit'
group by 1
