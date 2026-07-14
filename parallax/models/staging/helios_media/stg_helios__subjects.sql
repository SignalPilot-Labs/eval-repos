-- One row per subject.
with src as (

    select blob
    from {{ source('raw', 'client_blob') }}
    where source_client = 'helios_media'

)

select
    {{ j('blob', '$.session.user_ref') }}                          as subject_key,
    {{ j('blob', '$.client') }}                                    as client_id,
    min({{ ts_epoch_ms(j('blob', '$.session.started_at')) }})      as first_seen_ts,
    max({{ j('blob', '$.session.device') }})                       as device,
    max({{ j('blob', '$.session.geo') }})                          as geo,
    bool_or(
        ({{ j('blob', '$.session.user_ref') }} like 'qa-%'
         or {{ j('blob', '$.session.user_ref') }} like 'bot-%')
        and {{ j('blob', '$.session.device') }} = 'headless'
    )                                                              as is_internal,
    count(*)                                                       as enrollment_count
from src
group by 1, 2
