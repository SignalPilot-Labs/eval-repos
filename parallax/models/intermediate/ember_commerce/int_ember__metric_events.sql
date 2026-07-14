-- One row per metric event, conformed columns.
with events as (

    select * from {{ ref('stg_ember__metric_events') }}

),

xref as (

    select * from {{ ref('metric_xref') }}
    where client_id = 'ember_commerce'

)

select
    e.event_id,
    e.enrollment_id,
    e.client_id,
    e.experiment_key,
    e.subject_key,
    x.canonical_metric                              as metric_key,
    e.event_ts,
    e.quantity,
    case when x.is_monetary then e.amount_usd end   as amount_usd,
    coalesce(x.is_conversion, false)                as is_conversion,
    coalesce(x.canonical_metric = 'refund', false)  as is_refund
from events e
left join xref x
    on x.raw_metric = e.kind
