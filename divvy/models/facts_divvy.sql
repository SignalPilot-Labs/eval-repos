{{ config(materialized='table') }}

-- EXPECTED SHAPE: 413,689 rows — REASON: divvy_data INNER JOIN both station lookups WHERE duration BETWEEN 1 AND 1440 min

WITH base AS (
    SELECT
        ride_id,
        rideable_type,
        membership_status,
        start_station_name,
        end_station_name,
        started_at,
        ended_at,
        (epoch_us(ended_at) - epoch_us(started_at)) / 60000000.0 AS duration_minutes
    FROM {{ ref('stg_divvy_data') }}
    WHERE (epoch_us(ended_at) - epoch_us(started_at)) / 60000000.0 BETWEEN 1 AND 1440
)

SELECT
    base.ride_id,
    base.rideable_type,
    base.membership_status,
    start_n.station_id                                              AS start_station_id,
    base.start_station_name,
    end_n.station_id                                                AS end_station_id,
    base.end_station_name,
    base.started_at,
    base.ended_at,
    base.duration_minutes,
    start_n.primary_neighbourhood                                   AS start_neighbourhood,
    CAST(start_n.lat AS VARCHAR) || ',' || CAST(start_n.lng AS VARCHAR) AS start_location,
    end_n.primary_neighbourhood                                     AS end_neighbourhood,
    CAST(end_n.lat AS VARCHAR) || ',' || CAST(end_n.lng AS VARCHAR) AS end_location
FROM base
INNER JOIN {{ ref('dim_neighbourhoods') }} AS start_n
    ON base.start_station_name = start_n.station_name
INNER JOIN {{ ref('dim_neighbourhoods') }} AS end_n
    ON base.end_station_name = end_n.station_name
