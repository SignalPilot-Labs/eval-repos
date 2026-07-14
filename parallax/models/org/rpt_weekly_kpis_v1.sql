-- Superseded by rpt_platform_overview.
{% set clients = ['northwind', 'drift', 'granite', 'helios', 'ember', 'meridian', 'fjord'] %}
with enrollments as (
{% for c in clients %}
    select client_id, assigned_ts, subject_key, conversion_count, revenue_usd
    from {{ ref('int_' ~ c ~ '__enrollments') }}
    {% if not loop.last %}union all{% endif %}
{% endfor %}
)

select
    date_trunc('week', assigned_ts) as week_start,
    count(*)                        as enrollments,
    count(distinct subject_key)     as subjects,
    sum(conversion_count)           as conversions,
    round((sum(revenue_usd))::numeric, 2)      as revenue_usd
from enrollments
group by 1
