{{ config(materialized='ephemeral') }}
select * from main.results
