{{ config(materialized='table') }}

-- EXPECTED SHAPE: 10 rows — REASON: raw stats_store_performance_country has 10 rows, 10 unique (source_relation, date, country_region, package_name) combos

with source as (

    select *
    from {{ source('google_play', 'stats_store_performance_country') }}

),

final as (

    select
        cast('' as varchar)                                     as source_relation,
        cast(date as date)                                      as date_day,
        cast(country_region as varchar)                         as country_region,
        cast(package_name as varchar)                           as package_name,
        sum(cast(store_listing_acquisitions as bigint))         as store_listing_acquisitions,
        avg(store_listing_conversion_rate)                      as store_listing_conversion_rate,
        sum(cast(store_listing_visitors as bigint))             as store_listing_visitors
    from source
    group by 1, 2, 3, 4

)

select *
from final
