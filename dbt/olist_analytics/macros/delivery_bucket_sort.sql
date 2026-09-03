{% macro delivery_bucket_sort(variance_column) -%}
    CASE
        WHEN {{ variance_column }} IS NULL     THEN 0
        WHEN {{ variance_column }} <= -10      THEN 1
        WHEN {{ variance_column }} <= -5       THEN 2
        WHEN {{ variance_column }} <= -1       THEN 3
        WHEN {{ variance_column }} = 0         THEN 4
        WHEN {{ variance_column }} <= 4        THEN 5
        WHEN {{ variance_column }} <= 9        THEN 6
        ELSE 7
    END
{%- endmacro %}
