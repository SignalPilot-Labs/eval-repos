{{ config(materialized='ephemeral') }}
select * from main.driver_standings
