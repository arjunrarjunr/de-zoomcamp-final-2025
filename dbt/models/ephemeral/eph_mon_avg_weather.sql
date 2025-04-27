select 
    country,
    city,
    get_mo

from {{ ref('stg_weather') }}