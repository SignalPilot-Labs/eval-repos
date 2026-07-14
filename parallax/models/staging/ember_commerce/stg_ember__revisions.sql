-- One row per submitted document, all revisions.
with src as (

    select load_id, blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'ember_commerce'

)

select
    {{ j('blob', '$.testing.enrollment.id') }}                   as enrollment_id,
    cast({{ j('blob', '$.revision') }} as integer)               as revision,
    cast({{ j('blob', '$.superseded') }} as boolean)             as superseded,
    load_id,
    {{ j('blob', '$.testing.enrollment.test_key') }}             as experiment_key,
    {{ j('blob', '$.session.user_ref') }}                        as subject_key,
    {{ ts_iso(j('blob', '$.testing.enrollment.bucketed_at')) }}  as bucketed_at,
    {{ jarr_len('blob', '$.testing.impressions') }}              as impression_count,
    {{ jarr_len('blob', '$.testing.outcomes') }}                 as outcome_count,
    (
        select sum({{ jnum('o', '$.amount') }})
        from {{ jarr('blob', '$.testing.outcomes') }} as t(o)
        where {{ j('o', '$.kind') }} = 'order_complete'
    )                                                            as order_amount,
    (
        select sum({{ jnum('o', '$.amount') }})
        from {{ jarr('blob', '$.testing.outcomes') }} as t(o)
    )                                                            as monetary_amount
from src
