# Reference Table Snapshot

## quotes (8,953 rows)
| Column | Type |
|--------|------|
| date | DATE |
| ts | VARCHAR |
| bid_pr | INTEGER |
| ask_pr | DOUBLE |
| bid_size | INTEGER |
| ask_size | INTEGER |
| ticker | VARCHAR |

Sample:
| date | ts | bid_pr | ask_pr | bid_size | ask_size | ticker |
|---|---|---|---|---|---|---|
| 2021-09-22 | 2021-12-08 11:20:00 | -1002 | 1706.6666666666667 | 100 | 200 | AMC |
| 2021-09-22 | 2021-12-08 11:20:00 | -1002 | 1706.6666666666667 | 100 | 200 | INTC |
| 2021-09-22 | 2021-12-08 11:20:00 | -1002 | 1697.6666666666667 | 100 | 200 | FUBO |

## trades (3,271,354 rows)
| Column | Type |
|--------|------|
| id | INTEGER |
| date | DATE |
| ts | VARCHAR |
| ticker | VARCHAR |
| quantity | INTEGER |
| price | DOUBLE |
| side_cd | VARCHAR |

Sample:
| id | date | ts | ticker | quantity | price | side_cd |
|---|---|---|---|---|---|---|
| 100 | 2021-12-08 | 2021-12-08 16:00:00 | GME | 1000 | 15994.4 | B |
| 100 | 2021-12-08 | 2021-12-08 16:00:00 | TR | 1000 | 15994.4 | B |
| 100 | 2021-12-08 | 2021-12-08 16:00:00 | TR | 1000 | 15994.4 | B |
