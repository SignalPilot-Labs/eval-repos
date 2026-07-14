-- One row per surface and experiment: where players see tests in the game.
with exposures as (

    select * from {{ ref('int_granite__exposures') }}

),

enrollments as (

    select enrollment_id, variant, converted, revenue_usd
    from {{ ref('int_granite__enrollments') }}

)

select
    ex.surface,
    ex.experiment_key,
    count(*)                                        as exposures,
    count(distinct ex.enrollment_id)                as exposed_enrollments,
    count(distinct ex.enrollment_id)
        filter (where en.converted)                 as converted_enrollments
from exposures ex
left join enrollments en using (enrollment_id)
group by 1, 2
