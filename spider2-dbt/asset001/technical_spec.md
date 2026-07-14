# Technical Spec — asset001

## Build Order
1. stg_executions (staging — source: trades, existing complete SQL, needs table)
2. bar_executions (intermediate — depends on stg_executions, existing complete SQL, needs table)
3. bar_quotes (mart — depends on source quotes, stub to write)
4. positions_shares (mart — depends on bar_executions, existing complete SQL, needs table)
5. book_value (mart — depends on bar_quotes + positions_shares, stub to write)

---

## Model: bar_quotes

- **Source**: `source('asset_mgmt', 'quotes')` — 8,953 raw rows
- **Driving table**: quotes (8,953 rows)
- **Joins**: none — single source table
- **Key expressions**:
  - `date` = `date` column from quotes (already DATE type)
  - `ts` = `ts::TIMESTAMP` — cast VARCHAR ts to TIMESTAMP for join compatibility with positions_shares
  - `ticker` = `ticker` from quotes
  - `tt_key` = `concat(ticker, ts)` — following exact bar_executions pattern (bar_executions.sql uses `concat(ticker, ts) as tt_key` with ts cast to TIMESTAMP)
  - `avg_bid_pr` = `AVG(CAST(bid_pr AS DOUBLE))` — bid_pr is INTEGER in source, cast to DOUBLE before averaging
  - `avg_ask_pr` = `AVG(ask_pr)` — ask_pr is already DOUBLE
  - `avg_mid_pr` = `(AVG(CAST(bid_pr AS DOUBLE)) + AVG(ask_pr)) / 2.0` — midpoint between avg bid and avg ask
- **Filters**: none — no filter criteria specified in YML or task description
- **Expected grain**: one row per (date, ticker, ts) — one average per ticker per timestamp per date
- **Expected rows**: 3,430 (COUNT DISTINCT ticker+ts in quotes source = 3,430)

---

## Model: book_value

- **Source**: `ref('positions_shares')` for shares; `ref('bar_quotes')` for avg_mid_pr
- **Driving table**: positions_shares (grain: one row per (ticker, ts) from bar_executions/trades)
- **Joins**:
  - `LEFT JOIN ref('bar_quotes') bq ON ps.ticker = bq.ticker AND ps.ts = bq.ts`
  - Join on (ticker, ts) — both TIMESTAMP type after casting in bar_quotes
- **Key expressions**:
  - `tt_key` = `ps.tt_key` — carry from positions_shares (same concat(ticker, ts) pattern as bar_executions)
  - `ticker` = `ps.ticker`
  - `ts` = `ps.ts`
  - `shares` = `ps.shares` — cumulative shares from positions_shares window function
  - `value` = `ps.shares * bq.avg_mid_pr` — total position value at mid price
- **Filters**: none
- **Expected grain**: one row per (ticker, ts) from positions_shares
- **Expected rows**: ~number of distinct (ticker, ts) from bar_executions/trades — driven by positions_shares

---

## Decisions

- `bar_quotes` groups by (date, ts, ticker): source has 8,953 rows across 3,430 distinct (ticker, ts) combos; grouping at this level produces unique tt_key per row
- `tt_key = concat(ticker, ts)` in bar_quotes: exactly matches bar_executions.sql pattern (`concat(ticker, ts) as tt_key`)
- `ts::TIMESTAMP` in bar_quotes: ensures type compatibility for join with positions_shares.ts (which is TIMESTAMP from bar_executions inner cast)
- `avg_mid_pr = (AVG(bid_pr) + AVG(ask_pr)) / 2.0`: YML description says "midpoint between bid and ask prices"; mathematically identical to AVG((bid+ask)/2) due to linearity
- `CAST(bid_pr AS DOUBLE)`: bid_pr is INTEGER in source — must cast before division/averaging to avoid integer truncation
- `book_value` drives FROM positions_shares: YML tt_key description says "for each position", shares come from positions_shares window function
- LEFT JOIN bar_quotes in book_value → changed to INNER JOIN after verification: 300 positions_shares rows have no matching bar_quotes entry; LEFT JOIN produces NULL value, failing the YML not_null constraint; INNER JOIN excludes unpriced positions and ensures value is always non-null (semantically: book value only computable when a price exists)
- Join on (ticker, ts) not tt_key: avoids implicit string cast of TIMESTAMP in concat causing format mismatch between sources
- No filters in either model: task description and YML impose no exclusion criteria
- book_value expected rows revised to ~3185 after INNER JOIN (positions with matching bar_quotes prices)
