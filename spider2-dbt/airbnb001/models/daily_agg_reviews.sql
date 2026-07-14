{{ config(materialized='table') }}

-- EXPECTED SHAPE: 10,005 rows — REASON: unique (REVIEW_DATE::DATE, REVIEW_SENTIMENT) combos in fct_reviews

WITH review_cte AS (
    SELECT *
    FROM {{ ref('fct_reviews') }}
),

daily_cte AS (
    SELECT
        COUNT(*) AS REVIEW_TOTALS,
        REVIEW_SENTIMENT,
        REVIEW_DATE::DATE AS REVIEW_DATE
    FROM review_cte
    GROUP BY
        REVIEW_SENTIMENT,
        REVIEW_DATE::DATE
)

SELECT
    REVIEW_TOTALS,
    REVIEW_SENTIMENT,
    REVIEW_DATE,
    {{ dbt_utils.surrogate_key(['REVIEW_DATE', 'REVIEW_SENTIMENT']) }} AS DATE_SENTIMENT_ID
FROM daily_cte
