# Reference Table Snapshot

## customer_churn_month (52 rows)
| Column | Type |
|--------|------|
| date_month | DATE |
| customer_id | INTEGER |
| mrr | FLOAT |
| is_active | BOOLEAN |
| first_active_month | DATE |
| last_active_month | DATE |
| is_first_month | BOOLEAN |
| is_last_month | BOOLEAN |

Sample:
| date_month | customer_id | mrr | is_active | first_active_month | last_active_month | is_first_month | is_last_month |
|---|---|---|---|---|---|---|---|
| 2020-01-01 | 50 | 0.0 | False | 2019-12-01 | 2019-12-01 | False | False |
| 2020-01-01 | 15 | 0.0 | False | 2019-02-01 | 2019-12-01 | False | False |
| 2019-08-01 | 22 | 0.0 | False | 2018-12-01 | 2019-07-01 | False | False |

## customer_revenue_by_month (358 rows)
| Column | Type |
|--------|------|
| date_month | DATE |
| customer_id | INTEGER |
| mrr | INTEGER |
| is_active | BOOLEAN |
| first_active_month | DATE |
| last_active_month | DATE |
| is_first_month | BOOLEAN |
| is_last_month | BOOLEAN |

Sample:
| date_month | customer_id | mrr | is_active | first_active_month | last_active_month | is_first_month | is_last_month |
|---|---|---|---|---|---|---|---|
| 2019-12-01 | 50 | 25 | True | 2019-12-01 | 2019-12-01 | True | True |
| 2019-02-01 | 15 | 30 | True | 2019-02-01 | 2019-12-01 | True | False |
| 2019-03-01 | 15 | 30 | True | 2019-02-01 | 2019-12-01 | False | False |

## mrr (410 rows)
| Column | Type |
|--------|------|
| date_month | DATE |
| customer_id | INTEGER |
| mrr | FLOAT |
| is_active | BOOLEAN |
| first_active_month | DATE |
| last_active_month | DATE |
| is_first_month | BOOLEAN |
| is_last_month | BOOLEAN |
| previous_month_is_active | BOOLEAN |
| previous_month_mrr | FLOAT |
| mrr_change | FLOAT |
| change_category | VARCHAR |

Sample:
| date_month | customer_id | mrr | is_active | first_active_month | last_active_month | is_first_month | is_last_month | previous_month_is_active | previous_month_mrr | mrr_change | change_category |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 2019-10-01 | 35 | 50.0 | True | 2019-10-01 | 2019-11-01 | True | False | False | 0.0 | 50.0 | new |
| 2019-11-01 | 35 | 25.0 | True | 2019-10-01 | 2019-11-01 | False | True | True | 50.0 | -25.0 | downgrade |
| 2019-12-01 | 35 | 0.0 | False | 2019-10-01 | 2019-11-01 | False | False | True | 25.0 | -25.0 | churn |
