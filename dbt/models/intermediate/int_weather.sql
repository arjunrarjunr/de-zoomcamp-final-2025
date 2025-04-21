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
    case
        when
            city
            in ('火鸡', 'ТУРЦИЯ', 'ANKARA', 'KRASNYY TURKMENISTAN', '-KINGDOM', 'YAREN')
        then 'ANKARA'
        when city in ('CAIRO', 'القاهرة')
        then 'CAIRO'
        when city in ('北京', 'BEIJING SHI')
        then 'BEIJING'
        when city in ('SANTO DOMINGO', 'SANTO DOMINGO (D.N.)')
        then 'SANTO DOMINGO'
        when city in ('GUATEMALA CITY', 'NEW GUATEMALA')
        then 'GUATEMALA CITY'
        when city in ('ADDIS ABEBA', 'ADDIS ABABA')
        then 'ADDIS ABABA'
        when city in ('N''DJAMENA', 'NDJAMENA')
        then 'NDJAMENA'
        when city in ('SANAA', 'صنعاء')
        then 'SANAA'
        when city in ('VIENTIANE', 'เวียงจันทน์')
        then 'VIENTIANE'
        when city in ('TOKYO', '東京')
        then 'TOKYO'
        when city in ('BANGKOK', 'กรุงเทพมหานคร')
        then 'BANGKOK'
        else city
    end as city,
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
