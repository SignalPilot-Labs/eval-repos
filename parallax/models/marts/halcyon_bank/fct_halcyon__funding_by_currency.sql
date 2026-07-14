-- One row per settlement currency: monetary event totals.
with events as (

    select * from {{ ref('stg_halcyon__metric_events') }}
    where ccy is not null

)

select
    ccy,
    count(*)                                             as monetary_events,
    count(*) filter (where metric = 'funding_deposit')   as deposit_events,
    count(*) filter (where metric = 'refund')            as refund_events,
    sum(amount_usd)                                      as net_amount_usd
from events
group by 1
