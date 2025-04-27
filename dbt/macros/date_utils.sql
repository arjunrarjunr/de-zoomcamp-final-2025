{% macro get_month_name(date_column) %}
    {%- if target.type == 'snowflake' -%}
        TO_CHAR({{ date_column }}, 'MMMM')
    {%- elif target.type == 'bigquery' -%}
        FORMAT_DATE('%B', {{ date_column }})
    {%- elif target.type == 'redshift' or target.type == 'postgres' -%}
        TO_CHAR({{ date_column }}, 'Month')
    {%- elif target.type == 'databricks' or target.type == 'spark' -%}
        date_format({{ date_column }}, 'MMMM')
    {%- else -%}
        -- Default fallback
        {{ exceptions.raise_compiler_error("month_name macro not implemented for " ~ target.type) }}
    {%- endif -%}
{% endmacro %}