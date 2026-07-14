# eval-repos

The dbt projects behind the SignalPilot vs base Claude Code comparisons. One clear, clickable example per domain: the exact project configuration, models, and macros the agents worked against.

## Projects

| Directory | Domain | About |
|---|---|---|
| [`northwind/`](northwind/) | Healthcare revenue cycle | ~190-model RCM warehouse serving nine health-system clients, each delivering a different JSON dialect. Contains a hidden fan-before-aggregate in every client's `int_<client>__claim_financials`: row counts and uniqueness pass, but charge sums are silently multiplied ~4.5x. Base Claude Code reported $267B org-wide charges; the real figure is $71B. |
| [`jaffle/`](jaffle/) | Retail | The canonical dbt-labs Jaffle Shop (order_items / products / supplies edition) with a trapped `marts/orders.sql`: a perishable-supplies join inflates revenue ~2.74x while every grain check passes. Base reported $2,090,694 total revenue; the real figure is $763,290. |
| [`parallax/`](parallax/) | Experimentation platform | 183-model feature-flag / A/B testing warehouse serving nine client companies, each shipping a different JSON dialect. Hides raw-recoverable silent-shrink traps: a filter, dedup, or schema omission quietly drops rows below the mart while the raw landing table holds the full population. Base reported 230,760 logged impressions for one client; the real count is 573,648. |
| [`airbnb/`](airbnb/) | Travel marketplace | Reviews and listings pipeline. Base produced 11,135 rows for a 3-row month-over-month summary. |
| [`asset/`](asset/) | Capital markets | Stock quotes and positions. Base collapsed 3,430 price records into 15 and valued 1 position instead of 3,185. |
| [`shopify/`](shopify/) | E-commerce | Shop performance reporting. Base shipped a daily table with 2 of 2,077 days. |
| [`quickbooks/`](quickbooks/) | Accounting | Balance sheet build. Base ignored the project's own 17-column contract and dropped the account ordering column. |
| [`mrr/`](mrr/) | SaaS metrics | Monthly recurring revenue movements. Base overstated churn 13 percent by re-labeling customers who had already left. |
| [`pendo/`](pendo/) | Product analytics | Guide and page daily metrics. Base shipped 0 of 4,686 rows and called the empty report correct. |
| [`intercom/`](intercom/) | Customer support | Conversation metrics. Base built one of the two required models and quit on a reassuring "34 models passed" message. |
| [`superstore/`](superstore/) | Retail sales | Sales facts and regional managers. Base's single-key product join multiplied the sales table 2.5x. |
| [`retail/`](retail/) | Retail invoices | Country revenue ranking. Base shipped the buggy starter counting method unchanged, a 21x under-count. |
| [`tpch/`](tpch/) | Wholesale supply chain | Customer lifetime value. Base admitted 1,770 return-only customers with purchase totals built from returned goods. |
| [`reddit/`](reddit/) | Social media | Post and comment cleanup. Base overwrote 2,060 genuinely empty values and deleted 475 real comments. |
| [`google_play/`](google_play/) | App store analytics | Daily overview report. Base aggregated the wrong upstream table, making every date wrong at identical shape. |
| [`twilio/`](twilio/) | Communications | Messaging spend rollups. Base reported account spend with the wrong sign. |
| [`apple_store/`](apple_store/) | App store analytics | Territory and source-type reports. Base merged three sources into the report grain, 37 rows instead of 17. |
| [`f1/`](f1/) | Sports analytics | Driver championships. Base returned one row per champion-season, 75 rows instead of 34. |
| [`recharge/`](recharge/) | Subscription billing | Daily customer rollups. Base's calendar reached back before customers existed, 30 phantom days. |
| [`divvy/`](divvy/) | Mobility | Bike trip analytics. Base invented a filter that dropped one row and a loose join that admitted 5,237 trips. |

## What is in each directory

- `northwind/`, `jaffle/`, and `parallax/` are the trapped warehouses exactly as the agents saw them (from the dbt-playground evals): `dbt_project.yml`, `models/`, `macros/`, seeds, and tests. The traps are in plain sight in the model SQL.
- All other directories are official Spider 2.0-DBT task projects in their final SignalPilot-completed state, including the `technical_spec.md` the governed workflow wrote before coding.

Data files, credentials, and harness artifacts are excluded; these are the model layers for reading, not runnable snapshots of the warehouses.
