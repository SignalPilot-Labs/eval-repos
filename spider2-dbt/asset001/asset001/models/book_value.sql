{{ config(materialized='table') }}

-- EXPECTED SHAPE: ~3185 rows — REASON: INNER JOIN keeps only positions with a matching bar_quotes price

SELECT
    ps.tt_key,
    ps.ticker,
    ps.ts,
    ps.shares,
    ps.shares * bq.avg_mid_pr AS value
FROM {{ ref('positions_shares') }} ps
INNER JOIN {{ ref('bar_quotes') }} bq
    ON ps.ticker = bq.ticker
    AND ps.ts    = bq.ts
