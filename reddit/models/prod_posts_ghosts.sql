{{ config(materialized='table') }}

-- EXPECTED SHAPE: 30971 rows — REASON: one row per post, no filter, no join fan-out

SELECT
    author                                          AS author_post,
    distinguished                                   AS distinguished_post,
    edited                                          AS edited_post,
    post_id,
    is_original_content                             AS post_is_original_content,
    locked                                          AS post_locked,
    post_fullname,
    post_title,
    post_text,
    num_comments,
    post_score,
    post_url,
    created_at                                      AS post_created_at,
    over_18                                         AS post_over_18,
    spoiler                                         AS post_spoiler,
    stickied                                        AS post_stickied,
    upvote_ratio                                    AS post_upvote_ratio,
    -- UNMAPPED-INCLUDE pass-through columns (not in YML contract)
    author_flair_text,
    clicked,
    saved,
    -- Macro-derived additional columns
    {{ extract_hour('created_at') }}                AS hour_created_at,
    {{ normalize_timestamp('created_at') }}         AS normalized_created_at

FROM {{ source('raw', 'posts_ghosts') }}
