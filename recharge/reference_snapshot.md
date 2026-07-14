# Reference Table Snapshot

## recharge__billing_history (2 rows)
| Column | Type |
|--------|------|
| order_id | BIGINT |
| external_order_id_ecommerce | INTEGER |
| external_order_number_ecommerce | INTEGER |
| customer_id | BIGINT |
| email | VARCHAR |
| order_created_at | TIMESTAMP |
| order_status | VARCHAR |
| order_updated_at | TIMESTAMP |
| charge_id | BIGINT |
| transaction_id | VARCHAR |
| charge_status | VARCHAR |
| is_prepaid | BOOLEAN |
| order_total_price | FLOAT |
| order_type | VARCHAR |
| order_processed_at | TIMESTAMP |
| order_scheduled_at | TIMESTAMP |
| order_shipped_date | TIMESTAMP |
| address_id | BIGINT |
| is_deleted | BOOLEAN |
| charge_created_at | TIMESTAMP |
| payment_processor | VARCHAR |
| tags | VARCHAR |
| orders_count | INTEGER |
| charge_type | VARCHAR |
| charge_total_price | FLOAT |
| calculated_order_total_price | DECIMAL(28,2) |
| charge_subtotal_price | FLOAT |
| calculated_order_subtotal_price | DECIMAL(28,2) |
| charge_tax_lines | DOUBLE |
| calculated_order_tax_lines | DECIMAL(28,2) |
| charge_total_discounts | INTEGER |
| calculated_order_total_discounts | DECIMAL(28,2) |
| charge_total_refunds | INTEGER |
| calculated_order_total_refunds | DECIMAL(28,2) |
| charge_total_tax | DOUBLE |
| calculated_order_total_tax | DECIMAL(28,2) |
| charge_total_weight_grams | INTEGER |
| calculated_order_total_weight_grams | DECIMAL(28,2) |
| charge_total_shipping | DECIMAL(28,2) |
| calculated_order_total_shipping | DECIMAL(28,2) |
| order_item_quantity | HUGEINT |
| order_line_item_total | DECIMAL(28,2) |
| total_net_charge_value | FLOAT |
| total_calculated_net_order_value | DECIMAL(29,2) |

Sample:
| order_id | external_order_id_ecommerce | external_order_number_ecommerce | customer_id | email | order_created_at | order_status | order_updated_at | charge_id | transaction_id | charge_status | is_prepaid | order_total_price | order_type | order_processed_at | order_scheduled_at | order_shipped_date | address_id | is_deleted | charge_created_at | payment_processor | tags | orders_count | charge_type | charge_total_price | calculated_order_total_price | charge_subtotal_price | calculated_order_subtotal_price | charge_tax_lines | calculated_order_tax_lines | charge_total_discounts | calculated_order_total_discounts | charge_total_refunds | calculated_order_total_refunds | charge_total_tax | calculated_order_total_tax | charge_total_weight_grams | calculated_order_total_weight_grams | charge_total_shipping | calculated_order_total_shipping | order_item_quantity | order_line_item_total | total_net_charge_value | total_calculated_net_order_value |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 11000001 | 13000001 | 14000001 | 90000001 | name01@domain01.com | 2022-08-24 05:27:25 | SUCCESS | 2022-08-24 05:27:26 | 400000001 | ch_3La00000000000000000001uS | SUCCESS | False | 14.449999809265137 | RECURRING | 2022-08-24 05:27:27 | 2022-08-24 04:00:00 | 2022-08-24 05:27:27 | 300000001 | False | 2022-09-08 03:21:55 | stripe | Subscription, Subscription Recurring Order | 1 | RECURRING | 11.949999809265137 | 11.95 | 11.949999809265137 | 11.95 | 1.99 | 1.99 | 0 | 0.00 | 0 | 0.00 | 1.99 | 1.99 | 100 | 100.00 | 4.29 | 4.29 | 1 | 14.45 | 11.949999809265137 | 11.95 |
| 11000002 | 13000002 | 14000002 | 90000002 | name02@domain02.com | 2022-08-24 05:07:12 | SUCCESS | 2022-08-24 05:07:14 | 400000002 | ch_3La00000000000000000002uS | SUCCESS | False | 11.949999809265137 | RECURRING | 2022-08-24 05:07:15 | 2022-08-24 04:00:00 | 2022-08-24 05:07:15 | 300000002 | False | 2022-11-08 03:13:09 | braintree | Subscription, Subscription Recurring Order | 1 | RECURRING | 9.949999809265137 | 9.95 | 9.949999809265137 | 9.95 | 1.66 | 1.66 | 0 | 0.00 | 0 | 0.00 | 1.66 | 1.66 | 100 | 100.00 | 1.95 | 1.95 | 1 | 14.45 | 9.949999809265137 | 9.95 |

