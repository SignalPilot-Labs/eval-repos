-- Order header grain (one row per order). Money converted from cents to dollars.
select
    id                         as order_id,
    customer                   as customer_id,
    store_id,
    ordered_at,
    (tax_paid    / 100.0)::numeric(18,2)  as tax_paid_usd
from {{ source('raw', 'orders') }}
