with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'fjord_travel'

)

select
    {{ j('blob', '$.user.market') }}                    as market,
    count(*)                                            as enrollment_count,
    min({{ ts_iso(j('blob', '$.test.entered')) }})      as first_entered_ts
from src
group by 1
