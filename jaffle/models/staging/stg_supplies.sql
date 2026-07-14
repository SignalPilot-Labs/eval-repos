-- Supply master. One row per (supply, product-sku it is used for). A product uses many supplies,
-- so this is 1-to-many below product grain. Cost converted cents -> dollars.
select
    id                         as supply_id,
    sku                        as product_sku,
    name                       as supply_name,
    (cost / 100.0)::numeric(18,2)   as supply_cost_usd,
    (perishable in ('True','true','t')) as is_perishable
from {{ source('raw', 'supplies') }}
