-- Per-experiment IAP rollup. Superseded by fct_granite__experiment_results.
select
    experiment_key,
    count(*)                          as purchase_events,
    count(distinct subject_key)       as purchasers,
    sum(amount_usd)                   as revenue
from {{ ref('stg_granite__metric_events') }}
where metric = 'iap_purchase'
group by 1
