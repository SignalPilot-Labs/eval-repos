{{ config(materialized='table') }}

-- EXPECTED SHAPE: ~28,424 rows — REASON: "revenue lost due to returned items for each customer" (only customers with returned 'R' items)

WITH returns_per_customer AS (
    SELECT
        o.o_custkey                                                 AS c_custkey,
        ROUND(SUM(l.l_extendedprice * (1 - l.l_discount)), 2)      AS revenue_lost
    FROM {{ source('TPCH_SF1', 'lineitem') }} l
    LEFT JOIN {{ source('TPCH_SF1', 'orders') }} o
        ON l.l_orderkey = o.o_orderkey
    WHERE l.l_returnflag = 'R'
    GROUP BY o.o_custkey
)

SELECT
    rpc.c_custkey,
    c.c_name,
    rpc.revenue_lost,
    c.c_acctbal,
    n.n_name,
    c.c_address,
    c.c_phone,
    c.c_comment
FROM returns_per_customer rpc
LEFT JOIN {{ source('TPCH_SF1', 'customer') }} c
    ON rpc.c_custkey = c.c_custkey
LEFT JOIN {{ source('TPCH_SF1', 'nation') }} n
    ON c.c_nationkey = n.n_nationkey
