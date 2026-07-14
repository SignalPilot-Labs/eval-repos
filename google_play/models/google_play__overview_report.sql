{{ config(materialized='table') }}

-- EXPECTED SHAPE: union of distinct (package_name, date_day) across all 4 sources — REASON: FULL OUTER JOIN across installs/crashes/ratings/store_performance at (source_relation, package_name, date_day) grain

with installs as (

    select *
    from {{ ref('stats_installs_overview') }}

),

crashes as (

    select *
    from {{ ref('stats_crashes_overview') }}

),

ratings as (

    select *
    from {{ ref('stats_ratings_overview') }}

),

store_performance as (

    select *
    from {{ ref('int_google_play__store_performance') }}

),

install_metrics as (

    select
        *,
        sum(device_installs) over (
            partition by source_relation, package_name
            order by date_day asc
            rows between unbounded preceding and current row
        ) as total_device_installs,
        sum(device_uninstalls) over (
            partition by source_relation, package_name
            order by date_day asc
            rows between unbounded preceding and current row
        ) as total_device_uninstalls
    from installs

),

overview_join as (

    select
        -- grain columns: coalesce across all four sources
        coalesce(install_metrics.source_relation, crashes.source_relation, ratings.source_relation, store_performance.source_relation) as source_relation,
        coalesce(install_metrics.date_day, crashes.date_day, ratings.date_day, store_performance.date_day)                             as date_day,
        coalesce(install_metrics.package_name, crashes.package_name, ratings.package_name, store_performance.package_name)            as package_name,

        -- no OS version dimension at overview level
        cast(null as varchar)                                                                                                          as android_os_version,

        -- install metrics (coalesce to 0 when no matching record)
        coalesce(install_metrics.active_devices_last_30_days, 0)    as active_devices_last_30_days,
        coalesce(install_metrics.device_installs, 0)                as device_installs,
        coalesce(install_metrics.device_uninstalls, 0)              as device_uninstalls,
        coalesce(install_metrics.device_upgrades, 0)                as device_upgrades,
        coalesce(install_metrics.user_installs, 0)                  as user_installs,
        coalesce(install_metrics.user_uninstalls, 0)                as user_uninstalls,
        coalesce(install_metrics.install_events, 0)                 as install_events,
        coalesce(install_metrics.uninstall_events, 0)               as uninstall_events,
        coalesce(install_metrics.update_events, 0)                  as update_events,

        -- crash/ANR metrics
        coalesce(crashes.crashes, 0)                                as crashes,
        coalesce(crashes.anrs, 0)                                   as anrs,

        -- store metrics (coalesce counts to 0; leave rates null if no visitors)
        coalesce(store_performance.store_listing_acquisitions, 0)   as store_listing_acquisitions,
        coalesce(store_performance.store_listing_visitors, 0)       as store_listing_visitors,
        store_performance.store_listing_conversion_rate,            -- leave null if no visitors
        store_performance.total_store_acquisitions,
        store_performance.total_store_visitors,

        -- rolling metrics — backfilled via partition/first_value below
        install_metrics.total_device_installs,
        install_metrics.total_device_uninstalls,
        ratings.average_rating,                                     -- not coalesced: no rating = null, not 0
        ratings.rolling_total_average_rating

    from install_metrics
    full outer join crashes
        on install_metrics.date_day = crashes.date_day
        and install_metrics.source_relation = crashes.source_relation
        and install_metrics.package_name = crashes.package_name
    full outer join ratings
        on coalesce(install_metrics.date_day, crashes.date_day) = ratings.date_day
        and coalesce(install_metrics.source_relation, crashes.source_relation) = ratings.source_relation
        and coalesce(install_metrics.package_name, crashes.package_name) = ratings.package_name
    full outer join store_performance
        on coalesce(install_metrics.date_day, crashes.date_day, ratings.date_day) = store_performance.date_day
        and coalesce(install_metrics.source_relation, crashes.source_relation, ratings.source_relation) = store_performance.source_relation
        and coalesce(install_metrics.package_name, crashes.package_name, ratings.package_name) = store_performance.package_name

),

-- create partitions to batch rows together for null-backfilling of rolling metrics
create_partitions as (

    select
        *

    {%- set rolling_metrics = ['rolling_total_average_rating', 'total_device_installs', 'total_device_uninstalls', 'total_store_acquisitions', 'total_store_visitors'] -%}

    {% for metric in rolling_metrics -%}
        , sum(case when {{ metric }} is null
                then 0 else 1 end) over (
            partition by source_relation, package_name
            order by date_day asc
            rows unbounded preceding
        ) as {{ metric | lower }}_partition
    {%- endfor %}
    from overview_join

),

-- propagate the last non-null value across each partition batch
fill_values as (

    select
        source_relation,
        date_day,
        package_name,
        android_os_version,
        active_devices_last_30_days,
        device_installs,
        device_uninstalls,
        device_upgrades,
        user_installs,
        user_uninstalls,
        install_events,
        uninstall_events,
        update_events,
        crashes,
        anrs,
        store_listing_acquisitions,
        store_listing_visitors,
        store_listing_conversion_rate,
        average_rating

        {% for metric in rolling_metrics -%}

        , first_value( {{ metric }} ) over (
            partition by source_relation, {{ metric | lower }}_partition, package_name
            order by date_day asc
            rows between unbounded preceding and current row
        ) as {{ metric }}

        {%- endfor %}
    from create_partitions

),

final as (

    select
        source_relation,
        date_day,
        package_name,
        android_os_version,
        active_devices_last_30_days,
        device_installs,
        device_uninstalls,
        device_upgrades,
        user_installs,
        user_uninstalls,
        install_events,
        uninstall_events,
        update_events,
        crashes,
        anrs,
        average_rating,

        -- leave null if there are no ratings yet
        rolling_total_average_rating,

        -- the first day will have NULL values; coalesce to 0
        coalesce(total_device_installs, 0)                                                        as total_device_installs,
        coalesce(total_device_uninstalls, 0)                                                      as total_device_uninstalls,
        coalesce(total_device_installs, 0) - coalesce(total_device_uninstalls, 0)                 as net_device_installs,

        -- store metrics
        store_listing_acquisitions,
        store_listing_conversion_rate,                              -- leave null when no visitors
        store_listing_visitors,
        coalesce(total_store_acquisitions, 0)                                                      as total_store_acquisitions,
        coalesce(total_store_visitors, 0)                                                          as total_store_visitors,

        -- rolling conversion rate from cumulative totals (matches country_report pattern)
        round(
            cast(coalesce(total_store_acquisitions, 0) as decimal(18,4))
            / nullif(total_store_visitors, 0),
            4
        ) as rolling_store_conversion_rate

    from fill_values

)

select *
from final
