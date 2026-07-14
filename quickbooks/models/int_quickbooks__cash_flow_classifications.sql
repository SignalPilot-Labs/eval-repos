{{ config(materialized='table') }}

-- EXPECTED SHAPE: 276 rows — REASON: only balance_sheet rows from int_quickbooks__general_ledger_balances

with general_ledger_balances as (

    select *
    from {{ ref('int_quickbooks__general_ledger_balances') }}
    where financial_statement_helper = 'balance_sheet'
),

classified as (

    select
        period_first_day                                                  as cash_flow_period,
        source_relation,
        account_class,
        class_id,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        account_type,
        account_sub_type,
        account_number,
        account_id,
        account_name,
        period_ending_balance                                             as cash_ending_period,
        period_ending_converted_balance                                   as cash_converted_ending_period,
        {{ dbt_utils.generate_surrogate_key(['account_id', 'class_id', 'source_relation', 'period_first_day']) }}
                                                                          as account_unique_id,
        case
            when account_type = 'Bank'
                then 'Cash or Cash Equivalents'
            when account_type in ('Other Current Liability', 'Long Term Liability', 'Credit Card', 'Accounts Payable')
                then 'Financing'
            when account_type in ('Other Current Asset', 'Fixed Asset', 'Other Asset')
                then 'Investing'
            else 'Operating'
        end                                                               as cash_flow_type
    from general_ledger_balances
),

final as (

    select
        cash_flow_period,
        source_relation,
        account_class,
        class_id,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        account_type,
        account_sub_type,
        account_number,
        account_id,
        account_name,
        cash_ending_period,
        cash_converted_ending_period,
        account_unique_id,
        cash_flow_type,
        case cash_flow_type
            when 'Cash or Cash Equivalents' then 1
            when 'Operating'               then 2
            when 'Investing'               then 3
            when 'Financing'               then 4
            else null
        end                                                               as cash_flow_ordinal
    from classified
)

select *
from final
