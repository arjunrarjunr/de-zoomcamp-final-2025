select
    surrogate_key,
    date,
    case
        when country in ('BÉLGICA', 'BELGIQUE', 'BELGIEN')
        then 'BELGIUM'
        when country in ('INDE')
        then 'INDIA'
        when country in ('كولومبيا', 'COLÔMBIA')
        then 'COLOMBIA'
        when country in ('火鸡', 'ТУРЦИЯ', 'TURKMÉNISTAN')
        then 'TURKEY'
        when country in ('ESTONIE')
        then 'ESTONIA'
        when country in ('MALÁSIA')
        then 'MALAYSIA'
        when country in ('POLÔNIA', 'ПОЛЬША')
        then 'POLAND'
        when country in ('MARROCOS')
        then 'MOROCCO'
        when country in ('JEMEN')
        then 'YEMEN'
        when country in ('LETONIA')
        then 'LATVIA'
        when country in ('SÜDKOREA')
        then 'SOUTH KOREA'
        when country in ('MEXIQUE')
        then 'MEXICO'
        when country in ('ГВАТЕМАЛА')
        then 'GUATEMALA'
        else country
    end as country,
    city,
    temperature,
    weather_condition,
    wind_speed,
    wind_direction,
    pressure,
    precipitation,
    humidity,
    cloud_cover,
    feels_like,
    visibility,
    uv,
    gust,
    aq_co,
    aq_ozone,
    aq_no2,
    aq_so2,
    aq_pm2_5,
    aq_pm10,
    aq_us_epa_index,
    aq_gb_defra_index,
    sunrise_time,
    sunset_time,
    moonrise_time,
    moonset_time,
    moon_phase,
    moon_illumination,
    time_stamp
from {{ ref("stg_weather") }}
where row_number = 1
