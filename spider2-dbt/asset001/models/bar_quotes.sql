{{ config(materialized='table') }}

-- EXPECTED SHAPE: 3430 rows — REASON: COUNT(DISTINCT ticker || '|' || ts) = 3430 in quotes source

SELECT
    date,
    concat(ticker, ts::TIMESTAMP) AS tt_key,
    ts::TIMESTAMP                 AS ts,
    ticker,
    AVG(CAST(bid_pr AS DOUBLE))                                          AS avg_bid_pr,
    AVG(ask_pr)                                                          AS avg_ask_pr,
    (AVG(CAST(bid_pr AS DOUBLE)) + AVG(ask_pr)) / 2.0                   AS avg_mid_pr
FROM {{ source('asset_mgmt', 'quotes') }}
GROUP BY date, ts, ticker
