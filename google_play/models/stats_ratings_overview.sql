{{ config(materialized='table') }}

-- EXPECTED SHAPE: 10 rows — REASON: raw stats_ratings_overview has 10 rows, 10 unique (package_name, date) combos

with source as (

    select *
    from {{ source('google_play', 'stats_ratings_overview') }}

),

final as (

    select
        cast('' as varchar)                                                         as source_relation,
        cast(date as date)                                                          as date_day,
        cast(package_name as varchar)                                               as package_name,
        cast(nullif(cast(daily_average_rating as varchar), 'NA') as double)         as average_rating,
        total_average_rating                                                        as rolling_total_average_rating
    from source

)

select *
from final
