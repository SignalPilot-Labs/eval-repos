# Reference Table Snapshot

## shopify__inventory_levels (0 rows)
| Column | Type |
|--------|------|
| inventory_item_id | INTEGER |
| location_id | INTEGER |
| available_quantity | INTEGER |
| updated_at | TIMESTAMP |
| _fivetran_synced | TIMESTAMP |
| source_relation | VARCHAR |
| sku | INTEGER |
| is_inventory_item_deleted | BOOLEAN |
| cost | INTEGER |
| country_code_of_origin | INTEGER |
| province_code_of_origin | INTEGER |
| is_shipping_required | INTEGER |
| is_inventory_quantity_tracked | INTEGER |
| inventory_item_created_at | TIMESTAMP |
| inventory_item_updated_at | TIMESTAMP |
| location_name | VARCHAR |
| is_location_deleted | BOOLEAN |
| is_location_active | BOOLEAN |
| address_1 | VARCHAR |
| address_2 | INTEGER |
| city | VARCHAR |
| country | VARCHAR |
| country_code | VARCHAR |
| is_legacy_location | BOOLEAN |
| province | VARCHAR |
| province_code | VARCHAR |
| phone | INTEGER |
| zip | INTEGER |
| location_created_at | TIMESTAMP |
| location_updated_at | TIMESTAMP |
| variant_id | VARCHAR |
| product_id | VARCHAR |
| variant_title | VARCHAR |
| variant_inventory_policy | VARCHAR |
| variant_price | INTEGER |
| variant_image_id | INTEGER |
| variant_fulfillment_service | VARCHAR |
| variant_inventory_management | VARCHAR |
| is_variant_taxable | BOOLEAN |
| variant_barcode | INTEGER |
| variant_grams | INTEGER |
| variant_inventory_quantity | INTEGER |
| variant_weight | INTEGER |
| variant_weight_unit | VARCHAR |
| variant_option_1 | VARCHAR |
| variant_option_2 | INTEGER |
| variant_option_3 | INTEGER |
| variant_tax_code | VARCHAR |
| variant_created_at | TIMESTAMP |
| variant_updated_at | TIMESTAMP |
| subtotal_sold | HUGEINT |
| quantity_sold | HUGEINT |
| count_distinct_orders | BIGINT |
| count_distinct_customers | BIGINT |
| count_distinct_customer_emails | BIGINT |
| first_order_timestamp | TIMESTAMP |
| last_order_timestamp | TIMESTAMP |
| subtotal_sold_refunds | HUGEINT |
| quantity_sold_refunds | HUGEINT |
| count_fulfillment_pending | BIGINT |
| count_fulfillment_open | BIGINT |
| count_fulfillment_success | BIGINT |
| count_fulfillment_cancelled | BIGINT |
| count_fulfillment_error | BIGINT |
| count_fulfillment_failure | BIGINT |
| net_subtotal_sold | HUGEINT |
| net_quantity_sold | HUGEINT |


## shopify__order_lines (3 rows)
| Column | Type |
|--------|------|
| order_line_id | VARCHAR |
| index | INTEGER |
| name | VARCHAR |
| order_id | VARCHAR |
| fulfillable_quantity | INTEGER |
| fulfillment_status | VARCHAR |
| is_gift_card | BOOLEAN |
| grams | INTEGER |
| pre_tax_price | INTEGER |
| pre_tax_price_set | VARCHAR |
| price | DOUBLE |
| price_set | VARCHAR |
| product_id | VARCHAR |
| quantity | INTEGER |
| is_shipping_required | BOOLEAN |
| sku | VARCHAR |
| is_taxable | BOOLEAN |
| tax_code | VARCHAR |
| title | VARCHAR |
| total_discount | INTEGER |
| total_discount_set | VARCHAR |
| variant_id | VARCHAR |
| variant_title | VARCHAR |
| variant_inventory_management | VARCHAR |
| vendor | VARCHAR |
| properties | VARCHAR |
| _fivetran_synced | TIMESTAMP |
| source_relation | VARCHAR |
| order_lines_unique_key | VARCHAR |
| restock_types | VARCHAR |
| refunded_quantity | HUGEINT |
| refunded_subtotal | HUGEINT |
| quantity_net_refunds | HUGEINT |
| subtotal_net_refunds | HUGEINT |
| variant_created_at | TIMESTAMP |
| variant_updated_at | TIMESTAMP |
| inventory_item_id | VARCHAR |
| image_id | INTEGER |
| variant_price | INTEGER |
| variant_sku | INTEGER |
| variant_position | INTEGER |
| variant_inventory_policy | VARCHAR |
| variant_compare_at_price | INTEGER |
| variant_fulfillment_service | VARCHAR |
| variant_is_taxable | BOOLEAN |
| variant_barcode | INTEGER |
| variant_grams | INTEGER |
| variant_inventory_quantity | INTEGER |
| variant_weight | INTEGER |
| variant_weight_unit | VARCHAR |
| variant_option_1 | VARCHAR |
| variant_option_2 | INTEGER |
| variant_option_3 | INTEGER |
| variant_tax_code | VARCHAR |
| order_line_tax | DOUBLE |

