{{ config(materialized='table') }}

-- EXPECTED SHAPE: 122 rows — REASON: 2 customers × 61 calendar days (2022-09-08 to 2022-11-07)

with customer_dates as (

    select
        customer_id,
        date_day,
        date_week,
        date_month,
        date_year
    from {{ ref('int_recharge__customer_daily_rollup') }}

), customer_info as (

    select
        customer_id,
        first_charge_processed_at
    from {{ ref('recharge__customer_details') }}

), billing as (

    select *
    from {{ ref('recharge__billing_history') }}

), billing_agg as (

    select
        customer_id,
        cast(order_created_at as date) as order_date,

        -- order counts (order_status filter for consistent successful-order counts)
        count(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then order_id end) as no_of_orders,
        count(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                and lower(order_type) = 'recurring'
                then order_id end) as recurring_orders,
        count(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                and lower(charge_type) = 'checkout'
                then order_id end) as one_time_orders,

        -- total charges: gross (no status filter per YML "including all items" without "successful" qualifier)
        coalesce(sum(charge_total_price), 0) as total_charges,

        -- charge-level financials (order_status filter — "successful orders")
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then charge_total_discounts else 0 end), 0) as charge_total_discounts_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then calculated_order_total_discounts else 0 end), 0) as calculated_order_total_discounts_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then charge_total_tax else 0 end), 0) as charge_total_tax_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then calculated_order_total_tax else 0 end), 0) as calculated_order_total_tax_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then charge_total_price else 0 end), 0) as charge_total_price_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then calculated_order_total_price else 0 end), 0) as calculated_order_total_price_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then charge_total_refunds else 0 end), 0) as charge_total_refunds_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then calculated_order_total_refunds else 0 end), 0) as calculated_order_total_refunds_realized,

        -- order line items (order_status filter)
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then order_line_item_total else 0 end), 0) as order_line_item_total_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                then order_item_quantity else 0 end), 0) as order_item_quantity_realized,

        -- recurring net amounts (order_status filter + charge type)
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                and lower(charge_type) = 'recurring'
                then total_net_charge_value else 0 end), 0) as charge_recurring_net_amount_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                and lower(charge_type) = 'checkout'
                then total_net_charge_value else 0 end), 0) as charge_one_time_net_amount_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                and lower(charge_type) = 'recurring'
                then total_calculated_net_order_value else 0 end), 0) as calculated_order_recurring_net_amount_realized,
        coalesce(sum(case when lower(order_status) not in ('error', 'cancelled', 'queued')
                and lower(charge_type) = 'checkout'
                then total_calculated_net_order_value else 0 end), 0) as calculated_order_one_time_net_amount_realized

    from billing
    group by 1, 2

), joined as (

    select
        cd.customer_id,
        cd.date_day,
        cd.date_week,
        cd.date_month,
        cd.date_year,
        ci.first_charge_processed_at,

        coalesce(ba.no_of_orders, 0)                                    as no_of_orders,
        coalesce(ba.recurring_orders, 0)                                as recurring_orders,
        coalesce(ba.one_time_orders, 0)                                 as one_time_orders,
        coalesce(ba.total_charges, 0)                                   as total_charges,
        coalesce(ba.charge_total_discounts_realized, 0)                 as charge_total_discounts_realized,
        coalesce(ba.calculated_order_total_discounts_realized, 0)       as calculated_order_total_discounts_realized,
        coalesce(ba.charge_total_tax_realized, 0)                       as charge_total_tax_realized,
        coalesce(ba.calculated_order_total_tax_realized, 0)             as calculated_order_total_tax_realized,
        coalesce(ba.charge_total_price_realized, 0)                     as charge_total_price_realized,
        coalesce(ba.calculated_order_total_price_realized, 0)           as calculated_order_total_price_realized,
        coalesce(ba.charge_total_refunds_realized, 0)                   as charge_total_refunds_realized,
        coalesce(ba.calculated_order_total_refunds_realized, 0)         as calculated_order_total_refunds_realized,
        coalesce(ba.order_line_item_total_realized, 0)                  as order_line_item_total_realized,
        coalesce(ba.order_item_quantity_realized, 0)                    as order_item_quantity_realized,
        coalesce(ba.charge_recurring_net_amount_realized, 0)            as charge_recurring_net_amount_realized,
        coalesce(ba.charge_one_time_net_amount_realized, 0)             as charge_one_time_net_amount_realized,
        coalesce(ba.calculated_order_recurring_net_amount_realized, 0)  as calculated_order_recurring_net_amount_realized,
        coalesce(ba.calculated_order_one_time_net_amount_realized, 0)   as calculated_order_one_time_net_amount_realized

    from customer_dates cd
    left join customer_info ci
        on ci.customer_id = cd.customer_id
    left join billing_agg ba
        on ba.customer_id = cd.customer_id
        and ba.order_date = cd.date_day

), final as (

    select
        customer_id,
        date_day,
        date_week,
        date_month,
        date_year,

        no_of_orders,
        recurring_orders,
        one_time_orders,
        total_charges,

        charge_total_discounts_realized,
        sum(charge_total_discounts_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as charge_total_discounts_running_total,

        calculated_order_total_discounts_realized,
        sum(calculated_order_total_discounts_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as calculated_order_total_discounts_running_total,

        charge_total_tax_realized,
        sum(charge_total_tax_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as charge_total_tax_running_total,

        calculated_order_total_tax_realized,
        sum(calculated_order_total_tax_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as calculated_order_total_tax_running_total,

        charge_total_price_realized,
        sum(charge_total_price_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as charge_total_price_running_total,

        calculated_order_total_price_realized,
        sum(calculated_order_total_price_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as calculated_order_total_price_running_total,

        charge_total_refunds_realized,
        sum(charge_total_refunds_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as charge_total_refunds_running_total,

        calculated_order_total_refunds_realized,
        sum(calculated_order_total_refunds_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as calculated_order_total_refunds_running_total,

        order_line_item_total_realized,
        sum(order_line_item_total_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as order_line_item_total_running_total,

        order_item_quantity_realized,
        sum(order_item_quantity_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as order_item_quantity_running_total,

        round(
            cast(
                date_diff('day', cast(first_charge_processed_at as date), date_day)
                as double
            ) / 30,
        2)                                                                  as active_months_to_date,

        charge_recurring_net_amount_realized,
        sum(charge_recurring_net_amount_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as charge_recurring_net_amount_running_total,

        charge_one_time_net_amount_realized,
        sum(charge_one_time_net_amount_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as charge_one_time_net_amount_running_total,

        calculated_order_recurring_net_amount_realized,
        sum(calculated_order_recurring_net_amount_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as calculated_order_recurring_net_amount_running_total,

        calculated_order_one_time_net_amount_realized,
        sum(calculated_order_one_time_net_amount_realized)
            over (partition by customer_id order by date_day
                  rows between unbounded preceding and current row)         as calculated_order_one_time_net_amount_running_total

    from joined

)

select * from final
