-- Order-item grain (one row per line item on an order).
select
    id        as order_item_id,
    order_id,
    sku       as product_sku
from {{ source('raw', 'items') }}