## recharge__charge_line_item_history (8 rows)
| Column | Type |
|--------|------|
| charge_id | BIGINT |
| charge_row_num | BIGINT |
| source_index | INTEGER |
| charge_created_at | TIMESTAMP |
| customer_id | BIGINT |
| address_id | BIGINT |
| amount | FLOAT |
| title | VARCHAR |
| line_item_type | VARCHAR |

Sample:
| charge_id | charge_row_num | source_index | charge_created_at | customer_id | address_id | amount | title | line_item_type |
|---|---|---|---|---|---|---|---|---|
| 400000001 | 1 | 0 | 2022-09-08 03:21:55 | 90000001 | 300000001 | 11.949999809265137 | Title 01 | charge line |
| 400000001 | 2 | 0 | 2022-09-08 03:21:55 | 90000001 | 300000001 | 0.9599999785423279 | code01 | discount |
| 400000001 | 3 | 0 | 2022-09-08 03:21:55 | 90000001 | 300000001 | 4.289999961853027 | Title 01 | shipping |

## recharge__churn_analysis (2 rows)
| Column | Type |
|--------|------|
| customer_id | BIGINT |
| customer_hash | VARCHAR |
| external_customer_id_ecommerce | INTEGER |
| email | VARCHAR |
| first_name | VARCHAR |
| last_name | VARCHAR |
| customer_created_at | TIMESTAMP |
| customer_updated_at | TIMESTAMP |
| first_charge_processed_at | TIMESTAMP |
| subscriptions_active_count | INTEGER |
| subscriptions_total_count | INTEGER |
| has_valid_payment_method | BOOLEAN |
| has_payment_method_in_dunning | BOOLEAN |
| tax_exempt | BOOLEAN |
| billing_first_name | VARCHAR |
| billing_last_name | VARCHAR |
| billing_company | VARCHAR |
| billing_city | VARCHAR |
| billing_country | VARCHAR |
| total_orders | BIGINT |
| total_amount_ordered | DECIMAL(28,2) |
| avg_order_amount | DECIMAL(28,2) |
| total_order_line_item_total | DECIMAL(28,2) |
| avg_order_line_item_total | DECIMAL(28,2) |
| avg_item_quantity_per_order | DECIMAL(28,2) |
| total_amount_charged | DECIMAL(28,2) |
| avg_amount_charged | DECIMAL(28,2) |
| charges_count | BIGINT |
| total_amount_taxed | DECIMAL(28,2) |
| total_amount_discounted | DECIMAL(28,2) |
| total_refunds | DECIMAL(28,2) |
| total_one_time_purchases | BIGINT |
| total_net_spend | DECIMAL(28,2) |
| calculated_subscriptions_active_count | BIGINT |
| is_currently_subscribed | BOOLEAN |
| is_new_customer | BOOLEAN |
| active_months | DECIMAL(28,2) |
| orders_monthly_average | DECIMAL(28,2) |
| amount_ordered_monthly_average | DECIMAL(28,2) |
| one_time_purchases_monthly_average | DECIMAL(28,2) |
| amount_charged_monthly_average | DECIMAL(28,2) |
| amount_discounted_monthly_average | DECIMAL(28,2) |
| amount_taxed_monthly_average | DECIMAL(28,2) |
| net_spend_monthly_average | DECIMAL(28,2) |
| is_churned | BOOLEAN |
| churn_type | VARCHAR |

