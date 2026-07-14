{{ config(materialized='ephemeral') }}
select * from main.circuits
