{{ config(materialized='ephemeral') }}
select * from main.pit_stops
