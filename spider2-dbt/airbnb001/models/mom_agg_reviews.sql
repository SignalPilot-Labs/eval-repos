{{ config(materialized='table') }}

-- EXPECTED SHAPE: 3 rows — REASON: 1 latest date (2021-10-22) × 3 sentiments; MoM temporal scope + first-build NULL rule

WITH review_cte AS (
    SELECT *
    FROM {{ ref('fct_reviews') }}
),

max_date_cte AS (
    SELECT MAX(REVIEW_DATE::DATE) AS max_date
    FROM review_cte
),

final_cte AS (
    SELECT
        COUNT(*) AS REVIEW_TOTALS,
        review_cte.REVIEW_SENTIMENT,
        max_date_cte.max_date AS AGGREGATION_DATE
    FROM max_date_cte
    LEFT JOIN review_cte
        ON review_cte.REVIEW_DATE::DATE BETWEEN max_date_cte.max_date - INTERVAL '29' DAY
                                             AND max_date_cte.max_date
    GROUP BY
        review_cte.REVIEW_SENTIMENT,
        max_date_cte.max_date
)

SELECT
    REVIEW_TOTALS,
    REVIEW_SENTIMENT,
    AGGREGATION_DATE,
    CAST(NULL AS DOUBLE) AS MOM,
    {{ dbt_utils.surrogate_key(['AGGREGATION_DATE', 'REVIEW_SENTIMENT']) }} AS DATE_SENTIMENT_ID
FROM final_cte
