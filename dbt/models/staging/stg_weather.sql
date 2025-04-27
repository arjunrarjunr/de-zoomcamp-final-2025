with
    rename_type_cast as (
        select
            cast("last_updated" as date) as date,
            cast("last_updated" as time) as time,
            upper("country") as country,
            upper("location_name") as city,
            "temperature_celsius" as temperature,
            "condition_text" as weather_condition,
            "wind_kph" as wind_speed,
            "wind_direction" as wind_direction,
            "pressure_mb" as pressure,
            "precip_mm" as precipitation,
            "humidity" as humidity,
            "cloud" as cloud_cover,
            "feels_like_celsius" as feels_like,
            "visibility_km" as visibility,
            "uv_index" as uv,
            "gust_kph" as gust,
            "air_quality_carbon_monoxide" as aq_co,
            "air_quality_ozone" as aq_ozone,
            "air_quality_nitrogen_dioxide" as aq_no2,
            "air_quality_sulphur_dioxide" as aq_so2,
            "air_quality_pm2_5" as aq_pm2_5,
            "air_quality_pm10" as aq_pm10,
            "air_quality_us_epa_index" as aq_us_epa_index,
            "air_quality_gb_defra_index" as aq_gb_defra_index,
            "sunrise" as sunrise_time,
            "sunset" as sunset_time,
            "moonrise" as moonrise_time,
            "moonset" as moonset_time,
            "moon_phase" as moon_phase,
            "moon_illumination" as moon_illumination
        from {{ source("kaggle_datasets", "weather_dataset_raw") }}
    )
select
    {{ dbt_utils.generate_surrogate_key(["date", "country", "city"]) }}
    as rec_id,
    *,
    row_number() over (partition by date, country, city order by time) as row_number
from rename_type_cast
