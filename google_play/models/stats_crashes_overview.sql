{{ config(materialized='table') }}

-- EXPECTED SHAPE: 10 rows — REASON: raw stats_crashes_overview has 10 rows, 10 unique (package_name, date) combos

with source as (

    select *
    from {{ source('google_play', 'stats_crashes_overview') }}

),

final as (

    select
        cast('' as varchar)                     as source_relation,
        cast(date as date)                      as date_day,
        cast(package_name as varchar)           as package_name,
        cast(daily_crashes as bigint)           as crashes,
        cast(daily_anrs as bigint)              as anrs
    from source

)

select *
from final
