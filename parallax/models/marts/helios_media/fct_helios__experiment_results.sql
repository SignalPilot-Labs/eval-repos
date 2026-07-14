-- One row per experiment and variant: the standard readout.
with variant_metrics as (

    select * from {{ ref('int_helios__variant_metrics') }}

),

experiments as (

    select * from {{ ref('int_helios__experiments') }}

)

select
    ex.experiment_key,
    ex.experiment_name,
    ex.status,
    ex.primary_metric,
    vm.variant,
    vm.enrollments,
    vm.exposed_enrollments,
    vm.exposed_enrollments / nullif(vm.enrollments, 0)::double precision     as exposure_rate,
    vm.converted_enrollments,
    vm.converted_enrollments / nullif(vm.enrollments, 0)::double precision   as conversion_rate,
    vm.revenue_usd,
    vm.revenue_usd / nullif(vm.enrollments, 0)                     as revenue_per_enrollment
from variant_metrics vm
join experiments ex using (experiment_key)
