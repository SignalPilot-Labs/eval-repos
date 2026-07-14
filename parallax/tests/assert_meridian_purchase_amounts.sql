-- Purchase events carry positive amounts.
select *
from {{ ref('int_meridian__metric_events') }}
where metric_key = 'purchase'
  and (amount_usd is null or amount_usd <= 0)
