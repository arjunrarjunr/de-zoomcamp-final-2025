SELECT
    MONTH,
    CASE
        WHEN :WEATHER_PARAM = 'TEMPERATURE' THEN temperature
        WHEN :WEATHER_PARAM = 'PRESSURE' THEN pressure
        WHEN :WEATHER_PARAM = 'VISIBILITY' THEN visibility
        WHEN :WEATHER_PARAM = 'WIND_SPEED' THEN wind_speed
        WHEN :WEATHER_PARAM = 'PRECIPITATION' THEN precipitation
        WHEN :WEATHER_PARAM = 'HUMIDITY' THEN humidity
        WHEN :WEATHER_PARAM = 'FEELS_LIKE' THEN feels_like
        WHEN :WEATHER_PARAM = 'CLOUD_COVER' THEN cloud_cover
        WHEN :WEATHER_PARAM = 'MOON_ILLUMINATION' THEN moon_illumination
        WHEN :WEATHER_PARAM = 'UV' THEN uv
        WHEN :WEATHER_PARAM = 'GUST' THEN gust
        WHEN :WEATHER_PARAM = 'AQ_OZONE' THEN aq_ozone
        WHEN :WEATHER_PARAM = 'AQ_US_EPA_INDEX' THEN aq_us_epa_index
        WHEN :WEATHER_PARAM = 'AQ_NO2' THEN aq_no2
        WHEN :WEATHER_PARAM = 'AQ_PM2_5' THEN aq_pm2_5
        WHEN :WEATHER_PARAM = 'AQ_GB_DEFRA_INDEX' THEN aq_gb_defra_index
        WHEN :WEATHER_PARAM = 'AQ_PM10' THEN aq_pm10
        WHEN :WEATHER_PARAM = 'AQ_SO2' THEN aq_so2
        WHEN :WEATHER_PARAM = 'AQ_CO' THEN aq_co
        ELSE NULL
    END AS selected_metric
FROM
    MON_AVG_WEATHER
WHERE
    COUNTRY = :COUNTRY
    AND CITY = :CITY
    AND MONTH = 'October';