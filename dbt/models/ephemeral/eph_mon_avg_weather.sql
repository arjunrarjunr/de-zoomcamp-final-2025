select distinct
    country,
    city,
    {{ get_month_name("date") }} as month,
    avg(temperature) over (partition by country, city, month) as temperature,
    avg(pressure) over (partition by country, city, month) as pressure,
    avg(visibility) over (partition by country, city, month) as visibility,
    avg(wind_speed) over (partition by country, city, month) as wind_speed,
    avg(precipitation) over (partition by country, city, month) as precipitation,
    avg(humidity) over (partition by country, city, month) as humidity,
    avg(feels_like) over (partition by country, city, month) as feels_like,
    avg(cloud_cover) over (partition by country, city, month) as cloud_cover,
    avg(moon_illumination) over (
        partition by country, city, month
    ) as moon_illumination,
    avg(uv) over (partition by country, city, month) as uv,
    avg(gust) over (partition by country, city, month) as gust,
    avg(aq_ozone) over (partition by country, city, month) as aq_ozone,
    avg(aq_us_epa_index) over (partition by country, city, month) as aq_us_epa_index,

    avg(aq_no2) over (partition by country, city, month) as aq_no2,

    avg(aq_pm2_5) over (partition by country, city, month) as aq_pm2_5,

    avg(aq_gb_defra_index) over (
        partition by country, city, month
    ) as aq_gb_defra_index,
    avg(aq_pm10) over (partition by country, city, month) as aq_pm10,
    avg(aq_so2) over (partition by country, city, month) as aq_so2,

    avg(aq_co) over (partition by country, city, month) as aq_co

from {{ ref("fct_weather") }}
