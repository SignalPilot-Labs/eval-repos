-- One row per exposure event, conformed columns.
select
    exposure_id,
    enrollment_id,
    client_id,
    test_key      as experiment_key,
    subject_key,
    exposure_ts,
    placement     as surface
from {{ ref('stg_meridian__exposures') }}
