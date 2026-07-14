{{ config(materialized='ephemeral') }}
select * from main.qualifying
