# Technical Spec — quickbooks003

## Build Order
1. `int_quickbooks__cash_flow_classifications` (intermediate — depends on existing `int_quickbooks__general_ledger_balances`)
2. `quickbooks__general_ledger_by_period` (mart — depends on existing `int_quickbooks__general_ledger_balances` + `int_quickbooks__retained_earnings`)
3. `quickbooks__balance_sheet` (mart — depends on `quickbooks__general_ledger_by_period`)
4. `quickbooks__profit_and_loss` (mart — depends on `quickbooks__general_ledger_by_period`)
5. `quickbooks__cash_flow_statement` (mart — depends on `int_quickbooks__cash_flow_classifications` + `int_quickbooks__general_ledger_balances`)

---

## Model: int_quickbooks__cash_flow_classifications

- **Source**: `ref('int_quickbooks__general_ledger_balances')` — already has period_ending_balance, period_beginning_balance, period_net_change per account per period
- **Driving table**: `int_quickbooks__general_ledger_balances` (759 rows total, 276 balance_sheet rows after filter)
- **Joins**: none
- **Key expressions**:
  - `cash_flow_period` = `period_first_day`
  - `cash_ending_period` = `period_ending_balance`
  - `cash_converted_ending_period` = `period_ending_converted_balance`
  - `cash_flow_type` = CASE WHEN `account_type = 'Bank'` THEN 'Cash or Cash Equivalents' WHEN `account_type IN ('Other Current Liability','Long Term Liability','Credit Card','Accounts Payable')` THEN 'Financing' WHEN `account_type IN ('Other Current Asset','Fixed Asset','Other Asset')` THEN 'Investing' ELSE 'Operating' END
  - `cash_flow_ordinal` = CASE WHEN `cash_flow_type = 'Cash or Cash Equivalents'` THEN 1 WHEN `cash_flow_type = 'Operating'` THEN 2 WHEN `cash_flow_type = 'Investing'` THEN 3 WHEN `cash_flow_type = 'Financing'` THEN 4 END
  - `account_unique_id` = `{{ dbt_utils.generate_surrogate_key(['account_id', 'class_id', 'source_relation', 'cash_flow_period']) }}`
- **Filters**: `WHERE financial_statement_helper = 'balance_sheet'` — reference shows 276 rows, all balance_sheet accounts only; only those need cash flow classification
- **Expected grain**: one row per account per class_id per source_relation per period_first_day
- **Expected rows**: 276 (blueprint: int_quickbooks__general_ledger_balances has 276 balance_sheet rows)

---

## Model: quickbooks__general_ledger_by_period

- **Source**: `ref('int_quickbooks__general_ledger_balances')` UNION ALL `ref('int_quickbooks__retained_earnings')` — docs say "combines data from both general ledger balances and retained earnings"
- **Driving table**: UNION ALL of both (759 + 0 = 759 rows, retained_earnings currently empty)
- **Joins**: none (account_ordinal computed inline from account_class)
- **Key expressions**:
  - `account_ordinal` = CASE WHEN `account_class = 'Asset'` THEN 1 WHEN `account_class = 'Liability'` THEN 2 WHEN `account_class = 'Equity'` THEN 3 WHEN `account_class = 'Revenue'` THEN 4 WHEN `account_class = 'Expense'` THEN 5 ELSE NULL END — reference confirms Bank/Asset → ordinal 1, NULL account_class → NULL ordinal
  - All other columns passed through from UNION ALL sources unchanged
- **Filters**: none — includes all account types (balance_sheet AND income_statement)
- **Expected grain**: one row per account_id per class_id per source_relation per period_first_day
- **Expected rows**: 759 (blueprint: 759 from general_ledger_balances + 0 from retained_earnings)

---

## Model: quickbooks__balance_sheet

- **Source**: `ref('quickbooks__general_ledger_by_period')` — description explicitly states "The data is sourced from the `quickbooks__general_ledger_by_period` table"
- **Driving table**: `quickbooks__general_ledger_by_period` (759 rows, filtered to 276 balance_sheet rows)
- **Joins**: none
- **Key expressions**:
  - `calendar_date` = `period_first_day` (docs: "Timestamp of the first calendar date of the month")
  - `amount` = `period_ending_balance` (YML: "The total ending period balance")
  - `converted_amount` = `period_ending_converted_balance` (YML: "The total ending period balance, converted with exchange rates applied if available")
  - All other columns passed through unchanged with exact YML names
