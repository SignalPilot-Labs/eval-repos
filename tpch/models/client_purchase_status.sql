{{ config(materialized='table') }}

-- EXPECTED SHAPE: ~75,007 rows — REASON: "purchase status of each customer" (customers with non-return orders; 1,770 return-only customers excluded per domain-ecommerce rule)

WITH purchases AS (
    SELECT
        customer_id,
        SUM(customer_cost) AS purchase_total_raw
    FROM {{ ref('order_line_items') }}
    WHERE item_status != 'R'
    GROUP BY customer_id
),

enriched AS (
    SELECT
        p.customer_id,
        c.c_name                                                                         AS customer_name,
        ROUND(p.purchase_total_raw, 2)                                                   AS purchase_total,
        COALESCE(lr.revenue_lost, 0)                                                     AS return_total,
        ROUND(p.purchase_total_raw - COALESCE(lr.revenue_lost, 0), 2)                   AS lifetime_value,
        CAST(COALESCE(lr.revenue_lost, 0) AS DOUBLE) / p.purchase_total_raw * 100       AS return_pct_raw,
        ROUND(CAST(COALESCE(lr.revenue_lost, 0) AS DOUBLE) / p.purchase_total_raw * 100, 2) AS return_pct
    FROM purchases p
    LEFT JOIN {{ ref('lost_revenue') }} lr
        ON p.customer_id = lr.c_custkey
    LEFT JOIN {{ source('TPCH_SF1', 'customer') }} c
        ON p.customer_id = c.c_custkey
)

SELECT
    customer_id,
    customer_name,
    purchase_total,
    return_total,
    lifetime_value,
    return_pct,
    CASE
        WHEN return_pct_raw < 25   THEN 'green'
        WHEN return_pct_raw < 50   THEN 'yellow'
        WHEN return_pct_raw < 75   THEN 'orange'
        WHEN return_pct_raw <= 100 THEN 'red'
        ELSE NULL
    END AS customer_status
FROM enriched
