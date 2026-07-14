-- Event ids must be unique at the metric-event grain.
select
    event_id,
    count(*) as row_count
from {{ ref('int_quanta__metric_events') }}
group by 1
having count(*) > 1
