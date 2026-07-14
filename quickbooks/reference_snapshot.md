# Reference Table Snapshot

## int_quickbooks__cash_flow_classifications (276 rows)
| Column | Type |
|--------|------|
| cash_flow_period | DATE |
| source_relation | VARCHAR |
| account_class | VARCHAR |
| class_id | VARCHAR |
| is_sub_account | BOOLEAN |
| parent_account_number | VARCHAR |
| parent_account_name | VARCHAR |
| account_type | VARCHAR |
| account_sub_type | VARCHAR |
| account_number | VARCHAR |
| account_id | VARCHAR |
| account_name | VARCHAR |
| cash_ending_period | HUGEINT |
| cash_converted_ending_period | HUGEINT |
| account_unique_id | VARCHAR |
| cash_flow_type | VARCHAR |
| cash_flow_ordinal | INTEGER |

Sample:
| cash_flow_period | source_relation | account_class | class_id | is_sub_account | parent_account_number | parent_account_name | account_type | account_sub_type | account_number | account_id | account_name | cash_ending_period | cash_converted_ending_period | account_unique_id | cash_flow_type | cash_flow_ordinal |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2020-10-01 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 4979 | 4979 | 2087552277a3a3bd6adb158e7197fea5 | Cash or Cash Equivalents | 1 |
| 2020-11-01 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 4979 | 4979 | 9768b79ede0d02d5c5dc590a95a0146d | Cash or Cash Equivalents | 1 |
| 2020-12-01 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 4979 | 4979 | ac91a595adcc33319d8c3be20ae5ee99 | Cash or Cash Equivalents | 1 |

## quickbooks__ap_ar_enhanced (5 rows)
| Column | Type |
|--------|------|
| transaction_type | VARCHAR |
| transaction_id | VARCHAR |
| source_relation | VARCHAR |
| doc_number | VARCHAR |
| estimate_id | VARCHAR |
| department_name | VARCHAR |
| transaction_with | VARCHAR |
| customer_vendor_name | VARCHAR |
| customer_vendor_balance | INTEGER |
| customer_vendor_address_city | VARCHAR |
| customer_vendor_address_country | VARCHAR |
| customer_vendor_address_line | VARCHAR |
| customer_vendor_website | INTEGER |
| delivery_type | VARCHAR |
| estimate_status | VARCHAR |
| total_amount | INTEGER |
| total_converted_amount | INTEGER |
| estimate_total_amount | DOUBLE |
| estimate_total_converted_amount | DOUBLE |
| current_balance | INTEGER |
| due_date | DATE |
| is_overdue | BOOLEAN |
| days_overdue | BIGINT |
| initial_payment_date | DATE |
| recent_payment_date | DATE |
| total_current_payment | DOUBLE |
| total_current_converted_payment | DOUBLE |

Sample:
| transaction_type | transaction_id | source_relation | doc_number | estimate_id | department_name | transaction_with | customer_vendor_name | customer_vendor_balance | customer_vendor_address_city | customer_vendor_address_country | customer_vendor_address_line | customer_vendor_website | delivery_type | estimate_status | total_amount | total_converted_amount | estimate_total_amount | estimate_total_converted_amount | current_balance | due_date | is_overdue | days_overdue | initial_payment_date | recent_payment_date | total_current_payment | total_current_converted_payment |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| bill | 399 |  | 2021-01-01 | None | 456d0deba6a86c9585590550c797502d | vendor | None | None | None | None |  | None | None | None | 647 | 647 | None | None | 991 | 2020-12-17 | False | 0 | None | None | 0.0 | 0.0 |
| bill | 397 |  | None | None | 456d0deba6a86c9585590550c797502d | vendor | None | None | None | None |  | None | None | None | 757 | 757 | None | None | 832 | 2020-12-17 | False | 0 | None | None | 0.0 | 0.0 |
| bill | 398 |  | None | None | 456d0deba6a86c9585590550c797502d | vendor | None | None | None | None |  | None | None | None | 822 | 822 | None | None | 52 | 2020-12-17 | False | 0 | None | None | 0.0 | 0.0 |

## quickbooks__balance_sheet (276 rows)
| Column | Type |
|--------|------|
| calendar_date | DATE |
| period_first_day | DATE |
| period_last_day | DATE |
| source_relation | VARCHAR |
| account_class | VARCHAR |
| class_id | VARCHAR |
| is_sub_account | BOOLEAN |
| parent_account_number | VARCHAR |
| parent_account_name | VARCHAR |
| account_type | VARCHAR |
| account_sub_type | VARCHAR |
| account_number | VARCHAR |
| account_id | VARCHAR |
| account_name | VARCHAR |
| amount | HUGEINT |
| converted_amount | HUGEINT |
| account_ordinal | INTEGER |

