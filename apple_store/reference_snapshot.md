# Reference Table Snapshot

## apple_store__app_version_report (20 rows)
| Column | Type |
|--------|------|
| source_relation | VARCHAR |
| date_day | DATE |
| app_id | BIGINT |
| app_name | VARCHAR |
| source_type | VARCHAR |
| app_version | VARCHAR |
| crashes | HUGEINT |
| active_devices | BIGINT |
| active_devices_last_30_days | BIGINT |
| deletions | BIGINT |
| installations | BIGINT |
| sessions | BIGINT |

Sample:
| source_relation | date_day | app_id | app_name | source_type | app_version | crashes | active_devices | active_devices_last_30_days | deletions | installations | sessions |
|---|---|---|---|---|---|---|---|---|---|---|---|
|  | 2021-07-30 | 12345 | Super Cool Name | None | 1.0.0 (iOS) | 0 | 0 | 0 | 0 | 0 | 0 |
|  | 2021-03-20 | 12345 | Super Cool Name | Unavailable | 1.0.0 (iOS) | 0 | 0 | 1 | 0 | 0 | 0 |
|  | 2021-08-08 | 12345 | Super Cool Name | App Store Browse | 1.0.0 (iOS) | 0 | 0 | 0 | 0 | 0 | 0 |

## apple_store__device_report (20 rows)
| Column | Type |
|--------|------|
| source_relation | VARCHAR |
| date_day | DATE |
| app_id | BIGINT |
| app_name | VARCHAR |
| source_type | VARCHAR |
| device | VARCHAR |
| impressions | BIGINT |
| impressions_unique_device | BIGINT |
| page_views | BIGINT |
| page_views_unique_device | BIGINT |
| crashes | HUGEINT |
| first_time_downloads | BIGINT |
| redownloads | BIGINT |
| total_downloads | BIGINT |
| active_devices | BIGINT |
| active_devices_last_30_days | BIGINT |
| deletions | BIGINT |
| installations | BIGINT |
| sessions | BIGINT |

Sample:
| source_relation | date_day | app_id | app_name | source_type | device | impressions | impressions_unique_device | page_views | page_views_unique_device | crashes | first_time_downloads | redownloads | total_downloads | active_devices | active_devices_last_30_days | deletions | installations | sessions |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  | 2021-07-12 | 12345 | Super Cool Name | Institutional Purchase | Desktop | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
|  | 2021-03-17 | 12345 | Super Cool Name | App Store Search | iPhone | 1757 | 1113 | 209 | 151 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
|  | 2021-06-06 | 12345 | Super Cool Name | Unavailable | iPad | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

## apple_store__overview_report (9 rows)
| Column | Type |
|--------|------|
| source_relation | VARCHAR |
| date_day | DATE |
| app_id | BIGINT |
| app_name | VARCHAR |
| impressions | HUGEINT |
| page_views | HUGEINT |
| crashes | HUGEINT |
| first_time_downloads | HUGEINT |
| redownloads | HUGEINT |
| total_downloads | HUGEINT |
| active_devices | HUGEINT |
| deletions | HUGEINT |
| installations | HUGEINT |
| sessions | HUGEINT |

Sample:
| source_relation | date_day | app_id | app_name | impressions | page_views | crashes | first_time_downloads | redownloads | total_downloads | active_devices | deletions | installations | sessions |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  | 2021-03-17 | 12345 | Super Cool Name | 1757 | 209 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
|  | 2021-10-06 | 12345 | Super Cool Name | 1210 | 146 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
|  | 2021-08-23 | 12345 | Super Cool Name | 8 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

## apple_store__platform_version_report (20 rows)
| Column | Type |
|--------|------|
| source_relation | VARCHAR |
| date_day | DATE |
| app_id | BIGINT |
| app_name | VARCHAR |
| source_type | VARCHAR |
| platform_version | VARCHAR |
| impressions | BIGINT |
| impressions_unique_device | BIGINT |
| page_views | BIGINT |
| page_views_unique_device | BIGINT |
| crashes | HUGEINT |
| first_time_downloads | BIGINT |
| redownloads | BIGINT |
| total_downloads | BIGINT |
| active_devices | BIGINT |
| active_devices_last_30_days | BIGINT |
| deletions | BIGINT |
| installations | BIGINT |
| sessions | BIGINT |

Sample:
| source_relation | date_day | app_id | app_name | source_type | platform_version | impressions | impressions_unique_device | page_views | page_views_unique_device | crashes | first_time_downloads | redownloads | total_downloads | active_devices | active_devices_last_30_days | deletions | installations | sessions |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  | 2021-05-13 | 12345 | Super Cool Name | None | iOS 1.0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
|  | 2021-07-01 | 12345 | Super Cool Name | App Store Search | iOS 1.0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
|  | 2021-08-02 | 12345 | Super Cool Name | App Referrer | iOS 1.0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
