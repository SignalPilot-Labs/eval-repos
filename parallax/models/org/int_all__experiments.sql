-- All clients' experiments, conformed. One row per (client, experiment_key).
{% set clients = ['northwind', 'drift', 'granite', 'helios', 'ember', 'meridian', 'quanta', 'halcyon', 'fjord'] %}
{% for c in clients %}
select
    experiment_key,
    client_id,
    experiment_name,
    randomization_unit,
    status,
    start_ts,
    end_ts,
    variant_count,
    primary_metric
from {{ ref('int_' ~ c ~ '__experiments') }}
{% if not loop.last %}union all{% endif %}
{% endfor %}
