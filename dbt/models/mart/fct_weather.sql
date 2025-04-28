{{
    config(
        materialized='incremental',
        unique_key='rec_id',
        incremental_strategy='merge',
        on_schema_change='append_new_columns'
    )
}}
select * from {{ ref('int_weather') }}
{% if is_incremental() %}
where date > (select max(date) from {{ this }})
{% endif %}