# Technical Spec — recharge002

## Build Order
1. `int_recharge__calendar_spine` (intermediate table — already built, source for calendar days)
2. `recharge__customer_details` (mart table — already materialized, provides first_charge_processed_at)
3. `int_recharge__customer_daily_rollup` (intermediate ephemeral — cross join of calendar × customers)
4. `recharge__billing_history` (mart table — already materialized, provides daily order/charge metrics)
5. **`recharge__customer_daily_rollup`** (mart table — stub to rewrite)

---

## Model: recharge__customer_daily_rollup

- **Source**:
  - `ref('int_recharge__customer_daily_rollup')` — driving spine (customer × calendar)
  - `ref('recharge__billing_history')` — daily order/charge financial metrics
  - `ref('recharge__customer_details')` — for `first_charge_processed_at` (active_months_to_date)

- **Driving table**: `int_recharge__customer_daily_rollup` — ephemeral CTE expanding to
  customer × calendar_day (CROSS JOIN with `customer_created_at <= date_day` filter).
  2 customers × 61 calendar days = 122 rows expected.

- **Joins**:
  - `LEFT JOIN recharge__billing_history` ON `customer_id = customer_id` AND
    `CAST(order_created_at AS DATE) = date_day` — picks up daily order totals.
  - `LEFT JOIN recharge__customer_details` ON `customer_id = customer_id` — picks up
    `first_charge_processed_at` for active_months_to_date computation.

- **Key expressions**:
  - `date_week` = `CAST(DATE_TRUNC('week', date_day) AS DATE)` — from int_recharge__customer_daily_rollup
  - `date_month` = `CAST(DATE_TRUNC('month', date_day) AS DATE)` — from int_recharge__customer_daily_rollup
  - `date_year` = `CAST(DATE_TRUNC('year', date_day) AS DATE)` — from int_recharge__customer_daily_rollup
  - `no_of_orders` = `COUNT(order_id)` WHERE `order_status NOT IN ('error','cancelled','queued')`
  - `recurring_orders` = `COUNT(CASE WHEN lower(order_type) = 'recurring' THEN order_id END)`
  - `one_time_orders` = `COUNT(CASE WHEN lower(charge_type) = 'checkout' THEN order_id END)`
  - `total_charges` = `SUM(charge_total_price)` — all orders (no status filter; gross)
  - `charge_total_discounts_realized` = `SUM(charge_total_discounts)` (order_status filter)
  - `calculated_order_total_discounts_realized` = `SUM(calculated_order_total_discounts)` (order_status filter)
  - `charge_total_tax_realized` = `SUM(charge_total_tax)` (order_status filter)
  - `calculated_order_total_tax_realized` = `SUM(calculated_order_total_tax)` (order_status filter)
  - `charge_total_price_realized` = `SUM(charge_total_price)` (order_status filter; successful only)
  - `calculated_order_total_price_realized` = `SUM(calculated_order_total_price)` (order_status filter)
  - `charge_total_refunds_realized` = `SUM(charge_total_refunds)` (order_status filter)
  - `calculated_order_total_refunds_realized` = `SUM(calculated_order_total_refunds)` (order_status filter)
  - `order_line_item_total_realized` = `SUM(order_line_item_total)` (order_status filter)
  - `order_item_quantity_realized` = `SUM(order_item_quantity)` (order_status filter)
  - `charge_recurring_net_amount_realized` = `SUM(total_net_charge_value)` WHERE `lower(charge_type) = 'recurring'` (order_status filter)
  - `charge_one_time_net_amount_realized` = `SUM(total_net_charge_value)` WHERE `lower(charge_type) = 'checkout'` (order_status filter)
  - `calculated_order_recurring_net_amount_realized` = `SUM(total_calculated_net_order_value)` WHERE `lower(charge_type) = 'recurring'` (order_status filter)
  - `calculated_order_one_time_net_amount_realized` = `SUM(total_calculated_net_order_value)` WHERE `lower(charge_type) = 'checkout'` (order_status filter)
  - All `_running_total` columns = `SUM(xxx_realized) OVER (PARTITION BY customer_id ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`
  - `active_months_to_date` = `ROUND(CAST(DATE_DIFF('day', CAST(first_charge_processed_at AS DATE), date_day) AS DOUBLE) / 30, 2)`
    — mirrors sibling `recharge__customer_details.active_months` formula but anchored to each date_day

- **Filters**:
  - Success-based metrics: `lower(order_status) NOT IN ('error', 'cancelled', 'queued')` — matches sibling `int_recharge__customer_details` order_agg filter
  - `total_charges`: NO filter (gross total of all charge_total_price for the day)
  - No date range filter; calendar spine already restricts to relevant days via the CROSS JOIN condition `customer_created_at <= date_day`

- **Expected grain**: one row per (customer_id, date_day)

- **Expected rows**: 122 rows (2 customers × 61 calendar days from 2022-09-08 to 2022-11-07)

---

## Decisions

- **Driving table = int_recharge__customer_daily_rollup** — it is the calendar-spine model (CROSS JOIN of calendar × customers). Domain-ecommerce skill: "calendar-spine models: date spine drives FROM clause". Not billing_history (which would exclude zero-activity days).
- **Join billing by CAST(order_created_at AS DATE) = date_day** — order_created_at is the order's own date. Test data shows order_created_at = 2022-08-24 which is before the spine (2022-09-08); realized metrics will be 0 for all days in test data, which is correct behavior.
- **total_charges uses no status filter; charge_total_price_realized uses order_status filter** — `total_charges` YML says "total amount of charges...including all items" (no "successful" qualifier); `charge_total_price_realized` says "for successful orders".
- **LEFT JOIN recharge__customer_details for first_charge_processed_at** — int_recharge__customer_daily_rollup only exposes customer_id + date columns; need first_charge_processed_at for active_months_to_date from parent model.
- **active_months_to_date formula = DATE_DIFF('day', first_charge_processed_at, date_day) / 30** — mirrors `recharge__customer_details.active_months` sibling pattern but uses date_day instead of current_timestamp (per-day calculation, avoids staleness).
- **No COALESCE on realized columns for calendar-spine model** — zero-activity days should have 0 metrics. All COALESCE to 0 via LEFT JOIN null-handling in the billing_agg CTE.
- **Running totals via SUM OVER (UNBOUNDED PRECEDING AND CURRENT ROW)** — standard cumulative window; no pre-spine data needed since calendar spine is the scope.
- **order_status filter matches int_recharge__customer_details sibling** — `NOT IN ('error', 'cancelled', 'queued')` is the established filter for this project.
