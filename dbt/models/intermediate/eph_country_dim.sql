{{ config(materialized="ephemeral") }}
select DISTINCT country
from {{ ref("int_weather") }}
