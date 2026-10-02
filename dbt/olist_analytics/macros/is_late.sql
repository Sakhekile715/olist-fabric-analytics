{% macro is_late(delivered_column, estimated_column) -%}
    CASE
        WHEN {{ delivered_column }} IS NULL THEN NULL
        WHEN CAST({{ delivered_column }} AS DATE) > CAST({{ estimated_column }} AS DATE) THEN 1
        ELSE 0
    END
{%- endmacro %}