Sample:
| order_line_id | index | name | order_id | fulfillable_quantity | fulfillment_status | is_gift_card | grams | pre_tax_price | pre_tax_price_set | price | price_set | product_id | quantity | is_shipping_required | sku | is_taxable | tax_code | title | total_discount | total_discount_set | variant_id | variant_title | variant_inventory_management | vendor | properties | _fivetran_synced | source_relation | order_lines_unique_key | restock_types | refunded_quantity | refunded_subtotal | quantity_net_refunds | subtotal_net_refunds | variant_created_at | variant_updated_at | inventory_item_id | image_id | variant_price | variant_sku | variant_position | variant_inventory_policy | variant_compare_at_price | variant_fulfillment_service | variant_is_taxable | variant_barcode | variant_grams | variant_inventory_quantity | variant_weight | variant_weight_unit | variant_option_1 | variant_option_2 | variant_option_3 | variant_tax_code | order_line_tax |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5699743 | 1 | 327ea22d0f91783418e519cb45a4a3e9 | 2669509 | 0 | fulfilled | False | 0 | None | None | 4.4 | None | 4526236 | 1 | True | 854a136da51d43fb87c63c86a62ffad0 | False | None | 327ea22d0f91783418e519cb45a4a3e9 | 0 | None | 3187981 | None | None | 13aea892c8de2d62f2608c6191cfab1f | None | 2020-09-11 00:14:33.293000 |  | 795e79ca7150d37252baba3ad902abde | None | 0 | 0 | 1 | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None |
| 5699758 | 1 | 1fccbdc6ac5f6edabf76e56eb0460019 | 2669516 | 0 | fulfilled | False | 0 | None | None | 2.8 | None | 4506451 | 1 | True | 198369004c95b2b35f480f9691b14178 | False | None | 1fccbdc6ac5f6edabf76e56eb0460019 | 0 | None | 3181487 | None | None | 13aea892c8de2d62f2608c6191cfab1f | None | 2020-09-11 00:14:33.767000 |  | 6b2f30c5f5c6e053dbb1645c0ccb226b | None | 0 | 0 | 1 | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None |
| 5708321 | 1 | 74c574cc1e545fef2beeaf9bbb148fcc | 2674098 | 2 | None | False | 0 | None | None | 2.8 | None | 4505775 | 2 | True | b988b358c81b47d3e438c99bfb1c4ee1 | False | None | 74c574cc1e545fef2beeaf9bbb148fcc | 0 | None | 3181247 | None | None | 57403999f78b01b3fd325ba256eafe94 | None | 2020-09-12 00:15:10.199000 |  | 4085f6a501330b7382a7c83ec317ddea | None | 0 | 0 | 2 | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None | None |

