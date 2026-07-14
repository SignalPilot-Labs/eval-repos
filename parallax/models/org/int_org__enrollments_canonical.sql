-- Enrollments with the platform-canonical experiment key resolved.
with enrollments as (
    select * from {{ ref('int_all__enrollments') }}
),

xref as (
    select client_id, wire_key, canonical_key from {{ ref('experiment_xref') }}
)

select
    e.*,
    coalesce(x.canonical_key, e.experiment_key) as canonical_experiment_key
from enrollments e
left join xref x
    on x.client_id = e.client_id
   and x.wire_key = e.experiment_key
