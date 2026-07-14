-- One row per market and experiment.
with enrollments as (

    select * from {{ ref('int_fjord__enrollments') }}

),

markets as (

    select enrollment_id, market
    from {{ ref('stg_fjord__enrollments') }}

)

select
    m.market,
    en.experiment_key,
    count(*)                              as enrollments,
    count(*) filter (where en.converted)  as converted_enrollments,
    sum(en.revenue_usd)                   as revenue_usd
from enrollments en
join markets m using (enrollment_id)
group by 1, 2