## shopify__orders (3 rows)
| Column | Type |
|--------|------|
| order_id | VARCHAR |
| user_id | VARCHAR |
| total_discounts | DOUBLE |
| total_discounts_set | VARCHAR |
| total_line_items_price | DOUBLE |
| total_line_items_price_set | VARCHAR |
| total_price | DOUBLE |
| total_price_set | VARCHAR |
| total_tax_set | VARCHAR |
| total_tax | INTEGER |
| source_name | VARCHAR |
| subtotal_price | DOUBLE |
| has_taxes_included | BOOLEAN |
| total_weight | INTEGER |
| total_tip_received | FLOAT |
| landing_site_base_url | VARCHAR |
| location_id | VARCHAR |
| name | VARCHAR |
| note | VARCHAR |
| number | INTEGER |
| order_number | INTEGER |
| cancel_reason | INTEGER |
| cart_token | VARCHAR |
| checkout_token | VARCHAR |
| created_timestamp | TIMESTAMP |
| cancelled_timestamp | TIMESTAMP |
| closed_timestamp | TIMESTAMP |
| processed_timestamp | TIMESTAMP |
| updated_timestamp | TIMESTAMP |
| currency | VARCHAR |
| customer_id | VARCHAR |
| email | VARCHAR |
| financial_status | VARCHAR |
| fulfillment_status | VARCHAR |
| referring_site | VARCHAR |
| billing_address_address_1 | VARCHAR |
| billing_address_address_2 | VARCHAR |
| billing_address_city | VARCHAR |
| billing_address_company | VARCHAR |
| billing_address_country | VARCHAR |
| billing_address_country_code | VARCHAR |
| billing_address_first_name | VARCHAR |
| billing_address_last_name | VARCHAR |
| billing_address_latitude | VARCHAR |
| billing_address_longitude | VARCHAR |
| billing_address_name | VARCHAR |
| billing_address_phone | VARCHAR |
| billing_address_province | VARCHAR |
| billing_address_province_code | INTEGER |
| billing_address_zip | VARCHAR |
| browser_ip | VARCHAR |
| total_shipping_price_set | VARCHAR |
| shipping_address_address_1 | VARCHAR |
| shipping_address_address_2 | VARCHAR |
| shipping_address_city | VARCHAR |
| shipping_address_company | VARCHAR |
| shipping_address_country | VARCHAR |
| shipping_address_country_code | VARCHAR |
| shipping_address_first_name | VARCHAR |
| shipping_address_last_name | VARCHAR |
| shipping_address_latitude | VARCHAR |
| shipping_address_longitude | VARCHAR |
| shipping_address_name | VARCHAR |
| shipping_address_phone | VARCHAR |
| shipping_address_province | VARCHAR |
| shipping_address_province_code | INTEGER |
| shipping_address_zip | VARCHAR |
| token | VARCHAR |
| app_id | INTEGER |
| checkout_id | INTEGER |
| client_details_user_agent | VARCHAR |
| customer_locale | VARCHAR |
| order_status_url | VARCHAR |
| presentment_currency | VARCHAR |
| is_test_order | BOOLEAN |
| is_deleted | BOOLEAN |
| has_buyer_accepted_marketing | BOOLEAN |
| is_confirmed | BOOLEAN |
| _fivetran_synced | TIMESTAMP |
| source_relation | VARCHAR |
| orders_unique_key | VARCHAR |
| shipping_cost | INTEGER |
| order_adjustment_amount | HUGEINT |
| order_adjustment_tax_amount | DOUBLE |
| refund_subtotal | HUGEINT |
| refund_total_tax | DOUBLE |
| order_adjusted_total | DOUBLE |
| line_item_count | BIGINT |
| shipping_discount_amount | DOUBLE |
| percentage_calc_discount_amount | DOUBLE |
| fixed_amount_discount_amount | DOUBLE |
| count_discount_codes_applied | BIGINT |
| order_total_shipping_tax | DOUBLE |
| order_tags | VARCHAR |
| order_url_tags | VARCHAR |
| number_of_fulfillments | BIGINT |
| fulfillment_services | VARCHAR |
| tracking_companies | VARCHAR |
| tracking_numbers | VARCHAR |
| customer_order_seq_number | BIGINT |
| new_vs_repeat | VARCHAR |