Sample:
| calendar_date | period_first_day | period_last_day | source_relation | account_class | class_id | is_sub_account | parent_account_number | parent_account_name | account_type | account_sub_type | account_number | account_id | account_name | amount | converted_amount | account_ordinal |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2020-10-01 | 2020-10-01 | 2020-10-31 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 4979 | 4979 | 1 |
| 2020-11-01 | 2020-11-01 | 2020-11-30 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 4979 | 4979 | 1 |
| 2020-12-01 | 2020-12-01 | 2020-12-31 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 4979 | 4979 | 1 |

## quickbooks__cash_flow_statement (276 rows)
| Column | Type |
|--------|------|
| cash_flow_period | DATE |
| source_relation | VARCHAR |
| account_class | VARCHAR |
| class_id | VARCHAR |
| is_sub_account | BOOLEAN |
| parent_account_number | VARCHAR |
| parent_account_name | VARCHAR |
| account_type | VARCHAR |
| account_sub_type | VARCHAR |
| account_number | VARCHAR |
| account_id | VARCHAR |
| account_name | VARCHAR |
| cash_ending_period | HUGEINT |
| cash_converted_ending_period | HUGEINT |
| account_unique_id | VARCHAR |
| cash_flow_type | VARCHAR |
| cash_flow_ordinal | INTEGER |
| cash_beginning_period | HUGEINT |
| cash_net_period | HUGEINT |
| cash_converted_beginning_period | HUGEINT |
| cash_converted_net_period | HUGEINT |

Sample:
| cash_flow_period | source_relation | account_class | class_id | is_sub_account | parent_account_number | parent_account_name | account_type | account_sub_type | account_number | account_id | account_name | cash_ending_period | cash_converted_ending_period | account_unique_id | cash_flow_type | cash_flow_ordinal | cash_beginning_period | cash_net_period | cash_converted_beginning_period | cash_converted_net_period |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2019-01-01 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 0 | 0 | a847a13e90bbc77814609cdbaf74c81c | Cash or Cash Equivalents | 1 | 0 | 0 | 0 | 0 |
| 2019-02-01 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 0 | 0 | af1a9b5a5ff9341539471037d359ac8f | Cash or Cash Equivalents | 1 | 0 | 0 | 0 | 0 |
| 2019-03-01 |  | Asset | None | False | None | 6d69cd92d636a07b52a62b37e1f5201a | Bank | 195917574edc9b6bbeb5be9785b6a479 | None | 39 | 6d69cd92d636a07b52a62b37e1f5201a | 0 | 0 | 3ab41404c09c80d0ded7980c4c184dd6 | Cash or Cash Equivalents | 1 | 0 | 0 | 0 | 0 |

## quickbooks__expenses_sales_enhanced (0 rows)
| Column | Type |
|--------|------|
| transaction_source | VARCHAR |
| transaction_id | VARCHAR |
| source_relation | VARCHAR |
| transaction_line_id | INTEGER |
| doc_number | VARCHAR |
| transaction_type | VARCHAR |
| transaction_date | DATE |
| item_id | VARCHAR |
| item_quantity | DOUBLE |
| item_unit_price | DOUBLE |
| account_id | VARCHAR |
| account_name | VARCHAR |
| account_sub_type | VARCHAR |
| class_id | VARCHAR |
| department_id | VARCHAR |
| department_name | VARCHAR |
| customer_id | VARCHAR |
| customer_name | VARCHAR |
| customer_website | INTEGER |
| vendor_id | VARCHAR |
| vendor_name | VARCHAR |
| billable_status | VARCHAR |
| description | VARCHAR |
| amount | DOUBLE |
| converted_amount | DOUBLE |
| total_amount | INTEGER |
| total_converted_amount | DOUBLE |


