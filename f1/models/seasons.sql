{{ config(materialized='ephemeral') }}
select * from main.seasons
