# Technical Spec: reddit001

## Build Order
1. prod_posts_ghosts (staging — source: raw_posts_ghosts, no model dependencies)
2. prod_comments_ghosts (staging — source: raw_comments_ghosts, no model dependencies)

Both models are independent and can be built in any order.

---

## Model: prod_posts_ghosts
- **Source**: `source('raw', 'posts_ghosts')` → raw table `raw_posts_ghosts` (30,971 rows)
- **Driving table**: raw_posts_ghosts (30,971 rows) — single source, no JOIN needed
- **Joins**: none — this is a single-source cleansing/renaming model
- **Key expressions**:
  - author AS author_post
  - distinguished AS distinguished_post
  - edited AS edited_post
  - post_id AS post_id (direct, no alias needed)
  - is_original_content AS post_is_original_content
  - locked AS post_locked
  - post_fullname AS post_fullname (direct)
  - post_title AS post_title (direct)
  - post_text AS post_text (direct)
  - num_comments AS num_comments (direct)
  - post_score AS post_score (direct)
  - post_url AS post_url (direct)
  - created_at AS post_created_at
  - over_18 AS post_over_18
  - spoiler AS post_spoiler
  - stickied AS post_stickied
  - upvote_ratio AS post_upvote_ratio
  - author_flair_text (UNMAPPED-INCLUDE: no YML alias, pass-through)
  - clicked (UNMAPPED-INCLUDE: no YML alias, pass-through)
  - saved (UNMAPPED-INCLUDE: no YML alias, pass-through)
  - {{ extract_hour('created_at') }} AS hour_created_at (macro-derived, additional)
  - {{ normalize_timestamp('created_at') }} AS normalized_created_at (macro-derived, additional)
- **Filters**: none — not_null tests are output assertions, not input filters
- **Expected grain**: one row per post (post_id is unique key)
- **Expected rows**: 30,971 (matches raw_posts_ghosts row count, no filter, no join fan-out)

---

## Model: prod_comments_ghosts
- **Source**: `source('raw', 'comments_ghosts')` → raw table `raw_comments_ghosts` (15,359 rows)
- **Driving table**: raw_comments_ghosts (15,359 rows) — single source, no JOIN needed
- **Joins**: none — this is a single-source cleansing/renaming model
- **Key expressions**:
  - post_url AS comments_post_url
  - author AS author_comment
  - comment_id AS comment_id (direct)
  - body AS comment_body
  - created_at AS comment_created_at
  - distinguished AS comment_distinguished
  - edited AS comment_edited
  - is_author_submitter AS is_author_submitter (direct)
  - post_id AS comments_post_id
  - link_comment AS link_comment (direct)
  - comment_score AS comment_score (direct)
  - {{ extract_hour('created_at') }} AS hour_created_at (macro-derived, additional)
  - {{ normalize_timestamp('created_at') }} AS normalized_created_at (macro-derived, additional)
- **Filters**: none — not_null tests are output assertions, not input filters
- **Expected grain**: one row per comment (comment_id is unique key)
- **Expected rows**: 15,359 (matches raw_comments_ghosts row count, no filter, no join fan-out)

---

## Decisions
- No JOINs in either model: both are single-source cleansing models — source data already has all required columns, no enrichment lookup needed
- Column renaming only: YML contract uses prefixed names (author_post, post_created_at, etc.) while source has plain names (author, created_at); aliases handle the rename
- No WHERE filters: YML not_null tests are output assertions; source data expected to be clean based on task description ("cleansed table")
- UNMAPPED-INCLUDE extra columns (author_flair_text, clicked, saved) included in prod_posts_ghosts: map-columns flagged these as INCLUDE; they exist in source and are harmless extras
- Macros applied to created_at in both models: extract_hour and normalize_timestamp both take a timestamp column; created_at is the only TIMESTAMP in both source tables; output columns are additional beyond YML contract
- source('raw', 'posts_ghosts') and source('raw', 'comments_ghosts'): sources.yml maps these to raw_posts_ghosts and raw_comments_ghosts respectively via identifier override
- prod_posts_ghosts grain: post_id unique (blueprint confirms 30,971 rows)
- prod_comments_ghosts grain: comment_id unique (blueprint confirms 15,359 rows)
