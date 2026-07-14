{{ config(materialized='table') }}

-- EXPECTED SHAPE: 759 rows — REASON: UNION ALL of int_quickbooks__general_ledger_balances (759) + int_quickbooks__retained_earnings (0)

with general_ledger_balances as (

    select *
    from {{ ref('int_quickbooks__general_ledger_balances') }}
),

retained_earnings as (

    select *
    from {{ ref('int_quickbooks__retained_earnings') }}
),

unioned as (

    select
        account_id,
        source_relation,
        account_number,
        account_name,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        account_type,
        account_sub_type,
        account_class,
        class_id,
        financial_statement_helper,
        date_year,
        period_first_day,
        period_last_day,
        period_net_change,
        period_beginning_balance,
        period_ending_balance,
        period_net_converted_change,
        period_beginning_converted_balance,
        period_ending_converted_balance
    from general_ledger_balances

    union all

    select
        account_id,
        source_relation,
        account_number,
        account_name,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        account_type,
        account_sub_type,
        account_class,
        class_id,
        financial_statement_helper,
        date_year,
        period_first_day,
        period_last_day,
        period_net_change,
        period_beginning_balance,
        period_ending_balance,
        period_net_converted_change,
        period_beginning_converted_balance,
        period_ending_converted_balance
    from retained_earnings
),

final as (

    select
        account_id,
        source_relation,
        account_number,
        account_name,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        account_type,
        account_sub_type,
        account_class,
        class_id,
        financial_statement_helper,
        date_year,
        period_first_day,
        period_last_day,
        period_net_change,
        period_beginning_balance,
        period_ending_balance,
        period_net_converted_change,
        period_beginning_converted_balance,
        period_ending_converted_balance,
        case account_class
            when 'Asset'     then 1
            when 'Liability' then 2
            when 'Equity'    then 3
            when 'Revenue'   then 4
            when 'Expense'   then 5
            else null
        end as account_ordinal
    from unioned
)

select *
from final
