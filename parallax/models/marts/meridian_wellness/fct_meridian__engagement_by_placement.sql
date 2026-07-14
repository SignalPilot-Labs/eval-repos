-- Outcome activity by the placement seen the same day.
with impressions as (

    select
        enrollment_id,
        cast(exposure_ts as date)  as imp_date,
        surface                    as placement
    from {{ ref('int_meridian__exposures') }}

),

outcomes as (

    select
        enrollment_id,
        cast(event_ts as date)     as event_date,
        metric_key
    from {{ ref('int_meridian__metric_events') }}

)

select
    i.placement,
    o.metric_key,
    count(*)  as events
from outcomes o
join impressions i
    on i.enrollment_id = o.enrollment_id
   and i.imp_date = o.event_date
group by 1, 2
