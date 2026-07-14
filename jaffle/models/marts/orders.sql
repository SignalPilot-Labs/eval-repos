-- Order grain (one row per order). Revenue (subtotal) is rolled up from the order's line items.
with items as (
    select
        oi.order_id,
        sum(oi.product_price_usd) as subtotal_usd
    from {{ ref('order_items') }} oi
    join {{ ref('stg_supplies') }} sup
        on oi.product_sku = sup.product_sku
       and sup.is_perishable
    group by oi.order_id
)
select
    o.order_id,
    o.customer_id,
    o.store_id,
    o.ordered_at,
    items.subtotal_usd,
    o.tax_paid_usd,
    (items.subtotal_usd + o.tax_paid_usd) as order_total_usd
from {{ ref('stg_orders') }} o
left join items on o.order_id = items.order_id
