{{ config(materialized='table') }}

-- EXPECTED SHAPE: 1 row — REASON: "aggregate data on messaging activity per account" — 1 account × 1 date_day in source

with messages as (

    select *
    from {{ ref('int_twilio__messages') }}

),

account_history as (

    select
        account_id,
        friendly_name    as account_name,
        status           as account_status,
        type             as account_type
    from {{ var('account_history') }}
    where is_most_recent_record = true

),

account_spend as (

    select
        account_id,
        sum(price) as total_usage_price
    from {{ var('usage_record') }}
    group by account_id

),

message_daily as (

    select
        messages.account_id,
        messages.date_day,
        max(messages.date_week)                                                           as date_week,
        max(messages.date_month)                                                          as date_month,
        sum(case when messages.direction like '%outbound%' then 1 else 0 end)             as total_outbound_messages,
        sum(case when messages.direction like '%inbound%' then 1 else 0 end)              as total_inbound_messages,
        sum(case when messages.status = 'accepted' then 1 else 0 end)                    as total_accepted_messages,
        sum(case when messages.status = 'scheduled' then 1 else 0 end)                   as total_scheduled_messages,
        sum(case when messages.status = 'canceled' then 1 else 0 end)                    as total_canceled_messages,
        sum(case when messages.status = 'queued' then 1 else 0 end)                      as total_queued_messages,
        sum(case when messages.status = 'sending' then 1 else 0 end)                     as total_sending_messages,
        sum(case when messages.status = 'sent' then 1 else 0 end)                        as total_sent_messages,
        sum(case when messages.status = 'failed' then 1 else 0 end)                      as total_failed_messages,
        sum(case when messages.status = 'delivered' then 1 else 0 end)                   as total_delivered_messages,
        sum(case when messages.status = 'undelivered' then 1 else 0 end)                 as total_undelivered_messages,
        sum(case when messages.status = 'receiving' then 1 else 0 end)                   as total_receiving_messages,
        sum(case when messages.status = 'received' then 1 else 0 end)                    as total_received_messages,
        sum(case when messages.status = 'read' then 1 else 0 end)                        as total_read_messages,
        count(*)                                                                          as total_messages,
        abs(sum(messages.price))                                                          as total_messages_spend,
        max(messages.price_unit)                                                          as price_unit
    from messages
    group by
        messages.account_id,
        messages.date_day

),

final as (

    select
        d.account_id,
        a.account_name,
        a.account_status,
        a.account_type,
        d.date_day,
        d.date_week,
        d.date_month,
        d.total_outbound_messages,
        d.total_inbound_messages,
        d.total_accepted_messages,
        d.total_scheduled_messages,
        d.total_canceled_messages,
        d.total_queued_messages,
        d.total_sending_messages,
        d.total_sent_messages,
        d.total_failed_messages,
        d.total_delivered_messages,
        d.total_undelivered_messages,
        d.total_receiving_messages,
        d.total_received_messages,
        d.total_read_messages,
        d.total_messages,
        d.total_messages_spend,
        d.price_unit,
        abs(s.total_usage_price) as total_account_spend

    from message_daily d

    left join account_history a
        on d.account_id = a.account_id

    left join account_spend s
        on d.account_id = s.account_id

)

select *
from final
