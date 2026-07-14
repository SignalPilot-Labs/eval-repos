-- One row per region and experiment.
with enrollments as (

    select * from {{ ref('int_northwind__enrollments') }}

),

regions as (

    select enrollment_id, region
    from {{ ref('stg_northwind__enrollments') }}

)

select
    r.region,
    en.experiment_key,
    count(*)                              as enrollments,
    count(*) filter (where en.converted)  as converted_enrollments,
    sum(en.revenue_usd)                   as revenue_usd
from enrollments en
join regions r using (enrollment_id)
group by 1, 2
