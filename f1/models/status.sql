{{ config(materialized='ephemeral') }}
select * from main.status