Sample:
| order_id | user_id | total_discounts | total_discounts_set | total_line_items_price | total_line_items_price_set | total_price | total_price_set | total_tax_set | total_tax | source_name | subtotal_price | has_taxes_included | total_weight | total_tip_received | landing_site_base_url | location_id | name | note | number | order_number | cancel_reason | cart_token | checkout_token | created_timestamp | cancelled_timestamp | closed_timestamp | processed_timestamp | updated_timestamp | currency | customer_id | email | financial_status | fulfillment_status | referring_site | billing_address_address_1 | billing_address_address_2 | billing_address_city | billing_address_company | billing_address_country | billing_address_country_code | billing_address_first_name | billing_address_last_name | billing_address_latitude | billing_address_longitude | billing_address_name | billing_address_phone | billing_address_province | billing_address_province_code | billing_address_zip | browser_ip | total_shipping_price_set | shipping_address_address_1 | shipping_address_address_2 | shipping_address_city | shipping_address_company | shipping_address_country | shipping_address_country_code | shipping_address_first_name | shipping_address_last_name | shipping_address_latitude | shipping_address_longitude | shipping_address_name | shipping_address_phone | shipping_address_province | shipping_address_province_code | shipping_address_zip | token | app_id | checkout_id | client_details_user_agent | customer_locale | order_status_url | presentment_currency | is_test_order | is_deleted | has_buyer_accepted_marketing | is_confirmed | _fivetran_synced | source_relation | orders_unique_key | shipping_cost | order_adjustment_amount | order_adjustment_tax_amount | refund_subtotal | refund_total_tax | order_adjusted_total | line_item_count | shipping_discount_amount | percentage_calc_discount_amount | fixed_amount_discount_amount | count_discount_codes_applied | order_total_shipping_tax | order_tags | order_url_tags | number_of_fulfillments | fulfillment_services | tracking_companies | tracking_numbers | customer_order_seq_number | new_vs_repeat |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 8602081 | None | 2.8 | None | 5.6 | None | 2.8 | None | None | 0 | 294517 | 2.8 | True | 0 | None | None | None | d1743fc58a1e4d78769eaac49994a994 | 71509c29301d2cc14e37ecb53f735608 | 4135 | 5135 | None | None | None | 2020-09-11 19:35:42 | None | None | 2020-09-11 19:35:42 | 2020-09-11 19:35:46 | GBP | 3589760876641 | 021cb20b5c78751fc7ddc091b6b69b3e | paid | None | None | d6f4a399883df85d9d4b3a02bf6e738a | bc9b8576178dcd886639ba718f1d45c8 | ac08c606d455cde42980f980524a8038 | d41d8cd98f00b204e9800998ecf8427e | 89f9c9f489be2a83cf57e53b9197d288 | 79cba1185463850dedba31f172f1dc5b | f0962b7a185488ecb752cedac1038349 | aa35cb67c26e64bb81a1bf3f17e858ba | d97319f64674c02595f2989019970fc8 | c08dae474c5d4d3326fd6764d2a0ebe6 | 8b121314a4d97bc9dc15bfba8518ec88 | d41d8cd98f00b204e9800998ecf8427e | d41d8cd98f00b204e9800998ecf8427e | None | 00079ce435afddc28205639142773870 | None | one  | d6f4a399883df85d9d4b3a02bf6e738a | bc9b8576178dcd886639ba718f1d45c8 | ac08c606d455cde42980f980524a8038 | d41d8cd98f00b204e9800998ecf8427e | 89f9c9f489be2a83cf57e53b9197d288 | 79cba1185463850dedba31f172f1dc5b | f0962b7a185488ecb752cedac1038349 | aa35cb67c26e64bb81a1bf3f17e858ba | d97319f64674c02595f2989019970fc8 | c08dae474c5d4d3326fd6764d2a0ebe6 | 8b121314a4d97bc9dc15bfba8518ec88 | d41d8cd98f00b204e9800998ecf8427e | d41d8cd98f00b204e9800998ecf8427e | None | 00079ce435afddc28205639142773870 | 0f9c2880de17f71511eee5542c29b999 | None | None | None | None | None | None | False | None | True | None | 2020-09-12 00:15:10.199000 |  | c9a82e177b97ee202f09c5fbdf55b13d | 0 | None | None | None | None | 2.8 | None | 0.0 | 0.0 | 0.0 | 0 | 0.0 | None | None | None | None | None | None | 1 | new |
| 9541985 | None | 0.0 | None | 4.4 | None | 5.39 | None | None | 0 | web | 4.4 | True | 0 | None | 8584e97b29b0802fb393fa453a8b6a7a | None | 9e346f2e912c60e16679f4a4c8d29422 | None | 4065 | 5065 | None | 9600543f4d4613db59ac58a1009ecbb9 | cf0a9fe2c7c606b86559007dbb890a62 | 2020-09-09 22:57:51 | None | 2020-09-10 15:38:25 | 2020-09-09 22:57:50 | 2020-09-10 15:38:25 | GBP | 3584045351009 | dce90c7b4e52e045e5975836aff49cf1 | paid | fulfilled | 2cc983716a820bc713b793a6e8e73f42 | 1ff1de774005f8da13f42943881c655f | 70111f8840ccbd8b1007cc3f387ced6b | 1ac412baeba98370017c73df41c98a07 | d41d8cd98f00b204e9800998ecf8427e | 89f9c9f489be2a83cf57e53b9197d288 | 79cba1185463850dedba31f172f1dc5b | d3bae70c9d49bb7cb5a74cdd0eae7fc4 | 0dd89cff60965dff8f9ea2bc952a5474 | 75c29d6dd29594a652fcbd7c4c279a29 | 75468fbebc28e02ec5d4f54f4cbd4099 | c8189c7add9755e66391b58ecc12b3e2 | d41d8cd98f00b204e9800998ecf8427e | None | None | 2357e65b582faa0a2da3603b16fa4a7f | 109.249.185.68 | one   | 1ff1de774005f8da13f42943881c655f | 70111f8840ccbd8b1007cc3f387ced6b | 1ac412baeba98370017c73df41c98a07 | d41d8cd98f00b204e9800998ecf8427e | 89f9c9f489be2a83cf57e53b9197d288 | 79cba1185463850dedba31f172f1dc5b | d3bae70c9d49bb7cb5a74cdd0eae7fc4 | 0dd89cff60965dff8f9ea2bc952a5474 | 75c29d6dd29594a652fcbd7c4c279a29 | 75468fbebc28e02ec5d4f54f4cbd4099 | c8189c7add9755e66391b58ecc12b3e2 | d41d8cd98f00b204e9800998ecf8427e | None | None | 2357e65b582faa0a2da3603b16fa4a7f | e44b7f04610a8f4032530cc7f12663de | None | None | None | None | None | None | False | None | False | None | 2020-09-11 00:14:33.037000 |  | 5b45adb77df7687d7922569957b54c7d | 0 | None | None | None | None | 5.39 | None | 0.0 | 0.0 | 0.0 | 0 | 0.0 | None | None | None | None | None | None | 1 | new |
| 6488801 | None | 0.0 | None | 2.8 | None | 3.79 | None | None | 0 | web | 2.8 | True | 0 | None | 8584e97b29b0802fb393fa453a8b6a7a | None | 4fcb884b5b46413bae526a6e7e49d706 | None | 4066 | 5066 | None | b1ff04883dfeab658cd5211050476729 | 7bdb994e1196de3e4f34586e357613f9 | 2020-09-09 23:01:54 | None | 2020-09-10 15:38:26 | 2020-09-09 23:01:53 | 2020-09-10 15:38:26 | GBP | 3584045351009 | dce90c7b4e52e045e5975836aff49cf1 | paid | fulfilled | 2cc983716a820bc713b793a6e8e73f42 | 1ff1de774005f8da13f42943881c655f | 70111f8840ccbd8b1007cc3f387ced6b | 1ac412baeba98370017c73df41c98a07 | d41d8cd98f00b204e9800998ecf8427e | 89f9c9f489be2a83cf57e53b9197d288 | 79cba1185463850dedba31f172f1dc5b | d3bae70c9d49bb7cb5a74cdd0eae7fc4 | 0dd89cff60965dff8f9ea2bc952a5474 | 75c29d6dd29594a652fcbd7c4c279a29 | 75468fbebc28e02ec5d4f54f4cbd4099 | c8189c7add9755e66391b58ecc12b3e2 | d41d8cd98f00b204e9800998ecf8427e | None | None | 2357e65b582faa0a2da3603b16fa4a7f | 109.249.185.68 | one   | 1ff1de774005f8da13f42943881c655f | 70111f8840ccbd8b1007cc3f387ced6b | 1ac412baeba98370017c73df41c98a07 | d41d8cd98f00b204e9800998ecf8427e | 89f9c9f489be2a83cf57e53b9197d288 | 79cba1185463850dedba31f172f1dc5b | d3bae70c9d49bb7cb5a74cdd0eae7fc4 | 0dd89cff60965dff8f9ea2bc952a5474 | 75c29d6dd29594a652fcbd7c4c279a29 | 75468fbebc28e02ec5d4f54f4cbd4099 | c8189c7add9755e66391b58ecc12b3e2 | d41d8cd98f00b204e9800998ecf8427e | None | None | 2357e65b582faa0a2da3603b16fa4a7f | fb489b3ccc0ae36ce47744d7595e9746 | None | None | None | None | None | None | False | None | False | None | 2020-09-11 00:14:33.536000 |  | 14f20ac69f9eeec97fffdf1cd42959ac | 0 | None | None | None | None | 3.79 | None | 0.0 | 0.0 | 0.0 | 0 | 0.0 | None | None | None | None | None | None | 2 | repeat |

