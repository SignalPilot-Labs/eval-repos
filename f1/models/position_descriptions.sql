{{ config(materialized='ephemeral') }}
select * from main.position_descriptions
