{{ config(materialized='table') }}

-- EXPECTED SHAPE: 4 rows — REASON: one row per regional manager, one manager per region

SELECT
    r.region_id + 900   AS id,
    sm.manager_name     AS manager_name,
    r.region_id         AS region_id

FROM {{ ref('stg_sales_managers') }} sm
INNER JOIN {{ ref('dim_regions') }} r
    ON r.region_name = sm.region
