{{ config(materialized='table') }}

-- EXPECTED SHAPE: 276 rows — REASON: financial_statement_helper = 'balance_sheet' rows from quickbooks__general_ledger_by_period

with general_ledger_by_period as (

    select *
    from {{ ref('quickbooks__general_ledger_by_period') }}
    where financial_statement_helper = 'balance_sheet'
),

final as (

    select
        cast(period_first_day as date)              as calendar_date,
        cast(period_first_day as date)              as period_first_day,
        cast(period_last_day as date)               as period_last_day,
        account_class,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        class_id,
        account_type,
        account_sub_type,
        account_number,
        account_name,
        account_id,
        source_relation,
        period_ending_balance                       as amount,
        period_ending_converted_balance             as converted_amount,
        account_ordinal
    from general_ledger_by_period
)

select *
from final
