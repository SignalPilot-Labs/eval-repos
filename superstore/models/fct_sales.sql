{{ config(materialized='table') }}

-- EXPECTED SHAPE: 9994 rows — REASON: one row per order line item in stg_orders

SELECT
    ROW_NUMBER() OVER (ORDER BY o.row_id) + 100     AS id,
    o.order_id                                       AS order_id,
    dc_ord.date_id                                   AS order_date_id,
    dc_ship.date_id                                  AS ship_date_id,
    o.sales                                          AS sales,
    o.profit                                         AS profit,
    o.quantity                                       AS quantity,
    o.discount                                       AS discount,
    p.id                                             AS dim_products_id,
    c.id                                             AS dim_customers_id,
    s.id                                             AS dim_shipping_id,
    g.id                                             AS dim_geo_id

FROM {{ ref('stg_orders') }} o
JOIN {{ ref('dim_calendar') }} dc_ord
    ON dc_ord.date = STRPTIME(o.order_date, '%Y/%m/%d')::DATE
JOIN {{ ref('dim_calendar') }} dc_ship
    ON dc_ship.date = STRPTIME(o.ship_date, '%Y/%m/%d')::DATE
JOIN {{ ref('dim_products') }} p
    ON p.product_id = o.product_id
    AND p.segment = o.segment
    AND p.product_name = o.product_name
JOIN {{ ref('dim_customers') }} c
    ON c.customer_id = o.customer_id
JOIN {{ ref('dim_shipping') }} s
    ON s.ship_mode = o.ship_mode
JOIN {{ ref('dim_geo') }} g
    ON g.city = o.city
    AND g.state = o.state
    AND g.postal_code = o.postal_code