- **Filters**: `WHERE financial_statement_helper = 'balance_sheet'` — YML explicitly says "only entries where `financial_statement_helper` is equal to 'balance_sheet' are included"
- **Expected grain**: one row per account_id per class_id per source_relation per period_first_day
- **Expected rows**: 276 (reference snapshot: 276 rows)

---

## Model: quickbooks__profit_and_loss

- **Source**: `ref('quickbooks__general_ledger_by_period')`
- **Driving table**: `quickbooks__general_ledger_by_period` filtered to income_statement rows
- **Joins**: none
- **Key expressions**:
  - `calendar_date` = `period_first_day`
  - `amount` = `period_net_change` (YML: "The total period net change for the period")
  - `converted_amount` = `period_net_converted_change` (YML: "converted...net change")
  - All other columns passed through with exact YML names
- **Filters**: `WHERE financial_statement_helper = 'income_statement'` — profit & loss covers revenue and expense accounts which are all income_statement
- **Expected grain**: one row per account_id per class_id per source_relation per period_first_day
- **Expected rows**: 0 (reference snapshot: 0 rows — dataset has no income_statement accounts with non-null financial_statement_helper)

---

## Model: quickbooks__cash_flow_statement

- **Source**: `ref('int_quickbooks__cash_flow_classifications')` as primary; `ref('int_quickbooks__general_ledger_balances')` for beginning/net period values
- **Driving table**: `int_quickbooks__cash_flow_classifications` (276 rows)
- **Joins**: LEFT JOIN `int_quickbooks__general_ledger_balances` ON `account_id + coalesce(class_id,'0') + source_relation + period_first_day = cash_flow_period` — to get period_beginning_balance and period_net_change
- **Key expressions**:
  - `cash_beginning_period` = `gl.period_beginning_balance`
  - `cash_converted_beginning_period` = `gl.period_beginning_converted_balance`
  - `cash_net_period` = `gl.period_net_change`
  - `cash_converted_net_period` = `gl.period_net_converted_change`
  - All other columns passed through from `int_quickbooks__cash_flow_classifications`
- **Filters**: none
- **Expected grain**: one row per account_id per class_id per source_relation per cash_flow_period (= account_unique_id)
- **Expected rows**: 276 (reference snapshot: 276 rows)

---

## Decisions

- `int_quickbooks__general_ledger_balances` is the source for all balance period data; `int_quickbooks__retained_earnings` is empty in this dataset but must be included via UNION ALL for completeness
- `quickbooks__general_ledger_by_period` drives from UNION ALL (not a JOIN) — docs explicitly say "combines data from both" to get all accounts across all periods
- `account_ordinal` computed inline via CASE WHEN on `account_class` (not from cash_flow_ordinal) — the variable `financial_statement_ordinal: []` means no custom overrides; default maps Asset→1, Liability→2, Equity→3, Revenue→4, Expense→5; this is the financial-statement ordering (not cash flow ordering)
- `int_quickbooks__cash_flow_classifications` filters to `financial_statement_helper = 'balance_sheet'` only — reference snapshot shows exactly 276 rows = 276 balance_sheet rows in general_ledger_balances; cash flow statement covers only balance_sheet (cash) accounts
- `cash_flow_type` defaults: Bank → Cash or Cash Equivalents (reference confirms ordinal 1); Liability types → Financing; Other Asset types → Investing; else → Operating
- `quickbooks__balance_sheet` uses `period_ending_balance` as `amount` — YML says "total ending period balance" not net_change (contrast with profit_and_loss which uses period_net_change)
- `quickbooks__profit_and_loss` uses `period_net_change` as `amount` — YML says "total period net change for the period"
- `account_unique_id` uses `dbt_utils.generate_surrogate_key` on ['account_id', 'class_id', 'source_relation', 'cash_flow_period'] — YML description says "dependent on account_id, class_id, source_relation and calendar_date"
- No filter on `quickbooks__profit_and_loss` by `account_class` — filter by `financial_statement_helper = 'income_statement'` is sufficient and semantically equivalent
