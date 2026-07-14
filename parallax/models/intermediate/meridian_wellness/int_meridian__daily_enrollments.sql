-- Daily enrollment counts per experiment and variant.
select
    cast(assigned_ts as date)            as enrollment_date,
    experiment_key,
    variant,
    count(*)                             as enrollments,
    count(*) filter (where converted)    as converted_enrollments,
    sum(revenue_usd)                     as revenue_usd
from {{ ref('int_meridian__enrollments') }}
group by 1, 2, 3