## shopify__transactions (5 rows)
| Column | Type |
|--------|------|
| transaction_id | VARCHAR |
| order_id | VARCHAR |
| refund_id | VARCHAR |
| amount | DOUBLE |
| device_id | INTEGER |
| gateway | VARCHAR |
| source_name | VARCHAR |
| message | VARCHAR |
| currency | VARCHAR |
| location_id | INTEGER |
| parent_id | INTEGER |
| payment_avs_result_code | VARCHAR |
| payment_credit_card_bin | INTEGER |
| payment_cvv_result_code | INTEGER |
| payment_credit_card_number | INTEGER |
| payment_credit_card_company | INTEGER |
| kind | VARCHAR |
| receipt | VARCHAR |
| currency_exchange_id | INTEGER |
| currency_exchange_adjustment | INTEGER |
| currency_exchange_original_amount | INTEGER |
| currency_exchange_final_amount | INTEGER |
| currency_exchange_currency | INTEGER |
| error_code | INTEGER |
| status | VARCHAR |
| user_id | INTEGER |
| authorization_code | VARCHAR |
| created_timestamp | TIMESTAMP |
| processed_timestamp | TIMESTAMP |
| authorization_expires_at | TIMESTAMP |
| _fivetran_synced | TIMESTAMP |
| source_relation | VARCHAR |
| transactions_unique_id | VARCHAR |
| payment_method | VARCHAR |
| parent_created_timestamp | TIMESTAMP |
| parent_kind | VARCHAR |
| parent_amount | DOUBLE |
| parent_status | VARCHAR |

