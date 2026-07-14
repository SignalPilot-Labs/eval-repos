-- Customer master. One row per customer.
select
    id            as customer_id,
    name          as customer_name
from {{ source('raw', 'customers') }}
