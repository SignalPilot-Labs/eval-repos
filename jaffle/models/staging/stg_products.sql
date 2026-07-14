-- Product master (one row per sku). Price converted cents -> dollars.
select
    sku                        as product_sku,
    name                       as product_name,
    type                       as product_type,
    (price / 100.0)::numeric(18,2)  as product_price_usd,
    description                as product_description
from {{ source('raw', 'products') }}