Sample:
| transaction_id | order_id | refund_id | amount | device_id | gateway | source_name | message | currency | location_id | parent_id | payment_avs_result_code | payment_credit_card_bin | payment_cvv_result_code | payment_credit_card_number | payment_credit_card_company | kind | receipt | currency_exchange_id | currency_exchange_adjustment | currency_exchange_original_amount | currency_exchange_final_amount | currency_exchange_currency | error_code | status | user_id | authorization_code | created_timestamp | processed_timestamp | authorization_expires_at | _fivetran_synced | source_relation | transactions_unique_id | payment_method | parent_created_timestamp | parent_kind | parent_amount | parent_status |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2667417 | 2181743 | None | 415.0 | None | gateway_here | source_name | message_here | USD | None | None | Z | None | None | None | None | sale | None | None | None | None | None | None | None | success | None | None | 2020-02-27 16:05:37 | 2020-02-27 16:05:37 | None | 2020-10-28 20:33:09.797000 |  | fde86ba1352dc24f8c0483896a09d472 | None | None | None | None | None |
| 2572210 | 2089104 | None | 415.0 | None | gateway_here | source_name | message_here | USD | None | None | Y | None | None | None | None | sale | None | None | None | None | None | None | None | success | None | None | 2020-01-12 20:06:37 | 2020-01-12 20:06:37 | None | 2020-10-28 17:05:27.756000 |  | d20828eadd76d38e00014b222842871e | None | None | None | None | None |
| 2664325 | 2179107 | None | 415.0 | None | gateway_here | source_name | message_here | USD | None | None | None | None | None | None | None | sale | None | None | None | None | None | None | None | success | None | None | 2020-02-26 00:12:37 | 2020-02-26 00:12:37 | None | 2020-10-28 20:23:50.344000 |  | 9ff000779dd1a7f3420073a6c92e6e61 | None | None | None | None | None |
