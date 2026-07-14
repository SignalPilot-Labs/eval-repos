{{ config(materialized='table') }}

-- EXPECTED SHAPE: ≤10 rows — REASON: aggregating 10 country-level rows to package/date level

with store_performance as (

    select *
    from {{ ref('stats_store_performance_country') }}

),

aggregated as (

    select
        source_relation,
        date_day,
        package_name,
        sum(store_listing_acquisitions)     as store_listing_acquisitions,
        sum(store_listing_visitors)         as store_listing_visitors,
        -- recompute rate from aggregated sums (per-country rate cannot be averaged after cross-country summing)
        cast(sum(store_listing_acquisitions) as double) / nullif(sum(store_listing_visitors), 0)
                                            as store_listing_conversion_rate
    from store_performance
    group by 1, 2, 3

),

final as (

    select
        source_relation,
        date_day,
        package_name,
        store_listing_acquisitions,
        store_listing_visitors,
        store_listing_conversion_rate,
        sum(store_listing_acquisitions) over (
            partition by source_relation, package_name
            order by date_day asc
            rows between unbounded preceding and current row
        ) as total_store_acquisitions,
        sum(store_listing_visitors) over (
            partition by source_relation, package_name
            order by date_day asc
            rows between unbounded preceding and current row
        ) as total_store_visitors
    from aggregated

)

select *
from final
