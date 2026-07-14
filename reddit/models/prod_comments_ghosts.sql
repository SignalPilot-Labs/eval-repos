{{ config(materialized='table') }}

-- EXPECTED SHAPE: 15359 rows — REASON: one row per comment, no filter, no join fan-out

SELECT
    post_url                                        AS comments_post_url,
    author                                          AS author_comment,
    comment_id,
    body                                            AS comment_body,
    created_at                                      AS comment_created_at,
    distinguished                                   AS comment_distinguished,
    edited                                          AS comment_edited,
    is_author_submitter,
    post_id                                         AS comments_post_id,
    link_comment,
    comment_score,
    -- Macro-derived additional columns
    {{ extract_hour('created_at') }}                AS hour_created_at,
    {{ normalize_timestamp('created_at') }}         AS normalized_created_at

FROM {{ source('raw', 'comments_ghosts') }}
