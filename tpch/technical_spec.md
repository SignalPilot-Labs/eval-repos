# Technical Spec — tpch001

## Build Order
1. `lost_revenue` (mart — depends on TPCH_SF1 raw sources: lineitem, orders, customer, nation)
2. `client_purchase_status` (mart — depends on ref('order_line_items') + ref('lost_revenue') + TPCH_SF1.customer)

Note: `order_line_items` is EXISTING COMPLETE at `models/FINANCE/intermediate/order_line_items.sql`.
Build it via `+` prefix only if not yet materialized.

---

## Model: lost_revenue

- **Source**: TPCH_SF1 raw tables: `lineitem`, `orders`, `customer`, `nation`
- **Driving table**: lineitem filtered for `l_returnflag = 'R'` — fact aggregation drives (domain-ecommerce rule). Sibling model `SUPPLIER_RETURNS.sql` uses `WHERE item_status = 'R'` for returns.
- **Joins**:
  - INNER JOIN `orders` ON `lineitem.l_orderkey = orders.o_orderkey` (to get o_custkey)
  - LEFT JOIN `customer` ON `aggregated.c_custkey = customer.c_custkey` (enrichment)
  - LEFT JOIN `nation` ON `customer.c_nationkey = nation.n_nationkey` (enrichment)
- **Key expressions**:
  - `revenue_lost = ROUND(SUM(l_extendedprice * (1 - l_discount)), 2)` — aggregate THEN round (dbt-write rule)
  - All other columns (`c_name`, `c_acctbal`, `c_address`, `c_phone`, `c_comment`) come directly from customer table
  - `n_name` comes from nation table
- **Filters**: `WHERE l_returnflag = 'R'` — only include returned items (matches sibling `SUPPLIER_RETURNS.sql` pattern)
- **Expected grain**: one row per customer who has returned items
- **Expected rows**: ~28,424 (verified: `SELECT COUNT(DISTINCT o.o_custkey) FROM lineitem l JOIN orders o ON l.l_orderkey = o.o_orderkey WHERE l.l_returnflag = 'R'`)

---

## Model: client_purchase_status

- **Source**:
  - `ref('order_line_items')` — intermediate model with customer_id, item_status, customer_cost; already computes discounted price, do NOT recompute
  - `ref('lost_revenue')` — already computes revenue_lost per customer with 'R' items only
  - `source('TPCH_SF1', 'customer')` — for customer_name (c_name)
- **Driving table**: aggregated `order_line_items` filtered to `item_status != 'R'` → 75,007 distinct customers with non-return purchases
- **Joins**:
  - LEFT JOIN `ref('lost_revenue')` ON `order_line_items.customer_id = lost_revenue.c_custkey` (some customers have no returns → COALESCE to 0)
  - LEFT JOIN `source('TPCH_SF1', 'customer')` ON `customer_id = c_custkey` (for customer_name)
- **Key expressions**:
  - `purchase_total = ROUND(SUM(customer_cost), 2)` — items from order_line_items WHERE item_status != 'R' (exclude return rows). Domain-ecommerce rule: returns are rows in same fact table → exclude with WHERE before GROUP BY.
  - `return_total = COALESCE(ROUND(lost_revenue.revenue_lost, 2), 0)` — from ref('lost_revenue'), customers with no returns → 0
  - `lifetime_value = ROUND(purchase_total - return_total, 2)`
  - `return_pct = ROUND(CAST(return_total AS DOUBLE) / purchase_total * 100, 2)` — 0-100 scale (dbt-write rule: pct columns must be 0-100). CAST to DOUBLE for DuckDB integer division safety.
  - `customer_status` CASE WHEN (equal-width bands, domain-ecommerce rule):
    - `< 25` → 'green'
    - `>= 25 AND < 50` → 'yellow'
    - `>= 50 AND < 75` → 'orange'
    - `>= 75 AND <= 100` → 'red'
    - `> 100` → NULL (anomaly; accepted_values test requires only green/yellow/orange/red)
  - Apply CASE to full-precision return_pct before rounding (dbt-write Section 8)
- **Filters**: none — all customers with orders appear (domain-ecommerce: fact aggregation drives, customers with no qualifying rows don't appear)
- **Expected grain**: one row per customer with at least one order
- **Expected rows**: ~75,007 (value verifier: COUNT(DISTINCT customer_id) from order_line_items WHERE item_status != 'R'; 1,770 customers with only 'R' items correctly excluded)

---

## Decisions

- `purchase_total` = SUM of order_line_items WHERE item_status != 'R': domain-ecommerce rule — returns are rows in the same fact table, must exclude with WHERE. 1,770 customers with only 'R' items are correctly excluded (no net purchases). Some remaining customers may have return_pct > 100% (anomalies) → customer_status = NULL per domain rule.
- Sibling `SUPPLIER_RETURNS.sql` uses `WHERE item_status = 'R'` for return identification → same filter applied in `lost_revenue`.
- `lost_revenue` driving table = lineitem fact (NOT customer dimension) per domain-ecommerce rule: only customers WITH returns appear in this model.
- `client_purchase_status` driving table = order_line_items aggregation (NOT customer table) per domain-ecommerce rule: only customers who placed orders appear.
- LEFT JOIN `lost_revenue` in `client_purchase_status`: not all customers have returns (48,353 of 76,777 have zero returns); COALESCE(return_total, 0).
- CASE WHEN uses unrounded return_pct input (dbt-write Section 8: do not round before comparison).
- return_pct on 0-100 scale (dbt-write Section 12: pct columns must be 0-100).
- No filter on item_status in `client_purchase_status` order_line_items aggregation — the 'A' and 'R' items included in gross purchase_total is intentional and validated by the return_pct distribution.
