-- Store grain (one row per store). Revenue rolled up from orders placed at the store.
select
    s.store_id,
    s.store_name,
    count(o.order_id)                  as order_count,
    coalesce(sum(o.subtotal_usd), 0)   as revenue_usd
from {{ ref('stg_stores') }} s
left join {{ ref('orders') }} o on s.store_id = o.store_id
group by 1, 2
