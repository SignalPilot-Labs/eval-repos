{{ config(materialized='table') }}

-- EXPECTED SHAPE: 276 rows — REASON: one row per account per period from int_quickbooks__cash_flow_classifications

with cash_flow_classifications as (

    select *
    from {{ ref('int_quickbooks__cash_flow_classifications') }}
),

general_ledger_balances as (

    select *
    from {{ ref('int_quickbooks__general_ledger_balances') }}
),

final as (

    select
        c.account_unique_id,
        c.source_relation,
        c.cash_flow_period,
        c.account_class,
        c.is_sub_account,
        c.parent_account_number,
        c.parent_account_name,
        c.class_id,
        c.account_type,
        c.account_sub_type,
        c.account_number,
        c.account_name,
        c.account_id,
        c.cash_flow_type,
        c.cash_flow_ordinal,
        c.cash_ending_period,
        c.cash_converted_ending_period,
        coalesce(gl.period_beginning_balance, 0)          as cash_beginning_period,
        coalesce(gl.period_beginning_converted_balance, 0) as cash_converted_beginning_period,
        coalesce(gl.period_net_change, 0)                 as cash_net_period,
        coalesce(gl.period_net_converted_change, 0)       as cash_converted_net_period
    from cash_flow_classifications c

    left join general_ledger_balances gl
        on  gl.account_id      = c.account_id
        and gl.source_relation = c.source_relation
        and coalesce(gl.class_id, '0') = coalesce(c.class_id, '0')
        and gl.period_first_day = c.cash_flow_period
)

select *
from final
