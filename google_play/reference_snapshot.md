# Reference Table Snapshot

## stats_crashes_overview (10 rows)
| Column | Type |
|--------|------|
| _file | VARCHAR |
| _file | VARCHAR |
| _line | INTEGER |
| _line | INTEGER |
| _modified | VARCHAR |
| _modified | VARCHAR |
| date | DATE |
| date | DATE |
| package_name | VARCHAR |
| package_name | VARCHAR |
| daily_crashes | INTEGER |
| daily_crashes | INTEGER |
| daily_anrs | INTEGER |
| daily_anrs | INTEGER |
| _fivetran_synced | VARCHAR |
| _fivetran_synced | VARCHAR |

Sample:
| _file | _file | _line | _line | _modified | _modified | date | date | package_name | package_name | daily_crashes | daily_crashes | daily_anrs | daily_anrs | _fivetran_synced | _fivetran_synced |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| crashes_member.android.network_202010_overview.csv | 0 | 2020-11-01 14:40:13.652000+00:00 | 2020-10-01 | member.android.network | 11 | 0 | 2021-11-04 22:11:03.962000+00:00 |
| crashes_member.android.network_202010_overview.csv | 16 | 2020-11-01 14:40:13.652000+00:00 | 2020-10-29 | member.android.network | 13 | 0 | 2021-11-04 22:11:03.963000+00:00 |
| crashes_member.android.network_201904_overview.csv | 13 | 2019-05-01 09:53:47.602000+00:00 | 2019-04-15 | member.android.network | 2 | 4 | 2021-11-04 22:10:59.609000+00:00 |

## stats_installs_overview (10 rows)
| Column | Type |
|--------|------|
| _file | VARCHAR |
| _file | VARCHAR |
| _line | INTEGER |
| _line | INTEGER |
| _modified | VARCHAR |
| _modified | VARCHAR |
| date | DATE |
| date | DATE |
| package_name | VARCHAR |
| package_name | VARCHAR |
| current_device_installs | INTEGER |
| current_device_installs | INTEGER |
| daily_device_installs | INTEGER |
| daily_device_installs | INTEGER |
| daily_device_uninstalls | INTEGER |
| daily_device_uninstalls | INTEGER |
| daily_device_upgrades | INTEGER |
| daily_device_upgrades | INTEGER |
| current_user_installs | INTEGER |
| current_user_installs | INTEGER |
| total_user_installs | INTEGER |
| total_user_installs | INTEGER |
| daily_user_installs | INTEGER |
| daily_user_installs | INTEGER |
| daily_user_uninstalls | INTEGER |
| daily_user_uninstalls | INTEGER |
| _fivetran_synced | VARCHAR |
| _fivetran_synced | VARCHAR |
| active_device_installs | BIGINT |
| active_device_installs | BIGINT |
| install_events | INTEGER |
| install_events | INTEGER |
| update_events | INTEGER |
| update_events | INTEGER |
| uninstall_events | INTEGER |
| uninstall_events | INTEGER |

Sample:
| _file | _file | _line | _line | _modified | _modified | date | date | package_name | package_name | current_device_installs | current_device_installs | daily_device_installs | daily_device_installs | daily_device_uninstalls | daily_device_uninstalls | daily_device_upgrades | daily_device_upgrades | current_user_installs | current_user_installs | total_user_installs | total_user_installs | daily_user_installs | daily_user_installs | daily_user_uninstalls | daily_user_uninstalls | _fivetran_synced | _fivetran_synced | active_device_installs | active_device_installs | install_events | install_events | update_events | update_events | uninstall_events | uninstall_events |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| installs_com.cable.network_201401_overview.csv | 0 | 2018-10-07 11:55:41.478000+00:00 | 2018-09-01 | com.cable.tv | None | 0 | 0 | 0 | None | 0 | 0 | 0 | 2021-11-04 22:05:21.332000+00:00 | 1 | 0 | 0 | 0 |
| installs_com.cable.tv_201809_overview.csv | 16 | 2018-10-07 11:55:41.478000+00:00 | 2018-09-17 | com.cable.tv | None | 0 | 0 | 0 | None | 0 | 0 | 0 | 2021-11-04 22:05:21.332000+00:00 | 1 | 0 | 0 | 0 |
| installs_com.cable.store_201805_overview.csv | 2 | 2021-08-12 10:09:25.259000+00:00 | 2021-07-03 | com.cable.network | None | 38 | 0 | 0 | None | 0 | 23 | 33 | 2021-11-04 22:05:34.034000+00:00 | 164490 | 450 | 0 | 340 |

