-- Enrollment ids must be unique at the enrollment grain.
select
    enrollment_id,
    count(*) as row_count
from {{ ref('int_meridian__enrollments') }}
group by 1
having count(*) > 1
