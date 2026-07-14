# eval-repos

The dbt projects behind the SignalPilot vs base Claude Code comparisons. One clear, clickable example per domain: the exact project configuration, models, and macros the agents worked against.

## Projects

| Directory | Domain | About |
|---|---|---|
| [`northwind/`](northwind/) | Healthcare revenue cycle | ~190-model RCM warehouse serving nine health-system clients, each delivering a different JSON dialect. Contains a hidden fan-before-aggregate in every client's `int_<client>__claim_financials`: row counts and uniqueness pass, but charge sums are silently multiplied ~4.5x. Base Claude Code reported $267B org-wide charges; the real figure is $71B. |
| [`jaffle/`](jaffle/) | Retail | The canonical dbt-labs Jaffle Shop (order_items / products / supplies edition) with a trapped `marts/orders.sql`: a perishable-supplies join inflates revenue ~2.74x while every grain check passes. Base reported $2,090,694 total revenue; the real figure is $763,290. |
| [`airbnb/`](airbnb/) | Travel marketplace | Reviews and listings pipeline. Base produced 11,135 rows for a 3-row month-over-month summary. |
| [`asset/`](asset/) | Capital markets | Stock quotes and positions. Base collapsed 3,430 price records into 15 and valued 1 position instead of 3,185. |
| [`shopify/`](shopify/) | E-commerce | Shop performance reporting. Base shipped a daily table with 2 of 2,077 days. |
| [`quickbooks/`](quickbooks/) | Accounting | Balance sheet build. Base ignored the project's own 17-column contract and dropped the account ordering column. |
| [`mrr/`](mrr/) | SaaS metrics | Monthly recurring revenue movements. Base overstated churn 13 percent by re-labeling customers who had already left. |
| [`pendo/`](pendo/) | Product analytics | Guide and page daily metrics. Base shipped 0 of 4,686 rows and called the empty report correct. |

## What is in each directory

- `northwind/` and `jaffle/` are the trapped warehouses exactly as the agents saw them (from the dbt-playground evals): `dbt_project.yml`, `models/`, `macros/`, seeds, and tests. The traps are in plain sight in the model SQL.
- `airbnb/`, `asset/`, `shopify/`, `quickbooks/`, `mrr/`, and `pendo/` are official Spider 2.0-DBT task projects in their final SignalPilot-completed state, including the `technical_spec.md` the governed workflow wrote before coding.

Data files, credentials, and harness artifacts are excluded; these are the model layers for reading, not runnable snapshots of the warehouses.
