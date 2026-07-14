{% set clients = ['northwind', 'drift', 'granite', 'helios', 'ember', 'meridian', 'quanta', 'halcyon', 'fjord'] %}
{% for c in clients %}
select
    event_id,
    enrollment_id,
    client_id,
    experiment_key,
    subject_key,
    metric_key,
    event_ts,
    quantity,
    amount_usd,
    is_conversion,
    is_refund
from {{ ref('int_' ~ c ~ '__metric_events') }}
{% if not loop.last %}union all{% endif %}
{% endfor %}
