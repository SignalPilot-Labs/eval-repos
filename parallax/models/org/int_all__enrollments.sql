-- All clients' enrollments, conformed. One row per enrollment.
{% set clients = ['northwind', 'drift', 'granite', 'helios', 'ember', 'meridian', 'quanta', 'halcyon', 'fjord'] %}
{% for c in clients %}
select
    enrollment_id,
    client_id,
    experiment_key,
    subject_key,
    variant,
    assigned_ts,
    sdk_version,
    platform,
    is_internal_subject,
    exposure_count,
    first_exposure_ts,
    event_count,
    conversion_count,
    converted,
    revenue_usd
from {{ ref('int_' ~ c ~ '__enrollments') }}
{% if not loop.last %}union all{% endif %}
{% endfor %}
