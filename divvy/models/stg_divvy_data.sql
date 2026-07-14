{{ config(materialized='table') }}

-- EXPECTED SHAPE: 426,887 rows — REASON: all rows from divvy_data, no filtering

SELECT
    md5(ride_id || '-' || CAST(started_at AS VARCHAR))  AS r_id,
    ride_id,
    rideable_type,
    member_casual                                         AS membership_status,
    started_at,
    ended_at,
    start_station_name,
    CAST(start_station_id AS VARCHAR)                    AS start_station_id,
    end_station_name,
    CAST(end_station_id AS VARCHAR)                      AS end_station_id,
    ROUND(start_lat, 3)                                  AS start_lat,
    ROUND(start_lng, 3)                                  AS start_lng,
    ROUND(end_lat, 3)                                    AS end_lat,
    ROUND(end_lng, 3)                                    AS end_lng
FROM {{ source('main', 'divvy_data') }}
