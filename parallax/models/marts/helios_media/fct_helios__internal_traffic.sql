-- One row per experiment: internal-subject traffic share.
select
    experiment_key,
    client_id,
    count(*)                                                  as enrollments,
    count(*) filter (where is_internal_subject)               as internal_enrollments,
    count(*) filter (where is_internal_subject)
        / nullif(count(*), 0)::double precision               as internal_share,
    sum(event_count) filter (where is_internal_subject)       as internal_events,
    sum(revenue_usd) filter (where is_internal_subject)       as internal_revenue_usd
from {{ ref('int_helios__enrollments') }}
group by 1, 2
