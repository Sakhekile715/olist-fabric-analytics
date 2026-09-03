{% macro delivery_bucket(variance_column) -%}
    CASE
        WHEN {{ variance_column }} IS NULL     THEN 'Not delivered'
        WHEN {{ variance_column }} <= -10      THEN '10+ days early'
        WHEN {{ variance_column }} <= -5       THEN '5-9 days early'
        WHEN {{ variance_column }} <= -1       THEN '1-4 days early'
        WHEN {{ variance_column }} = 0         THEN 'On time'
        WHEN {{ variance_column }} <= 4        THEN '1-4 days late'
        WHEN {{ variance_column }} <= 9        THEN '5-9 days late'
        ELSE '10+ days late'
    END
{%- endmacro %}
