-- Store master (one row per store/location).
select
    id            as store_id,
    name          as store_name,
    opened_at,
    tax_rate
from {{ source('raw', 'stores') }}
