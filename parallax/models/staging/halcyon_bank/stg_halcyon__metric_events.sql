-- One row per metric frame.
with frames as (

    select * from {{ ref('stg_halcyon__frames') }}
    where kind = 'metric'

),

fx as (

    select * from {{ ref('fx_rates') }}

)

select
    {{ j('f.frame', '$.id') }}                        as event_id,
    f.enrollment_id,
    f.client_id,
    f.experiment_key,
    f.subject_key,
    {{ j('f.frame', '$.name') }}                      as metric,
    {{ ts_iso(j('f.frame', '$.at')) }}                as event_ts,
    cast({{ jnum('f.frame', '$.qty') }} as integer)   as quantity,
    cast({{ jnum('f.frame', '$.val') }} as bigint)    as val_minor,
    {{ j('f.frame', '$.ccy') }}                       as ccy,
    ({{ jnum('f.frame', '$.val') }})::numeric
        / (fx.minor_unit_divisor)::numeric * fx.usd_rate    as amount_usd
from frames f
left join fx
    on fx.ccy = {{ j('f.frame', '$.ccy') }}
