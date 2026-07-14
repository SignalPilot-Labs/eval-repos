# Technical Spec — shopify001

## Build Order
1. `shopify__products` (mart — depends on `int_shopify__products_with_aggregates`, `int_shopify__product__order_line_aggregates`)
2. `shopify__daily_shop` (mart — depends on `shopify__calendar`, `stg_shopify__shop` via var, `int_shopify__daily_orders`, `int_shopify__daily_abandoned_checkouts`, `int_shopify__daily_fulfillment`)

---

## Model: shopify__products

- **Source**:
  - `ref('int_shopify__products_with_aggregates')` — provides all product metadata + collections/tags/variants/image aggregates (ephemeral, compiles inline)
  - `ref('int_shopify__product__order_line_aggregates')` — provides all order-line-based metrics per product (ephemeral, compiles inline)

- **Driving table**: `int_shopify__products_with_aggregates` — 3 rows (one per unique product). Product is the authoritative grain.

- **Joins**:
  - `LEFT JOIN int_shopify__product__order_line_aggregates ON products_with_aggregates.product_id = agg.product_id AND products_with_aggregates.source_relation = agg.source_relation`
  - LEFT JOIN used because products may have no order lines yet.

- **Key expressions**:
  - `is_deleted` — from `products_with_aggregates.is_deleted`
  - `_fivetran_synced` — from `products_with_aggregates._fivetran_synced`
  - `created_timestamp` — from `products_with_aggregates.created_timestamp`
  - `handle`, `product_id`, `product_type`, `published_timestamp`, `published_scope`, `title`, `updated_timestamp`, `vendor`, `status` — from `products_with_aggregates.*`
  - `total_quantity_sold` = `COALESCE(agg.quantity_sold, 0)` — agg column is `quantity_sold`, output alias is `total_quantity_sold`
  - `subtotal_sold` = `COALESCE(agg.subtotal_sold, 0)`
  - `quantity_sold_net_refunds` = `COALESCE(agg.quantity_sold_net_refunds, 0)`
  - `subtotal_sold_net_refunds` = `COALESCE(agg.subtotal_sold_net_refunds, 0)`
  - `first_order_timestamp` — from agg (NULL for products with no orders)
  - `most_recent_order_timestamp` — from agg (NULL for products with no orders)
  - `source_relation` — from `products_with_aggregates.source_relation`
  - `avg_quantity_per_order_line` — from agg (NULL for products with no orders; avg of nothing = NULL)
  - `product_total_discount` = `COALESCE(agg.product_total_discount, 0)`
  - `product_avg_discount_per_order_line` — from agg (NULL for products with no orders)
  - `product_total_tax` = `COALESCE(agg.product_total_tax, 0)`
  - `product_avg_tax_per_order_line` — from agg (NULL for products with no orders)
  - `count_variants` — from `products_with_aggregates.count_variants`
  - `has_product_image` — from `products_with_aggregates.has_product_image`
  - `collections` — from `products_with_aggregates.collections`
  - `tags` — from `products_with_aggregates.tags`

- **Filters**: none. Include all products regardless of status or deletion flag.

- **Expected grain**: one row per product (product_id + source_relation)

- **Expected rows**: 3 (blueprint: 3 distinct products in shopify_product_data)

---

## Model: shopify__daily_shop

- **Source**:
  - `ref('shopify__calendar')` — date spine from 2019-01-01 to current_date (rebuilt); driving table
  - `var('shopify_shop')` = `ref('stg_shopify__shop')` — shop metadata (1 shop)
  - `ref('int_shopify__daily_orders')` — daily order aggregates (ephemeral, from shopify__orders + shopify__order_lines)
  - `ref('int_shopify__daily_abandoned_checkouts')` — daily abandoned checkout aggregates (ephemeral, from stg_shopify__abandoned_checkout)
  - `ref('int_shopify__daily_fulfillment')` — daily fulfillment event aggregates (ephemeral, from stg_shopify__fulfillment_event; ENABLED: shopify_using_fulfillment_event=true in dbt_project.yml)

- **Driving table**: `shopify__calendar` — calendar spine (2077+ rows). This is a calendar-spine model: all days MUST appear with zero-activity metrics COALESCE'd to 0. Exception to fact-drives rule per domain-ecommerce.

- **Joins**:
  - `CROSS JOIN stg_shopify__shop` — 1 shop row × N calendar rows = N output rows
  - `LEFT JOIN int_shopify__daily_orders ON calendar.date_day = orders.date_day AND shop.source_relation = orders.source_relation`
  - `LEFT JOIN int_shopify__daily_abandoned_checkouts ON calendar.date_day = abandoned.date_day AND shop.source_relation = abandoned.source_relation`
  - `LEFT JOIN int_shopify__daily_fulfillment ON calendar.date_day = fulfillment.date_day AND shop.source_relation = fulfillment.source_relation`
  - Note: source_relation is empty string (verified by querying shopify__orders and shopify__order_lines); equality join works correctly.

- **Key expressions**:
  - `date_day` — from `calendar.date_day`
  - `shop_id`, `name`, `domain`, `is_deleted`, `currency`, `enabled_presentment_currencies`, `iana_timezone`, `created_at` — from `shop.*`
  - All count and sum metrics from `int_shopify__daily_orders`: COALESCE to 0 for days with no orders
  - `avg_*` metrics: no COALESCE (NULL on days with no activity is semantically correct for averages)
  - `first_order_timestamp`, `last_order_timestamp`: NULL on days with no orders
  - Abandoned checkout counts: COALESCE to 0 from `int_shopify__daily_abandoned_checkouts`
  - Fulfillment counts: COALESCE to 0 from `int_shopify__daily_fulfillment` (11 statuses via Jinja loop in the int model, referenced as plain columns here)

- **Filters**: none for calendar or shop. `int_shopify__daily_abandoned_checkouts` internally filters `is_deleted = false`; no additional filter needed in this model.

- **Expected grain**: one row per date_day per shop (1 shop × calendar rows)

- **Expected rows**: same as shopify__calendar row count (2077+ after rebuild)

---

## Decisions

- `int_shopify__products_with_aggregates` drives shopify__products — it contains product metadata + aggregated collections/tags/variants/images; LEFT JOIN agg model to avoid dropping products with no sales.
- `total_quantity_sold` aliases `agg.quantity_sold` — int model names it `quantity_sold`, YML requires `total_quantity_sold`.
- COALESCE sum-type metrics to 0 for products with no sales (count/sum are 0); leave avg-type and timestamp metrics as NULL (undefined when no data).
- Calendar spine drives shopify__daily_shop per domain-ecommerce exception for calendar-spine models. CROSS JOIN shop (1 row) produces one row per day.
- `shopify_using_fulfillment_event=true` in dbt_project.yml — `int_shopify__daily_fulfillment` IS enabled and can be referenced.
- source_relation is empty string (not NULL) in all tables — equality join on source_relation is safe.
- All intermediate models are ephemeral — they compile as inline CTEs; no materialization needed before referencing them.
- No return filter on shopify__products — products record all quantities including refunds (handled via separate net-refund columns in int_shopify__product__order_line_aggregates).
