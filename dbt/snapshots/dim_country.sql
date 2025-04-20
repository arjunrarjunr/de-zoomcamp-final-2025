{% snapshot dim_country %}
    {{
        config(
            target_schema="WEATHER",
            target_database="KAGGLE_DATASETS",
            unique_key="COUNTRY",
            strategy="check",
            invalidate_hard_deletes=False,
            check_cols=["country"],
        )
    }}

    select *
    from {{ ref("eph_country_dim") }}
{% endsnapshot %}