Sample:
| customer_id | customer_hash | external_customer_id_ecommerce | email | first_name | last_name | customer_created_at | customer_updated_at | first_charge_processed_at | subscriptions_active_count | subscriptions_total_count | has_valid_payment_method | has_payment_method_in_dunning | tax_exempt | billing_first_name | billing_last_name | billing_company | billing_city | billing_country | total_orders | total_amount_ordered | avg_order_amount | total_order_line_item_total | avg_order_line_item_total | avg_item_quantity_per_order | total_amount_charged | avg_amount_charged | charges_count | total_amount_taxed | total_amount_discounted | total_refunds | total_one_time_purchases | total_net_spend | calculated_subscriptions_active_count | is_currently_subscribed | is_new_customer | active_months | orders_monthly_average | amount_ordered_monthly_average | one_time_purchases_monthly_average | amount_charged_monthly_average | amount_discounted_monthly_average | amount_taxed_monthly_average | net_spend_monthly_average | is_churned | churn_type |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 90000001 | d81234567891234567891234567890c | 1000000001 | name01@domain01.com | First01 | Last01 | 2022-09-07 09:54:24 | 2022-09-07 09:55:33 | 2022-09-07 09:55:30 | 0 | 0 | True | False | False | None | None | None | None | None | 1 | 14.45 | 14.45 | 14.45 | 14.45 | 1.00 | 11.95 | 11.95 | 1 | 1.99 | 0.00 | 0.00 | 0 | 11.95 | 0 | False | False | 24.60 | 0.04 | 0.59 | 0.00 | 0.49 | 0.00 | 0.08 | 0.49 | True | active cancellation |
| 90000002 | d81234567891234567891234567891b | 1000000002 | name02@domain02.com | First02 | Last02 | 2022-09-07 09:12:42 | 2022-09-07 09:29:25 | 2022-09-07 09:13:23 | 0 | 0 | True | False | False | None | None | None | None | None | 1 | 11.95 | 11.95 | 14.45 | 14.45 | 1.00 | 9.95 | 9.95 | 1 | 1.66 | 0.00 | 0.00 | 0 | 9.95 | 0 | False | False | 24.60 | 0.04 | 0.49 | 0.00 | 0.40 | 0.00 | 0.07 | 0.40 | True | active cancellation |

## recharge__customer_details (2 rows)
| Column | Type |
|--------|------|
| customer_id | BIGINT |
| customer_hash | VARCHAR |
| external_customer_id_ecommerce | INTEGER |
| email | VARCHAR |
| first_name | VARCHAR |
| last_name | VARCHAR |
| customer_created_at | TIMESTAMP |
| customer_updated_at | TIMESTAMP |
| first_charge_processed_at | TIMESTAMP |
| subscriptions_active_count | INTEGER |
| subscriptions_total_count | INTEGER |
| has_valid_payment_method | BOOLEAN |
| has_payment_method_in_dunning | BOOLEAN |
| tax_exempt | BOOLEAN |
| billing_first_name | VARCHAR |
| billing_last_name | VARCHAR |
| billing_company | VARCHAR |
| billing_city | VARCHAR |
| billing_country | VARCHAR |
| total_orders | BIGINT |
| total_amount_ordered | DECIMAL(28,2) |
| avg_order_amount | DECIMAL(28,2) |
| total_order_line_item_total | DECIMAL(28,2) |
| avg_order_line_item_total | DECIMAL(28,2) |
| avg_item_quantity_per_order | DECIMAL(28,2) |
| total_amount_charged | DECIMAL(28,2) |
| avg_amount_charged | DECIMAL(28,2) |
| charges_count | BIGINT |
| total_amount_taxed | DECIMAL(28,2) |
| total_amount_discounted | DECIMAL(28,2) |
| total_refunds | DECIMAL(28,2) |
| total_one_time_purchases | BIGINT |
| total_net_spend | DECIMAL(28,2) |
| calculated_subscriptions_active_count | BIGINT |
| is_currently_subscribed | BOOLEAN |
| is_new_customer | BOOLEAN |
| active_months | DECIMAL(28,2) |
| orders_monthly_average | DECIMAL(28,2) |
| amount_ordered_monthly_average | DECIMAL(28,2) |
| one_time_purchases_monthly_average | DECIMAL(28,2) |
| amount_charged_monthly_average | DECIMAL(28,2) |
| amount_discounted_monthly_average | DECIMAL(28,2) |
| amount_taxed_monthly_average | DECIMAL(28,2) |
| net_spend_monthly_average | DECIMAL(28,2) |

