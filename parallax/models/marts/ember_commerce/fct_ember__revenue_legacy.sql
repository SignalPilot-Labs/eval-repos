-- Experiment-level revenue rollup. Superseded by fct_ember__experiment_results.
select
    experiment_key,
    count(*) filter (where order_amount is not null) as order_docs,
    sum(order_amount)                                as revenue
from {{ ref('stg_ember__revisions') }}
group by 1
