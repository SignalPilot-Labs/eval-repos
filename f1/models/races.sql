{{ config(materialized='ephemeral') }}
select * from main.races
