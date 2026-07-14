{{ config(materialized='ephemeral') }}
select * from main.drivers