Sample:
| customer_id | customer_hash | external_customer_id_ecommerce | email | first_name | last_name | customer_created_at | customer_updated_at | first_charge_processed_at | subscriptions_active_count | subscriptions_total_count | has_valid_payment_method | has_payment_method_in_dunning | tax_exempt | billing_first_name | billing_last_name | billing_company | billing_city | billing_country | total_orders | total_amount_ordered | avg_order_amount | total_order_line_item_total | avg_order_line_item_total | avg_item_quantity_per_order | total_amount_charged | avg_amount_charged | charges_count | total_amount_taxed | total_amount_discounted | total_refunds | total_one_time_purchases | total_net_spend | calculated_subscriptions_active_count | is_currently_subscribed | is_new_customer | active_months | orders_monthly_average | amount_ordered_monthly_average | one_time_purchases_monthly_average | amount_charged_monthly_average | amount_discounted_monthly_average | amount_taxed_monthly_average | net_spend_monthly_average |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 90000001 | d81234567891234567891234567890c | 1000000001 | name01@domain01.com | First01 | Last01 | 2022-09-07 09:54:24 | 2022-09-07 09:55:33 | 2022-09-07 09:55:30 | 0 | 0 | True | False | False | None | None | None | None | None | 1 | 14.45 | 14.45 | 14.45 | 14.45 | 1.00 | 11.95 | 11.95 | 1 | 1.99 | 0.00 | 0.00 | 0 | 11.95 | 0 | False | False | 24.60 | 0.04 | 0.59 | 0.00 | 0.49 | 0.00 | 0.08 | 0.49 |
| 90000002 | d81234567891234567891234567891b | 1000000002 | name02@domain02.com | First02 | Last02 | 2022-09-07 09:12:42 | 2022-09-07 09:29:25 | 2022-09-07 09:13:23 | 0 | 0 | True | False | False | None | None | None | None | None | 1 | 11.95 | 11.95 | 14.45 | 14.45 | 1.00 | 9.95 | 9.95 | 1 | 1.66 | 0.00 | 0.00 | 0 | 9.95 | 0 | False | False | 24.60 | 0.04 | 0.49 | 0.00 | 0.40 | 0.00 | 0.07 | 0.40 |

## recharge__subscription_overview (2 rows)
| Column | Type |
|--------|------|
| subscription_id | INTEGER |
| customer_id | BIGINT |
| address_id | BIGINT |
| subscription_created_at | TIMESTAMP |
| external_product_id_ecommerce | BIGINT |
| external_variant_id_ecommerce | BIGINT |
| product_title | VARCHAR |
| variant_title | VARCHAR |
| sku | VARCHAR |
| price | FLOAT |
| quantity | INTEGER |
| subscription_status | VARCHAR |
| charge_interval_frequency | INTEGER |
| order_interval_unit | VARCHAR |
| order_interval_frequency | INTEGER |
| order_day_of_month | INTEGER |
| order_day_of_week | INTEGER |
| expire_after_specific_number_of_charges | INTEGER |
| subscription_updated_at | TIMESTAMP |
| subscription_next_charge_scheduled_at | TIMESTAMP |
| subscription_cancelled_at | TIMESTAMP |
| cancellation_reason | VARCHAR |
| cancellation_reason_comments | INTEGER |
| _fivetran_synced | TIMESTAMP |
| is_most_recent_record | BOOLEAN |
| count_successful_charges | BIGINT |
| count_queued_charges | BIGINT |
| charges_until_expiration | BIGINT |
| charge_interval_frequency_days | INTEGER |

Sample:
| subscription_id | customer_id | address_id | subscription_created_at | external_product_id_ecommerce | external_variant_id_ecommerce | product_title | variant_title | sku | price | quantity | subscription_status | charge_interval_frequency | order_interval_unit | order_interval_frequency | order_day_of_month | order_day_of_week | expire_after_specific_number_of_charges | subscription_updated_at | subscription_next_charge_scheduled_at | subscription_cancelled_at | cancellation_reason | cancellation_reason_comments | _fivetran_synced | is_most_recent_record | count_successful_charges | count_queued_charges | charges_until_expiration | charge_interval_frequency_days |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 600000002 | 90000002 | 300000002 | 2022-01-31 16:00:12 | 6800000000002 | 4800000000002 | Product Title 02 | Pause or Cancel Anytime | SKU02 | 11.949999809265137 | 1 | ACTIVE | 45 | day | 45 | None | None | None | 2022-09-07 14:13:14 | 2022-09-29 04:00:00 | None | None | None | 2022-09-08 03:53:21.881000 | True | 0 | 0 | None | 45 |
| 600000001 | 90000001 | 300000001 | 2022-06-05 19:28:27 | 6800000000001 | 4800000000001 | Product Title 01 | Delivered Monthly / Pause or Cancel Anytime | SKU01 | 18.450000762939453 | 1 | CANCELLED | 28 | day | 28 | None | None | None | 2022-09-07 16:10:18 | None | 2022-09-07 16:10:19 | Lack of benefits | None | 2022-09-08 03:56:10.482000 | True | 0 | 0 | None | 28 |
