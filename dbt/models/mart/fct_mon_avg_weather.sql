{{
    config(
        materialized='table'
    )
}}
SELECT
    date,
    avg_temp,
    avg_humidity,
    avg_wind_speed
FROM (