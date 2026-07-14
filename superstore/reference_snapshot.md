# Reference Table Snapshot

## dim_regional_managers (4 rows)
| Column | Type |
|--------|------|
| id | BIGINT |
| manager_name | VARCHAR |
| region_id | BIGINT |

Sample:
| id | manager_name | region_id |
|---|---|---|
| 1001 | Anna Andreadi | 101 |
| 1002 | Kelly Williams | 102 |
| 1003 | Chuck Magee | 103 |

## fct_sales (9,994 rows)
| Column | Type |
|--------|------|
| id | BIGINT |
| order_id | VARCHAR |
| order_date_id | INTEGER |
| ship_date_id | INTEGER |
| sales | DOUBLE |
| profit | DOUBLE |
| quantity | INTEGER |
| discount | DOUBLE |
| dim_products_id | BIGINT |
| dim_customers_id | BIGINT |
| dim_shipping_id | BIGINT |
| dim_geo_id | BIGINT |

Sample:
| id | order_id | order_date_id | ship_date_id | sales | profit | quantity | discount | dim_products_id | dim_customers_id | dim_shipping_id | dim_geo_id |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 101 | CA-2018-152156 | 20181108 | 20181111 | 261.96 | 41.9136 | 2 | 0.0 | 101 | 721 | 104 | 11 |
| 102 | CA-2018-152156 | 20181108 | 20181111 | 731.94 | 219.582 | 3 | 0.0 | 3896 | 721 | 104 | 11 |
| 103 | US-2017-108966 | 20171011 | 20171018 | 957.5775 | -383.031 | 5 | 0.45 | 663 | 428 | 101 | 12 |
