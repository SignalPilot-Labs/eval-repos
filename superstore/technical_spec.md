# Technical Spec: superstore001

## Build Order
1. `dim_regional_managers` (mart — depends on ref('stg_sales_managers'), ref('dim_regions'))
2. `fct_sales` (mart — depends on ref('stg_orders'), ref('dim_calendar'), ref('dim_products'), ref('dim_customers'), ref('dim_shipping'), ref('dim_geo'))

---

## Model: dim_regional_managers

- **Source**: `ref('stg_sales_managers')` (manager_name, Region) + `ref('dim_regions')` (region_id, region_name)
- **Driving table**: `stg_sales_managers` (4 rows — one per sales manager/region)
- **Joins**:
  - `INNER JOIN dim_regions r ON r.region_name = sm.Region`
- **Key expressions**:
  - `id = r.region_id + 900` — verified from existing dim_regional_managers data: West→101+900=1001, East→103+900=1003, Central→102+900=1002, South→104+900=1004
  - `manager_name = sm.manager_name`
  - `region_id = r.region_id`
- **Filters**: none
- **Expected grain**: one row per regional manager (one per region)
- **Expected rows**: 4

---

## Model: fct_sales

- **Source**: `ref('stg_orders')` (9,994 rows) as driving table
- **Driving table**: `stg_orders` (9,994 rows — one row per order line item)
- **Joins**:
  - `JOIN dim_calendar dc_ord ON dc_ord.date = STRPTIME(o.order_date, '%Y/%m/%d')::DATE` — for order_date_id
  - `JOIN dim_calendar dc_ship ON dc_ship.date = STRPTIME(o.ship_date, '%Y/%m/%d')::DATE` — for ship_date_id
  - `JOIN dim_products p ON p.product_id = o.product_id AND p.segment = o.segment AND p.product_name = o.product_name` — for dim_products_id (dim_products has multiple rows per product_id; joining on product_id+segment+product_name gives unique 1:1 match → 9,994 rows)
  - `JOIN dim_customers c ON c.customer_id = o.customer_id` — for dim_customers_id
  - `JOIN dim_shipping s ON s.ship_mode = o.ship_mode` — for dim_shipping_id
  - `JOIN dim_geo g ON g.city = o.city AND g.state = o.state AND g.postal_code = o.postal_code` — for dim_geo_id
- **Key expressions**:
  - `id = ROW_NUMBER() OVER (ORDER BY o.row_id) + 100` — verified: existing fct_sales min=101, max=10094, 9994 rows; ids are assigned in row_id order
  - `order_id = o.order_id`
  - `order_date_id = dc_ord.date_id` (YYYYMMDD integer from dim_calendar)
  - `ship_date_id = dc_ship.date_id` (YYYYMMDD integer from dim_calendar)
  - `sales = o.sales`
  - `profit = o.profit`
  - `quantity = o.quantity`
  - `discount = o.discount`
  - `dim_products_id = p.id`
  - `dim_customers_id = c.id`
  - `dim_shipping_id = s.id`
  - `dim_geo_id = g.id`
- **Filters**: none — a separate `returned_orders` raw source table exists; per domain-ecommerce rule, the orders table records only sales rows, no return filter needed
- **Expected grain**: one row per order line item (one per unique order_id + product_id combination)
- **Expected rows**: 9,994

---

## Decisions

- `dim_regional_managers.id = region_id + 900`: verified against existing materialized table (1001-1004), matches region_ids 101-104 plus 900 offset
- INNER JOIN dim_regions in dim_regional_managers: every sales manager must have a matching region; source data has 4 managers and 4 regions with exact name matches
- `fct_sales.id = ROW_NUMBER() OVER (ORDER BY o.row_id) + 100`: verified against existing table (min=101, max=10094, 9994 rows); row ordering by row_id produces sequential ids
- No return filter in fct_sales: `returned_orders` is a separate raw source table (domain-ecommerce rule — if separate returns source exists, orders table contains only sales, no filter needed)
- All JOINs in fct_sales are INNER (no LEFT): all dimension lookups are guaranteed — 0 unmatched rows verified for dim_geo join (COUNT(*) after LEFT JOIN WHERE id IS NULL = 0); dim_calendar covers all dates; product_id, customer_id, ship_mode are present in all staging rows
- stg_orders.order_date is in format 'YYYY/M/D' (non-ISO) — must use STRPTIME(col, '%Y/%m/%d')::DATE before joining dim_calendar
- stg_orders.postal_code already handles Burlington NULL fix (in stg_orders.sql), so dim_geo join on postal_code is safe
