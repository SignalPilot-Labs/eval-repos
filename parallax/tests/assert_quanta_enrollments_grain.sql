-- Enrollment ids must be unique at the enrollment grain.
select
    enrollment_id,
    count(*) as row_count
from {{ ref('int_quanta__enrollments') }}
group by 1
having count(*) > 1
