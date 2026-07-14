# Reference Table Snapshot

## facts_divvy (413,689 rows)
| Column | Type |
|--------|------|
| ride_id | VARCHAR |
| rideable_type | VARCHAR |
| membership_status | VARCHAR |
| start_station_id | INTEGER |
| start_station_name | VARCHAR |
| end_station_name | VARCHAR |
| end_station_id | INTEGER |
| started_at | TIMESTAMP |
| ended_at | TIMESTAMP |
| duration_minutes | DOUBLE |
| start_neighbourhood | VARCHAR |
| start_location | VARCHAR |
| end_neighbourhood | VARCHAR |
| end_location | VARCHAR |

Sample:
| ride_id | rideable_type | membership_status | start_station_id | start_station_name | end_station_name | end_station_id | started_at | ended_at | duration_minutes | start_neighbourhood | start_location | end_neighbourhood | end_location |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 137EC5CA8CFD91D4 | docked_bike | casual | 403992 | Wells St & Evergreen Ave | Michigan Ave & Jackson Blvd | 440556 | 2020-03-08 14:35:33 | 2020-03-08 15:49:44 | 74.18333333333334 | Old Town | 41.9067,-87.6348 | Grant Park | 41.8779,-87.6241 |
| 5BCE51A81FE7B1E7 | docked_bike | casual | 464934 | Lakefront Trail & Bryn Mawr Ave | Pine Grove Ave & Irving Park Rd | 415060 | 2020-03-08 14:01:26 | 2020-03-08 14:27:49 | 26.383333333333333 | Edgewater | 41.984,-87.6523 | Lake View | 41.9544,-87.648 |
| 3BBA85BEBCC39229 | docked_bike | member | 470956 | 900 W Harrison St | Desplaines St & Jackson Blvd | 456221 | 2020-03-04 12:10:02 | 2020-03-04 12:14:08 | 4.1 | Little Italy, UIC | 41.8748,-87.6498 | West Loop | 41.8783,-87.6439 |

## stg_divvy_data (426,887 rows)
| Column | Type |
|--------|------|
| r_id | VARCHAR |
| ride_id | VARCHAR |
| rideable_type | VARCHAR |
| membership_status | VARCHAR |
| started_at | TIMESTAMP |
| ended_at | TIMESTAMP |
| start_station_name | VARCHAR |
| start_station_id | VARCHAR |
| end_station_name | VARCHAR |
| end_station_id | VARCHAR |
| start_lat | DECIMAL(18,3) |
| start_lng | DECIMAL(18,3) |
| end_lat | DECIMAL(18,3) |
| end_lng | DECIMAL(18,3) |

Sample:
| r_id | ride_id | rideable_type | membership_status | started_at | ended_at | start_station_name | start_station_id | end_station_name | end_station_id | start_lat | start_lng | end_lat | end_lng |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 242d827bdf0bdd75cc4655e28a36c6ad | EACB19130B0CDA4A | docked_bike | member | 2020-01-21 20:06:59 | 2020-01-21 20:14:30 | Western Ave & Leland Ave | 239 | Clark St & Leland Ave | 326 | 41.967 | -87.688 | 41.967 | -87.667 |
| bbdd92f9c0956dd1cf0defe0c3437271 | 8FED874C809DC021 | docked_bike | member | 2020-01-30 14:22:39 | 2020-01-30 14:26:22 | Clark St & Montrose Ave | 234 | Southport Ave & Irving Park Rd | 318 | 41.962 | -87.666 | 41.954 | -87.664 |
| dc4e32e9e62f7e5a9d1bab253d56cb15 | 789F3C21E472CA96 | docked_bike | member | 2020-01-09 19:29:26 | 2020-01-09 19:32:17 | Broadway & Belmont Ave | 296 | Wilton Ave & Belmont Ave | 117 | 41.940 | -87.646 | 41.940 | -87.653 |
