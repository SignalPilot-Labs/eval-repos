{{ config(materialized='ephemeral') }}
select * from main.lap_times
