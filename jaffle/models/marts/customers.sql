-- Customer grain (one row per customer). Lifetime spend = sum of order revenue.
select
    c.customer_id,
    c.customer_name,
    count(o.order_id)                       as lifetime_orders,
    coalesce(sum(o.subtotal_usd), 0)        as lifetime_spend_usd
from {{ ref('stg_customers') }} c
left join {{ ref('orders') }} o on c.customer_id = o.customer_id
group by 1, 2
