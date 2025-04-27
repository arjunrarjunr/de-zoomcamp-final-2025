{% macro get_month_name(date_column) %}
    {{ 
        -- Cross-database compatible
        adapter.dispatch('get_month_name')(date_column)
    }}
{% endmacro %}