## stats_ratings_overview (10 rows)
| Column | Type |
|--------|------|
| a | INTEGER |
| a | INTEGER |
| _file | VARCHAR |
| _file | VARCHAR |
| _line | INTEGER |
| _line | INTEGER |
| _modified | VARCHAR |
| _modified | VARCHAR |
| date | DATE |
| date | DATE |
| package_name | VARCHAR |
| package_name | VARCHAR |
| daily_average_rating | VARCHAR |
| daily_average_rating | VARCHAR |
| total_average_rating | DOUBLE |
| total_average_rating | DOUBLE |
| _fivetran_synced | VARCHAR |
| _fivetran_synced | VARCHAR |

Sample:
| a | a | _file | _file | _line | _line | _modified | _modified | date | date | package_name | package_name | daily_average_rating | daily_average_rating | total_average_rating | total_average_rating | _fivetran_synced | _fivetran_synced |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | ratings_member.android.internetshop_201706_overview.csv | 2 | 2017-07-05 07:21:59.258000+00:00 | 2017-06-03 | member.android.internetshop | 3.00 | 4.38 | 2021-11-04 22:13:22.958000+00:00 |
| 1 | ratings_member.android.internetshop_201706_overview.csv | 18 | 2017-07-05 07:21:59.258000+00:00 | 2017-06-19 | member.android.internetshop | 3.50 | 4.37 | 2021-11-04 22:13:22.958000+00:00 |
| 2 | ratings_com.tv.cable_202004_overview.csv | 4 | 2020-05-29 07:40:52.257000+00:00 | 2020-04-05 | com.tv.cable | NA | 3.98 | 2021-11-04 22:13:31.257000+00:00 |

## stats_store_performance_country (10 rows)
| Column | Type |
|--------|------|
| _file | VARCHAR |
| _file | VARCHAR |
| _line | INTEGER |
| _line | INTEGER |
| _modified | VARCHAR |
| _modified | VARCHAR |
| date | DATE |
| date | DATE |
| package_name | VARCHAR |
| package_name | VARCHAR |
| country_region | VARCHAR |
| country_region | VARCHAR |
| store_listing_acquisitions | INTEGER |
| store_listing_acquisitions | INTEGER |
| store_listing_visitors | INTEGER |
| store_listing_visitors | INTEGER |
| store_listing_conversion_rate | DOUBLE |
| store_listing_conversion_rate | DOUBLE |
| _fivetran_synced | VARCHAR |
| _fivetran_synced | VARCHAR |

Sample:
| _file | _file | _line | _line | _modified | _modified | date | date | package_name | package_name | country_region | country_region | store_listing_acquisitions | store_listing_acquisitions | store_listing_visitors | store_listing_visitors | store_listing_conversion_rate | store_listing_conversion_rate | _fivetran_synced | _fivetran_synced |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| store_performance_member.android.candyshop_202002_country.csv | 7 | 2021-04-13 18:47:55.258000+00:00 | 2020-02-28 | member.android.candyshop | US | 32 | 71 | 0.4507 | 2021-11-04 22:11:39.098000+00:00 |
| store_performance_member.android.candyshop_202003_country.csv | 15 | 2021-04-13 11:33:18.152000+00:00 | 2020-03-08 | member.android.candyshop | US | 42 | 79 | 0.5316 | 2021-11-04 22:11:38.992000+00:00 |
| store_performance_member.android.candyshop_202003_country.csv | 31 | 2021-04-13 11:33:18.152000+00:00 | 2020-03-14 | member.android.candyshop | ES | 33 | 109 | 0.3027 | 2021-11-04 22:11:38.992000+00:00 |
