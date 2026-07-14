{{ config(materialized='table') }}

-- EXPECTED SHAPE: 3 rows — REASON: one row per unique product (product_id + source_relation)

with products_with_aggregates as (

    select *
    from {{ ref('int_shopify__products_with_aggregates') }}

),

product_order_line_aggregates as (

    select *
    from {{ ref('int_shopify__product__order_line_aggregates') }}

),

joined as (

    select
        products_with_aggregates.is_deleted,
        products_with_aggregates._fivetran_synced,
        products_with_aggregates.created_timestamp,
        products_with_aggregates.handle,
        products_with_aggregates.product_id,
        products_with_aggregates.product_type,
        products_with_aggregates.published_timestamp,
        products_with_aggregates.published_scope,
        products_with_aggregates.title,
        products_with_aggregates.updated_timestamp,
        products_with_aggregates.vendor,
        coalesce(product_order_line_aggregates.quantity_sold, 0)             as total_quantity_sold,
        coalesce(product_order_line_aggregates.subtotal_sold, 0)             as subtotal_sold,
        coalesce(product_order_line_aggregates.quantity_sold_net_refunds, 0) as quantity_sold_net_refunds,
        coalesce(product_order_line_aggregates.subtotal_sold_net_refunds, 0) as subtotal_sold_net_refunds,
        product_order_line_aggregates.first_order_timestamp,
        product_order_line_aggregates.most_recent_order_timestamp,
        products_with_aggregates.source_relation,
        product_order_line_aggregates.avg_quantity_per_order_line,
        coalesce(product_order_line_aggregates.product_total_discount, 0)    as product_total_discount,
        product_order_line_aggregates.product_avg_discount_per_order_line,
        coalesce(product_order_line_aggregates.product_total_tax, 0)         as product_total_tax,
        product_order_line_aggregates.product_avg_tax_per_order_line,
        products_with_aggregates.count_variants,
        products_with_aggregates.has_product_image,
        products_with_aggregates.status,
        products_with_aggregates.collections,
        products_with_aggregates.tags

    from products_with_aggregates
    left join product_order_line_aggregates
        on products_with_aggregates.product_id = product_order_line_aggregates.product_id
        and products_with_aggregates.source_relation = product_order_line_aggregates.source_relation

)

select *
from joined
