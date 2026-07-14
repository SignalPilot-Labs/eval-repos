{{ config(materialized='ephemeral') }}
select * from main.constructor_results
