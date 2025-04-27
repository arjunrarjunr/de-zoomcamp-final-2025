{{
    config(
        materialized='incremental',
        unique_key='SURROGATE_KEY',
    )
}}