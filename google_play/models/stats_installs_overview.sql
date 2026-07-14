{{ config(materialized='table') }}

-- EXPECTED SHAPE: 10 rows — REASON: raw stats_installs_overview has 10 rows, 10 unique (package_name, date) combos

with source as (

    select *
    from {{ source('google_play', 'stats_installs_overview') }}

),

final as (

    select
        cast('' as varchar)                                 as source_relation,
        cast(date as date)                                  as date_day,
        cast(package_name as varchar)                       as package_name,
        cast(active_device_installs as bigint)              as active_devices_last_30_days,
        cast(daily_device_installs as bigint)               as device_installs,
        cast(daily_device_uninstalls as bigint)             as device_uninstalls,
        cast(daily_device_upgrades as bigint)               as device_upgrades,
        cast(daily_user_installs as bigint)                 as user_installs,
        cast(daily_user_uninstalls as bigint)               as user_uninstalls,
        cast(install_events as bigint)                      as install_events,
        cast(uninstall_events as bigint)                    as uninstall_events,
        cast(update_events as bigint)                       as update_events
    from source

)

select *
from final
