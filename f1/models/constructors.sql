{{ config(materialized='ephemeral') }}
select * from main.constructors
