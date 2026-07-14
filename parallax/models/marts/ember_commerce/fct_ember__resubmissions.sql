-- One row per enrollment that was submitted more than once.
with history as (

    select * from {{ ref('stg_ember__revisions') }}

)

select
    enrollment_id,
    experiment_key,
    subject_key,
    count(*)                                          as submission_count,
    max(revision)                                     as latest_revision,
    min(bucketed_at)                                  as bucketed_at,
    sum(outcome_count)                                as total_outcome_rows,
    max(monetary_amount) filter (where not superseded) as latest_amount,
    sum(monetary_amount) filter (where superseded)     as superseded_amount
from history
group by 1, 2, 3
having count(*) > 1
