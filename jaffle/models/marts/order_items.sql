-- Order-item grain with the product price attached. One row per line item.
select
    oi.order_item_id,
    oi.order_id,
    oi.product_sku,
    p.product_type,
    p.product_price_usd
from {{ ref('stg_order_items') }} oi
left join {{ ref('stg_products') }} p on oi.product_sku = p.product_sku
