-- One row per platform and experiment.
select
    platform,
    experiment_key,
    count(*)                              as enrollments,
    count(*) filter (where converted)     as converted_enrollments,
    sum(exposure_count)                   as exposures,
    sum(revenue_usd)                      as revenue_usd
from {{ ref('int_quanta__enrollments') }}
group by 1, 2
