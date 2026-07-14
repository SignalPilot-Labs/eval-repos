-- Experiment-level revenue rollup. Superseded by fct_northwind__experiment_results.
select
    experiment_key,
    count(*)          as order_events,
    sum(value_micros) as revenue
from {{ ref('stg_northwind__metric_events') }}
where metric = 'order_complete'
group by 1
