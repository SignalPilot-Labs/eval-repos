{{ config(materialized='table') }}

-- EXPECTED SHAPE: 0 rows — REASON: no income_statement rows in this dataset

with general_ledger_by_period as (

    select *
    from {{ ref('quickbooks__general_ledger_by_period') }}
    where financial_statement_helper = 'income_statement'
),

final as (

    select
        account_id,
        class_id,
        source_relation,
        cast(period_first_day as date)          as calendar_date,
        cast(period_first_day as date)          as period_first_day,
        cast(period_last_day as date)           as period_last_day,
        account_class,
        is_sub_account,
        parent_account_number,
        parent_account_name,
        account_type,
        account_sub_type,
        account_number,
        account_name,
        period_net_change                       as amount,
        period_net_converted_change             as converted_amount,
        account_ordinal
    from general_ledger_by_period
)

select *
from final
