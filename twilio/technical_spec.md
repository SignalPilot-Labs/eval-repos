# Technical Spec — twilio001

## Build Order
1. `int_twilio__messages` (intermediate — already built, do NOT rewrite)
2. `twilio__message_enhanced` (mart — already built, do NOT rewrite)
3. `twilio__number_overview` (mart — depends on int_twilio__messages)
4. `twilio__account_overview` (mart — depends on int_twilio__messages + stg_twilio__account_history + stg_twilio__usage_record)

---

## Model: twilio__number_overview

- **Source**: `ref('int_twilio__messages')` — pre-computed message rows with direction split, phone_number, status, price, date fields
- **Driving table**: `int_twilio__messages` (10 rows)
- **Joins**: none — single table aggregation
- **Key expressions**:
  - `phone_number`: GROUP BY phone_number
  - `total_outbound_messages` = `SUM(CASE WHEN direction LIKE '%outbound%' THEN 1 ELSE 0 END)`
  - `total_inbound_messages` = `SUM(CASE WHEN direction LIKE '%inbound%' THEN 1 ELSE 0 END)`
  - `total_accepted_messages` = `SUM(CASE WHEN status = 'accepted' THEN 1 ELSE 0 END)`
  - `total_scheduled_messages` = `SUM(CASE WHEN status = 'scheduled' THEN 1 ELSE 0 END)`
  - `total_canceled_messages` = `SUM(CASE WHEN status = 'canceled' THEN 1 ELSE 0 END)`
  - `total_queued_messages` = `SUM(CASE WHEN status = 'queued' THEN 1 ELSE 0 END)`
  - `total_sending_messages` = `SUM(CASE WHEN status = 'sending' THEN 1 ELSE 0 END)`
  - `total_sent_messages` = `SUM(CASE WHEN status = 'sent' THEN 1 ELSE 0 END)`
  - `total_failed_messages` = `SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END)`
  - `total_delivered_messages` = `SUM(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END)`
  - `total_undelivered_messages` = `SUM(CASE WHEN status = 'undelivered' THEN 1 ELSE 0 END)`
  - `total_receiving_messages` = `SUM(CASE WHEN status = 'receiving' THEN 1 ELSE 0 END)`
  - `total_received_messages` = `SUM(CASE WHEN status = 'received' THEN 1 ELSE 0 END)`
  - `total_read_messages` = `SUM(CASE WHEN status = 'read' THEN 1 ELSE 0 END)`
  - `total_messages` = `COUNT(*)`
  - `total_spend` = `SUM(price)` — single-source, preserve negative sign (domain-marketing rule)
- **Filters**: none
- **Expected grain**: one row per phone_number
- **Expected rows**: 1 (1 distinct phone_number in test data: 15555555555)

---

## Model: twilio__account_overview

- **Sources**:
  - `ref('int_twilio__messages')` — messages with account_id, direction, status, price, date fields
  - `var('account_history')` → `ref('stg_twilio__account_history')` — friendly_name, status, type, is_most_recent_record
  - `var('usage_record')` → `ref('stg_twilio__usage_record')` — cleaned price (FLOAT, positive) per account_id
- **Driving table**: `int_twilio__messages` (10 rows, per domain-marketing: drive from event table)
- **Joins**:
  - `LEFT JOIN stg_twilio__account_history a ON messages.account_id = a.account_id WHERE a.is_most_recent_record = TRUE`
  - `LEFT JOIN (SELECT account_id, SUM(price) AS total_usage_price FROM stg_twilio__usage_record GROUP BY account_id) spend ON messages.account_id = spend.account_id`
- **Key expressions**:
  - `account_id`: GROUP BY account_id
  - `account_name`: from `stg_twilio__account_history.friendly_name`
  - `account_status`: from `stg_twilio__account_history.status`
  - `account_type`: from `stg_twilio__account_history.type`
  - `date_day`: GROUP BY date_day
  - `date_week`: `MAX(date_week)` (1:1 per date_day)
  - `date_month`: `MAX(date_month)` (1:1 per date_day)
  - direction/status counts: same CASE WHEN expressions as twilio__number_overview
  - `total_messages`: `COUNT(*)`
  - `total_messages_spend`: `ABS(SUM(price))` — multi-source model, normalize with ABS (messages negative, usage positive)
  - `price_unit`: `MAX(price_unit)` — all 'USD' in test data
  - `total_account_spend`: `ABS(spend.total_usage_price)` — total across all usage records for the account, same value on all date_day rows for the same account
- **Filters**: none on messages; `is_most_recent_record = TRUE` on account_history (boolean flag = most recent account state)
- **Expected grain**: one row per (account_id, date_day)
- **Expected rows**: 1 (1 distinct account_id × 1 distinct date_day in test data)

---

## Decisions

- `int_twilio__messages` is driving table for both models (domain-marketing: drive from event/activity table)
- `total_spend` in number_overview uses `SUM(price)` without ABS — single-source model, sign preserved (domain-marketing rule)
- `total_messages_spend` and `total_account_spend` in account_overview both use ABS — multi-source: messages have negative price (-0.0158), usage records have positive price (0.01–0.07), different sign conventions require normalization
- `stg_twilio__usage_record` used over raw `twilio_usage_record_data` — staging model cleans price column with `remove_non_numeric_chars` (raw data has "$0.05", "0.01x" strings)
- `stg_twilio__account_history` filtered `is_most_recent_record = TRUE` — boolean flag ensures most recent account metadata; not filtered for event counting, only for dimension lookup
- `total_account_spend` is total across ALL usage records per account (not per day) — YML description says "across all Twilio resources used", aggregated at account level and repeated per date_day row
- LEFT JOIN for account_history and usage_record (dbt-write Section 4 default; accounts/usage may not always match message activity)
- `date_week` and `date_month` use MAX (deterministic since grain already includes date_day)
