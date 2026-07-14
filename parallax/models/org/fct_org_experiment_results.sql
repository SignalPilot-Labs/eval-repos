-- Platform readout. One row per (client, canonical experiment, variant).
with enrollments as (
    select * from {{ ref('int_org__enrollments_canonical') }}
)

select
    client_id,
    canonical_experiment_key,
    variant,
    count(*)                                                as enrollments,
    count(*) filter (where is_internal_subject)             as internal_enrollments,
    count(*) filter (where exposure_count > 0)              as exposed_enrollments,
    round((count(*) filter (where exposure_count > 0) * 1.0 / count(*))::numeric, 4) as exposure_rate,
    sum(conversion_count)                                   as conversions,
    count(*) filter (where converted)                       as converted_enrollments,
    round((count(*) filter (where converted) * 1.0 / count(*))::numeric, 4) as conversion_rate,
    round((sum(revenue_usd))::numeric, 2)                              as revenue_usd,
    round((sum(revenue_usd) / count(*))::numeric, 4)                   as revenue_per_enrollment_usd
from enrollments
group by 1, 2, 3
