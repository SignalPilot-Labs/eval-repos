-- Experiment x variant rollup over enrollments.
select
    experiment_key,
    client_id,
    variant,
    count(*)                                     as enrollments,
    count(*) filter (where exposure_count > 0)   as exposed_enrollments,
    sum(exposure_count)                          as exposures,
    count(*) filter (where converted)            as converted_enrollments,
    sum(conversion_count)                        as conversions,
    sum(revenue_usd)                             as revenue_usd
from {{ ref('int_fjord__enrollments') }}
group by 1, 2, 3