## quickbooks__general_ledger (76 rows)
| Column | Type |
|--------|------|
| unique_id | VARCHAR |
| transaction_id | VARCHAR |
| source_relation | VARCHAR |
| transaction_index | INTEGER |
| transaction_date | DATE |
| customer_id | VARCHAR |
| vendor_id | VARCHAR |
| amount | INTEGER |
| account_id | VARCHAR |
| class_id | VARCHAR |
| department_id | VARCHAR |
| account_number | VARCHAR |
| account_name | VARCHAR |
| is_sub_account | BOOLEAN |
| parent_account_number | VARCHAR |
| parent_account_name | VARCHAR |
| account_type | VARCHAR |
| account_sub_type | VARCHAR |
| financial_statement_helper | VARCHAR |
| account_current_balance | INTEGER |
| account_class | VARCHAR |
| transaction_type | VARCHAR |
| transaction_source | VARCHAR |
| account_transaction_type | VARCHAR |
| adjusted_amount | INTEGER |
| adjusted_converted_amount | INTEGER |
| running_balance | HUGEINT |
| running_converted_balance | HUGEINT |

Sample:
| unique_id | transaction_id | source_relation | transaction_index | transaction_date | customer_id | vendor_id | amount | account_id | class_id | department_id | account_number | account_name | is_sub_account | parent_account_number | parent_account_name | account_type | account_sub_type | financial_statement_helper | account_current_balance | account_class | transaction_type | transaction_source | account_transaction_type | adjusted_amount | adjusted_converted_amount | running_balance | running_converted_balance |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 9820a9afe886808e6262efe96c4b162f | 3 |  | 0 | 2020-03-27 | None | None | 8000 | 3 | None | None | None | None | None | None | None | None | None | None | None | None | credit | deposit | None | -8000 | -8000 | -8000 | -8000 |
| acd0859f7c391ec656eb7d35043a34e8 | 107 |  | 0 | 2020-11-06 | None | 18 | 77 | 3 | None | 1 | None | None | None | None | None | None | None | None | None | None | debit | purchase | None | -77 | -77 | -8077 | -8077 |
| 9ea26bd3e3f53e871c5da1150d9cd981 | 101 |  | 0 | None | None | 18 | 12 | 3 | None | 1 | None | None | None | None | None | None | None | None | None | None | debit | purchase | None | -12 | -12 | -8089 | -8089 |

## quickbooks__general_ledger_by_period (759 rows)
| Column | Type |
|--------|------|
| account_id | VARCHAR |
| source_relation | VARCHAR |
| account_number | VARCHAR |
| account_name | VARCHAR |
| is_sub_account | BOOLEAN |
| parent_account_number | VARCHAR |
| parent_account_name | VARCHAR |
| account_type | VARCHAR |
| account_sub_type | VARCHAR |
| account_class | VARCHAR |
| class_id | VARCHAR |
| financial_statement_helper | VARCHAR |
| date_year | DATE |
| period_first_day | DATE |
| period_last_day | DATE |
| period_net_change | HUGEINT |
| period_beginning_balance | HUGEINT |
| period_ending_balance | HUGEINT |
| period_net_converted_change | HUGEINT |
| period_beginning_converted_balance | HUGEINT |
| period_ending_converted_balance | HUGEINT |
| account_ordinal | INTEGER |

Sample:
| account_id | source_relation | account_number | account_name | is_sub_account | parent_account_number | parent_account_name | account_type | account_sub_type | account_class | class_id | financial_statement_helper | date_year | period_first_day | period_last_day | period_net_change | period_beginning_balance | period_ending_balance | period_net_converted_change | period_beginning_converted_balance | period_ending_converted_balance | account_ordinal |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 35 |  | None | None | None | None | None | None | None | None | None | None | 2020-01-01 | 2020-03-01 | 2020-03-31 | -89222 | 0 | 0 | -89222 | 0 | 0 | None |
| 35 |  | None | None | None | None | None | None | None | None | None | None | 2020-01-01 | 2020-04-01 | 2020-04-30 | 0 | 0 | 0 | 0 | 0 | 0 | None |
| 35 |  | None | None | None | None | None | None | None | None | None | None | 2020-01-01 | 2020-05-01 | 2020-05-31 | 0 | 0 | 0 | 0 | 0 | 0 | None |

## quickbooks__profit_and_loss (0 rows)
| Column | Type |
|--------|------|
| calendar_date | DATE |
| period_first_day | DATE |
| period_last_day | DATE |
| source_relation | VARCHAR |
| account_class | VARCHAR |
| class_id | VARCHAR |
| is_sub_account | BOOLEAN |
| parent_account_number | VARCHAR |
| parent_account_name | VARCHAR |
| account_type | VARCHAR |
| account_sub_type | VARCHAR |
| account_number | VARCHAR |
| account_id | VARCHAR |
| account_name | VARCHAR |
| amount | HUGEINT |
| converted_amount | HUGEINT |
| account_ordinal | INTEGER |

