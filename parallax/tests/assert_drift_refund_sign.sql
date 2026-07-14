-- Refund events carry non-positive amounts.
select *
from {{ ref('int_drift__metric_events') }}
where is_refund
  and amount_usd > 0
