{% set clients = ['northwind', 'drift', 'granite', 'helios', 'ember', 'meridian', 'quanta', 'halcyon', 'fjord'] %}
{% for c in clients %}
select
    exposure_id,
    enrollment_id,
    client_id,
    experiment_key,
    subject_key,
    exposure_ts,
    surface
from {{ ref('int_' ~ c ~ '__exposures') }}
{% if not loop.last %}union all{% endif %}
{% endfor %}
